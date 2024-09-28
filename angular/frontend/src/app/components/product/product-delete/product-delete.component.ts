import { routes } from './../../../app.routes';
import { Product } from './../product.model';
import { ActivatedRoute, Router } from '@angular/router';
import { ProductService } from './../product.service';
import { Component, NgModule, OnInit, ViewEncapsulation } from '@angular/core';
import { MatButtonModule } from '@angular/material/button'
import { FormsModule, NgModel } from '@angular/forms';
import { MAT_FORM_FIELD_DEFAULT_OPTIONS, MatFormField, MatFormFieldModule } from '@angular/material/form-field';
import { MatInput, MatInputModule } from '@angular/material/input';
import { MatCard, MatCardTitle } from '@angular/material/card';
import { ProductReadComponent } from '../product-read/product-read.component';
import { ChangeDetectionStrategy } from '@angular/core';
import { MatSelectModule } from '@angular/material/select';
import {MatIconModule} from '@angular/material/icon';
import {MatDividerModule} from '@angular/material/divider';

@Component({
  selector: 'app-product-delete',
  standalone: true,
  providers: [
    { provide: MAT_FORM_FIELD_DEFAULT_OPTIONS, useValue: { appearance: 'outline' } }
  ],
  imports: [MatButtonModule, MatInput,MatFormFieldModule, MatInput, MatInputModule,
    ProductReadComponent,
    MatSelectModule,
    FormsModule,
    MatInputModule,
    MatInput,
    MatFormField,
    MatFormFieldModule,
    MatCard, MatCardTitle,],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './product-delete.component.html',
  styleUrl: './product-delete.component.css',
})
export class ProductDeleteComponent implements OnInit {
  product: Product;
  
  constructor(
    private productService: ProductService,
    private router: Router,
    private route: ActivatedRoute
  ) {}
 
  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id')!;
    this.productService.readById(id).subscribe((product) => {
      this.product = product;
    });
  }
 
  deleteProduct(): void {
    this.productService.delete(this.product.id!).subscribe(() => {
      this.productService.showMessage('Produto excluido com sucesso!');
      this.router.navigate(['/products']);
    });
  }
 
  cancel(): void {
    this.router.navigate(['/products']);
  }
}