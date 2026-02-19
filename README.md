# MechieBro (Flutter + Firebase MVP)

Android-first MVP for an emergency + scheduled bike service marketplace in Delhi.

## What is implemented in this scaffold

- Flutter app with Material 3 + Riverpod + go_router
- Home screen matching requested red gradient and quick actions
- OTP login flow (Firebase Auth phone)
- Emergency request creation flow with map pin selection
- Schedule booking flow with service list and lead-time/hour guardrails
- Mechanic onboarding + KYC (masked Aadhaar last 4 only) + radius + skills/tools
- Admin mode (in-app MVP) to approve mechanic KYC
- Booking list tabs (Upcoming/Ongoing/Past) with basic timeline-ready statuses
- Payment screen (Cash + UPI manual UTR)
- Rating screen (both sides)
- Support screen (FAQ + WhatsApp link + support chat stub)
- Cloud Functions TypeScript for:
  - emergency broadcast (geohash windows + FCM)
  - first-accept transaction safety
  - mechanic location updates
  - valid booking state transition enforcement
- Firestore rules + indexes
- Seed script to set admin custom claim and approve mechanic
- Unit tests for model serialization and repository caching

## Project structure

- `lib/core`: theme + router
- `lib/features/*`: clean-ish feature modules (`presentation`, `application`, `data`, `domain`)
- `functions/`: Firebase Cloud Functions (TypeScript)
- `scripts/`: seed scripts
- `firestore.rules`, `firestore.indexes.json`

## Prerequisites

- Flutter stable (`flutter --version`)
- Firebase CLI (`npm i -g firebase-tools`)
- Android Studio + emulator/device
- A Firebase project with:
  - Auth (Phone)
  - Firestore
  - Storage
  - Cloud Functions
  - FCM

## Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Configure Firebase options:
   - Run flutterfire configure (recommended):
     ```bash
     dart pub global activate flutterfire_cli
     flutterfire configure
     ```
   - Or replace placeholders in `lib/firebase_options.dart` manually.

3. Android Google Maps API key:
   - Add `com.google.android.geo.API_KEY` in `android/app/src/main/AndroidManifest.xml` metadata.
   - Restrict key to Android package + SHA-1.

4. Firestore deploy:
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes
   ```

5. Functions setup + deploy:
   ```bash
   cd functions
   npm install
   npm run build
   cd ..
   firebase deploy --only functions
   ```

6. Run app:
   ```bash
   flutter run
   ```

## Emulator workflow (optional)

```bash
firebase emulators:start
```

Point app to local emulators in debug using Firebase SDK emulator settings (TODO hook in app init).

## Seed data / admin bootstrap

Set admin claim and verify mechanic:

```bash
GOOGLE_APPLICATION_CREDENTIALS=serviceAccount.json node scripts/seed_admin_mechanic.js <adminUid> <mechanicUid>
```

## MVP notes and TODOs

- Background mechanic location updates are best-effort TODO for phase 2.
- Call masking is currently a UI stub.
- KYC doc upload UI hooks exist; add full Storage upload and secure moderation pipeline.
- Security hardening: route all sensitive updates through callable functions.
- Add richer timeline/event subcollection and receipts PDF export.
