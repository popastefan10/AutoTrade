const express = require("express");
const fs = require("fs");
const sharp = require("sharp");
const ejs = require("ejs");
const sass = require("sass");

const app = express();

app.use("/resurse", express.static(__dirname + "/resurse"));

app.set("view engine", "ejs");

// Home
app.get(["/", "/home", "/index"], (req, res) => {
  res.render("pagini/index", { ip: req.ip, imagini: obImagini.imagini, abc: 7 });
  console.log("GET Request at '/'");
});

// Galerie statica - compilare sass, ejs
app.get("*/galerie_statica.css", (req, res) => {
  // Obtin codul sass
  var sirScss = fs.readFileSync(__dirname + "/resurse/sass/galerie_statica.scss").toString("utf8");
  var nrImagini = obImagini.imagini.length;

  // Compilez ejs-ul si obtin un nou sass pe care il pun in folder-ul temp
  rezScss = ejs.render(sirScss, { nrImagini: nrImagini });
  var caleScss = __dirname + "/temp/galerie_statica.scss";
  fs.writeFileSync(caleScss, rezScss);

  try {
    // Compilez codul sass din temp
    rezCompilare = sass.compile(caleScss, {sourceMap: true});

    // Scriu codul css intr-un fisier in temp
    var caleCss = __dirname + "/temp/galerie_statica.css";
    fs.writeFileSync(caleCss, rezCompilare.css);

    // Send response
    res.setHeader("Content-Type", "text/css");
    res.sendFile(caleCss);
  }
  catch (err) {
    console.log(err);
    res.send("Eroare :(");
  }
});

// Ultimele vanzari
app.get("/ultimele_vanzari", (req, res) => {
  res.render("pagini/ultimele_vanzari", { imagini: obImagini.imagini });
  console.log("GET Request at '/ultimele_vanzari'");
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
  obImagini = JSON.parse(buf); // global

  // Filtrez imaginile dupa momentul zilei
  d = new Date();
  ora = d.getHours();
  var moment;
  if(ora >= 5 && ora < 12)
    moment = "dimineata";
  else if(ora >= 12 && ora < 20)
    moment = "zi";
  else
    moment = "noapte";
  obImagini.imagini = obImagini.imagini.filter(imagine => imagine.timp == moment);

  // Trunchiez numarul de imagini la un numar divizibil cu 3
  var nrImagini = obImagini.imagini.length;
  nrImagini = Math.floor(nrImagini / 3) * 3;
  obImagini.imagini = obImagini.imagini.slice(0, nrImagini);

  // Creez duplicate redimensionate pentru fiecare imagine
  for (let imagine of obImagini.imagini) {
    let nume_imagine, extensie;
    [nume_imagine, extensie] = imagine.cale_relativa.split(".");

    let dim_mic = 250;
    let dim_mediu = 300;
    // obtin imaginile in dimensiune mica, medie si mare
    imagine.mic = `${obImagini.cale_galerie}/mic/${nume_imagine}-${dim_mic}.webp`; // nume-150.webp
    imagine.mediu = `${obImagini.cale_galerie}/mediu/${nume_imagine}-${dim_mediu}.png`; // nume-300.png
    imagine.mare = `${obImagini.cale_galerie}/${imagine.cale_relativa}`;

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

// Erori
function creeazaErori() {
  var buf = fs
    .readFileSync(__dirname + "/resurse/json/erori.json")
    .toString("utf-8");
  obErori = JSON.parse(buf); // global
}
creeazaErori();

function randeazaEroare(res, identificator, titlu, text, imagine) {
  var eroare = obErori.erori.find(function (elem) {
    return elem.identificator == identificator;
  });

  titlu = titlu || (eroare && eroare.titlu) || "Eroare - titlu";
  text = text || (eroare && eroare.text) || "Eroare - text";
  imagine =
    imagine ||
    (eroare && obErori.cale_baza + "/" + eroare.imagine) ||
    obErori.cale_baza + "/" + "interzis.jpg";

  if (eroare && eroare.status) {
    res.status(eroare.identificator).render("pagini/eroare_generala", {
      titlu: eroare.titlu,
      text: eroare.text,
      imagine: obErori.cale_baza + "/" + eroare.imagine,
    });
  } else {
    res.render("pagini/eroare_generala", {
      titlu: titlu,
      text: text,
      imagine: imagine,
    });
  }
}

const PORT = 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
