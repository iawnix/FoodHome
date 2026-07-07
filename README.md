# FoodHome

FoodHome is a family menu and kitchen-sync app prototype.

This repository starts the V0.0 slice from the product and technical plans:

- Flutter app with local demo data.
- Four main surfaces: tonight order, kitchen, family menu, settings.
- Shared order state machine used by app tests and mirrored in Cloud Functions.
- Firebase rules, indexes, and TypeScript function contracts prepared for V0.1.
- No Firebase project files, API keys, signing keys, or local secrets are stored.

Current repository: <https://github.com/iawnix/FoodHome>

## Layout

```text
app/          Flutter client
functions/    Firebase Cloud Functions v2 TypeScript contracts
firebase/     Firestore and Storage rules
docs/         Product, technical, code-style, API, data model, glossary
scripts/      Local environment helpers
```

## Local Checks

```bash
scripts/doctor.sh
cd app && flutter analyze && flutter test
cd ../functions && npm test
```

Validated on 2026-07-07:

- `flutter analyze`
- `flutter test`
- `flutter build apk --debug`
- `flutter build web`
- `npm test` in `functions/`

The Flutter app currently uses in-memory demo state. Firebase write paths and AI
provider keys are intentionally not configured in this repository.

The Android debug APK is a local build artifact and is not tracked in Git. See
`docs/build-artifacts.md` for the latest local artifact metadata and
`docs/roadmap.md` for the next implementation steps.
