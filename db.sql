-- obsluga w lini polecen:
-- kasia:~$ psql przepisy
-- przepisy=# \i Dokumenty/BazyDanych/db.sql        
-- to wykonuje ten kod

DROP TABLE IF EXISTS polaczenie;
DROP TABLE IF EXISTS historia;
DROP TABLE IF EXISTS przepisy;
DROP TABLE IF EXISTS produkty;
DROP TABLE IF EXISTS uzytkownicy;


CREATE TABLE uzytkownicy(
			id_uzyt SERIAL PRIMARY KEY NOT NULL ,
			nazwa varchar(256) NOT NULL
			);

INSERT INTO uzytkownicy(nazwa) VALUES ('kasia');


CREATE TABLE produkty(
			id_prod  SERIAL PRIMARY KEY NOT NULL,
			nazwa varchar(256) NOT NULL
			);

INSERT INTO produkty (nazwa) VALUES ('marchew');
INSERT INTO produkty (nazwa) VALUES ('groszek');
INSERT INTO produkty (nazwa) VALUES ('ser');
INSERT INTO produkty (nazwa) VALUES ('twaróg');
INSERT INTO produkty (nazwa) VALUES ('mleko');
INSERT INTO produkty (nazwa) VALUES ('szynka');
INSERT INTO produkty (nazwa) VALUES ('śmietana');
INSERT INTO produkty (nazwa) VALUES ('jogurt');
INSERT INTO produkty (nazwa) VALUES ('grzyby');


CREATE TABLE przepisy(
			id_przep  SERIAL PRIMARY KEY NOT NULL ,
			nazwa varchar(256) NOT NULL,
			przepis varchar(1024) NOT NULL,
			id_uzyt int4,
			FOREIGN KEY (id_uzyt) REFERENCES uzytkownicy(id_uzyt),
			data timestamp
			);

INSERT INTO przepisy (nazwa,przepis,data) VALUES ('ser z grzybami', 'dodaj grzyby do sera', '2015-12-30 22:15:00');
INSERT INTO przepisy (nazwa,przepis,data) VALUES ('marchewka z groszkiem', 'dodaj marchewke do groszku', '2015-12-30 22:15:01');




CREATE TABLE polaczenie(
			id_pol  SERIAL PRIMARY KEY NOT NULL ,
			id_prod int4, 
			FOREIGN KEY (id_prod) REFERENCES produkty(id_prod),		
			id_przep int4,
			FOREIGN KEY (id_przep) REFERENCES przepisy(id_przep)	

			);

INSERT INTO polaczenie (id_prod, id_przep) VALUES (9 , 1);
INSERT INTO polaczenie (id_prod, id_przep) VALUES (3 , 1);
INSERT INTO polaczenie (id_prod, id_przep) VALUES (1 , 2);
INSERT INTO polaczenie (id_prod, id_przep) VALUES (2 , 2);


CREATE TABLE historia(
			id_hist  SERIAL PRIMARY KEY NOT NULL ,
			id_przep int4,
			FOREIGN KEY (id_przep) REFERENCES przepisy(id_przep),					
			zmiana varchar(1024),
			UNIQUE (zmiana),
			id_uzyt int4,
			FOREIGN KEY (id_uzyt) REFERENCES uzytkownicy(id_uzyt),		
			data timestamp
			);

INSERT INTO historia (zmiana) VALUES ('dodaj to to i to, no i nie zapomnij o tym');

--------------------
DROP FUNCTION IF EXISTS spr_stan_przed_insert() ;
CREATE FUNCTION spr_stan_przed_insert() RETURNS TRIGGER AS '
BEGIN
	IF NEW.data < (SELECT data FROM historia WHERE id_przep=NEW.id_przep ) THEN 
		RAISE NOTICE ''Operacja nie zostala wykonana. Nie edytujesz najnowszego przepisu'';
		RETURN NULL;
	ELSE
		INSERT INTO historia (id_przep, zmiana, id_uzyt, data)
		VALUES (OLD.id_przep, OLD.przepis, OLD.id_uzyt, now()) ;
		RETURN NEW;
END IF;
END;
' LANGUAGE 'plpgsql';

--DROP TRIGGER IF EXISTS t_spr_stan_przed_insert ON przepisy ;
CREATE TRIGGER t_spr_stan_przed_insert BEFORE UPDATE ON przepisy FOR EACH ROW EXECUTE PROCEDURE spr_stan_przed_insert();