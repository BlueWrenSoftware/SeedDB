function toggleMenu() {
  let getMenu = document.querySelector(".mainMenu");
  getMenu.classList.toggle("hamburger");
}
let getHamburger = document.querySelector("#openMenu");

getHamburger.addEventListener("click", toggleMenu);

/*    function toggleMenu() {
       let getMenu = document.querySelector(".mainMenu");
       getMenu.classList.toggle("hamburger");
    }
    
    let getHamburger = document.querySelector("#openMenu");
    getHamburger.addEventListener("click", toggleMenu);*/

/*     	let image_tracker = "linkHamburger";
	function change(){
 		let image = document.getElementById("changeHamburger");
 		if(image_tracker == "linkHamburger"){
 			image.src = "../images/hamburger_close.svg";
 			image_tracker = "closedHamburger";
 		}
 		else{
 			image.src = "../images/hamburger_link.svg";
 			image_tracker = "linkHamburger";
 		}
 	}*/