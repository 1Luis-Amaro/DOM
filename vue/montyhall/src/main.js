import Vue from "vue";
import App from "./App"

new Vue({
    render: h => h (App)
    //outra forma de fazer 
    //render(createElement) {
    // return createElement(App)}
}).$mount("#app")