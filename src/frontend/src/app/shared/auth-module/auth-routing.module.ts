import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { SignInComponent } from './sign-in/sign-in.component';
import { NgxMdModule } from 'ngx-md';

const routes: Routes = [
  {
    path: 'sign-in', component: SignInComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes), NgxMdModule],
  exports: [RouterModule]
})
export class AuthRoutingModule {
}
