/**
 * Usage:
 *  GOOGLE_APPLICATION_CREDENTIALS=serviceAccount.json node scripts/seed_admin_mechanic.js <adminUid> <mechanicUid>
 */
const admin = require('firebase-admin');

admin.initializeApp();

async function main() {
  const adminUid = process.argv[2];
  const mechanicUid = process.argv[3];
  if (!adminUid || !mechanicUid) {
    throw new Error('Provide adminUid and mechanicUid');
  }

  await admin.auth().setCustomUserClaims(adminUid, { admin: true });
  await admin.firestore().collection('mechanics').doc(mechanicUid).set({ kycStatus: 'VERIFIED' }, { merge: true });
  console.log('Admin claim set and mechanic approved.');
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
