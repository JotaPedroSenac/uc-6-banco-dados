begin;

CREATE TABLE IF NOT EXISTS aluno(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(60),
	email VARCHAR(60),
	telefone CHAR(14),
	matricula INT,
	curso VARCHAR(60)
);

select * from aluno;


INSERT INTO aluno (nome, email, telefone, matricula, curso) 
values ('Joaquim', 'joaquim@email.com', '84999999999999', '123456', 'programacao');

UPDATE aluno SET 
nome = 'Beltrano',
email = 'beltrano@email.com'
WHERE matricula = '654321';

DELETE FROM aluno
WHERE matricula = '654829';



-- views (view, botao direito, edit, allrows)
-- usa views para encapsular consultas repetitivas
create view vw_aluno as
select * from aluno;


-- consulya encapsulada
select * from vw_aluno;


--- Procedimentos - procedures


--- Funções - functions



rollback;
commit;