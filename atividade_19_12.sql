begin;

CREATE TABLE IF NOT EXISTS autor(
	id serial PRIMARY KEY,
	nome varchar(60) NOT NULL,
	data_nascimento date,
	CONSTRAINT chk_data_nascimento CHECK (data_nascimento <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS livro (
	id serial PRIMARY KEY,
	titulo varchar(60) NOT NULL,
	id_autor integer,
	ano_publicacao integer,
	CONSTRAINT autor_livro FOREIGN KEY (id_autor) REFERENCES autor (id) ON DELETE CASCADE,
	CONSTRAINT chk_ano_publicacao CHECK (ano_publicacao >= 1500 AND ano_publicacao <= extract(YEAR FROM CURRENT_DATE))
);

CREATE TABLE IF NOT EXISTS usuario (
	id serial PRIMARY KEY,
	nome varchar(60) NOT NULL,
	email varchar(60) UNIQUE,
	data_adesao date,
	CONSTRAINT chk_data_adesao CHECK (data_adesao <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS emprestimo (
	id serial PRIMARY KEY,
	id_livro integer,
	id_usuario integer,
	data_emprestimo date NOT NULL,
	data_devolucao date,
	CONSTRAINT emprestimo_livro FOREIGN KEY (id_livro) REFERENCES livro (id)ON DELETE CASCADE,
	CONSTRAINT emprestimo_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id) ON DELETE CASCADE,
	CONSTRAINT chk_data_emprestimo CHECK (data_emprestimo <= data_devolucao),
	CONSTRAINT uq_livro_emprestimo UNIQUE(id_livro, data_emprestimo)
);

--insert

INSERT INTO autor (nome, data_nascimento) 
VALUES 
('J.K. Rowling', '1965-07-31'),
('Gabriel García Márquez', '1927-03-06'),
('Jane Austen', '1775-12-16'),
('George Orwell', '1903-06-25'),
('Machado de Assis', '1839-06-21');

INSERT INTO livro (titulo, id_autor, ano_publicacao) 
VALUES 
('Harry Potter', 1, 1997),
('Cem Anos de Solidão', 2, 1967),
('Orgulho e Preconceito', 3, 1813),
('1984', 4, 1949),
('Dom Casmurro', 5, 1899);

INSERT INTO usuario (nome, email, data_adesao)
VALUES
('João Pedro', 'joaopedro@email.com', '2024-06-19'),
('Valtemir', 'valtemir@email.com', '2024-06-20'),
('Joel', 'joel@email.com', '2024-06-21'),
('Xexeu', 'xexeu@email.com', '2024-06-22'),
('Eduardo PM', 'eduardopm@email.com', '2024-06-22');

INSERT INTO emprestimo (id_livro, id_usuario, data_emprestimo, data_devolucao)
VALUES
(1, 1, '2024-12-19', '2024-12-31'),
(2, 2, '2024-12-19', '2024-12-31'),
(3, 3, '2024-12-19', '2024-12-31'),
(4, 4, '2024-12-19', '2024-12-31'),
(5, 5, '2024-12-19', '2024-12-31');

-- consultas teste

SELECT * FROM autor;
SELECT * FROM livro;
SELECT * FROM usuario;
SELECT * FROM emprestimo;

-- Liste todos os livros com seus respectivos autores

SELECT autor.nome, livro.titulo FROM autor
JOIN livro ON livro.id_autor = autor.id;

--Liste os usuarios e seus e-mails

SELECT nome, email FROM usuario;

-- Mostre todos os empréstimos realizados, incluindo as informações do livro, do usuarios e das datas

SELECT usuario.nome, livro.titulo, emprestimo.data_emprestimo, emprestimo.data_devolucao FROM
emprestimo JOIN livro ON id_livro = livro.id JOIN usuario ON id_usuario = usuario.id;

-- Liste os livros que ainda não foram devolvidos.

SELECT livro.titulo, emprestimo.data_devolucao
FROM emprestimo
JOIN livro on id_livro = livro.id
WHERE data_devolucao = NULL;

-- Verifique se há tentativas de empréstimos duplicados no mesmo dia para um mesmo livro. (adiada)

--18. Encontre os usuários que pegaram emprestado livros do autor Jane Austen

SELECT usuario.nome, livro.titulo, autor.nome AS nome_autor FROM emprestimo
JOIN livro ON id_livro = livro.id
JOIN usuario ON id_usuario = usuario.id
JOIN autor ON id_autor = autor.id
WHERE autor.nome = 'Jane Austen';


rollback;
commit;