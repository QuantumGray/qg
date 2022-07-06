import {
  Auth,
  signInWithEmailAndPassword,
  signOut,
  UserCredential,
} from "firebase/auth";
import { RequestResponse } from "../../../qg_typescript_base/utils/request_response";
import { ClientVendor } from "../../models/client_vendor";
import { BaseAuthRepository } from "./base_auth_repository";

export class AuthRepository implements BaseAuthRepository {
  private auth: Auth;

  constructor(clientVendor: ClientVendor) {
    this.auth = clientVendor.auth;
  }

  signInEmailAndPassword(email: string, password: string) {
    return new RequestResponse<UserCredential, any>().guard(async () => {
      const credentials = await signInWithEmailAndPassword(
        this.auth,
        email,
        password
      );

      return credentials;
    });
  }

  signOut() {
    return new RequestResponse<void, any>().guard(async () => {
      return await signOut(this.auth);
    });
  }
}
