import { Namespace } from './namespace';

export class Function {
  name: string;
  namespace: Namespace;
  image: string;
  invocationCount: number;
  replicas: number;
  envProcess: string;
  availableReplicas: number;
  labels: {};
  annotations: {};

  constructor() {
    this.namespace = new Namespace();
  }

  static emptyObject(): Function {
    const result = new Function();
    result.namespace = Namespace.emptyObject();
    result.invocationCount = 0;
    result.availableReplicas = 0;
    result.replicas = 0;
    return result;
  }
}

export class FunctionResponse {
	data: string;
	status: number;
}