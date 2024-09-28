import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { HeaderComponent } from './components/template/header/header.component';
import { FooterComponent } from './components/template/footer/footer.component';
import { NavComponent } from './components/template/nav/nav.component';
import { ProductCreateComponent } from './components/product/product-create/product-create.component';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, HeaderComponent, FooterComponent, NavComponent, ProductCreateComponent],
  templateUrl: 'app.component.html',
  styles: [],
})
export class AppComponent {
  title = 'froasdasdsadsantend';
}
