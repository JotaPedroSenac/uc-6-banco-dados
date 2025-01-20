
--1. Quantidade de bibliotecários responsáveis por cada unidade.

SELECT unidade.nome, count(bibliotecario.id) as total_bibliotecarios
FROM bibliotecario
JOIN unidade ON unidade.id = bibliotecario.id_unidade
GROUP BY unidade.nome;

--2. Quantidade de livros disponíveis em cada unidade.

--criar view
CREATE VIEW vw_quantidade_livros_disponiveis as
SELECT unidade.nome, count(livro.id) as total_livros
FROM livro
JOIN unidade ON unidade.id = livro.id_unidade
GROUP BY unidade.nome;

-- chamar view
select * from vw_quantidade_livros_disponiveis;

--3. Quantidade de empréstimos realizados em cada unidade.

SELECT unidade.nome, count(emprestimo.id) as total_emprestimos
FROM emprestimo
JOIN livro ON livro.id = emprestimo.id_livro
JOIN unidade ON unidade.id = livro.id_unidade
GROUP BY unidade.nome;

--5. Quantidade total de usuários cadastrados no sistema.

SELECT count(id) as total_usuarios
FROM usuario;

--6. Quantidade total de livros cadastrados no sistema.

SELECT count(id) as total_livros
FROM livro;

--7. Quantidade de livros emprestados por cada usuário. Ordene pelo total encontrado e em ordem decrescente.

SELECT usuario.nome, count(emprestimo.id) as total_emprestimos
FROM emprestimo
JOIN usuario ON usuario.id = emprestimo.id_usuario
GROUP BY usuario.nome
ORDER BY total_emprestimos DESC;

-- 8. Quantidade de empréstimos realizados por mês. Use EXTRACT(MONTH FROM data_emprestimo) para extrair o mês.

SELECT EXTRACT(MONTH FROM data_emprestimo) as mes, count(id) as total_emprestimos
FROM emprestimo
GROUP BY mes
ORDER BY mes;

-- 9. Média do número de páginas dos livros cadastrados no sistema.

SELECT round(avg(numero_paginas), 2) as media_paginas
FROM LIVRO;

--10. Quantidade de livros cadastrados em cada categoria.

SELECT categoria.nome as categoria, count(livro.id) as total_livros
FROM livro
JOIN categoria ON categoria.id = livro.id_categoria
GROUP by categoria;

-- 11. Liste os livros cujos autores possuem nacionalidade americana.

SELECT livro.titulo as livro, autor.nome as nome
FROM autor
JOIN livro ON livro.id_autor = autor.id
WHERE autor.nacionalidade = 'Americana';


--12. Quantidade de livros emprestados atualmente (não devolvidos).

SELECT count(id) as total_livros_emprestados
FROM emprestimo
GROUP BY devolvido
HAVING devolvido = false;

-- 13. Unidades com mais de 60 livros cadastrados.

SELECT unidade.nome as unidade, count(livro.id) as total_livros
FROM livro
JOIN unidade ON unidade.id = livro.id_unidade
GROUP by unidade
HAVING count(livro.id) > 60;

-- 14. Quantidade de livros por autor. Ordene pelo total e em ordem decrescente.

SELECT autor.nome as autor, count(livro.id) as total_livros
FROM livro
JOIN autor ON autor.id = livro.id_autor
GROUP BY autor
ORDER BY total_livros DESC;

--15. Categorias que possuem mais de 5 livros disponíveis atualmente.

SELECT categoria.nome, count(livro.id_categoria) as total_livros_disponiveis
FROM categoria
JOIN livro ON livro.id_categoria = categoria.id
WHERE livro.disponivel = true
GROUP BY categoria.nome
HAVING count(livro.id_categoria) > 5;

-- 16. Unidades com pelo menos um empréstimo em aberto.

SELECT unidade.nome
FROM unidade 
JOIN livro ON livro.id_unidade = unidade.id
JOIN emprestimo ON emprestimo.id_livro = livro.id
GROUP BY unidade.nome, emprestimo.devolvido
HAVING emprestimo.devolvido = false;

-- Selects

SELECT * FROM autor;
SELECT * FROM bibliotecario;
SELECT * FROM categoria;
SELECT * FROM emprestimo;
SELECT * FROM livro;
SELECT * FROM unidade;
SELECT * FROM usuario;


--- Procedimentos - procedures

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

-- procedure - botao direito - scripts - execute (para executar)

call inserir_novo_autor('Nome', 'br', '1990-11-11');


-- procedimento para criar nova categoria

create or replace procedure inserir_nova_categoria(
	nome varchar,
	descricao text
)
LANGUAGE SQL
AS $$
INSERT INTO categoria(nome, descricao) 
VALUES (nome, descricao)
$$;

call inserir_nova_categoria('ação', 'livros de ação');




-- procedimento de atualização

create or replace procedure update_telefone_unidade(
	id_unidade integer,
	telefone_unidade varchar
) language sql
as $$
UPDATE unidade SET telefone = telefone_unidade
where id = id_unidade
$$;


-- procedimento para atualizar none do usuario

select * from usuario;

create or replace procedure update_nome_usuario(
	id_usuario integer,
	nome_usuario varchar
) language sql
as $$
UPDATE usuario SET nome = nome_usuario
where id = id_usuario
$$;

-- procedimento para excluir um livro pelo id

select * from livro;

delete from livro where id = 109;


create or replace procedure delete_livro(
	id_livro integer
) language sql
as $$
delete from livro where id = id_livro
$$;



--- Funções - functions

