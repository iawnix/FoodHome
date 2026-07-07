import {onCall} from "firebase-functions/v2/https";
import {FoodHomeService} from "../domain/foodhome_service.js";
import {FirestoreFoodHomeStore} from "./firestore_store.js";

let service: FoodHomeService | null = null;

function getService(): FoodHomeService {
  service ??= new FoodHomeService({
    store: new FirestoreFoodHomeStore(),
  });
  return service;
}

function authUid(uid: string | undefined): string | null {
  return uid ?? null;
}

export const createHousehold = onCall(async (request) => {
  return getService().createHousehold(authUid(request.auth?.uid), request.data);
});

export const joinHousehold = onCall(async (request) => {
  return getService().joinHousehold(authUid(request.auth?.uid), request.data);
});

export const upsertDish = onCall(async (request) => {
  return getService().upsertDish(authUid(request.auth?.uid), request.data);
});

export const submitOrder = onCall(async (request) => {
  return getService().submitOrder(authUid(request.auth?.uid), request.data);
});

export const transitionOrderStatus = onCall(async (request) => {
  return getService().transitionOrderStatus(
    authUid(request.auth?.uid),
    request.data,
  );
});
