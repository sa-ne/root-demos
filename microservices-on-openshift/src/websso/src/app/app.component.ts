import { Component, OnInit, Input } from '@angular/core';

import { Product } from './model/product'
import { Basket } from './model/basket';
import { User } from './model/user';

// import { KeycloakProfile } from 'keycloak-js';
// import { KeycloakService } from 'keycloak-angular';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit{
  user: User;
  products: Product[];
  product: Product;
  basket: Basket;
  // userDetails: KeycloakProfile;

  title = 'Amazin - Shopping Reimagined - sso';

  constructor() {}
  // constructor(private keycloakService: KeycloakService) {
  //   console.log("AppComponent : with added Keycloak")
  // }

  async ngOnInit() {
    console.log("AppComponent : ngOnInit")
    // if (await this.keycloakService.isLoggedIn()) {
    //   console.log("AppComponent : isLoggedIn")
    //   this.userDetails = await this.keycloakService.loadUserProfile();
    // }
  }

  async doLogout() {
     // await this.keycloakService.logout();
  }

  onNewLogin(user : User)  {
    this.user = user;
    console.log("AppComponent : onNewLogin : JSON : " + JSON.stringify(this.user));
    console.log("AppComponent : onNewLogin : " + user.id + " : " + user.username+ " basketId : " + this.user.basketId);
    this.basket = new Basket();
    this.basket.id = this.user.basketId
    console.log("AppComponent : onNewLogin : Basket JSON : " + JSON.stringify(this.basket));
  }

  onNewProductList(products : Product[])  {
    console.log("AppComponent : onNewProductList : " + products);
    this.products = products;
  }

  onNewSelectedProduct(product: Product)  {
      console.log("AppComponent : onNewSelectedProduct : " +product.id+":"+product.name+":"+product.price);
      this.product = product;
  }

  onUpdatedBasket(basket : Basket)  {
      console.log("AppComponent : onUpdatedBasket : Basket JSON : " + JSON.stringify(this.basket));
      this.basket = basket;
  }

}
