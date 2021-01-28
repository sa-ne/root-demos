import { Injectable} from '@angular/core';

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable ,  of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';
import { Product } from '../model/product';

import { environment } from '../../environments/environment';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable()
export class InventoryService {
  private tracer;
  private inventoryUrl = `${environment.inventory_backend}/api/products`;

  constructor(private http: HttpClient) {}

  getAllProducts(): Observable<Product[]> {

    const url = `${this.inventoryUrl}/all`;
    return this.http.get<Product[]>(url)
    .pipe(
      tap(products => this.log(`fetched all products`)),
      catchError(this.handleError<Product[]>(`getAllProducts all`))
    );
  }

  getProductsByType(type: string): Observable<Product[]> {
    const url = `${this.inventoryUrl}/type/${type}`;
    return this.http.get<Product[]>(url).pipe(
      tap(_ => this.log(`fetched products type=${type}`)),
      tap(products => this.productListReceived(products)),
      catchError(this.handleError<Product[]>(`getProductsByType type=${type}`))
    );
  }

  getProductById(id: number): Observable<Product> {
    const url = `${this.inventoryUrl}/${id}`;
    return this.http.get<Product>(url).pipe(
      tap(_ => this.log(`fetched product id=${id}`)),
      tap(product => this.productReceived(product)),
      catchError(this.handleError<Product>(`getProduct id=${id}`))
    );
  }

  productListReceived(products : Product[]) : void {
    console.log("InventoryService : productListReceived : products : " + products);
  }

  productReceived(product: Product) : void {
    console.log("InventoryService : productReceived : product : "  + product.id + ":" + product.name);
  }
  /**
   * Handle Http operation that failed.
   * Let the app continue.
   * @param operation - name of the operation that failed
   * @param result - optional value to return as the observable result
   */
  private handleError<T> (operation = 'operation', result?: T) {
    return (error: any): Observable<T> => {

      // TODO: send the error to remote logging infrastructure
      console.error(error); // log to console instead

      // TODO: better job of transforming error for user consumption
      this.log(`${operation} failed: ${error.message}`);

      // Let the app keep running by returning an empty result.
      return of(result as T);
    };
  }

  /** Log a HeroService message with the MessageService */
  private log(message: string) {
    console.log('InventoryService: ' + message);
  }
}
