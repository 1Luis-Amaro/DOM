import { Component } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatListModule } from '@angular/material/list'
import { HomeComponent } from '../../../views/home/home.component';
import { ProductCrudComponent } from '../../../views/product-crud/product-crud.component';
import { RouterModule, RouterOutlet } from '@angular/router';





@Component({
  selector: 'app-nav',
  standalone: true,
  imports: [MatToolbarModule, MatSidenavModule, MatListModule, HomeComponent, ProductCrudComponent, RouterModule, RouterOutlet],
  templateUrl: './nav.component.html',
  styleUrl: './nav.component.css'
})
export class NavComponent {

}
