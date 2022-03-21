const express = require("express");
const app = express();

app.use("/resurse", express.static(__dirname + "/resurse"));

app.set("view engine", "ejs");

app.get(["/", "/home", "/index"], (req, res) => {
  res.render("pagini/index", {ip: req.ip});
  console.log("GET Request at '/'");
});

app.get("/*.ejs", (req, res) => {
  res.status(403).render("pagini/403.ejs");
});

app.get("/*", (req, res, next) => {
  console.log("GET Request at /*: " + req.url);

  res.render("pagini" + req.url + ".ejs", function(err, html) {
    if(err) {
      if(err.message.includes("Failed to lookup view")) {
        console.log(err);
        res.status(404).render("pagini/404.ejs");
      }
    }
    else {
      res.send(html);
    }
  });
  next();
});

const PORT = 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});