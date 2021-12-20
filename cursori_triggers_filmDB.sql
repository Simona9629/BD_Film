-- rutine cu cursori

-- o procedura care primeste genul unei productii
-- afiseaza o lista cu titlul productiilor

DELIMITER //
CREATE OR REPLACE PROCEDURE productii_dupa_gen(IN gen VARCHAR(50))
BEGIN
	DECLARE titlu_productie VARCHAR(50);
	DECLARE lista_productii VARCHAR(500);
    DECLARE ok TINYINT(1) DEFAULT 1;
    DECLARE cursor_productii CURSOR FOR
		SELECT titlu
        FROM productie
        WHERE productie.gen = gen;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_productii;
    productii: LOOP
		FETCH cursor_productii INTO titlu_productie;
        IF ok = 0 THEN
			LEAVE productii;
		ELSE 
			SET lista_productii = CONCAT_WS('-', lista_productii, titlu_productie);
		END if;
    END LOOP productii;
    CLOSE cursor_productii;
    SELECT lista_productii;
END;
//
DELIMITER ;

CALL productii_dupa_gen('drama');

-- tabela serial

CREATE TABLE serial(
	id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    titlu VARCHAR(50),
    data_aparitie DATE,
    gen VARCHAR(50)
);

-- procedura care populeaza tabela serial

DELIMITER //
CREATE OR REPLACE PROCEDURE populare_serial()
BEGIN
	DECLARE titlu_serial VARCHAR(50);
    DECLARE data_aparitie DATE;
    DECLARE gen VARCHAR(50);
    DECLARE ok TINYINT(1) DEFAULT 1;
    DECLARE cursor_seriale CURSOR FOR
		SELECT productie.titlu, productie.data_aparitie, productie.gen
        FROM productie
        WHERE tip = 'serial';
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_seriale;
    TRUNCATE serial;
    seriale: LOOP
		FETCH cursor_seriale INTO titlu_serial, data_aparitie, gen;
        IF ok = 0 THEN 
			LEAVE seriale;
		ELSE
			INSERT INTO serial VALUES(NULL, titlu_serial, data_aparitie, gen);
        END IF;
    END LOOP seriale;
    CLOSE cursor_seriale;
    SELECT * FROM serial;

END;
//
DELIMITER ;
CALL populare_serial();

-- functie care primeste ca parametru numele unui membru
-- returneaza o lista cu productiile la care acesta a lucrat

DELIMITER //
CREATE FUNCTION productii_dupa_membru(nume VARCHAR(70)) RETURNS VARCHAR(200)
BEGIN
	DECLARE titlu_productie VARCHAR(50);
    DECLARE lista_productii VARCHAR(200);
    DECLARE ok TINYINT(1) DEFAULT 1;
    DECLARE cursor_membru CURSOR FOR 
		SELECT titlu
        FROM membru JOIN membru_productie ON membru.id = membru_productie.id_membru
        JOIN productie ON membru_productie.id_productie = productie.id
        WHERE CONCAT(membru.prenume, ' ', membru.nume) = nume;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET ok = 0;
    OPEN cursor_membru;
    productii: LOOP
		FETCH cursor_membru INTO titlu_productie;
        IF ok = 0 THEN
			LEAVE productii;
		ELSE
			SET lista_productii = CONCAT_WS('-', lista_productii, titlu_productie);
        END IF;
    END LOOP productii;
	CLOSE cursor_membru;
    RETURN lista_productii;

END;
//
DELIMITER ;

SELECT productii_dupa_membru('Stephen Edwin King');
SELECT productii_dupa_membru('Christopher Edward Nolan');


