import { Component, OnInit, Input, EventEmitter, Output } from '@angular/core';
import { Location } from '@angular/common';

import { Product } from '../model/product';
import { Basket } from '../model/basket';

import { InventoryService } from '../services/inventory.service';
import { BasketService } from '../services/basket.service';

@Component({
  selector: 'app-details',
  templateUrl: './details.component.html',
  styleUrls: ['./details.component.css']
})
export class DetailsComponent implements OnInit {

  @Input() product: Product;
  basket: Basket;
  @Output() updatedBasket = new EventEmitter<Basket>();

  constructor(
    private inventoryService: InventoryService,
    private basketService: BasketService
  ) {}

  ngOnInit() {
    console.log("DetailsComponent ngOnInit");
  }

  onAddToBasket(product: Product) : void  {
    console.log("Add to basket : "  + product.id + ":" + product.name );
    this.basketService.addProductToBasket(product).subscribe( (basket : Basket) => {
      console.log("AppComponent : createBasket : " +basket.id);
      this.basket = basket;
      this.updatedBasket.emit(basket);
    });
  }

}
