const express = require("express");
const fs = require("fs");
const sharp = require("sharp");
const ejs = require("ejs");
const sass = require("sass");
const { Client } = require("pg");

const app = express();

// Conectarea la baza de date

// Client local //////////////////////////////////
// const client_username = "pstefan";
// const client_password = "1234";
// const client_database = "AutoTrade";
// const client_host = "localhost";
// const client_port = 5432;

// var client = new Client({
//   user: client_username,
//   password: client_password,
//   database: client_database,
//   host: client_host,
//   port: client_port,
// });

// Client Heroku /////////////////////////////////
const client_username = "lqyvncxhxqraja";
const client_password = "9564af8319dffcd7c465af48a941b94d61daa87d36cf119527ca0ec1dd2a0cd3";
const client_database = "ddc50ndf2ged35";
const client_host = "ec2-54-164-40-66.compute-1.amazonaws.com";
const client_port = 5432;

var client = new Client({
  user: client_username,
  password: client_password,
  database: client_database,
  host: client_host,
  port: client_port,
  ssl: { rejectUnauthorized: false }
});

client.connect();

// obiect global
obGlobal = {
  obErori: null,
  obImagini: null,
  obImaginiGalerieAnimata: null,
  obImaginiGalerieStatica: null
}

app.use("/resurse", express.static(__dirname + "/resurse"));

// Trimitem tipurile de caroserii in res.locals
app.use("/*", function(req, res, next) {
  res.locals.tipuriCaroserii = obGlobal.tipuriCaroserii;
  next();
});

app.set("view engine", "ejs");

// Home
app.get(["/", "/home", "/index"], (req, res) => {

  res.render("pagini/index", {
    ip: req.ip,
    imagini: obGlobal.obImaginiGalerieStatica
  });
  
  console.log("GET Request at '/'");
});

// Galerie statica - compilare sass, ejs
app.get("*/galerie_statica.css", (req, res) => {
  filtreazaGalerieStatica();
  var nrImagini = obGlobal.obImaginiGalerieStatica.length;
  compileSassWithEJS(res, "galerie_statica", { nrImagini: nrImagini });
});

// Galerie animata - compilare sass, ejs
app.get("*/galerie_animata.css", (req, res) => {
  filtreazaGalerieAnimata();
  var nrImagini = obGlobal.obImaginiGalerieAnimata.length;
  compileSassWithEJS(res, "galerie_animata", { nrImagini: nrImagini });
})

// Ultimele vanzari
app.get("/ultimele_vanzari", (req, res) => {
  res.render("pagini/ultimele_vanzari", { imagini: obGlobal.obImaginiGalerieStatica, imaginiGalerieAnimata: obGlobal.obImaginiGalerieAnimata });
  console.log("GET Request at '/ultimele_vanzari'");
});

// Produse
app.get("/produse", function(req, res) {
  getInfoFromDB();

  var tipProdus = req.query.tip;
  var condQuery = tipProdus ? `categorie = '${tipProdus}'` : `1 = 1`;

  client.query(`SELECT * FROM masini WHERE ${condQuery}`, function(err, rezQuery) {
    if(err)
      console.log(err);

    res.render("pagini/produse", {
      produse: rezQuery.rows,
      optiuni: obGlobal.tipuriCaroserii,
      producatori: obGlobal.producatori,
      tipuriDeMotoare: obGlobal.tipuriDeMotoare,
      cai_putere: obGlobal.cai_putere,
      pret: obGlobal.pret,
      dotari: obGlobal.dotari
    });
  });
  console.log("GET Request at '/produse'");
});

app.get("/produs/:id", function(req, res) {
  client.query(`SELECT * FROM masini WHERE id = ${req.params.id}`, function(err, rezQuery) {
    res.render("pagini/produs", {prod: rezQuery.rows[0]});
  });
  console.log(`GET Request at '/produs/${req.params.id}'`);
});

// Eroare custom
app.get("/eroare", function (req, res) {
  randeazaEroare(res, 1, "Titlu custom");
});

// Eroare 403
app.get("/*.ejs", (req, res) => {
  randeazaEroare(res, 403); // Eroare 403
});

// Cerere generala
app.get("/*", (req, res, next) => {
  console.log("GET Request at /*: " + req.url);

  res.render("pagini" + req.url + ".ejs", function (err, html) {
    if (err) {
      if (err.message.includes("Failed to lookup view")) {
        randeazaEroare(res, 404); // Eroare 404
        console.log(err);
      }
    } else {
      res.send(html);
    }
  });
  next();
});

// Galerie statica
function creeazaImagini() {
  var buf = fs
    .readFileSync(__dirname + "/resurse/json/galerie.json")
    .toString("utf8");
  obGlobal.obImagini = JSON.parse(buf); // global

  // Trunchiez numarul de imagini la un numar divizibil cu 3
  var nrImagini = obGlobal.obImagini.imagini.length;
  nrImagini = Math.floor(nrImagini / 3) * 3;
  obGlobal.obImagini.imagini = obGlobal.obImagini.imagini.slice(0, nrImagini);

  // Creez duplicate redimensionate pentru fiecare imagine
  for (let imagine of obGlobal.obImagini.imagini) {
    let nume_imagine, extensie;
    [nume_imagine, extensie] = imagine.cale_relativa.split(".");

    let dim_mic = 250;
    let dim_mediu = 300;
    // obtin imaginile in dimensiune mica, medie si mare
    imagine.mic = `${obGlobal.obImagini.cale_galerie}/mic/${nume_imagine}-${dim_mic}.webp`; // nume-150.webp
    imagine.mediu = `${obGlobal.obImagini.cale_galerie}/mediu/${nume_imagine}-${dim_mediu}.png`; // nume-300.png
    imagine.mare = `${obGlobal.obImagini.cale_galerie}/${imagine.cale_relativa}`;

    // daca nu exista imaginea in dimensiune mica redimensionez imaginea mare
    if (!fs.existsSync(imagine.mic)) {
      sharp(__dirname + "/" + imagine.mare)
        .resize(dim_mic)
        .toFile(__dirname + "/" + imagine.mic);

      console.log(__dirname + "/" + imagine.mic);
    }

    // daca nu exista imaginea in dimensiune medie redimensionez imaginea mare
    if (!fs.existsSync(imagine.mediu)) {
      sharp(__dirname + "/" + imagine.mare)
        .resize(dim_mediu)
        .toFile(__dirname + "/" + imagine.mediu);
    }
  }
}
creeazaImagini();

// Alege imaginile care se potrivesc cu ora curenta
function filtreazaGalerieStatica() {
  // Filtrez imaginile dupa momentul zilei
  d = new Date();
  ora = d.getHours();

  var moment;
  if (ora >= 5 && ora < 12) moment = "dimineata";
  else if (ora >= 12 && ora < 20) moment = "zi";
  else moment = "noapte";
  obGlobal.obImaginiGalerieStatica = obGlobal.obImagini.imagini.filter(
    (imagine) => imagine.timp == moment
  );
}
filtreazaGalerieStatica();

// Alege din imaginile galeriei statica un nr par aleator
// de imagini cuprins intre 6 si 12 inclusiv
function filtreazaGalerieAnimata() {
  // Mai intai ma asigur ca am obtinut pozele din galeria statica
  filtreazaGalerieStatica();

  // Calculez numarul de poze din galeria animata
  var nrPoze = Math.floor(Math.random() * 6) + 6 // Generez un numar de poze intre 0 si 6
  nrPoze = Math.min(nrPoze, obGlobal.obImaginiGalerieStatica.length);
  nrPoze -= nrPoze % 2; // Numarul de poze trebuie sa fie par

  // Aleg aleator un numar de poze din galeria statica
  obGlobal.obImaginiGalerieAnimata = obGlobal.obImaginiGalerieStatica.filter((imagine) => true);
  obGlobal.obImaginiGalerieAnimata.sort((a, b) => 0.5 - Math.random()); // Shuffle
  obGlobal.obImaginiGalerieAnimata = obGlobal.obImaginiGalerieAnimata.filter(
    (imagine, index) => index < nrPoze
  );
}
filtreazaGalerieAnimata();

// Functia compileaza un fisier sass, resurse/sass/fisier.sass
// mai intai cu ejs apoi cu sass si obtine in final un fisier
// css in locatia resurse/temp/fisier.css
// Parametri:
//    numeFisier = numele fisierului fara extensie
//    ejsLocals = optiunile trimise procesorului de ejs
function compileSassWithEJS(res, numeFisier, ejsLocals) {
  // Obtin codul sass
  var sirScss = fs
    .readFileSync(__dirname + `/resurse/sass/${numeFisier}.scss`)
    .toString("utf8");

  // Compilez ejs-ul si obtin un nou sass pe care il pun in folder-ul temp
  var rezScss = ejs.render(sirScss, ejsLocals);
  var caleScss = __dirname + `/temp/${numeFisier}.scss`;
  if (!fs.existsSync(__dirname + "/temp"))
    fs.mkdir(__dirname + "/temp", function (err) { console.log(err); });
  fs.writeFileSync(caleScss, rezScss);

  try {
    // Compilez codul sass din temp
    rezCompilare = sass.compile(caleScss, { sourceMap: true });

    // Scriu codul css intr-un fisier in temp
    var caleCss = __dirname + `/temp/${numeFisier}.css`;
    fs.writeFileSync(caleCss, rezCompilare.css);

    // Send response
    res.setHeader("Content-Type", "text/css");
    res.sendFile(caleCss);
  } catch (err) {
    console.log(err);
    res.send("Eroare :(");
  }
}

// Erori
function creeazaErori() {
  var buf = fs
    .readFileSync(__dirname + "/resurse/json/erori.json")
    .toString("utf-8");
  obGlobal.obErori = JSON.parse(buf); // global
}
creeazaErori();

function randeazaEroare(res, identificator, titlu, text, imagine) {
  var eroare = obGlobal.obErori.erori.find(function (elem) {
    return elem.identificator == identificator;
  });

  titlu = titlu || (eroare && eroare.titlu) || "Eroare - titlu";
  text = text || (eroare && eroare.text) || "Eroare - text";
  imagine =
    imagine ||
    (eroare && obGlobal.obErori.cale_baza + "/" + eroare.imagine) ||
    obGlobal.obErori.cale_baza + "/" + "interzis.jpg";

  if (eroare && eroare.status) {
    res.status(eroare.identificator).render("pagini/eroare_generala", {
      titlu: eroare.titlu,
      text: eroare.text,
      imagine: obGlobal.obErori.cale_baza + "/" + eroare.imagine,
    });
  } else {
    res.render("pagini/eroare_generala", {
      titlu: titlu,
      text: text,
      imagine: imagine,
    });
  }
}

// SQL ///////////////////////////////////////////

// Preia toate informatiile importante din baza de date:
//    tipurile de caroserii,
//    
function getInfoFromDB() {
  getTipuriCaroseriiFromDB();
  getProducatoriFromDB();
  getTipuriDeMotoareFromDB();
  getCaiPutereFromDB();
  getPretFromDB();
  getDotariFromDB();
}
getInfoFromDB();

// Preia tipurile de caroserii din baza de date
function getTipuriCaroseriiFromDB() {
  client.query("SELECT unnest(enum_range(NULL::categ_caroserie));", function (err, rezCateg) {
    if (err)
      console.log(err);
    else {
      obGlobal.tipuriCaroserii = [];
      for (let tipCaroserie of rezCateg.rows)
        obGlobal.tipuriCaroserii.push(tipCaroserie.unnest);
    }
  });
}

// Preia toti producatorii din baza de date
function getProducatoriFromDB() {
  obGlobal.producatori = new Object();

  var producatori_query = "SELECT DISTINCT producator FROM masini ORDER BY producator;";
  client.query(producatori_query, function(err, rezQuery) {
    if(err)
      console.log(err);
    else {
      var producatori = new Array();
      for (let producator of rezQuery.rows)
        producatori.push(producator.producator);
      obGlobal.producatori.toti = producatori;
    }
  })
}

function getTipuriDeMotoareFromDB() {
  obGlobal.tipuriDeMotoare = new Object();

  var tipuriDeMotoareQuery = "SELECT DISTINCT tip_motor FROM masini;";
  client.query(tipuriDeMotoareQuery, function(err, rezQuery) {
    if(err)
      console.log(err);
    else {
      obGlobal.tipuriDeMotoare.toate = new Array();
      for (let tipMotor of rezQuery.rows)
        obGlobal.tipuriDeMotoare.toate.push(tipMotor.tip_motor);
      
      obGlobal.tipuriDeMotoare.toate.sort(function (tip1, tip2) {
        return parseInt(tip1.substr(1)) - parseInt(tip2.substr(1));
      });
    }
  });
}

// Preia maximul si minimul de cai putere
function getCaiPutereFromDB() {
  obGlobal.cai_putere = new Object();

  var max_cai_putere_query = "SELECT MAX(cai_putere) FROM masini;";
  client.query(max_cai_putere_query, function(err, rezQuery) {
    if(err)
      console.log(err);
    else
      obGlobal.cai_putere.max = rezQuery.rows[0].max;
  });

  var min_cai_putere_query = "SELECT MIN(cai_putere) FROM masini;";
  client.query(min_cai_putere_query, function(err, rezQuery) {
    if(err)
      console.log(err);
    else
      obGlobal.cai_putere.min = rezQuery.rows[0].min;
  });
}

// Preia pretul minim si maxim
function getPretFromDB () {
  obGlobal.pret = new Object();

  var max_pret_query = "SELECT MAX(pret) FROM masini;";
  client.query(max_pret_query, function(err, rezQuery) {
    if(err)
      console.log(err);
    else
      obGlobal.pret.max = rezQuery.rows[0].max;
  });

  var min_pret_query = "SELECT MIN(pret) FROM masini;";
  client.query(min_pret_query, function(err, rezQuery) {
    if(err)
      console.log(err);
    else
      obGlobal.pret.min = rezQuery.rows[0].min;
  });
}

// Preia dotarile sub forma unui set de string-uri nenormalizate
function getDotariFromDB() {
  obGlobal.dotari = new Object();

  var dotari_query = "SELECT dotari FROM masini;";
  client.query(dotari_query, function(err, rezQuery) {
    if(err)
      console.log(err);
    else {
      var perechi_dotari = rezQuery.rows;
      obGlobal.dotari.toate = new Set();
      for (let pereche_dotari of perechi_dotari)
        for (let dotare of pereche_dotari.dotari)
          obGlobal.dotari.toate.add(dotare);
    }
  });
}

var s_port = process.env.PORT || 5000;
app.listen(s_port, () => {
  console.log(`Server is running on port ${s_port}.`);
});