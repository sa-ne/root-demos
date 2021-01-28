(window["webpackJsonp"] = window["webpackJsonp"] || []).push([["main"],{

/***/ "./src/$$_lazy_route_resource lazy recursive":
/*!**********************************************************!*\
  !*** ./src/$$_lazy_route_resource lazy namespace object ***!
  \**********************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

function webpackEmptyAsyncContext(req) {
	// Here Promise.resolve().then() is used instead of new Promise() to prevent
	// uncaught exception popping up in devtools
	return Promise.resolve().then(function() {
		var e = new Error("Cannot find module '" + req + "'");
		e.code = 'MODULE_NOT_FOUND';
		throw e;
	});
}
webpackEmptyAsyncContext.keys = function() { return []; };
webpackEmptyAsyncContext.resolve = webpackEmptyAsyncContext;
module.exports = webpackEmptyAsyncContext;
webpackEmptyAsyncContext.id = "./src/$$_lazy_route_resource lazy recursive";

/***/ }),

/***/ "./src/app/app.component.css":
/*!***********************************!*\
  !*** ./src/app/app.component.css ***!
  \***********************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2FwcC5jb21wb25lbnQuY3NzIn0= */"

/***/ }),

/***/ "./src/app/app.component.html":
/*!************************************!*\
  !*** ./src/app/app.component.html ***!
  \************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<p>\n<div class=\"container\">\n  <div class=\"row\">\n    <div class=\"col-md-12\">\n      <nav class=\"navbar navbar-default\">\n        <div class=\"navbar-header\">\n          <a class=\"navbar-brand\" href=\"#\">{{title}}</a>\n        </div>\n        <div class=\"collapse navbar-collapse\">\n          <app-categories (productList)=\"onNewProductList($event)\"></app-categories>\n          <app-login (loggedInUser)=\"onNewLogin($event)\"></app-login>\n        </div>\n      </nav>\n    </div>\n  </div>\n  <div class=\"row\">\n    <div class=\"col-md-1\"></div>\n    <div class=\"col-md-2\">\n      <app-inventory [products]=\"products\" (selectedProduct)=\"onNewSelectedProduct($event)\"></app-inventory>\n    </div>\n    <div class=\"col-md-4\">\n      <app-details [product]=\"product\" (updatedBasket)=\"onUpdatedBasket($event)\"></app-details>\n    </div>\n    <div class=\"col-md-4\">\n      <app-basket [user]=\"user\" [basket]=\"basket\" (updatedBasket)=\"onUpdatedBasket($event)\"></app-basket>\n    </div>\n  </div>\n</div><!-- /.container-fluid -->\n"

/***/ }),

/***/ "./src/app/app.component.ts":
/*!**********************************!*\
  !*** ./src/app/app.component.ts ***!
  \**********************************/
/*! exports provided: AppComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppComponent", function() { return AppComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _model_basket__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./model/basket */ "./src/app/model/basket.ts");



var AppComponent = /** @class */ (function () {
    function AppComponent() {
        this.title = 'Amazin - Shopping Reimagined';
    }
    AppComponent.prototype.onNewLogin = function (user) {
        this.user = user;
        console.log("AppComponent : onNewLogin : JSON : " + JSON.stringify(this.user));
        console.log("AppComponent : onNewLogin : " + user.id + " : " + user.username + " basketId : " + this.user.basketId);
        this.basket = new _model_basket__WEBPACK_IMPORTED_MODULE_2__["Basket"]();
        this.basket.id = this.user.basketId;
        console.log("AppComponent : onNewLogin : Basket JSON : " + JSON.stringify(this.basket));
    };
    AppComponent.prototype.onNewProductList = function (products) {
        console.log("AppComponent : onNewProductList : " + products);
        this.products = products;
    };
    AppComponent.prototype.onNewSelectedProduct = function (product) {
        console.log("AppComponent : onNewSelectedProduct : " + product.id + ":" + product.name + ":" + product.price);
        this.product = product;
    };
    AppComponent.prototype.onUpdatedBasket = function (basket) {
        console.log("AppComponent : onUpdatedBasket : Basket JSON : " + JSON.stringify(this.basket));
        this.basket = basket;
    };
    AppComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-root',
            template: __webpack_require__(/*! ./app.component.html */ "./src/app/app.component.html"),
            styles: [__webpack_require__(/*! ./app.component.css */ "./src/app/app.component.css")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [])
    ], AppComponent);
    return AppComponent;
}());



/***/ }),

/***/ "./src/app/app.module.ts":
/*!*******************************!*\
  !*** ./src/app/app.module.ts ***!
  \*******************************/
/*! exports provided: AppModule */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "AppModule", function() { return AppModule; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_platform_browser__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser */ "./node_modules/@angular/platform-browser/fesm5/platform-browser.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _app_component__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./app.component */ "./src/app/app.component.ts");
/* harmony import */ var _angular_forms__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! @angular/forms */ "./node_modules/@angular/forms/fesm5/forms.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var _services_inventory_service__WEBPACK_IMPORTED_MODULE_6__ = __webpack_require__(/*! ./services/inventory.service */ "./src/app/services/inventory.service.ts");
/* harmony import */ var _inventory_inventory_component__WEBPACK_IMPORTED_MODULE_7__ = __webpack_require__(/*! ./inventory/inventory.component */ "./src/app/inventory/inventory.component.ts");
/* harmony import */ var _categories_categories_component__WEBPACK_IMPORTED_MODULE_8__ = __webpack_require__(/*! ./categories/categories.component */ "./src/app/categories/categories.component.ts");
/* harmony import */ var _services_categories_service__WEBPACK_IMPORTED_MODULE_9__ = __webpack_require__(/*! ./services/categories.service */ "./src/app/services/categories.service.ts");
/* harmony import */ var _title_case_pipe__WEBPACK_IMPORTED_MODULE_10__ = __webpack_require__(/*! ./title-case.pipe */ "./src/app/title-case.pipe.ts");
/* harmony import */ var _details_details_component__WEBPACK_IMPORTED_MODULE_11__ = __webpack_require__(/*! ./details/details.component */ "./src/app/details/details.component.ts");
/* harmony import */ var _basket_basket_component__WEBPACK_IMPORTED_MODULE_12__ = __webpack_require__(/*! ./basket/basket.component */ "./src/app/basket/basket.component.ts");
/* harmony import */ var _services_basket_service__WEBPACK_IMPORTED_MODULE_13__ = __webpack_require__(/*! ./services/basket.service */ "./src/app/services/basket.service.ts");
/* harmony import */ var _login_login_component__WEBPACK_IMPORTED_MODULE_14__ = __webpack_require__(/*! ./login/login.component */ "./src/app/login/login.component.ts");
/* harmony import */ var _services_user_service__WEBPACK_IMPORTED_MODULE_15__ = __webpack_require__(/*! ./services/user.service */ "./src/app/services/user.service.ts");
















var AppModule = /** @class */ (function () {
    function AppModule() {
    }
    AppModule = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_2__["NgModule"])({
            declarations: [
                _app_component__WEBPACK_IMPORTED_MODULE_3__["AppComponent"],
                _inventory_inventory_component__WEBPACK_IMPORTED_MODULE_7__["InventoryComponent"],
                _categories_categories_component__WEBPACK_IMPORTED_MODULE_8__["CategoriesComponent"],
                _title_case_pipe__WEBPACK_IMPORTED_MODULE_10__["TitleCasePipe"],
                _details_details_component__WEBPACK_IMPORTED_MODULE_11__["DetailsComponent"],
                _basket_basket_component__WEBPACK_IMPORTED_MODULE_12__["BasketComponent"],
                _login_login_component__WEBPACK_IMPORTED_MODULE_14__["LoginComponent"]
            ],
            imports: [
                _angular_platform_browser__WEBPACK_IMPORTED_MODULE_1__["BrowserModule"],
                _angular_forms__WEBPACK_IMPORTED_MODULE_4__["FormsModule"],
                _angular_common_http__WEBPACK_IMPORTED_MODULE_5__["HttpClientModule"],
            ],
            providers: [_services_inventory_service__WEBPACK_IMPORTED_MODULE_6__["InventoryService"], _services_categories_service__WEBPACK_IMPORTED_MODULE_9__["CategoriesService"], _services_basket_service__WEBPACK_IMPORTED_MODULE_13__["BasketService"], _services_user_service__WEBPACK_IMPORTED_MODULE_15__["UserService"]],
            bootstrap: [_app_component__WEBPACK_IMPORTED_MODULE_3__["AppComponent"]]
        })
    ], AppModule);
    return AppModule;
}());



/***/ }),

/***/ "./src/app/basket/basket.component.css":
/*!*********************************************!*\
  !*** ./src/app/basket/basket.component.css ***!
  \*********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2Jhc2tldC9iYXNrZXQuY29tcG9uZW50LmNzcyJ9 */"

/***/ }),

/***/ "./src/app/basket/basket.component.html":
/*!**********************************************!*\
  !*** ./src/app/basket/basket.component.html ***!
  \**********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div *ngIf=\"user\">\n  <nav class=\"navbar navbar-default\">\n    <div class=\"container-fluid\">\n      <div class=\"row\">\n        <div class=\"col-md-6\">\n          <div class=\"navbar-brand\">Basket # {{basket.id}}</div>\n        </div>\n        <div class=\"col-md-6\">\n          <div class=\"navbar-brand\">Total £ {{basket.total}}</div>\n        </div>\n      </div>\n    </div>\n  </nav>\n  <div class=\"list-group\">\n    <div class=\"list-group-item\">\n      <div class=\"container-fluid\">\n        <div class=\"row\">\n          <div class=\"col-md-2\"></div>\n          <div class=\"col-md-4\">\n            <h4>Item</h4>\n          </div>\n          <div class=\"col-md-3\">\n            <h4>Price</h4>\n          </div>\n          <div class=\"col-md-3\">\n          </div>\n        </div>\n      </div>\n    </div>\n    <div *ngFor=\"let product of basket.products\" class=\"list-group-item\">\n      <div class=\"container-fluid\">\n        <div class=\"row\">\n          <div class=\"col-md-2\">\n            <img src=\"assets/{{product.name | lowercase}}.jpeg\" height=\"32\" width=\"32\">\n          </div>\n          <div class=\"col-md-4\">\n            {{product.name | titlecase}}\n          </div>\n          <div class=\"col-md-4\">\n            £ {{ product.price }}\n          </div>\n          <div class=\"col-md-2\">\n            <a href=\"#\" (click)=\"onClickRemoveProduct(product)\" class=\"btn btn-primary\">\n              <span class=\"glyphicon glyphicon-remove\" aria-hidden=\"true\"></span>\n            </a>\n          </div>\n        </div>\n      </div>\n    </div>\n  </div>\n</div>\n"

/***/ }),

/***/ "./src/app/basket/basket.component.ts":
/*!********************************************!*\
  !*** ./src/app/basket/basket.component.ts ***!
  \********************************************/
/*! exports provided: BasketComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "BasketComponent", function() { return BasketComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _services_basket_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../services/basket.service */ "./src/app/services/basket.service.ts");
/* harmony import */ var _model_basket__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../model/basket */ "./src/app/model/basket.ts");
/* harmony import */ var _model_user__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../model/user */ "./src/app/model/user.ts");





var BasketComponent = /** @class */ (function () {
    function BasketComponent(basketService) {
        this.basketService = basketService;
        this.updatedBasket = new _angular_core__WEBPACK_IMPORTED_MODULE_1__["EventEmitter"]();
    }
    BasketComponent.prototype.ngOnInit = function () {
        console.log("BasketComponent ngOnInit user : " + this.user);
    };
    BasketComponent.prototype.ngOnChanges = function (changes) {
        var _this = this;
        console.log("Something has changed !!");
        for (var propName in changes) {
            var chng = changes[propName];
            var cur = JSON.stringify(chng.currentValue);
            var prev = JSON.stringify(chng.previousValue);
            console.log(propName + ": currentValue = " + cur + ", previousValue = " + prev);
            if (propName == "basket" && this.basket) {
                console.log("lets load the basket");
                console.log("BasketComponent : basket BEFORE : " + JSON.stringify(this.basket));
                this.basketService.getBasket(this.basket).subscribe(function (basket) {
                    console.log("BasketComponent : basket AFTER : " + JSON.stringify(basket));
                    _this.basket = basket;
                    _this.basketService.setBasket(basket);
                });
            }
        }
    };
    BasketComponent.prototype.onClickRemoveProduct = function (product) {
        var _this = this;
        console.log("BasketComponent onClickRemoveProduct");
        console.log("Delete item at index : " + product.basketIndex);
        this.basketService.removeProductFromBasket(product.basketIndex).subscribe(function (basket) {
            console.log("BasketComponent : removeProductFromBasket AFTER : " + JSON.stringify(basket));
            _this.basket = basket;
            _this.basketService.setBasket(basket);
            _this.updatedBasket.emit(basket);
        });
    };
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Input"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", _model_user__WEBPACK_IMPORTED_MODULE_4__["User"])
    ], BasketComponent.prototype, "user", void 0);
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Input"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", _model_basket__WEBPACK_IMPORTED_MODULE_3__["Basket"])
    ], BasketComponent.prototype, "basket", void 0);
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Output"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", Object)
    ], BasketComponent.prototype, "updatedBasket", void 0);
    BasketComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-basket',
            template: __webpack_require__(/*! ./basket.component.html */ "./src/app/basket/basket.component.html"),
            styles: [__webpack_require__(/*! ./basket.component.css */ "./src/app/basket/basket.component.css")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_services_basket_service__WEBPACK_IMPORTED_MODULE_2__["BasketService"]])
    ], BasketComponent);
    return BasketComponent;
}());



/***/ }),

/***/ "./src/app/categories/categories.component.css":
/*!*****************************************************!*\
  !*** ./src/app/categories/categories.component.css ***!
  \*****************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2NhdGVnb3JpZXMvY2F0ZWdvcmllcy5jb21wb25lbnQuY3NzIn0= */"

/***/ }),

/***/ "./src/app/categories/categories.component.html":
/*!******************************************************!*\
  !*** ./src/app/categories/categories.component.html ***!
  \******************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<ul class=\"nav navbar-nav\">\n  <li *ngFor=\"let category of categories\">\n    <button (click)=onClickCategory(category) type=\"button\" class=\"btn btn-default navbar-btn\">{{ category | titleCase}}</button>\n    &nbsp;\n  </li>\n</ul>\n"

/***/ }),

/***/ "./src/app/categories/categories.component.ts":
/*!****************************************************!*\
  !*** ./src/app/categories/categories.component.ts ***!
  \****************************************************/
/*! exports provided: CategoriesComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "CategoriesComponent", function() { return CategoriesComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _services_categories_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../services/categories.service */ "./src/app/services/categories.service.ts");
/* harmony import */ var _services_inventory_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../services/inventory.service */ "./src/app/services/inventory.service.ts");




var CategoriesComponent = /** @class */ (function () {
    function CategoriesComponent(categoriesService, inventoryService) {
        this.categoriesService = categoriesService;
        this.inventoryService = inventoryService;
        this.productList = new _angular_core__WEBPACK_IMPORTED_MODULE_1__["EventEmitter"]();
    }
    CategoriesComponent.prototype.ngOnInit = function () {
        console.log("CategoriesComponent ngOnInit");
        this.getCategories();
    };
    CategoriesComponent.prototype.getCategories = function () {
        var _this = this;
        this.categoriesService.getCategories().subscribe(function (categories) { return _this.categories = categories; });
    };
    CategoriesComponent.prototype.onClickCategory = function (category) {
        this.selectedCategory = category;
        console.log("CategoriesComponent selected category : " + this.selectedCategory);
        this.getAllProductsForCategory(this.selectedCategory);
    };
    CategoriesComponent.prototype.getAllProductsForCategory = function (category) {
        var _this = this;
        console.log("CategoriesComponent get inventory for category : " + category);
        this.inventoryService.getProductsByType(category).subscribe(function (products) {
            console.log("CategoriesComponent : products : " + products);
            _this.productList.emit(products);
            _this.products = products;
        });
    };
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Output"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", Object)
    ], CategoriesComponent.prototype, "productList", void 0);
    CategoriesComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-categories',
            template: __webpack_require__(/*! ./categories.component.html */ "./src/app/categories/categories.component.html"),
            styles: [__webpack_require__(/*! ./categories.component.css */ "./src/app/categories/categories.component.css")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_services_categories_service__WEBPACK_IMPORTED_MODULE_2__["CategoriesService"],
            _services_inventory_service__WEBPACK_IMPORTED_MODULE_3__["InventoryService"]])
    ], CategoriesComponent);
    return CategoriesComponent;
}());



/***/ }),

/***/ "./src/app/details/details.component.css":
/*!***********************************************!*\
  !*** ./src/app/details/details.component.css ***!
  \***********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2RldGFpbHMvZGV0YWlscy5jb21wb25lbnQuY3NzIn0= */"

/***/ }),

/***/ "./src/app/details/details.component.html":
/*!************************************************!*\
  !*** ./src/app/details/details.component.html ***!
  \************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div *ngIf=\"product\">\n  <div class=\"list-group\">\n      <h1>{{product.name}}</h1>\n      <p><img class=\"img-responsive center-block\" src=\"assets/{{product.name | lowercase}}.jpeg\" alt=\"{{product.name | lowercase}} image\"></p>\n      <p><h3 class=\"pull-left\">£ {{product.price}}</h3>\n        <a class=\"btn btn-primary btn-lg pull-right\" href=\"#\" role=\"button\" (click)=\"onAddToBasket(product)\" >add to basket</a>\n  </div>\n</div>\n"

/***/ }),

/***/ "./src/app/details/details.component.ts":
/*!**********************************************!*\
  !*** ./src/app/details/details.component.ts ***!
  \**********************************************/
/*! exports provided: DetailsComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "DetailsComponent", function() { return DetailsComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _model_product__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../model/product */ "./src/app/model/product.ts");
/* harmony import */ var _services_inventory_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../services/inventory.service */ "./src/app/services/inventory.service.ts");
/* harmony import */ var _services_basket_service__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! ../services/basket.service */ "./src/app/services/basket.service.ts");





var DetailsComponent = /** @class */ (function () {
    function DetailsComponent(inventoryService, basketService) {
        this.inventoryService = inventoryService;
        this.basketService = basketService;
        this.updatedBasket = new _angular_core__WEBPACK_IMPORTED_MODULE_1__["EventEmitter"]();
    }
    DetailsComponent.prototype.ngOnInit = function () {
        console.log("DetailsComponent ngOnInit");
    };
    DetailsComponent.prototype.onAddToBasket = function (product) {
        var _this = this;
        console.log("Add to basket : " + product.id + ":" + product.name);
        this.basketService.addProductToBasket(product).subscribe(function (basket) {
            console.log("AppComponent : createBasket : " + basket.id);
            _this.basket = basket;
            _this.updatedBasket.emit(basket);
        });
    };
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Input"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", _model_product__WEBPACK_IMPORTED_MODULE_2__["Product"])
    ], DetailsComponent.prototype, "product", void 0);
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Output"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", Object)
    ], DetailsComponent.prototype, "updatedBasket", void 0);
    DetailsComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-details',
            template: __webpack_require__(/*! ./details.component.html */ "./src/app/details/details.component.html"),
            styles: [__webpack_require__(/*! ./details.component.css */ "./src/app/details/details.component.css")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_services_inventory_service__WEBPACK_IMPORTED_MODULE_3__["InventoryService"],
            _services_basket_service__WEBPACK_IMPORTED_MODULE_4__["BasketService"]])
    ], DetailsComponent);
    return DetailsComponent;
}());



/***/ }),

/***/ "./src/app/inventory/inventory.component.css":
/*!***************************************************!*\
  !*** ./src/app/inventory/inventory.component.css ***!
  \***************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2ludmVudG9yeS9pbnZlbnRvcnkuY29tcG9uZW50LmNzcyJ9 */"

/***/ }),

/***/ "./src/app/inventory/inventory.component.html":
/*!****************************************************!*\
  !*** ./src/app/inventory/inventory.component.html ***!
  \****************************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<!-- <div *ngIf=\"products\"> -->\n  <div class=\"row\">\n        <div class=\"list-group\">\n          <div class=\"media\">\n            <a href=\"#\" (click)=\"onClickProduct(product)\" *ngFor=\"let product of products\" class=\"list-group-item\">\n              <div class=\"media-left media-middle\">\n                <img src=\"assets/{{product.name | lowercase}}.jpeg\" class=\"media-object\" height=\"42\" width=\"42\">\n              </div>\n              <div class=\"media-body media-middle\">{{product.name | titlecase}}</div>\n            </a>\n          </div>\n      </div>\n  </div>\n<!-- </div> -->\n"

/***/ }),

/***/ "./src/app/inventory/inventory.component.ts":
/*!**************************************************!*\
  !*** ./src/app/inventory/inventory.component.ts ***!
  \**************************************************/
/*! exports provided: InventoryComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "InventoryComponent", function() { return InventoryComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _services_inventory_service__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../services/inventory.service */ "./src/app/services/inventory.service.ts");



var InventoryComponent = /** @class */ (function () {
    function InventoryComponent(inventoryService) {
        this.inventoryService = inventoryService;
        this.selectedProduct = new _angular_core__WEBPACK_IMPORTED_MODULE_1__["EventEmitter"]();
    }
    InventoryComponent.prototype.ngOnInit = function () {
        console.log("InventoryComponent : products : " + this.products);
    };
    InventoryComponent.prototype.onClickProduct = function (product) {
        var _this = this;
        console.log("InventoryComponent : product clicked : " + product.id + ":" + product.name);
        this.inventoryService.getProductById(product.id).subscribe(function (product) {
            console.log("InventoryComponent : product received : " + product);
            _this.selectedProduct.emit(product);
            _this.product = product;
        });
    };
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Input"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", Array)
    ], InventoryComponent.prototype, "products", void 0);
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Output"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", Object)
    ], InventoryComponent.prototype, "selectedProduct", void 0);
    InventoryComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-inventory',
            template: __webpack_require__(/*! ./inventory.component.html */ "./src/app/inventory/inventory.component.html"),
            styles: [__webpack_require__(/*! ./inventory.component.css */ "./src/app/inventory/inventory.component.css")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_services_inventory_service__WEBPACK_IMPORTED_MODULE_2__["InventoryService"]])
    ], InventoryComponent);
    return InventoryComponent;
}());



/***/ }),

/***/ "./src/app/login/login.component.css":
/*!*******************************************!*\
  !*** ./src/app/login/login.component.css ***!
  \*******************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "\n/*# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IiIsImZpbGUiOiJzcmMvYXBwL2xvZ2luL2xvZ2luLmNvbXBvbmVudC5jc3MifQ== */"

/***/ }),

/***/ "./src/app/login/login.component.html":
/*!********************************************!*\
  !*** ./src/app/login/login.component.html ***!
  \********************************************/
/*! no static exports found */
/***/ (function(module, exports) {

module.exports = "<div *ngIf=\"!loggedIn; else elseBlock\">\n<form class=\"navbar-form navbar-right\" role=\"login\" #loginForm=\"ngForm\" (ngSubmit)=\"onSubmit()\">\n  <div class=\"form-group\">\n    <input type=\"text\" class=\"form-control\" id=\"username\" placeholder=\"username\" [(ngModel)]=\"user.username\" name=\"username\">\n    <input type=\"password\" class=\"form-control\" id=\"password\" placeholder=\"password\" [(ngModel)]=\"user.password\" name=\"password\" ng-reflect-name=\"password\">\n  </div>\n  <button type=\"submit\" class=\"btn btn-default\">Sign in</button>\n</form>\n</div>\n<ng-template #elseBlock><div class=\"navbar-brand navbar-right\">{{ greeting }}</div></ng-template>\n"

/***/ }),

/***/ "./src/app/login/login.component.ts":
/*!******************************************!*\
  !*** ./src/app/login/login.component.ts ***!
  \******************************************/
/*! exports provided: LoginComponent */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "LoginComponent", function() { return LoginComponent; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _model_user__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ../model/user */ "./src/app/model/user.ts");
/* harmony import */ var _services_user_service__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ../services/user.service */ "./src/app/services/user.service.ts");




var LoginComponent = /** @class */ (function () {
    function LoginComponent(userService) {
        this.userService = userService;
        this.user = new _model_user__WEBPACK_IMPORTED_MODULE_2__["User"]();
        this.loggedInUser = new _angular_core__WEBPACK_IMPORTED_MODULE_1__["EventEmitter"]();
        this.loggedIn = false;
    }
    LoginComponent.prototype.ngOnInit = function () {
        console.log("LoginComponent ngOnInit");
    };
    LoginComponent.prototype.onSubmit = function () {
        var _this = this;
        console.log("login");
        console.log("user.username : " + this.user.username);
        console.log("user.password : " + this.user.password);
        this.userService.login(this.user).subscribe(function (user) {
            console.log("LoginComponent : user : " + user.id + " : " + user.username);
            _this.loggedIn = true;
            _this.loggedInUser.emit(user);
            _this.user = user;
        });
    };
    Object.defineProperty(LoginComponent.prototype, "greeting", {
        get: function () { return "Welcome " + this.user.username + " !"; },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(LoginComponent.prototype, "diagnostic", {
        get: function () { return JSON.stringify(this.user); },
        enumerable: true,
        configurable: true
    });
    tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Output"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:type", Object)
    ], LoginComponent.prototype, "loggedInUser", void 0);
    LoginComponent = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Component"])({
            selector: 'app-login',
            template: __webpack_require__(/*! ./login.component.html */ "./src/app/login/login.component.html"),
            styles: [__webpack_require__(/*! ./login.component.css */ "./src/app/login/login.component.css")]
        }),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_services_user_service__WEBPACK_IMPORTED_MODULE_3__["UserService"]])
    ], LoginComponent);
    return LoginComponent;
}());



/***/ }),

/***/ "./src/app/model/basket.ts":
/*!*********************************!*\
  !*** ./src/app/model/basket.ts ***!
  \*********************************/
/*! exports provided: Basket */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Basket", function() { return Basket; });
var Basket = /** @class */ (function () {
    function Basket() {
    }
    return Basket;
}());



/***/ }),

/***/ "./src/app/model/product.ts":
/*!**********************************!*\
  !*** ./src/app/model/product.ts ***!
  \**********************************/
/*! exports provided: Product */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "Product", function() { return Product; });
var Product = /** @class */ (function () {
    function Product() {
    }
    return Product;
}());



/***/ }),

/***/ "./src/app/model/user.ts":
/*!*******************************!*\
  !*** ./src/app/model/user.ts ***!
  \*******************************/
/*! exports provided: User */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "User", function() { return User; });
var User = /** @class */ (function () {
    function User() {
    }
    return User;
}());



/***/ }),

/***/ "./src/app/services/basket.service.ts":
/*!********************************************!*\
  !*** ./src/app/services/basket.service.ts ***!
  \********************************************/
/*! exports provided: BasketService */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "BasketService", function() { return BasketService; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var rxjs__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! rxjs */ "./node_modules/rxjs/_esm5/index.js");
/* harmony import */ var rxjs_operators__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! rxjs/operators */ "./node_modules/rxjs/_esm5/operators/index.js");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../../environments/environment */ "./src/environments/environment.ts");






var httpOptions = {
    headers: new _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpHeaders"]({ 'Content-Type': 'application/json' })
};
var BasketService = /** @class */ (function () {
    function BasketService(http) {
        this.http = http;
        this.basketUrl = _environments_environment__WEBPACK_IMPORTED_MODULE_5__["environment"].basket_backend + "/api/basket";
    }
    BasketService.prototype.setBasket = function (basket) {
        this.basket = basket;
    };
    BasketService.prototype.getBasket = function (basket) {
        var _this = this;
        console.log("getBasketForUser");
        var url = this.basketUrl + "/get/" + basket.id;
        return this.http.get(url)
            .pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (_) { return _this.log("fetched basket"); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("getBasket")));
    };
    BasketService.prototype.addProductToBasket = function (product) {
        var _this = this;
        console.log("addProductToBasket");
        var url = this.basketUrl + "/" + this.basket.id + "/add/" + product.id;
        return this.http.put(url, null, httpOptions)
            .pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (_) { return _this.log("fetched basket"); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("createBasket")));
    };
    BasketService.prototype.removeProductFromBasket = function (itemAtIndex) {
        var _this = this;
        console.log("removeProductFromBasket");
        var url = this.basketUrl + "/" + this.basket.id + "/remove/" + itemAtIndex;
        return this.http.delete(url, httpOptions)
            .pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (_) { return _this.log("fetched basket"); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("createBasket")));
    };
    /**
     * Handle Http operation that failed.
     * Let the app continue.
     * @param operation - name of the operation that failed
     * @param result - optional value to return as the observable result
     */
    BasketService.prototype.handleError = function (operation, result) {
        var _this = this;
        if (operation === void 0) { operation = 'operation'; }
        return function (error) {
            // TODO: send the error to remote logging infrastructure
            console.error(error); // log to console instead
            // TODO: better job of transforming error for user consumption
            _this.log(operation + " failed: " + error.message);
            // Let the app keep running by returning an empty result.
            return Object(rxjs__WEBPACK_IMPORTED_MODULE_3__["of"])(result);
        };
    };
    /** Log a HeroService message with the MessageService */
    BasketService.prototype.log = function (message) {
        console.log('BasketService: ' + message);
    };
    BasketService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"]])
    ], BasketService);
    return BasketService;
}());



/***/ }),

/***/ "./src/app/services/categories.service.ts":
/*!************************************************!*\
  !*** ./src/app/services/categories.service.ts ***!
  \************************************************/
/*! exports provided: CategoriesService */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "CategoriesService", function() { return CategoriesService; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var rxjs__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! rxjs */ "./node_modules/rxjs/_esm5/index.js");
/* harmony import */ var rxjs_operators__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! rxjs/operators */ "./node_modules/rxjs/_esm5/operators/index.js");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../../environments/environment */ "./src/environments/environment.ts");






var httpOptions = {
    headers: new _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpHeaders"]({ 'Content-Type': 'application/json' })
};
var CategoriesService = /** @class */ (function () {
    function CategoriesService(http) {
        this.http = http;
        this.catgegoriesUrl = _environments_environment__WEBPACK_IMPORTED_MODULE_5__["environment"].inventory_backend + "/api/products/types";
    }
    CategoriesService.prototype.getCategories = function () {
        var _this = this;
        var url = "" + this.catgegoriesUrl;
        return this.http.get(url)
            .pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (products) { return _this.log("fetched all categories"); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("getCategories")));
    };
    /**
     * Handle Http operation that failed.
     * Let the app continue.
     * @param operation - name of the operation that failed
     * @param result - optional value to return as the observable result
     */
    CategoriesService.prototype.handleError = function (operation, result) {
        var _this = this;
        if (operation === void 0) { operation = 'operation'; }
        return function (error) {
            // TODO: send the error to remote logging infrastructure
            console.error(error); // log to console instead
            // TODO: better job of transforming error for user consumption
            _this.log(operation + " failed: " + error.message);
            // Let the app keep running by returning an empty result.
            return Object(rxjs__WEBPACK_IMPORTED_MODULE_3__["of"])(result);
        };
    };
    /** Log a HeroService message with the MessageService */
    CategoriesService.prototype.log = function (message) {
        console.log('CategoriesService: ' + message);
    };
    CategoriesService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"]])
    ], CategoriesService);
    return CategoriesService;
}());



/***/ }),

/***/ "./src/app/services/inventory.service.ts":
/*!***********************************************!*\
  !*** ./src/app/services/inventory.service.ts ***!
  \***********************************************/
/*! exports provided: InventoryService */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "InventoryService", function() { return InventoryService; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var rxjs__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! rxjs */ "./node_modules/rxjs/_esm5/index.js");
/* harmony import */ var rxjs_operators__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! rxjs/operators */ "./node_modules/rxjs/_esm5/operators/index.js");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../../environments/environment */ "./src/environments/environment.ts");






var httpOptions = {
    headers: new _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpHeaders"]({ 'Content-Type': 'application/json' })
};
var InventoryService = /** @class */ (function () {
    function InventoryService(http) {
        this.http = http;
        this.inventoryUrl = _environments_environment__WEBPACK_IMPORTED_MODULE_5__["environment"].inventory_backend + "/api/products";
    }
    InventoryService.prototype.getAllProducts = function () {
        var _this = this;
        var url = this.inventoryUrl + "/all";
        return this.http.get(url)
            .pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (products) { return _this.log("fetched all products"); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("getAllProducts all")));
    };
    InventoryService.prototype.getProductsByType = function (type) {
        var _this = this;
        var url = this.inventoryUrl + "/type/" + type;
        return this.http.get(url).pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (_) { return _this.log("fetched products type=" + type); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (products) { return _this.productListReceived(products); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("getProductsByType type=" + type)));
    };
    InventoryService.prototype.getProductById = function (id) {
        var _this = this;
        var url = this.inventoryUrl + "/" + id;
        return this.http.get(url).pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (_) { return _this.log("fetched product id=" + id); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (product) { return _this.productReceived(product); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError("getProduct id=" + id)));
    };
    InventoryService.prototype.productListReceived = function (products) {
        console.log("InventoryService : productListReceived : products : " + products);
    };
    InventoryService.prototype.productReceived = function (product) {
        console.log("InventoryService : productReceived : product : " + product.id + ":" + product.name);
    };
    /**
     * Handle Http operation that failed.
     * Let the app continue.
     * @param operation - name of the operation that failed
     * @param result - optional value to return as the observable result
     */
    InventoryService.prototype.handleError = function (operation, result) {
        var _this = this;
        if (operation === void 0) { operation = 'operation'; }
        return function (error) {
            // TODO: send the error to remote logging infrastructure
            console.error(error); // log to console instead
            // TODO: better job of transforming error for user consumption
            _this.log(operation + " failed: " + error.message);
            // Let the app keep running by returning an empty result.
            return Object(rxjs__WEBPACK_IMPORTED_MODULE_3__["of"])(result);
        };
    };
    /** Log a HeroService message with the MessageService */
    InventoryService.prototype.log = function (message) {
        console.log('InventoryService: ' + message);
    };
    InventoryService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"]])
    ], InventoryService);
    return InventoryService;
}());



/***/ }),

/***/ "./src/app/services/user.service.ts":
/*!******************************************!*\
  !*** ./src/app/services/user.service.ts ***!
  \******************************************/
/*! exports provided: UserService */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "UserService", function() { return UserService; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_common_http__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! @angular/common/http */ "./node_modules/@angular/common/fesm5/http.js");
/* harmony import */ var rxjs__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! rxjs */ "./node_modules/rxjs/_esm5/index.js");
/* harmony import */ var rxjs_operators__WEBPACK_IMPORTED_MODULE_4__ = __webpack_require__(/*! rxjs/operators */ "./node_modules/rxjs/_esm5/operators/index.js");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_5__ = __webpack_require__(/*! ../../environments/environment */ "./src/environments/environment.ts");






var httpOptions = {
    headers: new _angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpHeaders"]({ 'Content-Type': 'application/json' })
};
var UserService = /** @class */ (function () {
    function UserService(http) {
        this.http = http;
        this.userUrl = _environments_environment__WEBPACK_IMPORTED_MODULE_5__["environment"].user_backend + "/api";
    }
    UserService.prototype.login = function (user) {
        var _this = this;
        console.log("UserService creating user");
        var url = this.userUrl + "/login";
        return this.http.post(url, user, httpOptions)
            .pipe(Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["tap"])(function (_) { return _this.log('fetched user'); }), Object(rxjs_operators__WEBPACK_IMPORTED_MODULE_4__["catchError"])(this.handleError('login')));
    };
    /**
     * Handle Http operation that failed.
     * Let the app continue.
     * @param operation - name of the operation that failed
     * @param result - optional value to return as the observable result
     */
    UserService.prototype.handleError = function (operation, result) {
        var _this = this;
        if (operation === void 0) { operation = 'operation'; }
        return function (error) {
            // TODO: send the error to remote logging infrastructure
            console.error(error); // log to console instead
            // TODO: better job of transforming error for user consumption
            _this.log(operation + " failed: " + error.message);
            // Let the app keep running by returning an empty result.
            return Object(rxjs__WEBPACK_IMPORTED_MODULE_3__["of"])(result);
        };
    };
    /** Log a HeroService message with the MessageService */
    UserService.prototype.log = function (message) {
        console.log('UserService: ' + message);
    };
    UserService = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Injectable"])(),
        tslib__WEBPACK_IMPORTED_MODULE_0__["__metadata"]("design:paramtypes", [_angular_common_http__WEBPACK_IMPORTED_MODULE_2__["HttpClient"]])
    ], UserService);
    return UserService;
}());



/***/ }),

/***/ "./src/app/title-case.pipe.ts":
/*!************************************!*\
  !*** ./src/app/title-case.pipe.ts ***!
  \************************************/
/*! exports provided: TitleCasePipe */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "TitleCasePipe", function() { return TitleCasePipe; });
/* harmony import */ var tslib__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! tslib */ "./node_modules/tslib/tslib.es6.js");
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");


var TitleCasePipe = /** @class */ (function () {
    function TitleCasePipe() {
    }
    TitleCasePipe.prototype.transform = function (input) {
        return input.length === 0 ? '' :
            input.replace(/\w\S*/g, (function (txt) { return txt[0].toUpperCase() + txt.substr(1).toLowerCase(); }));
    };
    TitleCasePipe = tslib__WEBPACK_IMPORTED_MODULE_0__["__decorate"]([
        Object(_angular_core__WEBPACK_IMPORTED_MODULE_1__["Pipe"])({
            name: 'titleCase'
        })
    ], TitleCasePipe);
    return TitleCasePipe;
}());



/***/ }),

/***/ "./src/environments/environment.ts":
/*!*****************************************!*\
  !*** ./src/environments/environment.ts ***!
  \*****************************************/
/*! exports provided: environment */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony export (binding) */ __webpack_require__.d(__webpack_exports__, "environment", function() { return environment; });
// This file can be replaced during build by using the `fileReplacements` array.
// `ng build --prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
var environment = {
    production: false,
    inventory_backend: "http://api-gateway-amazin-dev.apps.ocp.datr.eu",
    basket_backend: "http://api-gateway-amazin-dev.apps.ocp.datr.eu",
    user_backend: "http://api-gateway-amazin-dev.apps.ocp.datr.eu"
};
/*
 * For easier debugging in development mode, you can import the following file
 * to ignore zone related error stack frames such as `zone.run`, `zoneDelegate.invokeTask`.
 *
 * This import should be commented out in production mode because it will have a negative impact
 * on performance if an error is thrown.
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.


/***/ }),

/***/ "./src/main.ts":
/*!*********************!*\
  !*** ./src/main.ts ***!
  \*********************/
/*! no exports provided */
/***/ (function(module, __webpack_exports__, __webpack_require__) {

"use strict";
__webpack_require__.r(__webpack_exports__);
/* harmony import */ var _angular_core__WEBPACK_IMPORTED_MODULE_0__ = __webpack_require__(/*! @angular/core */ "./node_modules/@angular/core/fesm5/core.js");
/* harmony import */ var _angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__ = __webpack_require__(/*! @angular/platform-browser-dynamic */ "./node_modules/@angular/platform-browser-dynamic/fesm5/platform-browser-dynamic.js");
/* harmony import */ var _app_app_module__WEBPACK_IMPORTED_MODULE_2__ = __webpack_require__(/*! ./app/app.module */ "./src/app/app.module.ts");
/* harmony import */ var _environments_environment__WEBPACK_IMPORTED_MODULE_3__ = __webpack_require__(/*! ./environments/environment */ "./src/environments/environment.ts");




if (_environments_environment__WEBPACK_IMPORTED_MODULE_3__["environment"].production) {
    Object(_angular_core__WEBPACK_IMPORTED_MODULE_0__["enableProdMode"])();
}
Object(_angular_platform_browser_dynamic__WEBPACK_IMPORTED_MODULE_1__["platformBrowserDynamic"])().bootstrapModule(_app_app_module__WEBPACK_IMPORTED_MODULE_2__["AppModule"])
    .catch(function (err) { return console.error(err); });


/***/ }),

/***/ 0:
/*!***************************!*\
  !*** multi ./src/main.ts ***!
  \***************************/
/*! no static exports found */
/***/ (function(module, exports, __webpack_require__) {

module.exports = __webpack_require__(/*! /Users/jusdavis/github/microservices-on-openshift/src/web/src/main.ts */"./src/main.ts");


/***/ })

},[[0,"runtime","vendor"]]]);
//# sourceMappingURL=main.js.map