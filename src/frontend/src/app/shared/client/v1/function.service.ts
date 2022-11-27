import { Injectable } from '@angular/core';
import { Observable } from 'rxjs/Observable';
import { throwError } from 'rxjs';
import 'rxjs/add/operator/catch';
import 'rxjs/add/operator/map';
import 'rxjs/add/observable/throw';
import { Function } from '../../model/v1/function';
import { isNotEmpty } from '../../utils';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';

@Injectable()
export class FunctionService {
  headers = new HttpHeaders({'Content-type': 'application/json'});
  options = {'headers': this.headers};

  constructor(private http: HttpClient) {
  }

  getFunctionByName(name: string, cluster: string): Observable<any> {
    let params = new HttpParams();
    params = params.set("cluster", cluster);

    return this.http
      .get(`/system/function/${name}`, {headers:this.headers, params:params})

      .catch(error => throwError(error));
  }

  getFunctions(): Observable<any> {
	return this.http
      .get(`/system/functions`, this.options)
      .catch(error => throwError(error));
  }
}