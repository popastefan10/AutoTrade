window.addEventListener("load", function () {
	var tema = localStorage.getItem("tema");
	if (tema) {
		var btnTemaSimbol = document.getElementById("btn-tema").querySelector("i");
		btnTemaSimbol.classList.toggle("fa-sun");
		btnTemaSimbol.classList.toggle("fa-moon");
	}

	// Butonul "schimba tema"
	document.getElementById("btn-tema").addEventListener("click", function () {
		var tema = localStorage.getItem("tema");
		if (tema)
			localStorage.removeItem("tema");
		else
			localStorage.setItem("tema", "dark");
		document.body.classList.toggle("dark");

		var btnTemaSimbol = document.getElementById("btn-tema").querySelector("i");
		btnTemaSimbol.classList.toggle("fa-sun");
		btnTemaSimbol.classList.toggle("fa-moon");
	});
});