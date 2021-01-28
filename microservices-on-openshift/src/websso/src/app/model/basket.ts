import { Product } from './product';


export class Basket {
  id: number;
  userId: string;
  products?: Product[];
  total: string;
}
