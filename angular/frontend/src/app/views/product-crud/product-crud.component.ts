import { ProductReadComponent } from './../../components/product/product-read/product-read.component';
import { Component, OnInit } from '@angular/core';
import { MatButtonModule } from '@angular/material/button'
import { Router } from '@angular/router'
import { ProductRead2Component } from '../../components/product/product-read2/product-read2.component';
import { HeaderService } from '../../components/template/header/header.service';

@Component({
  selector: 'app-product-crud',
  standalone: true,
  imports: [MatButtonModule, ProductReadComponent, ProductRead2Component],
  templateUrl: './product-crud.component.html',
  styleUrl: './product-crud.component.css'
})
export class ProductCrudComponent implements OnInit{

  constructor(private router: Router, private headerService: HeaderService) {
    headerService.headerData = {
      title: 'Cadastro de Produtos',
      icon: 'storefront',
      routeUrl: '/products'
    }
  }

  ngOnInit(): void {
    
  }

navigateToProductCreate(): void {
  this.router.navigate(['/products/create'])
}

}
