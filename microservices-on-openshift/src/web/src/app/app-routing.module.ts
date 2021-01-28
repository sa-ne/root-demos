import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { InventoryComponent }   from './inventory/inventory.component';
import { DetailsComponent }   from './details/details.component';
import { BasketComponent }   from './basket/basket.component';

const routes: Routes = [
  { path: '', redirectTo: '/show', pathMatch: 'full' },
  { path: 'show', component: InventoryComponent },
  { path: 'show/:productType', component: InventoryComponent },
  { path: 'show/:productType/details/:productId', component: DetailsComponent },
  { path: 'show/basket/add/:productId', component: BasketComponent },
];

@NgModule({
  imports: [ RouterModule.forRoot(routes, { enableTracing: false }), ],
  exports: [ RouterModule ],
  declarations: []
})
export class AppRoutingModule { }
