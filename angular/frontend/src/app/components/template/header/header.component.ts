import { Component } from '@angular/core';
import { MatToolbarModule } from '@angular/material/toolbar'
import { RouterModule, RouterOutlet } from '@angular/router';
import { HeaderService } from './header.service';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [MatToolbarModule, RouterOutlet, RouterModule],
  templateUrl: './header.component.html',
  styleUrl: './header.component.css'
})
export class HeaderComponent {

  constructor(private headerService: HeaderService) {}

  ngOnInit(): void {
  }
    get title(): string{
      return this.headerService.headerData.title
    }

    get icon(): string{
      return this.headerService.headerData.icon
    }

    get routeUrl(): string{
      return this.headerService.headerData.routeUrl
    }


  }

