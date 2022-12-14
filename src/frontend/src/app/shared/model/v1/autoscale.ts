import { App } from './app';

export class Autoscale {
  id: number;
  name: string;
  metaData: string;
  user: string;
  appId: number;
  metaDataObj: {};
  description: string;
  deleted: boolean;
  createTime: Date;
  app: App;
  order: number;
}

export const HPAAutoscaleNames = [
  "cpu", "memory"
];
