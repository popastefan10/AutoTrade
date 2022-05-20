# AutoTrade
Site la care lucrez pentru cursul de Tehnici Web, poate fi accesat [aici](https://frozen-everglades-33559.herokuapp.com/).

## Prerequisites
* Trebuie instalat [PostgreSQL](https://www.postgresql.org/download/). Dupa ce s-a instalat trebuie adaugat folder-ul `PostgreSQL\14\bin` in `PATH` 
  (pe Windows de obicei se afla in `C:\Program Files\`).
* Trebuie instalat [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli).

## Instructiuni instalare
    > git clone https://github.com/popastefan10/AutoTrade.git
    > cd AutoTrade
    > npm install
    > npm install -g nodemon
    > npm install -g sass
    > nodemon .
    
## Posibile erori
* Nu gaseste fisierele `.css` din folder-ul `resurse/temp`
  Solutie: trebuie creat manual folder-ul `resurse/temp`
* In `package.json` trebuie sa fie specificate versiunea de `node` folosita.
