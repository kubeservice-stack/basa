import { Component, OnInit, Input } from '@angular/core';
import { CantainerType } from '../../../shared/shared.const';
import { Subscription } from 'rxjs/Subscription';
import { MessageHandlerService } from '../../../shared/message-handler/message-handler.service';
import { AuthService } from '../../../shared/auth/auth.service';
import { AppService } from '../../../shared/client/v1/app.service';
import { InvokeService } from '../../../shared/client/v1/invoke.service';
import { App } from '../../../shared/model/v1/app';
import { Function } from '../../../shared/model/v1/function';
import { CacheService } from '../../../shared/auth/cache.service';
import { ActivatedRoute, Router } from '@angular/router';
import 'rxjs/add/observable/combineLatest';
import { combineLatest } from 'rxjs';
import { DeploymentService } from '../../../shared/client/v1/deployment.service';
import { Deployment } from '../../../shared/model/v1/deployment';


@Component({
  selector: 'invoke-deployment',
  templateUrl: './invoke-deployment.component.html',
  styleUrls: ['./invoke-deployment.component.scss']
})

export class InvokeDeploymentComponent implements OnInit {
  @Input() deploymentType: CantainerType;
  @Input() deploymentName: string;
  @Input() appId: number;
  @Input() cluster: string;

  fc: Function = new Function();
  URL :string;
  requestPath: string
  invokestr: any;
  body: string;
  contentType: string;
  method: string;
  status: number;

  modalOpened: boolean;
  title: string;
  hiddenFooter: boolean;

  constructor(public authService: AuthService,
              private appService: AppService,
              private invokeService: InvokeService,
              private router: Router,
              private deploymentService: DeploymentService,
              private messageHandlerService: MessageHandlerService,
              public cacheService: CacheService,
              private route: ActivatedRoute) {
                this.hiddenFooter = true;
                this.modalOpened = false;
                this.method = "GET";
                this.requestPath = "/";
            }

  ngOnInit(): void{
  }

  onCancel() {
    this.modalOpened = false;
  }

  openModal(fc: Function, deploymentName: string, appId: number, deploymentType: CantainerType, cluster: string) {
    this.contentType = "json";
    this.deploymentName = deploymentName;
    this.appId = appId;
    this.deploymentType = deploymentType;
    this.cluster = cluster;
    this.URL =  `https://api-serverless.ke.com/function/${this.deploymentName}.${fc.namespace}`;
    this.fc = fc;
    this.modalOpened = true;
    this.hiddenFooter = true;
  }

  onSubmit() {
    this.invokeService.getInvoke(this.method, this.deploymentName, String(this.fc.namespace), this.requestPath, this.body, this.contentType, this.cluster).subscribe(
      response => {
        this.status = 200;
        this.invokestr = response;
      },
      error => {
        this.status = error.status;
        this.invokestr  = error.message;
      }
    );
  }
}
