const express = require("express");
const fs = require("fs");
const sharp = require("sharp");
const ejs = require("ejs");
const sass = require("sass");
const { Client } = require("pg");

const formidable = require("formidable");
const crypto = require("crypto");
const session = require("express-session");
const { NONAME } = require("dns");

const app = express();

app.use(session({
  secret: 'abcdefg', // folosit de express session pentru criptarea id-ului de sesiune
  resave: true,
  saveUninitialized: false
}));

// Conectarea la baza de date

if (process.env.SITE_ONLINE) { // Client Heroku
  var client = new Client({
    user: "lqyvncxhxqraja",
    password: "9564af8319dffcd7c465af48a941b94d61daa87d36cf119527ca0ec1dd2a0cd3",
    database: "ddc50ndf2ged35",
    host: "ec2-54-164-40-66.compute-1.amazonaws.com",
    port: 5432,
    ssl: { rejectUnauthorized: false }
  });
}
else { // Client local
  var client = new Client({
    user: "pstefan",
    password: "1234",
    database: "AutoTrade",
    host: "localhost",
    port: 5432,
  });
}

client.connect();

// obiect global
obGlobal = {
  obErori: null,
  obImagini: null,
  obImaginiGalerieAnimata: null,
  obImaginiGalerieStatica: null
}

app.use("/resurse", express.static(__dirname + "/resurse"));

// res.locals
app.use("/*", function(req, res, next) {
  res.locals.tipuriCaroserii = obGlobal.tipuriCaroserii;
  res.locals.utilizator = req.session.utilizator;
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

// Utilizatori ///////////////////////////////////

parolaServer = "tehniciweb";

app.post("/inreg", function (req, res) {
  console.log("POST Request at '/inreg'");

  var formular = new formidable.IncomingForm();
  formular.parse(req, function (err, campuriText, campuriFisier) {

    var eroare = "";
    if (campuriText.username == "")
      eroare += "Username necompletat. ";
    if (!campuriText.username.match(new RegExp("^[A-Za-z0-9]+$")))
      eroare += "Username contine caractere nepermise. ";

    if (eroare != "") {
      res.render("pagini/inregistrare", { raspuns: `Eroare: ${eroare}` });
      return;
    }

    // Verific daca username-ul exista deja
    var queryUtiliz = `SELECT username FROM utilizatori WHERE username = '${campuriText.username}';`;
    client.query(queryUtiliz, function (err, rezQuery) {
      if (err) {
        console.log(err);
        res.render("pagini/inregistrare", { raspuns: `Eroare baza de date` });
        return;
      }
      if (rezQuery.rows.length != 0) {
        eroare += "Username-ul exista deja. ";
        res.render("pagini/inregistrare", { raspuns: `Eroare: ${eroare}` });
        return;
      }
      else {
        // Inserez noul utilizator cu parola criptata
        var parolaCriptata = crypto.scryptSync(campuriText.parola, parolaServer, 64).toString("hex");
        var comandaInserare = 
          "INSERT INTO utilizatori (username, nume, prenume, parola, email, culoare_chat) " +
          `VALUES (
            '${campuriText.username}',
            '${campuriText.nume}',
            '${campuriText.prenume}',
            '${parolaCriptata}',
            '${campuriText.email}',
            '${campuriText.culoare_chat}'
          );`;

        client.query(comandaInserare, function (err, rezInserare) {
          if (err) {
            console.log(err);
            res.render("pagini/inregistrare", { raspuns: `Eroare baza de date` });
          }
          else
            res.render("pagini/inregistrare", { raspuns: "Datele au fost introduse." });
        });
      }
    });
  });
});

app.post("/login", function (req, res) {
  console.log("POST Request at '/login'");

  var formular = new formidable.IncomingForm();
  formular.parse(req, function (err, campuriText, campuriFisier) {
    // Preiau din BD datele utilizatorului
    var parolaCriptata = crypto.scryptSync(campuriText.parola, parolaServer, 64).toString("hex");
    var querySelect = `SELECT * FROM utilizatori WHERE username = '${campuriText.username}' AND parola = '${parolaCriptata}';`;
    client.query(querySelect, function(err, rezQuery) {
      if (err)
        console.log(err);
      else if (rezQuery.rows.length == 1) { // am utilizatorul si credentialele sunt corecte
        req.session.utilizator = {
          nume: rezQuery.rows[0].nume,
          prenume: rezQuery.rows[0].prenume,
          username: rezQuery.rows[0].username,
          rol: rezQuery.rows[0].rol,
          email: rezQuery.rows[0].email,
          culoare_chat: rezQuery.rows[0].culoare_chat
        }
        console.log(req.session.utilizator);
        res.redirect("/index");
      }
      else {
        console.log("Login esuat!");
        res.send(":(");
      }
    });
  });
});

app.get("/logout", function (req, res) {
  req.session.destroy();
  res.locals.utilizator = null;
  res.render("pagini/logout");
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

async function trimiteMail(email, subiect, mesajText, mesajHtml, atasamente = []){
  var transp = nodemailer.createTransport({
		service: "gmail",
		secure: false,
		auth: { // date login 
			user: obGlobal.emailServer,
			pass: "rwgmgkldxnarxrgu"
		},
		tls: {
			rejectUnauthorized:false
		}
  });

  //genereaza html
  await transp.sendMail({
		from:obGlobal.emailServer,
		to:email,
		subject:subiect,//"Te-ai inregistrat cu succes",
		text:mesajText, //"Username-ul tau este "+username
		html: mesajHtml,// `<h1>Salut!</h1><p style='color:blue'>Username-ul tau este ${username}.</p> <p><a href='http://${numeDomeniu}/cod/${username}/${token}'>Click aici pentru confirmare</a></p>`,
		attachments: atasamente
  })
  console.log("trimis mail");
}

var s_port = process.env.PORT || 5000;
app.listen(s_port, () => {
  console.log(`Server is running on port ${s_port}.`);
});