import { UserCredential } from "firebase/auth";
import { RequestResponse } from "../../../qg_typescript_base/utils/request_response";

export abstract class BaseAuthRepository {
  abstract signInEmailAndPassword(
    email: String,
    password: String
  ): Promise<RequestResponse<UserCredential, any>>;
  abstract signOut(): Promise<RequestResponse<void, any>>;
}
