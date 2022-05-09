// const index = require("../../index");

function normalizeStringWithSpaces(stringWithSpaces) {
	var tokens = stringWithSpaces.split(" ");
	tokens = tokens.map(token => token.toLowerCase());
	var normalizedString = tokens.join("_");
	return normalizedString;
}

function getStringFromNormalized(normalizedString) {
	var tokens = normalizedString.split("_");
	var retString = tokens.join(" ");
	return retString;
}

function ascundeDotari() {
	const LIM = 6;

	var dotari = document.getElementsByClassName("container-dotare");
	for (let idx = LIM; idx < dotari.length; idx++)
	dotari[idx].style.display = "none";

	var btnAscundeDotari = document.getElementById("ascunde-dotari").querySelector("button");
	btnAscundeDotari.innerHTML = "+ Mai multe";
}

function afiseazaDotari() {
	var dotari = document.getElementsByClassName("container-dotare");
	for (let idx = 0; idx < dotari.length; idx++)
	dotari[idx].style.display = "block";

	var btnAscundeDotari = document.getElementById("ascunde-dotari").querySelector("button");
	btnAscundeDotari.innerHTML = "- Mai putine";
}

window.onload = function () {
	ascundeDotari();

	// ascunde filtrele
	document.getElementById("btn-ascunde-filtre").addEventListener('click', function() {
		var sectiuneFiltre = document.getElementById("filtre-produse");

		if (sectiuneFiltre.style.display == "none")
			sectiuneFiltre.style.display = "block";
		else
			sectiuneFiltre.style.display = "none";
	});

	// ascunde dotarile
	document.getElementById("ascunde-dotari").addEventListener('click', function() {
		var btnAscundeDotari = document.getElementById("ascunde-dotari").querySelector("button");
		if (btnAscundeDotari.innerHTML[0] == "+")
			afiseazaDotari();
		else
			ascundeDotari();
	});

	// butonul de filtrare
	document.getElementById("filtrare").addEventListener('click', function () {
		if (!valideazaInputuri())
			return;

		// obtin valorile dupa care sa filtrez
		// nume
		var valNume = document.getElementById("inp-nume").value.toLowerCase();

		// producator
		var valProducator = document.getElementById("input-producator").value;

		// tipuri de motoare
		var selectTipuriDeMotoare = document.getElementById("select-tip-motor");
		var valTipuriDeMotoare = new Array();
		for (let optiuneTipMotor of selectTipuriDeMotoare.querySelectorAll("option"))
			if (optiuneTipMotor.selected)
				valTipuriDeMotoare.push(optiuneTipMotor.value);

		// interval cai putere
		var butoaneRadio = document.getElementsByName("gr_rad");
		for (let butonRadio of butoaneRadio)
			if (butonRadio.checked)
				var valCaiPutere = butonRadio.value;
	
		var minCaiPutere, maxCaiPutere; // obtin intervalul de cai putere
		if (valCaiPutere != "toate") {
			[minCaiPutere, maxCaiPutere] = valCaiPutere.split(":")
			minCaiPutere = parseInt(minCaiPutere);
			maxCaiPutere = parseInt(maxCaiPutere);
		}
		else
			minCaiPutere = 0, maxCaiPutere = 10000;

		// pret minim
		var minPret = document.getElementById("inp-pret").value;

		// tip caroserie
		var tipCaroserie = document.getElementById("inp-categorie").value;

		// dotari
		var checkboxDotari = document.getElementsByName("dotari");
		var dotariAlese = new Array();
		for (let checkboxDotare of checkboxDotari) {
			if (checkboxDotare.checked)
				dotariAlese.push(checkboxDotare.value);
		}

		// cuvinte cheie
		var textareaCuvCheie = document.getElementById("textarea-cuv-cheie");
		var cuvinteCheie = textareaCuvCheie.value.split(",").map(cuvCheie => cuvCheie.trim());

		// filtrarea produselor
		var produse = document.getElementsByClassName("produs");
		for (let produs of produse) {
			produs.style.display = "none";

			var numeProdus = produs.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase();
			var condNume = numeProdus.includes(valNume);

			var producatorProdus = produs.getElementsByClassName("val-producator")[0].innerHTML;
			var condProducator = valProducator == "" || producatorProdus == valProducator;

			var tipMotorProdus = produs.getElementsByClassName("val-tip-motor")[0].innerHTML;
			var condTipMotor = valTipuriDeMotoare.length == 0 || valTipuriDeMotoare.includes(tipMotorProdus);

			var caiPutereProdus = parseInt(produs.getElementsByClassName("val-cai-putere")[0].innerHTML);
			var condCaiPutere = caiPutereProdus >= minCaiPutere && caiPutereProdus < maxCaiPutere;

			var pretProdus = parseInt(produs.getElementsByClassName("val-pret")[0].innerHTML);
			var condPret = pretProdus >= minPret;

			var tipCaroserieProdus = produs.getElementsByClassName("val-categorie")[0].innerHTML;
			var condTipCaroserie = tipCaroserie == "toate" || tipCaroserieProdus == tipCaroserie;

			var dotariProdus = produs.getElementsByClassName("val-dotari")[0].innerHTML.split(",");
			var condDotari = false;
			if (dotariAlese.length == 0)
				condDotari = true;
			else
				for (let dotareProdus of dotariProdus) {
					dotareProdus = dotareProdus.trim();
					condDotari ||= dotariAlese.includes(dotareProdus);
				}
			
			var descriereProdus = produs.getElementsByClassName("descriere")[0].innerHTML.toLowerCase();
			var condDescriere = false;
			for (let cuvantCheie of cuvinteCheie)
				condDescriere ||= descriereProdus.includes(cuvantCheie);

			var condFinala =
				condNume &&
				condProducator &&
				condTipMotor &&
				condCaiPutere &&
				condPret &&
				condTipCaroserie &&
				condDotari &&
				condDescriere;
			if (condFinala)
				produs.style.display = "block";
		};
	});

	// afisez valoarea pe care o indica range-ul
	document.getElementById("inp-pret").addEventListener("input", function() {
		document.getElementById("infoRange").innerHTML = `${document.getElementById("inp-pret").value}`;
	});

	// butonul de resetare
	document.getElementById("resetare").addEventListener("click", function() {
		// resetez filtrele la starea initiala
		document.getElementById("inp-nume").value = "";
		document.getElementById("input-producator").value = "";
		document.getElementById("i_rad5").checked = true;
		document.getElementById("inp-pret").value = document.getElementById("inp-pret").defaultValue;
		document.getElementById("infoRange").innerHTML = `(${document.getElementById("inp-pret").defaultValue})`;
		document.getElementById("sel-toate").selected = true;
		document.getElementById("textarea-cuv-cheie").value = "";

		// tipuri de motoare
		var selectTipuriDeMotoare = document.getElementById("select-tip-motor");
		for (let optiuneTipMotor of selectTipuriDeMotoare.querySelectorAll("option"))
			optiuneTipMotor.selected = false;

		// dotari
		var checkboxuriDotari = document.getElementsByName("dotari");
		for (let checkboxDotare of checkboxuriDotari)
			checkboxDotare.checked = false;
		ascundeDotari();

		// afisez toate produsele
		var produse = document.getElementsByClassName("produs");
		for (let produs of produse) {
			produs.style.display = "block";
		}
	});

	// butonul de sortare crescator dupa pret si numarul de dotari
	document.getElementById("sortCrescPretNrDotari").addEventListener("click", function() {
		var produse = document.getElementsByClassName("produs");
		var vProduse = Array.from(produse);

		vProduse.sort((a, b) => {
			return cmpProduse(a, b, [{functieCmp: cmpProdusePret, ascending: true}, {functieCmp: cmpProduseDotari, ascending: true}]);
		});

		for(let produs of vProduse) {
			produs.parentElement.appendChild(produs);
		}
	});

	// butonul de sortare descrescator dupa pret si numarul de dotari
	document.getElementById("sortDescrescPretNrDotari").addEventListener("click", function() {
		var produse = document.getElementsByClassName("produs");
		var vProduse = Array.from(produse);

		vProduse.sort((a, b) => {
			return cmpProduse(a, b, [{functieCmp: cmpProdusePret, ascending: false}, {functieCmp: cmpProduseDotari, ascending: false}]);
		});

		for(let produs of vProduse) {
			produs.parentElement.appendChild(produs);
		}
	});

	// butonul pentru calculul mediei preturilor
	document.getElementById("calcPretMediu").addEventListener("click", function() {
		var produse = document.getElementsByClassName("produs");
		var pretTotal = 0, nrProduse = 0;

		for (let produs of produse)
			if (produs.style.display != "none") {
				pretTotal += parseInt(produs.getElementsByClassName("val-pret")[0].innerHTML);
				nrProduse++;
			}

		var pretMediu = Math.round(pretTotal / nrProduse).toFixed(0);
		document.getElementsByClassName("val-pret-mediu")[0].innerHTML = pretMediu;
		document.getElementById("container-pret-mediu").style.display = "block";
		
		var displayTime = 2000; // ms
		setTimeout(function () {
			document.getElementById("container-pret-mediu").style.display = "none";
		}, displayTime);
	});
};

// functii de comparare de produse dupa diferite criterii
function cmpProdusePret(produsA, produsB, ascending) {
	var pretA = parseInt(produsA.getElementsByClassName("val-pret")[0].innerHTML);
	var pretB = parseInt(produsB.getElementsByClassName("val-pret")[0].innerHTML);
	return ascending ? pretA - pretB : pretB - pretA;
}

function cmpProduseNume(produsA, produsB, ascending) {
	var numeA = produsA.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase();
	var numeB = produsB.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase();
	return (ascending ? 1 : -1) * numeA.localeCompare(numeB);
}

function cmpProduseDotari(produsA, produsB, ascending) {
	var nrDotariA = produsA.getElementsByClassName("val-dotari")[0].innerHTML.split(",").length;
	var nrDotariB = produsB.getElementsByClassName("val-dotari")[0].innerHTML.split(",").length;
	return (ascending ? 1 : -1) * (nrDotariA - nrDotariB);
}

function cmpProduse(produsA, produsB, vObFunctiiCmp) {
	for(let obFunctieCmp of vObFunctiiCmp) {
		var rezFunctieCmp = obFunctieCmp.functieCmp(produsA, produsB, obFunctieCmp.ascending);
		if (rezFunctieCmp)
			return rezFunctieCmp;
	}

	return -1;
}

function valideazaInputuri() {
	var valCuvCheie = document.getElementById("textarea-cuv-cheie").value.split(",");
	
	for (let cuvCheie of valCuvCheie) {
		cuvCheie = cuvCheie.trim()
		if (cuvCheie.split(" ").length > 1) {
			alert("Cuvintele cheie trebuie să fie separate prin virgulă!");
			return false;
		}
	}

	return true;
}