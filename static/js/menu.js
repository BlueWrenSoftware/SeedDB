function toggleMenu() {
  let getMenu = document.querySelector(".js-menu__hamburger--black");
  getMenu.classList.toggle("js-menu__hamburger--red");
}
let getHamburger = document.querySelector("#js-open-menu");

getHamburger.addEventListener("click", toggleMenu);

