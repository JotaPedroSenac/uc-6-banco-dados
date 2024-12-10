CREATE TABLE IF NOT EXISTS GENERO (
	ID SERIAL PRIMARY KEY,
	NOME VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS FILME (
	ID SERIAL PRIMARY KEY,
	NOME VARCHAR(60) NOT NULL,
	ID_GENERO INT NOT NULL,
	CONSTRAINT FK_GENERO FOREIGN KEY (ID_GENERO) REFERENCES GENERO (ID)
);

INSERT INTO
	GENERO (NOME)
VALUES
	('Animação'),
	('Terror'),
	('Ação'),
	('Drama'),
	('Comedia');

INSERT INTO
	FILME (NOME, ID_GENERO)
VALUES
	('Batman', 3),
	('The Battle of the Dark River', 3),
	('White Duck', 1),
	('Breaking Barriers', 4),
	('The Two Hours', 2);
	
-- ALTER TABLE FILME ADD UNIQUE (nome);

--questão 04
INSERT INTO
	FILME (NOME, ID_GENERO)
VALUES
	('Batman - o retorno', 3),
	('Moana', 7),
	('Pato Donald', 1),
	('Hulk', 2),
	('Tropa de Elite', 6);

-- --questão 05
	INSERT INTO
		GENERO (ID, NOME)
	VALUES
		(6, 'Documentario'),
		(7, 'Suspense');

-- --questão 06
SELECT
	NOME
FROM
	FILME
WHERE
	ID_GENERO = (select id from genero where nome = 'Terror');

-- --questão 07
SELECT
	NOME
FROM
	FILME
WHERE
	ID_GENERO = (select id from genero where nome = 'Drama')
	OR ID_GENERO = (select id from genero where nome = 'Terror');

SELECT
	*
FROM
	FILME;

SELECT 
	*
FROM
	GENERO;

--questão 9
SELECT * FROM FILME WHERE nome LIKE 'T%';

-- questão 10

UPDATE filme SET id_genero=4 WHERE id_genero = 3;

-- forma melhor (mudando de drama para ação)

UPDATE FILME
	SET id_genero = (select id from genero where nome = 'Ação')
	WHERE id_genero = (select id from genero where nome = 'Drama');

-- Questão 11

SELECT FILME.NOME AS NOME_FILME, GENERO.NOME AS NOME_GENERO FROM FILME, GENERO
WHERE ID_GENERO = GENERO.ID ORDER BY FILME.NOME;

-- Questão 12

DELETE FROM FILME
WHERE ID_GENERO = (Select id from genero where nome = 'Ação');
