import { NgModule } from '@angular/core';
import { SharedModule } from '../shared.module';
import { NgxMdModule } from 'ngx-md';
import { SignInComponent } from './sign-in/sign-in.component';
import { AuthRoutingModule } from './auth-routing.module';
import { AuthoriseService } from '../client/v1/auth.service';

@NgModule({
  imports: [
    NgxMdModule,
    SharedModule,
    AuthRoutingModule
  ],
  providers: [
    AuthoriseService
  ],
  declarations: [SignInComponent]
})
export class AuthModule {
}
