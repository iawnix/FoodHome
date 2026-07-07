import {getApps, initializeApp} from "firebase-admin/app";
import {Firestore, getFirestore} from "firebase-admin/firestore";

export function initializeFirebaseAdmin(): void {
  if (getApps().length === 0) {
    initializeApp();
  }
}

export function getDefaultFirestore(): Firestore {
  initializeFirebaseAdmin();
  return getFirestore();
}
