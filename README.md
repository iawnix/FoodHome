# FoodHome

FoodHome is a family menu and kitchen-sync app prototype.

This repository starts the V0.0 slice from the product and technical plans:

- Flutter app with local demo data.
- Four main surfaces: tonight order, kitchen, family menu, settings.
- Shared order state machine used by app tests and mirrored in Cloud Functions.
- Firebase rules, indexes, and TypeScript function contracts prepared for V0.1.
- No Firebase project files, API keys, signing keys, or local secrets are stored.

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

The Flutter app currently uses in-memory demo state. Firebase write paths and AI
provider keys are intentionally not configured in this repository.
