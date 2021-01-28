import { Component, OnInit, Output, Input, EventEmitter } from '@angular/core';
import { Product } from '../model/product';
import { InventoryService } from '../services/inventory.service';

@Component({
  selector: 'app-inventory',
  templateUrl: './inventory.component.html',
  styleUrls: ['./inventory.component.css']
})
export class InventoryComponent implements OnInit {
  @Input() products: Product[];
  @Output() selectedProduct = new EventEmitter<Product>();

  product: Product;
  constructor(
    private inventoryService: InventoryService,
  ) {}

  ngOnInit() {
    console.log("InventoryComponent : products : " + this.products);
  }

  onClickProduct(product: Product): void {
    console.log("InventoryComponent : product clicked : " + product.id + ":" + product.name);
    this.inventoryService.getProductById(product.id).subscribe( (product : Product) => {
      console.log("InventoryComponent : product received : " + product);
      this.selectedProduct.emit(product);
      this.product = product;
    });
  }
}
