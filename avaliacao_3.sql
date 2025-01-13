
--1. Quantidade de bibliotecários responsáveis por cada unidade.

SELECT unidade.nome, count(bibliotecario.id) as total_bibliotecarios
FROM bibliotecario
JOIN unidade ON unidade.id = bibliotecario.id_unidade
GROUP BY unidade.nome;

--2. Quantidade de livros disponíveis em cada unidade.

SELECT unidade.nome, count(livro.id) as total_livros
FROM livro
JOIN unidade ON unidade.id = livro.id_unidade
GROUP BY unidade.nome;

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