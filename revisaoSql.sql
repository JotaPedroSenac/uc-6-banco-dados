CREATE TABLE aluno(
	id SERIAL,
	nome VARCHAR(255),
	cpf CHAR(11),
	observacao TEXT,
	idade INTEGER,
	dinheiro NUMERIC(10,2),
	altura REAL,
	ativo BOOLEAN,
	data_nascimento DATE,
	hora TIME,
	matriculado_em TIMESTAMP
);



INSERT INTO aluno
(nome, 
cpf, 
observacao, 
idade, 
dinheiro, 
altura, 
ativo, 
data_nascimento,
hora,
matriculado_em) 
VALUES 
('Diogo', 
'12345678901', 
'texto aleatório escrito somente para encher linguiça',
25,
100.50,
1.81,
TRUE,
'1999-06-22',
'17:30:00',
'2024-12-12 00:08:20');

UPDATE aluno set nome = 'JP';

DELETE FROM aluno WHERE nome = 'JP';

INSERT INTO aluno
(nome, 
cpf, 
observacao, 
idade, 
dinheiro, 
altura, 
ativo, 
data_nascimento,
hora,
matriculado_em) 
VALUES 
('Diogo', 
'12345678901', 
'texto aleatório escrito somente para encher linguiça',
25,
100.50,
1.81,
TRUE,
'1999-06-22',
'17:30:00',
'2024-12-12 00:08:20');

SELECT nome, cpf, matriculado_em AS quando_se_matriculou FROM aluno;

INSERT INTO aluno (nome) VALUES ('Vinicius Dias');
INSERT INTO aluno (nome) VALUES ('Nico Steppat');
INSERT INTO aluno (nome) VALUES ('João Roberto');
INSERT INTO aluno (nome) VALUES ('Diego');

--diferente
-- SELECT *
-- FROM aluno
-- WHERE nome <> 'Diego'

--semelhante
-- SELECT * FROM aluno WHERE nome LIKE 'Di_go';

-- Não é --semelhante

--SELECT * FROM aluno WHERE nome NOT LIKE 'Di_go';

---So trazer quem começa com D

-- SELECT * FROM aluno WHERE nome LIKE 'D%';

-- retornar campo cpf vazio (não vazio seria is not null)

-- SELECT * FROM aluno WHERE cpf IS NULL;

-- Selecionar um intervalo de numeros

-- SELECT * FROM aluno WHERE idade BETWEEN 18 AND 35;

CREATE TABLE curso(
  id INT PRIMARY KEY,
  nome VARCHAR(255)
);

INSERT INTO curso (id, nome)
VALUES (1, 'HTMl');

INSERT INTO curso (id, nome)
VALUES (2, 'JavaScript');

SELECT * FROM curso;

CREATE TABLE alunos(
  id SERIAL PRIMARY KEY,
  nome VARCHAR(255) NOT NULL
);

INSERT INTO alunos(nome) VALUES ('Diogo');
INSERT INTO alunos(nome) VALUES ('Vinicius');

SELECT * FROM alunos;

CREATE TABLE aluno_curso(
  aluno_id INT,
  curso_id INT,
  PRIMARY KEY (aluno_id, curso_id),
  foreign KEY (aluno_id) references alunos (id),
  foreign KEY (curso_id) references curso (id)
);

INSERT INTO aluno_curso(aluno_id, curso_id) VALUES (1,1);
INSERT INTO aluno_curso(aluno_id, curso_id) VALUES (2,1);
SELECT * FROM aluno_curso;

--Juntando tabelas

SELECT * FROM alunos
JOIN aluno_curso ON aluno_curso.aluno_id = alunos.id
JOIN curso       ON curso.id                     = aluno_curso.curso_id;

INSERT INTO aluno_curso (aluno_id, curso_id) VALUES (2, 2);

SELECT * FROM alunos
JOIN aluno_curso ON aluno_curso.aluno_id = alunos.id
JOIN curso       ON curso.id                     = aluno_curso.curso_id;


--- Se quiser apenas os nomes ( e apelido)

SELECT alunos.nome as alunos, curso.nome as cursos FROM alunos
JOIN aluno_curso ON aluno_curso.aluno_id = alunos.id
JOIN curso       ON curso.id                     = aluno_curso.curso_id;