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


rollback;
commit;