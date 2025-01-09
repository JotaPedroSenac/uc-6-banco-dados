begin;
CREATE TABLE IF NOT EXISTS cliente (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	cpf CHAR(14) UNIQUE NOT NULL,
	email VARCHAR(60) UNIQUE,
	telefone CHAR(11),
	data_cadastro TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE IF NOT EXISTS produto(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	descricao VARCHAR(60),
	preco NUMERIC(10,2) NOT NULL,
	quantidade_estoque INTEGER NOT NULL,
	data_cadastro TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
	CONSTRAINT chk_preco CHECK (preco >= 0),
	CONSTRAINT chk_quantidade_estoque CHECK (quantidade_estoque > 0)
);

CREATE TABLE IF NOT EXISTS funcionario (
	id SERIAL PRIMARY KEY,
	nome VARCHAR(60) NOT NULL,
	cpf CHAR(14) UNIQUE NOT NULL,
	cargo VARCHAR(30) NOT NULL,
	salario NUMERIC(10,2) NOT NULL,
	data_admissao TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
	email VARCHAR(60) UNIQUE,
	CONSTRAINT chk_salario CHECK (salario >= 0)
);

CREATE TABLE IF NOT EXISTS venda(
	id SERIAL PRIMARY KEY,
	cliente_id INTEGER,
	funcionario_id INTEGER,
	data TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
	total NUMERIC(10,2) NOT NULL,
	CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES cliente (id),
	CONSTRAINT fk_venda_funcionario FOREIGN KEY (funcionario_id) REFERENCES funcionario (id) ON DELETE SET NULL,
	CONSTRAINT chk_total_venda CHECK (total >= 0)
);

CREATE TABLE IF NOT EXISTS itens_venda (
	id SERIAL PRIMARY KEY,
	venda_id INTEGER,
	produto_id INTEGER,
	quantidade INTEGER NOT NULL,
	preco_unitario NUMERIC(10,2) NOT NULL,
	subtotal NUMERIC(10,2) NOT NULL,
	CONSTRAINT fk_itens_venda FOREIGN KEY (venda_id) REFERENCES venda (id) ON DELETE CASCADE,
	CONSTRAINT fk_venda_produto FOREIGN KEY (produto_id) REFERENCES produto (id) ON DELETE SET NULL,
	CONSTRAINT chk_quantidade CHECK (quantidade > 0),
	CONSTRAINT chk_subtotal CHECK (subtotal > 0)
);

-- Inserções na tabela cliente
INSERT INTO cliente (nome, cpf, email, telefone) VALUES
('João Silva', '123.456.789-00', 'joao.silva@email.com', '11999999999'),
('Maria Oliveira', '987.654.321-00', NULL, NULL),
('Carlos Pereira', '456.123.789-00', 'carlos.pereira@email.com', '21988888888'),
('Ana Santos', '789.123.456-00', 'ana.santos@email.com', NULL),
('Pedro Lima', '321.654.987-00', NULL, '31977777777');

-- Inserções na tabela produto
INSERT INTO produto (nome, descricao, preco, quantidade_estoque) VALUES
('Notebook', 'Notebook Core i5, 8GB RAM', 3500.00, 10),
('Smartphone', 'Smartphone 128GB, Dual SIM', 2000.00, 20),
('TV 50"', 'Smart TV 50 polegadas 4K', 3000.00, 5),
('Teclado Mecânico', 'Teclado com iluminação RGB', 250.00, 15),
('Mouse Gamer', 'Mouse com sensor de alta precisão', 150.00, 30);

-- Inserções na tabela funcionario
INSERT INTO funcionario (nome, cpf, cargo, salario, data_admissao, email) VALUES
('Lucas Ferreira', '321.987.654-00', 'Gerente', 5000.00, '2023-01-10', 'lucas.ferreira@email.com'),
('Fernanda Costa', '654.321.987-00', 'Vendedor', 2500.00, '2023-02-15', 'fernanda.costa@email.com'),
('Ricardo Alves', '987.123.654-00', 'Caixa', 2000.00, '2023-03-20', NULL),
('Juliana Martins', '123.789.456-00', 'Assistente', 1800.00, '2023-04-25', 'juliana.martins@email.com'),
('Paulo Souza', '789.456.123-00', 'Supervisor', 3000.00, '2023-05-30', NULL);

-- Inserções na tabela venda
INSERT INTO venda (cliente_id, funcionario_id, total) VALUES
(1, 1, 5500.00),
(2, 2, 2500.00),
(3, 3, 3000.00),
(4, NULL, 1800.00),
(5, 5, 4500.00);

-- Inserções na tabela itens_venda
INSERT INTO itens_venda (venda_id, produto_id, quantidade, preco_unitario, subtotal) VALUES
(1, 1, 1, 3500.00, 3500.00),
(1, 2, 1, 2000.00, 2000.00),
(2, 3, 1, 2500.00, 2500.00),
(3, 4, 2, 250.00, 500.00),
(3, 5, 1, 150.00, 150.00);

-- testes

SELECT * FROM cliente;
SELECT * FROM funcionario;
SELECT * FROM produto;
SELECT * FROM venda;
SELECT * FROM itens_venda;

-- liste o total de vendas realizadas por cada cliente

SELECT cliente.nome, count(venda.cliente_id) as total_vendas
from venda
join cliente on venda.cliente_id = cliente.id
group by cliente.nome
order by cliente.nome;

--liste o total de vendas realizada por cada funcionário

SELECT funcionario.nome as nome_funcionario, count(venda.funcionario_id) as total_vendas
from venda
join funcionario on venda.funcionario_id = funcionario.id
group by funcionario.nome
order by funcionario.nome;

-- liste a quantidade total de produtos vendidos por cada venda

SELECT produto.nome, sum(itens_venda.quantidade) as quantidade_total_itens
FROM 
itens_venda
JOIN produto ON itens_venda.produto_id = produto.id
group by produto.nome;

--5. Liste os clientes que realizaram mais de 5 compras.

-- SELECT venda.cliente_id, sum(itens_venda.quantidade) as qntd_itens_comprados
-- from venda
-- join itens_venda on itens_venda.venda_id = venda.id
-- group by venda.cliente_id;

-- por linha: usa where (antes de agrupar)
-- por grupo: usa having (depois de agrupar)

select cliente.nome, count(venda.cliente_id) as total
from venda
join itens_venda on venda.cliente_id = itens_venda.venda_id
join cliente on cliente.id = venda.cliente_id
group by cliente.nome
having count(total) > 1;

--em having não pode usar apelidos com underline

--6. Liste os produtos que possuem mais de 50 unidades em estoque.

SELECT nome, quantidade_estoque 
FROM produto 
WHERE quantidade_estoque > 10
order by quantidade_estoque desc;

--7. Liste os funcionários que participaram de mais de 10 vendas.

SELECT funcionario.nome, count(venda.funcionario_id) as total_vendas
FROM venda
join funcionario on funcionario.id = venda.funcionario_id
group by funcionario.nome
having count(venda.funcionario_id) >= 1;

-- 8. Liste os produtos cujo total vendido (quantidade) seja superior a 100 unidades.

SELECT produto.nome, sum(itens_venda.quantidade) as total_vendido
FROM itens_venda
JOIN produto on produto.id = itens_venda.produto_id
group by produto.nome
having sum(itens_venda.quantidade) >= 1
order by total_vendido desc;

--9. Calcule o valor total das vendas de cada cliente.

SELECT cliente.nome, sum(venda.total) as total_vendido
FROM venda
JOIN cliente on cliente.id = venda.cliente_id
group by cliente.nome
order by total_vendido desc;

-- 10.Calcule o valor total das vendas realizadas por cada funcionário.

SELECT funcionario.nome, sum(venda.total) as total_vendido
FROM venda
JOIN funcionario on funcionario.id = venda.funcionario_id
group by funcionario.nome
order by total_vendido desc;

-- 11.Calcule o total de itens vendidos por venda.

SELECT venda_id, sum(quantidade) as qntd
FROM itens_venda
GROUP BY venda_id
ORDER BY qntd desc;


--12.Calcule o total de produtos vendidos agrupados por categoria (se
--adicionarmos uma coluna de categoria na tabela de produtos).

ALTER TABLE produto ADD COLUMN categoria VARCHAR(60);

-- atualizar os dados
UPDATE produto SET categoria = 'Eletronicos' WHERE nome in ('Notebook', 'Smartphone', 'TV 50"');
UPDATE produto SET categoria = 'Perifericos' WHERE nome in ('Teclado Mecânico', 'Mouse Gamer');

-- query

SELECT produto.categoria, sum(itens_venda.quantidade) as total_vendido
FROM itens_venda
JOIN produto ON
itens_venda.produto_id = produto.id
GROUP BY produto.categoria
ORDER BY total_vendido;

--13.Calcule o total arrecadado com vendas para cada cliente.

SELECT cliente.nome as cliente, sum(venda.total) as total_arrecadado
FROM venda
JOIN cliente ON cliente.id  = venda.cliente_id
GROUP BY cliente.nome
ORDER BY total_arrecadado DESC;

--14.Calcule o preço médio dos produtos em estoque.

SELECT round(avg(preco),2) as Preco_medio
FROM produto
WHERE quantidade_estoque > 0;

--15.Calcule o preço médio dos produtos vendidos por venda.

SELECT itens_venda.venda_id, round(avg(itens_venda.preco_unitario),2) as Preco_medio
FROM itens_venda
JOIN venda ON itens_venda.venda_id = venda.id
GROUP BY itens_venda.venda_id;

-- 16.Calcule a média de salários dos funcionários.

SELECT round(avg(salario),2) as media_salarial FROM funcionario;

-- 17.Calcule a média do total das vendas por funcionário.

SELECT funcionario.nome, round(avg(venda.total),2) as media_de_vendas
FROM venda
JOIN funcionario on funcionario.id = venda.funcionario_id
group by funcionario.nome
order by media_de_vendas desc;


--18.Conte quantas vendas foram realizadas por cliente.



SELECT cliente.nome, count(itens_venda.venda_id) as Quantidade_vendas
FROM itens_venda
JOIN venda ON venda.id = itens_venda.venda_id
JOIN cliente ON cliente.id = venda.cliente_id
GROUP BY cliente.nome;

--19.Conte quantas vendas cada funcionário participou.

SELECT funcionario.nome, count(venda.funcionario_id) as Quantidade_vendas
FROM funcionario
JOIN venda ON venda.funcionario_id = funcionario.id
GROUP BY funcionario.nome;

-- 20.Conte quantos produtos estão cadastrados no banco.

SELECT count(nome)as quantidade_produtos
FROM produto;

--21.Conte quantas vendas foram realizadas em cada dia.

SELECT data, count(id) as quantidade_vendas
FROM venda
GROUP BY data;

-- 22.Liste os clientes que realizaram mais de 5 compras, ordenados pelo total de vendas.

SELECT cliente.nome, count(venda_id) as total_compras
FROM itens_venda
JOIN venda ON venda.id = itens_venda.venda_id
JOIN cliente ON cliente.id = venda.cliente_id
GROUP BY cliente.nome
HAVING count(venda_id) >= 1;

-- 23.Liste os produtos mais vendidos (em quantidade) cujo total vendido ultrapassa 50 unidades.


SELECT produto.nome, sum(quantidade) as quantidade_vendas
FROM itens_venda
JOIN produto ON produto.id = itens_venda.produto_id
GROUP BY produto.nome
HAVING sum(quantidade) > 1;

-- 24.Calcule a média de preço dos produtos vendidos em cada venda.


SELECT venda_id, round(avg(subtotal),2) as media_preco
FROM itens_venda
JOIN venda on venda.id = itens_venda.venda_id
GROUP BY venda_id;

-- 25.Liste os funcionários que participaram de vendas cujo total médio é superior a R$ 5.000,00.

SELECT funcionario.nome, round(avg(venda.total),2) as media_vendas
FROM venda
JOIN funcionario ON funcionario.id = venda.funcionario_id
GROUP BY funcionario.nome
HAVING round(avg(venda.total),2) > 5000.00;





select * from venda;
select * from funcionario
select * from produto;
select * from itens_venda;
select * from cliente;




rollback;
commit;