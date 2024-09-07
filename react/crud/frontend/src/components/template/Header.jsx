import './Header.css'
import React from 'react'

export default props =>
    <header className='header d-none d-sm-flex flex-column'>{/*estou dizendo que para celulares o header nao aparecera e se o dispositivo for sm para cima ele usa o displa flex */}
        <h1 className="mt-3"> {/**margin bottom 3 */}
            <i className={`fa fa-${props.icon}`}></i> {props.title}
        </h1>
        <p className='lead text-muted'>{props.subtitle}</p>
    </header>