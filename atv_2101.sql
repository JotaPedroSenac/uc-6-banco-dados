-- view
-- 1. Crie uma view para listar todos os livros com seus autores e categorias.

CREATE VIEW livros_com_autores_e_categorias AS
	SELECT
	livro.id AS id_livro,
	livro.titulo,
	autor.nome AS autor_nome,
	categoria.nome AS categoria_nome

	FROM
		livro
	JOIN autor ON livro.id_autor = autor.id
	JOIN categoria ON livro.id_categoria = categoria.id;

	-- chamar view

	select * from livros_com_autores_e_categorias;

-- 2. Crie uma view que exiba os livros disponíveis com título, unidade e categoria

	CREATE VIEW livros_disponiveis AS
	SELECT
	livro.id AS id_livro,
	livro.titulo,
	unidade.nome AS unidade_nome,
	categoria.nome AS categoria_nome

	FROM
		livro
	JOIN unidade ON unidade.id = livro.id_unidade
	JOIN categoria ON livro.id_categoria = categoria.id
	WHERE livro.disponivel = true;

	select * from livros_disponiveis;

-- 3. Crie uma view para listar os usuários e o total de empréstimos realizados por cada um.

CREATE VIEW usuarios_qntd_emprestimos AS
	SELECT usuario.nome as nome_usuario, 
	count(emprestimo.id) as total_emprestimo
	from emprestimo
	join usuario on usuario.id = emprestimo.id_usuario
	group by usuario.nome
	order by total_emprestimo desc;

	select * from usuarios_qntd_emprestimos;

-- 4. Crie uma view que mostre os empréstimos atrasados com os nomes dos usuários e os títulos dos livros.

	CREATE VIEW emprestimos_atrasados AS
		SELECT emprestimo.id, usuario.nome, livro.titulo, emprestimo.devolvido as devolvido
		from emprestimo
		join livro on livro.id = emprestimo.id_livro
		join usuario on usuario.id = emprestimo.id_usuario
		where emprestimo.devolvido = false
		
		select * from emprestimos_atrasados;

--5. Crie uma view para exibir o nome das unidades e o total de livros disponíveis em cada uma.*

CREATE VIEW livros_disponiveis_por_unidade AS
	SELECT unidade.nome as nome_unidade, count(livro.id_unidade) as total_livros_disponiveis
	FROM livro
	join unidade on unidade.id = livro.id_unidade
	where livro.disponivel = true
	group by unidade.nome
	order by total_livros_disponiveis desc;

	select * from livros_disponiveis_por_unidade;
		
-- 6. Crie uma view que exiba todos os autores com o número total de livros publicados.

CREATE VIEW livros_publicados_por_autor AS
	SELECT autor.nome as nome_autor, count(*) as qntd_livros_publicados
	from livro
	join autor on autor.id = livro.id_autor
	group by autor.nome
	order by qntd_livros_publicados desc;

	select * from livros_publicados_por_autor;

-- 7. Crie uma view para listar todos os empréstimos com o status de devolução(devolvido ou não).

CREATE VIEW status_de_devolução_emprestimo AS
	SELECT livro.titulo as titulo_livro, emprestimo.devolvido as status_devolvido
	from emprestimo
	join livro on livro.id = emprestimo.id_livro;

	select * from status_de_devolução_emprestimo;

--8. Crie uma view para listar os livros categorizados por ano de publicação, ordenados do mais recente para o mais antigo.

CREATE VIEW livros_por_ano_publicaçao AS
	SELECT titulo, ano_publicacao
	from livro
	order by ano_publicacao desc;

select * from livros_por_ano_publicaçao;

--9. Crie uma view que mostre os bibliotecários e as unidades às quais estão associados.

CREATE VIEW bibliotecario_unidade AS
	select bibliotecario.nome as nome_bibliotecario, unidade.nome as nome_unidade
	from bibliotecario
	join unidade on unidade.id = bibliotecario.id_unidade;
	
select * from bibliotecario_unidade;

-- 10. Crie uma view para exibir os usuários que nunca realizaram empréstimos.

CREATE VIEW usuarios_sem_emprestimos AS
	select nome
	from usuario
	join emprestimo on emprestimo.id_usuario = usuario.id
	where emprestimo.id_usuario is null;

select * from usuarios_sem_emprestimos;


------ procedures

-- 1. Crie uma procedure para adicionar um novo autor ao banco de dados.

create or replace procedure inserir_novo_autor(
	nome varchar,
	nacionalidade varchar,
	data_nascimento date
)
LANGUAGE SQL
AS $$
INSERT INTO autor(nome, nacionalidade, data_nascimento) 
VALUES (nome, nacionalidade, data_nascimento)
$$;

call inserir_novo_autor('zezinho', 'brasileiro', '1990-11-11');


-- 2. Crie uma procedure para registrar um novo empréstimo, verificando se o livro está disponível.


CREATE OR REPLACE PROCEDURE registrar_novo_emprestimo(
    id_usuario INTEGER,
    id_livro INTEGER,
    data_devolucao DATE
)
LANGUAGE plpgsql
AS $$
BEGIN

    INSERT INTO emprestimo(id_usuario, id_livro, data_devolucao)
    VALUES (id_usuario, id_livro, data_devolucao);
    UPDATE livro 
    SET disponivel = FALSE 
    WHERE id = id_livro;
END;
$$;


call registrar_novo_emprestimo(1, 116, '2025-01-22');


--- 3. Crie uma procedure para devolver um livro, atualizando o status de devolução e a disponibilidade.

create or replace procedure devolucao_livro(
	id_do_livro INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE livro 
    SET disponivel = TRUE 
    WHERE id = id_do_livro;

	UPDATE emprestimo 
    SET devolvido = TRUE 
    WHERE id_livro = id_do_livro;
END;
$$;

call devolucao_livro(111);

--4. Crie uma procedure para excluir uma unidade, garantindo que os livros relacionados sejam removidos.

create or replace procedure excluir_unidade(
	id_da_unidade INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    delete from unidade 
    WHERE id = id_da_unidade;
END;
$$;


call excluir_unidade(4);

-- 5. Crie uma procedure para adicionar uma nova categoria à tabela de categorias.

create or replace procedure inserir_nova_categoria(
	nome varchar,
	descricao text
)
LANGUAGE SQL
AS $$
INSERT INTO categoria(nome, descricao) 
VALUES (nome, descricao)
$$;

call inserir_nova_categoria('Religião', 'livros de religião');

-- 6. Crie uma procedure para atualizar o telefone de um usuário, identificando-o pelo ID.

create or replace procedure atualizar_telefone(
	id_do_usuario INTEGER,
	telefone_usuario VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE usuario 
    SET telefone = telefone_usuario 
    WHERE id = id_do_usuario;

END;
$$;

call atualizar_telefone(1, '(84) 99999-9999');

-- 7. Crie uma procedure para transferir um livro de uma unidade para outra.

create or replace procedure transferir_livro_unidade(
	id_do_livro INTEGER,
	id_da_unidade INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE livro 
    SET id_unidade = id_da_unidade
    WHERE id = id_do_livro;

END;
$$;

call transferir_livro_unidade(110, 2);

-- 8. Crie uma procedure para remover um bibliotecário, verificando se ele está associado a alguma unidade.

create or replace procedure remover_bibliotecario(
	id_do_bibliotecario INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    delete from bibliotecario 
    WHERE id = id_do_bibliotecario;
END;
$$;

call remover_bibliotecario(7);

-- 9. Crie uma procedure para atualizar a categoria de um livro, identificando-o pelo ID.

create or replace procedure atualizar_categoria_livro(
	id_do_livro INTEGER,
	id_da_categoria INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE livro 
    SET id_categoria = id_da_categoria 
    WHERE id = id_do_livro;

END;
$$;

call atualizar_categoria_livro(110, 6);

-- 10. Crie uma procedure para adicionar um novo usuário ao banco de dados, passando os dados necessários como parâmetros.

create or replace procedure inserir_novo_usuario(
	nome_user varchar,
	email_user varchar,
	telefone_user varchar,
	endereco_user text
)
LANGUAGE PLPGSQL
AS $$
BEGIN
	INSERT INTO usuario(nome, email,telefone,endereco) 
	VALUES (nome_user,email_user,telefone_user, endereco_user);
	END;
$$;

call inserir_novo_usuario('zezinho', 'zezinho@email.com', '(84) 999888-0000', 'rua dos bobos');


SELECT * FROM autor;
SELECT * FROM bibliotecario;
SELECT * FROM categoria;
SELECT * FROM emprestimo order by id;
SELECT * FROM livro order by id;
SELECT * FROM unidade;
SELECT * FROM usuario;