window.onload = function () {
    // filtre produse
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

            var condFinala = condNume && condCaiPutere && condPret && condTipCaroserie;
            if (condFinala)
                produs.style.display = "block";
        }
    });

    document.getElementById("inp-pret").addEventListener('input', function() {
        document.getElementById("infoRange").innerHTML = `(${document.getElementById("inp-pret").value})`;
    });
}  