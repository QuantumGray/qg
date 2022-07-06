export class RequestResponse<T, B> {
  public async guard(exec: Function) {
    try {
      const execResult = await exec();
      return new RequestDataResponse<T, B>(execResult);
    } catch (e: any) {
      return new RequestErrorResponse<T, B>(e);
    }
  }
}

export class RequestDataResponse<T, B> extends RequestResponse<T, B> {
  public data: T;

  constructor(data: T) {
    super();
    this.data = data;
  }
}

export class RequestErrorResponse<T, B> extends RequestResponse<T, B> {
  public error: B;

  constructor(error: B) {
    super();
    this.error = error;
  }
}
