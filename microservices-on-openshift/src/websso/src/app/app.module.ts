import { BrowserModule } from '@angular/platform-browser';
import { NgModule, APP_INITIALIZER } from '@angular/core';
 // import { NgModule } from '@angular/core';
import { AppComponent } from './app.component';

import { FormsModule }    from '@angular/forms';
import { HttpClientModule }    from '@angular/common/http';
import { AppRoutingModule }     from './app-routing.module';
import { InventoryService }          from './services/inventory.service';
import { InventoryComponent } from './inventory/inventory.component';
import { CategoriesComponent } from './categories/categories.component';
import { CategoriesService } from './services/categories.service';
import { TitleCasePipe } from './title-case.pipe';
import { DetailsComponent } from './details/details.component';
import { BasketComponent } from './basket/basket.component';
import { BasketService } from './services/basket.service';
import { LoginComponent } from './login/login.component';
import { UserService } from './services/user.service';

import { AppAuthGuard } from './app.authguard';
import { initializer } from './utils/app-init';
import { KeycloakAngularModule, KeycloakService } from 'keycloak-angular';

@NgModule({
  declarations: [
    AppComponent,
    InventoryComponent,
    CategoriesComponent,
    TitleCasePipe,
    DetailsComponent,
    BasketComponent,
    LoginComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpClientModule,
    KeycloakAngularModule
  ],
  providers: [CategoriesService, BasketService, UserService, InventoryService,
  AppAuthGuard,
  {
    provide: APP_INITIALIZER,
    useFactory: initializer,
    multi: true,
    deps: [KeycloakService]
  }
  ],

  bootstrap: [AppComponent]
})
export class AppModule { }
