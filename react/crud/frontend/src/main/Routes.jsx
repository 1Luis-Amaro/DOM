import React from 'react'
import { Routes, Route } from "react-router-dom";

import Home from '../components/home/Home';
import UserCrud from '../components/user/UserCrud';

export default props => 
	<Routes>
		<Route exact path="/" element={<Home />} /> {/* o exact quer dizer que eu vou navegar exatamente para homo quando for / já o patch supomos que coloco /user1 ele navega porquenão tem o exact*/}
		<Route path="/users/" element={<UserCrud />} />
		<Route path="*" element={<Home />} />
	</Routes>

