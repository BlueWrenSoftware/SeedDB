function toggleMenu() {
  let getMenu = document.querySelector(".js-menu-hamburger--black");
  getMenu.classList.toggle("js-menu-hamburger--red");
}
let getHamburger = document.querySelector(".js-menu-hamburger");

getHamburger.addEventListener("click", toggleMenu);

