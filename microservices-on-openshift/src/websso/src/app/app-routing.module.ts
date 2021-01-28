import { NgModule } from '@angular/core';
import { RouterModule, Routes, PreloadAllModules } from '@angular/router';

import { InventoryComponent }   from './inventory/inventory.component';
import { DetailsComponent }   from './details/details.component';
import { BasketComponent }   from './basket/basket.component';
import { AppAuthGuard } from './app.authguard';

const routes: Routes = [
  // { path: '/', redirectTo: '/show', pathMatch: 'full', canActivate: [AppAuthGuard], data: { roles: ['product'] } },
  // { path: '/show', component: InventoryComponent, canActivate: [AppAuthGuard], data: { roles: ['product'] } },
  // { path: '/show/:productType', component: InventoryComponent, canActivate: [AppAuthGuard], data: { roles: ['product'] } },
  // { path: 'show/:productType/details/:productId', component: DetailsComponent, canActivate: [AppAuthGuard], data: { roles: ['product'] } },
  // { path: 'show/basket/add/:productId', component: BasketComponent, canActivate: [AppAuthGuard], data: { roles: ['basket'] } },
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { enableTracing: false }), ],
  exports: [ RouterModule ],
  providers: [AppAuthGuard]
})
export class AppRoutingModule { }
