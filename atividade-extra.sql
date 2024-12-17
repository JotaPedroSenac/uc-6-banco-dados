--- tabela categorias

CREATE TABLE IF NOT EXISTS categorias(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255)
);

-- tabela fornecedores

CREATE TABLE IF NOT EXISTS fornecedores(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	rua VARCHAR(255),
	cidade VARCHAR(255),
	estado CHAR(2)
);

--- tabela produtos
CREATE TABLE IF NOT EXISTS produtos(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255),
	QUANTIDADE INT,
	PRECO NUMERIC(10,2),
	id_fornecedor INT,
	id_categoria INT,
	constraint fk_produto_fornecedor FOREIGN KEY(id_fornecedor) REFERENCES fornecedores(id) ON DELETE CASCADE,
	constraint fk_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categorias(id) ON DELETE CASCADE
);

-- 1. Crie uma regra para garantir que o nome de um produto seja único na tabela produtos.

ALTER TABLE produtos ADD CONSTRAINT nome_unico UNIQUE(nome);

--2. Defina uma constraint para garantir que o preço dos produtos nunca seja menor que zero.

ALTER TABLE produtos ADD CONSTRAINT check_preco_maior_zero CHECK(preco >= 0);

--3. Implemente uma constraint que assegure que a coluna quantidade na tabela produtos nunca seja nula.

ALTER TABLE produtos ALTER COLUMN quantidade SET NOT NULL;

--4. Adicione uma constraint para garantir que o estado dos fornecedores sempre siga o padrão de duas letras, como "SP" ou "RJ".

ALTER TABLE fornecedores ADD CONSTRAINT chk_sigla CHECK(estado ~ '^[A-Z]{2}$');

--5. Crie uma constraint para que o nome das categorias na tabela categorias seja único.

ALTER TABLE categorias ADD CONSTRAINT unq_categorias UNIQUE(nome);

-- inserir Dados de categorias

INSERT INTO categorias(nome) 
VALUES 
('Super Luxo'),
('Importado'),
('Tecnologia'),
('Vintage'),
('Supremo');

INSERT INTO fornecedores (nome, rua, cidade, estado)
VALUES
('Ajax SA', 'Rua Presidente Castelo Branco', 'Porto Alegre', 'RS'),
('Sansul SA', 'Av Brasil', 'Rio de Janeiro', 'RJ'),
('South Chairs', 'Rua do Moinho', 'Santa Maria', 'RS'),
('Elon Electro', 'Rua Apolo', 'São Paulo', 'SP'),
('Mike electro', 'Rua Pedro da Cunha', 'Curitiba', 'PR');


INSERT INTO produtos (nome, quantidade, preco, id_fornecedor, id_categoria)
VALUES 
('Cadeira azul', 30, 300.00, 5, 5),
('Cadeira vermelha', 50, 2150.00, 2,1),
('Guarda-roupa Disney', 400, 829.50, 4, 1),
('Torradeira Azul', 20, 9.90, 3, 1),
('TV', 30, 3000.25, 2, 2);

-- teste
SELECT * FROM categorias;
SELECT * FROM fornecedores;
SELECT * FROM produtos;

-- 6. INSERIR dados de 2 produtos de categoria 3 e qualquer fornecedor

INSERT INTO produtos (nome, quantidade, preco, id_fornecedor, id_categoria)
VALUES
('xbox', 10, 5000.00, 5, 3),
('notebook', 20, 6250.00, 5,3);

--7. INSERIR dados de 2 fornecedores distintas, sendo do Estado do RN e outro do estado da PB;

INSERT INTO fornecedores (nome, rua, cidade, estado)
VALUES
('JP PCs', 'Rua dos pajeus', 'Natal', 'RN'),
('Tudo em jampa', 'Rua das Flores', 'João Pessoa', 'PB');

--8. INSERIR dados de mais 1 categoria de nome Nacional

INSERT INTO categorias(nome)
VALUES
('Nacional');

--9. ATUALIZE a tabela produtos, aumentando o preço do produto cujo id é 4, para R$ 298.00;

UPDATE produtos SET preco = 298.00 WHERE id = 4;

--RECUPERE da tabela produtos, todos os produtos do Fornecedor localizado no RJ;

SELECT nome FROM produtos Where id_fornecedor = (SELECT id FROM fornecedores WHERE estado = 'RJ');

--10. RECUPERE da tabela produtos, todos os produtos do Fornecedor localizado no RS;

SELECT nome FROM produtos WHERE id_fornecedor IN (SELECT id FROM fornecedores WHERE estado = 'RS');

--11. RECUPERE da tabela produtos, todos os produtos do Fornecedor localizado em SP;

SELECT nome FROM produtos WHERE id_fornecedor IN (SELECT ID FROM fornecedores WHERE estado = 'SP');

--12. RECUPERE da tabela produtos e fornecedores o nome do produto mais caro e o nome do fornecedor deste produto;

SELECT produtos.nome AS Produto, fornecedores.nome AS Fornecedor, produtos.preco FROM produtos
JOIN fornecedores on produtos.id_fornecedor = fornecedores.id
ORDER BY preco DESC
LIMIT 1;

-- 13. ATUALIZE a tabela fornecedores, alterando a cidade para Parnamirim, o estado para RN e a Rua
--para Abel Cabral, do Fornecedor cujo nome é Elon Electro;

UPDATE fornecedores SET cidade = 'Parnamirim', estado = 'RN', rua = 'Abel Cabral' WHERE nome = 'Elon Electro';

--14. ATUALIZE a tabela produtos, alterando o preço dos produtos em 10% de aumento, cujo
--fornecedor seja Sansul SA.

UPDATE produtos SET preco = preco * 1.10
WHERE id_fornecedor IN (SELECT id FROM fornecedores WHERE nome = 'Sansul SA');

--15. ATUALIZE a tabela produtos, alterando o preço dos produtos em 10% de diminuição, cujo
--fornecedor seja Mike electro e a categoria seja Supremo.

UPDATE produtos SET preco = preco * 0.9
WHERE id_fornecedor IN (SELECT id FROM fornecedores WHERE nome = 'Mike electro')
AND id_categoria IN (SELECT id FROM categorias WHERE nome = 'Supremo');

-- 16. RECUPERE da tabela produtos, todos os produtos que tenham o preço entre 8 e 2.000,
--ordenados a partir do maior preço.

SELECT nome, preco FROM produtos 
WHERE preco BETWEEN 2 AND 2000
ORDER BY preco DESC

-- 17. RECUPERE da tabela produtos, todos os produtos que tenham o preço entre maior que 2.000,
--ordenados a partir do menor preço.

SELECT nome, preco
FROM produtos
WHERE preco > 2000
ORDER BY preco 

-- 18. RECUPERE da tabela fornecedor, o nome de todos os fornecedores que iniciam com a letra A.

SELECT nome FROM fornecedores
WHERE nome LIKE 'A%';

--19. RECUPERE da tabela fornecedor, o nome de todos os fornecedores que contenham a letra S.

SELECT nome FROM fornecedores 
WHERE nome LIKE '%S%';

--20. ATUALIZE a tabela produtos, aumentando em 15% a quantidade de produtos que tenham o
--preço inferior a 300.

UPDATE produtos 
SET quantidade = quantidade * 1.15
WHERE preco < 300;

-- 21. APAGUE da tabela produtos todas os produtos da categoria 5;

DELETE FROM produtos WHERE id_categoria = 5;

-- 22. RECUPERE da tabela fornecedores, todos os registros cadastrados;

SELECT * FROM fornecedores;

-- 23. RECUPERE da tabela produtos, o nome dos produtos que iniciam com a letra T e tenham o preço
--acima de 400.

SELECT nome, preco FROM produtos 
WHERE nome LIKE 'T%' AND preco > 400;

--24. APAGUE a tabela produtos;

DELETE FROM produtos;