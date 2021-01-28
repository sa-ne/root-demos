export class User {

  id?: number;
  basketId?: number;
  username: String;
  password?: String;
  firstName?: String;
  lastName?: String;
  email?: String;
  roles?: string[] = [];
  isCustomer: boolean = false;
  isAdmin: boolean = false;
}
