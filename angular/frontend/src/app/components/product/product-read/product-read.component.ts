import { Router, RouterLink } from '@angular/router';
import { subscribe } from 'diagnostics_channel';
import { ProductService } from '../product.service';
import { Product } from './../product.model';
import { Component, LOCALE_ID, OnInit, } from '@angular/core';
import { AfterViewInit, ViewChild } from '@angular/core';
import { MatTableModule, MatTable } from '@angular/material/table';
import { MatPaginatorModule, MatPaginator } from '@angular/material/paginator';
import { MatSortModule, MatSort } from '@angular/material/sort';
import { CurrencyPipe } from '@angular/common';
import  localePt from '@angular/common/locales/pt'
import { registerLocaleData } from '@angular/common';
import { routes } from '../../../app.routes';

registerLocaleData(localePt)

@Component({
  selector: 'app-product-read',
  standalone: true,
  imports: [ MatTable, MatTableModule,MatPaginator,MatPaginatorModule,MatSortModule, MatSort, CurrencyPipe, RouterLink],
  providers: [{
    provide: LOCALE_ID,
    useValue: 'pt-BR'}],
  templateUrl: './product-read.component.html',
  styleUrl: './product-read.component.css'
})
export class ProductReadComponent implements OnInit{
  products: Product []
  displayedColumns = ['id', 'name', 'price', 'action']

  constructor (private productService: ProductService) { }
  ngOnInit(): void {
    this.productService.read().subscribe(products =>{
      this.products = products
    })
  }
}
 