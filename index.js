const express = require("express");
const fs = require("fs");
const app = express();

app.use("/resurse", express.static(__dirname + "/resurse"));

app.set("view engine", "ejs");

app.get(["/", "/home", "/index"], (req, res) => {
  res.render("pagini/index", { ip: req.ip });
  console.log("GET Request at '/'");
});

app.get("/eroare", function(req, res) {
  randeazaEroare(res, 1, "Titlu custom");
});

app.get("/*.ejs", (req, res) => {
  randeazaEroare(res, 403); // Eroare 403
});

app.get("/*", (req, res, next) => {
  console.log("GET Request at /*: " + req.url);

  res.render("pagini" + req.url + ".ejs", function (err, html) {
    if (err) {
      if (err.message.includes("Failed to lookup view")) {
        console.log(err);
        randeazaEroare(res, 404); // Eroare 404
      }
    } else {
      res.send(html);
    }
  });
  next();
});

function creeazaErori() {
  var buf = fs
    .readFileSync(__dirname + "/resurse/json/erori.json")
    .toString("utf-8");
  obErori = JSON.parse(buf); // global
  console.log(obErori);
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
  }
  else {
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
