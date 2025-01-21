
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

--5. Crie uma view para exibir o nome das unidades e o total de livros disponíveis em cada uma.




SELECT * FROM autor;
SELECT * FROM bibliotecario;
SELECT * FROM categoria;
SELECT * FROM emprestimo;
SELECT * FROM livro;
SELECT * FROM unidade;
SELECT * FROM usuario;