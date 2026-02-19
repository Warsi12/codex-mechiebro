import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { geohashQueryBounds, distanceBetween } from 'geofire-common';

admin.initializeApp();
const db = admin.firestore();

export const broadcastEmergencyRequest = functions.https.onCall(async (data) => {
  const { requestId, radiusKm = 5 } = data;
  const requestSnap = await db.collection('emergencyRequests').doc(requestId).get();
  if (!requestSnap.exists) throw new functions.https.HttpsError('not-found', 'Request not found');

  const req = requestSnap.data() as any;
  const center: [number, number] = [req.location.lat, req.location.lng];
  const bounds = geohashQueryBounds(center, radiusKm * 1000);

  const candidates: string[] = [];
  for (const b of bounds) {
    const snapshot = await db
      .collection('mechanics')
      .where('kycStatus', '==', 'VERIFIED')
      .where('isOnline', '==', true)
      .orderBy('lastLocation.geohash')
      .startAt(b[0])
      .endAt(b[1])
      .get();

    snapshot.docs.forEach((doc) => {
      const loc = doc.data().lastLocation;
      if (!loc) return;
      const distKm = distanceBetween([loc.lat, loc.lng], center);
      if (distKm <= radiusKm) candidates.push(doc.id);
    });
  }

  if (!candidates.length) return { count: 0 };

  const tokensSnap = await db.collection('fcmTokens').where('uid', 'in', candidates.slice(0, 30)).get();
  const tokens = tokensSnap.docs.map((d) => d.get('token')).filter(Boolean);

  if (tokens.length) {
    await admin.messaging().sendEachForMulticast({
      tokens,
      notification: {
        title: 'New emergency nearby',
        body: `${req.issueType} • Tap to accept`,
      },
      data: { requestId },
    });
  }

  return { count: candidates.length };
});

export const acceptEmergencyRequest = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Please login.');
  const { requestId } = data;

  const ref = db.collection('emergencyRequests').doc(requestId);
  const result = await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new functions.https.HttpsError('not-found', 'Request not found');
    const payload = snap.data() as any;
    if (payload.status !== 'REQUESTED') {
      throw new functions.https.HttpsError('failed-precondition', 'Already accepted by another mechanic.');
    }

    tx.update(ref, {
      status: 'ACCEPTED',
      assignedMechanicId: uid,
      acceptedAt: admin.firestore.FieldValue.serverTimestamp(),
      timeline: admin.firestore.FieldValue.arrayUnion({ status: 'ACCEPTED', at: Date.now(), actor: uid }),
    });

    return { customerId: payload.customerId };
  });

  return { ok: true, customerId: result.customerId };
});

export const updateMechanicLocation = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Missing auth');

  const { lat, lng, geohash } = data;
  await db.collection('mechanics').doc(uid).set(
    {
      lastLocation: {
        lat,
        lng,
        geohash,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      },
    },
    { merge: true },
  );

  return { ok: true };
});

const transitions: Record<string, string[]> = {
  REQUESTED: ['ACCEPTED', 'CANCELLED'],
  ACCEPTED: ['EN_ROUTE', 'CANCELLED'],
  EN_ROUTE: ['ARRIVED', 'CANCELLED'],
  ARRIVED: ['IN_SERVICE'],
  IN_SERVICE: ['COMPLETED'],
  COMPLETED: ['PAID'],
  PAID: ['RATED'],
};

export const transitionBookingState = functions.https.onCall(async (data, context) => {
  const uid = context.auth?.uid;
  if (!uid) throw new functions.https.HttpsError('unauthenticated', 'Missing auth');

  const { bookingId, nextStatus } = data;
  const ref = db.collection('bookings').doc(bookingId);

  await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    if (!snap.exists) throw new functions.https.HttpsError('not-found', 'Booking not found');
    const current = (snap.data() as any).status;
    if (!(transitions[current] || []).includes(nextStatus)) {
      throw new functions.https.HttpsError('failed-precondition', `Invalid transition ${current} -> ${nextStatus}`);
    }

    tx.update(ref, {
      status: nextStatus,
      timeline: admin.firestore.FieldValue.arrayUnion({ status: nextStatus, at: Date.now(), actor: uid }),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  return { ok: true };
});
