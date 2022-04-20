DROP TYPE IF EXISTS categ_caroserie;
DROP TYPE IF EXISTS tip_motorizare;

CREATE TYPE categ_caroserie AS ENUM('SUV', 'estate', 'sedan', 'coupe', 'cabriolet','hatchback');
CREATE TYPE tip_tractiune AS ENUM('spate', 'data', 'integrala');


CREATE TABLE IF NOT EXISTS prajituri (
   id serial PRIMARY KEY,
   nume VARCHAR(50) UNIQUE NOT NULL,
   descriere TEXT,
   pret NUMERIC(8,2) NOT NULL,
	 producator VARCHAR(50) NOT NULL,
	 motor VARCHAR(50) NOT NULL,
	 cai_putere INT NOT NULL CHECK (cai_putere>=0),   
   kilometri_reali INT NOT NULL CHECK (kilometri_reali>=0 AND kilometri_reali <= 10000),   
   tractiune tip_tractiune DEFAULT 'spate',
   categorie categ_caroserie DEFAULT 'sedan',
   dotari VARCHAR [], --pot sa nu fie specificare deci nu punem NOT NULL
   folosita BOOLEAN NOT NULL DEFAULT TRUE,
   imagine VARCHAR(300),
   data_adaugare TIMESTAMP DEFAULT current_timestamp
);

INSERT into masini (nume, descriere, pret, producator, motor, cai_putere, kilometri_reali, motorizare, categorie, dotari, folosita, dotari, data_adaugare) VALUES 
()