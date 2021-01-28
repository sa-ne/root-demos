import { Injectable } from '@angular/core';

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable ,  of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';

import { Basket } from '../model/basket';
import { Product } from '../model/product';

import { environment } from '../../environments/environment';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable()
export class BasketService {

  basket : Basket;

  private basketUrl = `${environment.basket_backend}/api/basket`;

  constructor(private http: HttpClient) { }

  setBasket(basket: Basket): void{
    this.basket = basket;
  }

  getBasket(basket: Basket): Observable<Basket> {
    console.log("getBasketForUser");
    const url = `${this.basketUrl}/get/${basket.id}`;
    return this.http.get<Basket>(url)
    .pipe(
      tap(_ => this.log(`fetched basket`)),
      catchError(this.handleError<Basket>(`getBasket`))
    );
  }

  addProductToBasket(product: Product): Observable<Basket> {
    console.log("addProductToBasket");
    const url = `${this.basketUrl}/${this.basket.id}/add/${product.id}`;
    return this.http.put<Basket>(url, null, httpOptions)
    .pipe(
      tap(_ => this.log(`fetched basket`)),
      catchError(this.handleError<Basket>(`createBasket`))
    );
  }

  removeProductFromBasket(itemAtIndex: number): Observable<Basket> {
    console.log("removeProductFromBasket");
    const url = `${this.basketUrl}/${this.basket.id}/remove/${itemAtIndex}`;
    return this.http.delete<Basket>(url, httpOptions)
    .pipe(
      tap(_ => this.log(`fetched basket`)),
      catchError(this.handleError<Basket>(`createBasket`))
    );

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
    console.log('BasketService: ' + message);
  }
}
