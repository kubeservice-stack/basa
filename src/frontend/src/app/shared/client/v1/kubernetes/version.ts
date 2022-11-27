import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { HttpClient } from '@angular/common/http';
import { throwError } from 'rxjs';

@Injectable()
export class VersionClient {
  constructor(private http: HttpClient) {
  }

  getVersion(cluster: string): Observable<any> {
    return this.http
      .get(`/api/v1/kubernetes/version/clusters/${cluster}`)
      .catch(error => throwError(error));
  }
}