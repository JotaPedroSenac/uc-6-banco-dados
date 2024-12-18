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
	CONSTRAINT chk_data_emprestimo CHECK (data_emprestimo <= data_devolucao)
);



rollback;
commit;
