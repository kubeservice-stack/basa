import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { throwError } from 'rxjs';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/map';
import 'rxjs/add/observable/throw';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

@Injectable()
export class InvokeService {
  headers = new HttpHeaders({'Content-type': 'application/json'});
  options = {responseType: 'json', 'headers': this.headers};

  headertext = new HttpHeaders({'Content-type': 'text/plain'});
  optionstext = {responseType: 'text', 'headers': this.headertext};

  headerdownload = new HttpHeaders({'Content-Disposition': 'attachment; filename="test.txt"'});
  optionsdownload  = {'headers': this.headerdownload};

  constructor(private http: HttpClient) {
  }

  getInvoke(method: string, name: string, namespace: string, path: string, body: string, typed: string, cluster: string): Observable<any> {
    let params = new HttpParams();
    params = params.set("method", method);
    params = params.set("path", path);
    params = params.set("cluster", cluster);

    let fnNamespace = (namespace && namespace.length > 0) ? "." + namespace : "";
    let url = `/function/${name}${fnNamespace}`;

    if (typed == "text") {
      return this.http
        .post(url, body, { responseType: 'text', params:params })
        .catch(error => throwError(error));
    } else if (typed == "json") {
      return this.http
        .post(url, body, { responseType: 'json', 'headers': this.headers, params:params })
        .catch(error => throwError(error));
    } else {
      return this.http
        .post(url, body, {'headers': this.headerdownload, params:params})
        .catch(error => throwError(error));
    }
  }
}