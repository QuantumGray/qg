import { FirebaseApp, getApps, initializeApp } from "firebase/app";
import "firebase/compat/auth";
import "firebase/compat/firestore";
import "firebase/compat/storage";
import { Firestore, getFirestore } from "firebase/firestore";
import { Auth, getAuth } from "firebase/auth";
import { FirebaseStorage, getStorage } from "firebase/storage";

export class ClientVendor {
  private readonly app: FirebaseApp;
  public readonly firestore: Firestore;
  public readonly auth: Auth;
  public readonly storage: FirebaseStorage;

  constructor(firebaseConfig: object) {
    this.app = initializeApp(firebaseConfig);
    this.firestore = getFirestore(this.app);
    this.auth = getAuth(this.app);
    this.storage = getStorage(this.app);
  }
}
