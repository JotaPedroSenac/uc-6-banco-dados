--QUESTÃO 1: 

CREATE TABLE IF NOT EXISTS clientes(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100)NOT NULL UNIQUE,
	email VARCHAR(100)NOT NULL UNIQUE,
	telefone VARCHAR(20)NOT NULL UNIQUE,
	data_cadastro DATE NOT NULL
);


CREATE TABLE IF NOT EXISTS servicos(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100)NOT NULL UNIQUE,
	descricao TEXT NOT NULL,
	preco DECIMAL(10,2) NOT NULL,
	tipo_servico VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS tecnicos(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(100)NOT NULL,
	especialidade VARCHAR(50) NOT NULL,
	data_contratacao DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS chamados(
	id SERIAL PRIMARY KEY,
	cliente_id INT,
	tecnico_id INT,
	servico_id INT,
	data_chamado DATE NOT NULL,
	status VARCHAR(20) NOT NULL,
	descricao TEXT NOT NULL,
	constraint fk_cliente_chamados FOREIGN KEY(cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
	constraint fk_tecnicos_chamados FOREIGN KEY(tecnico_id) REFERENCES tecnicos(id) ON DELETE CASCADE,
	constraint fk_servicos_chamados FOREIGN KEY(servico_id) REFERENCES servicos(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS pagamentos(
	id SERIAL PRIMARY KEY,
	cliente_id INT,
	chamado_id INT,
	valor_pago DECIMAL(10,2) NOT NULL,
	data_pagamento DATE NOT NULL,
	forma_pagamento VARCHAR(50) NOT NULL,
	constraint fk_pagamentos_clientes FOREIGN KEY(cliente_id) REFERENCES clientes(id) ON DELETE CASCADE,
	constraint fk_pagamentos_chamados FOREIGN KEY(chamado_id) REFERENCES chamados(id) ON DELETE CASCADE
);

--QUESTÃO 2:

--alterar data_cadastro para o dia atual

ALTER TABLE clientes ALTER COLUMN data_cadastro TYPE DATE;
ALTER TABLE clientes ALTER COLUMN data_cadastro SET DEFAULT CURRENT_DATE;

-- preco > 0 na tabela servicos

ALTER TABLE servicos ADD CONSTRAINT chk_preco CHECK(preco > 0);

--status na tabela chamados deve ser um dos valores: 'Pendente', 'Em Andamento', 'Finalizado'

ALTER TABLE chamados ADD CONSTRAINT chk_status CHECK(status = 'Pendente' or status = 'Em andamento' or status = 'Finalizado')
 
--valor_pago > 0 na tabela pagamentos.

ALTER TABLE pagamentos ADD CONSTRAINT chk_pagamentos CHECK(valor_pago > 0);

-- tipo_servico na tabela servicos deve ser um dos valores: 'Consultoria', 'Suporte', 'Manutenção'.

ALTER TABLE servicos ADD CONSTRAINT chk_servicos CHECK(tipo_servico = 'Consultoria' or tipo_servico = 'Suporte' or tipo_servico = 'Manutenção');

-- QUESTÃO 3: 

INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES ('João Silva','joao@email.com','(11) 98765-4321', '2023-01-15' );
INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES ('Maria Oliveira','maria@email.com','(21) 99654-3210', '2023-02-20' );
INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES ('Pedro Souza','pedro@email.com','(31) 99765-1234', '2023-03-10' );
INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES ('Ana Costa','ana@email.com','(41) 98888-9999', '2023-04-25' );
INSERT INTO clientes (nome, email, telefone, data_cadastro) VALUES ('Lucas Almeida','lucas@email.com','(61) 99123-4567', '2023-05-30' );

INSERT INTO servicos (nome, descricao, preco, tipo_servico) VALUES ('Consultoria em TI', 'Consultoria especializada em infraestrutura de TI', 500.00, 'Consultoria');
INSERT INTO servicos (nome, descricao, preco, tipo_servico) VALUES ('Manutenção de Equipamentos', 'Manutenção preventiva e corretiva de equipamentos', 300.00, 'Manutenção');
INSERT INTO servicos (nome, descricao, preco, tipo_servico) VALUES ('Suporte Técnico', 'Suporte remoto e presencial para empresa', 200.00, 'Suporte');

INSERT INTO tecnicos (nome, especialidade, data_contratacao) VALUES ('Carlos Oliveira', 'Consultoria TI', '2022-10-10');
INSERT INTO tecnicos (nome, especialidade, data_contratacao) VALUES ('Fernanda Souza', 'Manutenção', '2021-06-15');
INSERT INTO tecnicos (nome, especialidade, data_contratacao) VALUES ('Roberto Costa', 'Suporte Técnico', '2020-08-20');

INSERT INTO chamados (cliente_id, tecnico_id, servico_id, data_chamado, status, descricao) VALUES (1,1,1,'2023-06-01', 'Pendente', 'Reparo no cabeamento de rede');
INSERT INTO chamados (cliente_id, tecnico_id, servico_id, data_chamado, status, descricao) VALUES (2,2,2,'2023-07-10', 'Em andamento', 'Manutenção no Servidor');
INSERT INTO chamados (cliente_id, tecnico_id, servico_id, data_chamado, status, descricao) VALUES (3,3,3,'2023-08-05', 'Finalizado', 'Configuração de software empresarial');
INSERT INTO chamados (cliente_id, tecnico_id, servico_id, data_chamado, status, descricao) VALUES (4,1,2,'2023-09-20', 'Pendente', 'Manutenção de computador');
INSERT INTO chamados (cliente_id, tecnico_id, servico_id, data_chamado, status, descricao) VALUES (5,2,1,'2023-10-15', 'Finalizado', 'Suporte para software');


INSERT INTO pagamentos (cliente_id, chamado_id, valor_pago, data_pagamento, forma_pagamento) VALUES (1,3, 350.00, '2023-06-15', 'Pix');
INSERT INTO pagamentos (cliente_id, chamado_id, valor_pago, data_pagamento, forma_pagamento) VALUES (2,4, 450.00, '2023-07-15', 'Pix');
INSERT INTO pagamentos (cliente_id, chamado_id, valor_pago, data_pagamento, forma_pagamento) VALUES (3,5, 600.00, '2023-08-10', 'Pix');
INSERT INTO pagamentos (cliente_id, chamado_id, valor_pago, data_pagamento, forma_pagamento) VALUES (4,6, 300.00, '2023-09-25', 'Pix');

----teste

SELECT * FROM clientes;
SELECT * FROM servicos;
SELECT * FROM tecnicos;
SELECT * FROM chamados;
SELECT * FROM pagamentos;


--4. Liste o nome e e-mail de todos os clientes cadastrados

SELECT nome AS Cliente, email FROM clientes;

--5. Recupere os nomes dos serviços disponíveis e seus respectivos preços.

SELECT tipo_servico, preco FROM servicos;

--6. Exiba os nomes e especialidades de todos os técnicos

SELECT nome, especialidade FROM tecnicos;

--7. Mostre a descrição e o status de todos os chamados registrados

SELECT descricao, status FROM chamados;

-- 8. Liste os valores pagos e as datas de pagamento de todos os registros na tabela de pagamentos.

SELECT valor_pago, data_pagamento FROM pagamentos;

--9. Liste os nomes dos clientes e as descrições de seus chamados que estão com o status "Em Andamento".

SELECT clientes.nome, chamados.descricao FROM clientes JOIN chamados on clientes.id = chamados.cliente_id WHERE chamados.status = 'Em andamento';

--10. Recupere os nomes dos técnicos que realizaram serviços com o tipo "Manutenção".

SELECT nome, especialidade from tecnicos where especialidade = 'Manutenção';

-- 11. Mostre os nomes dos clientes e o valor total pago por cada um deles.

SELECT clientes.nome, pagamentos.valor_pago FROM clientes join pagamentos on clientes.id = pagamentos.cliente_id;

-- 12. Liste os clientes e os serviços que eles solicitaram, incluindo a descrição do serviço.

SELECT clientes.nome, servicos.tipo_servico, servicos.descricao FROM clientes join servicos on clientes.id = servicos.id;

--13. Recupere os nomes dos técnicos que realizaram chamados para serviços com o preço superior a 400, e exiba também o nome do serviço

SELECT tecnicos.nome, servicos.preco, servicos.nome FROM tecnicos join servicos on tecnicos.id = servicos.id WHERE preco > 400;

-- 14. Atualize o preço de todos os serviços do tipo "Manutenção" para 350, se o preço atual for inferior a 350.

UPDATE servicos SET preco = 350 WHERE tipo_servico = 'Manutenção' AND preco < 350;


-- 15. Exclua todos os técnicos que não têm chamados registrados.

DELETE FROM tecnicos WHERE id NOT IN (SELECT DISTINCT tecnico_id FROM chamados);