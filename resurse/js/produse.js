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

window.onload = function () {
	// functieTest();

	// ascunde filtrele
	document.getElementById("ascunde-filtre").addEventListener('click', function() {
		var sectiuneFiltre = document.getElementById("filtre-produse");

		if (sectiuneFiltre.style.display == "none")
			sectiuneFiltre.style.display = "block";
		else
			sectiuneFiltre.style.display = "none";
	});

    // butonul de filtrare
    document.getElementById("filtrare").addEventListener('click', function () {
        // obtin valorile dupa care sa filtrez
        // nume
        var valNume = document.getElementById("inp-nume").value.toLowerCase();

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

        // filtrarea produselor
        var produse = document.getElementsByClassName("produs");
        for (let produs of produse) {
            produs.style.display = "none";

            var numeProdus = produs.getElementsByClassName("val-nume")[0].innerHTML.toLowerCase();
            var condNume = numeProdus.includes(valNume);

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
			// condDotari = true;

            var condFinala = condNume && condCaiPutere && condPret && condTipCaroserie && condDotari;
            if (condFinala)
                produs.style.display = "block";
        };
    });

    // afisez valoarea pe care o indica range-ul
    document.getElementById("inp-pret").addEventListener("input", function() {
        document.getElementById("infoRange").innerHTML = `(${document.getElementById("inp-pret").value})`;
    });

    // butonul de resetare
    document.getElementById("resetare").addEventListener("click", function() {
        // resetez filtrele la starea initiala
        document.getElementById("inp-nume").value = "";
        document.getElementById("i_rad5").checked = true;
        document.getElementById("inp-pret").value = document.getElementById("inp-pret").defaultValue;
        document.getElementById("infoRange").innerHTML = `(${document.getElementById("inp-pret").defaultValue})`;
        document.getElementById("sel-toate").selected = true;

		var checkboxuriDotari = document.getElementsByName("dotari");
		for (let checkboxDotare of checkboxuriDotari)
			checkboxDotare.checked = false;

        // afisez toate produsele
        var produse = document.getElementsByClassName("produs");
        for (let produs of produse) {
            produs.style.display = "block";
        }
    });

    // butonul de sortare crescator dupa pret si nume
    document.getElementById("sortCrescNume").addEventListener("click", function() {
        var produse = document.getElementsByClassName("produs");
        var vProduse = Array.from(produse);

        vProduse.sort((a, b) => {
            return cmpProduse(a, b, [{functieCmp: cmpProdusePret, ascending: true}, {functieCmp: cmpProduseNume, ascending: true}]);
        });

        for(let produs of vProduse) {
            produs.parentElement.appendChild(produs);
        }
    });

    // butonul de sortare descrescator dupa pret si nume
    document.getElementById("sortDescrescNume").addEventListener("click", function() {
        var produse = document.getElementsByClassName("produs");
        var vProduse = Array.from(produse);

        vProduse.sort((a, b) => {
            return cmpProduse(a, b, [{functieCmp: cmpProdusePret, ascending: false}, {functieCmp: cmpProduseNume, ascending: false}]);
        });

        for(let produs of vProduse) {
            produs.parentElement.appendChild(produs);
        }
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

function cmpProduse(produsA, produsB, vObFunctiiCmp) {
    for(let obFunctieCmp of vObFunctiiCmp) {
        var rezFunctieCmp = obFunctieCmp.functieCmp(produsA, produsB, obFunctieCmp.ascending);
        if (rezFunctieCmp)
            return rezFunctieCmp;
    }

    return -1;
}