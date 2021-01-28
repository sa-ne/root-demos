import { Component, OnInit, Output, EventEmitter } from '@angular/core';

import { User } from '../model/user';
import { UserService } from '../services/user.service';

import { KeycloakProfile } from 'keycloak-js';
import { KeycloakService } from 'keycloak-angular';

import { environment } from '../../environments/environment';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  user : User = new User();
  @Output() loggedInUser = new EventEmitter<User>();
  loggedIn : boolean = false;
  userDetails: KeycloakProfile;

   // constructor(private userService: UserService) { }

  constructor(private keycloakService: KeycloakService, private userService: UserService) { }

  async ngOnInit() {
    console.log("LoginComponent ngOnInit");
    if (await this.keycloakService.isLoggedIn()) {
      console.log("AppComponent : isLoggedIn")
      this.userDetails = await this.keycloakService.loadUserProfile();
      console.log("LoginComponent keycloakService : JSON : " + JSON.stringify(this.keycloakService.getUserRoles(true)));

      this.user.username = this.userDetails.username;
      this.user.firstName = this.userDetails.firstName;
      this.user.lastName = this.userDetails.lastName;
      this.user.email = this.userDetails.email;
      this.user.roles = this.keycloakService.getUserRoles(true);
      if (this.user.roles.includes(environment.customer_role))  {
        this.user.isCustomer = true;
      }
      if (this.user.roles.includes(environment.admin_role))  {
        this.user.isAdmin = true;
      }
      this.userService.login(this.user).subscribe( (user: User) => {
        console.log("LoginComponent : user : " + user.id + " : " + user.username);
        this.loggedIn = true;
        this.user.id = user.id;
        this.user.basketId = user.basketId;
        this.loggedInUser.emit(this.user);
      });

    }
    console.log("LoginComponent userDetails : JSON : " + JSON.stringify(this.userDetails));
    console.log("LoginComponent user : JSON : " + JSON.stringify(this.user));
  }

  onClickSignOut(): void {
    console.log("LoginComponent onClickSignOut");
    this.keycloakService.logout();
  }

  get greeting() { return "Welcome " + this.user.firstName + " " + this.user.lastName}
  get diagnostic() { return JSON.stringify(this.user); }
}
