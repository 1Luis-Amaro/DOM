import { ProductService } from './../product.service';
import { Component, NgModule, OnInit} from '@angular/core';
import { Router } from '@angular/router';
import { MatButtonModule } from '@angular/material/button'
import { Product } from '../product.model';
import { FormsModule, NgModel } from '@angular/forms';
import { MAT_FORM_FIELD_DEFAULT_OPTIONS, MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatCard, MatCardTitle } from '@angular/material/card';




@Component({
  selector: 'app-product-create',
  standalone: true,
  providers: [
    {provide: MAT_FORM_FIELD_DEFAULT_OPTIONS, useValue: {appearance: 'outline'}}
  ],
  imports: [MatButtonModule, FormsModule, MatInputModule, MatFormFieldModule, MatInputModule, MatCard, MatCardTitle, ],
  templateUrl: './product-create.component.html',
  styleUrl: './product-create.component.css'
})
export class ProductCreateComponent implements OnInit {

  product: Product = {
    name: '',
    price: null
  }

constructor(private productService: ProductService, private router: Router){ }

  ngOnInit(): void {
  }

  createProduct(): void {
    this.productService.create(this.product).subscribe(() => {
      this.productService.showMessage('Produto Criado')
      this.router.navigate(['/products'])

    })
  }

  cancel(): void {
    this.router.navigate(['/products'])
  }



}

