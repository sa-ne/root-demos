import { Injectable } from '@angular/core';

import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable ,  of } from 'rxjs';
import { catchError, map, tap } from 'rxjs/operators';

import { environment } from '../../environments/environment';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
};

@Injectable()
export class CategoriesService {

  private catgegoriesUrl = `${environment.inventory_backend}/api/products/types`;

  constructor(private http: HttpClient) { }

  getCategories(): Observable<string[]> {
    const url = `${this.catgegoriesUrl}`;
    return this.http.get<string[]>(url)
    .pipe(
      tap(products => this.log(`fetched all categories`)),
      catchError(this.handleError<string[]>(`getCategories`))
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
    console.log('CategoriesService: ' + message);
  }
}
