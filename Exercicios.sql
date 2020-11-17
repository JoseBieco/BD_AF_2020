-- Devido ao fato de termos apenas 4 cores de toners, não será possivel inserir 5 valores
INSERT INTO Cor
VALUES
	('Amarelo'),
	('Ciano'),
	('Magenta'),
	('Preto')

INSERT INTO Setor
VALUES
	('Laboratório de Informática', 'A'),
	('Sala dos Professores', 'E'),
	('Secretaria', 'E'),
	('Marketing', 'E'),
	('Biblioteca', 'H')

-- TODO Patrimonio
INSERT INTO Impressora
VALUES
	(1, 'XEROX', 'FACENS_XER_COLOR'),
	(2, 'XEROX', 'FACENS_XER_PB'),
	(4, 'LEXMARK', 'FACENS_LEX_COLOR'),
	(3, 'LEXMARK', 'FACENS_LEX_PB'),
	(5, 'LEXMARK', 'FACENS_LEX_PB')

INSERT INTO Suprimento
VALUES
	('106R03396', 'XERCOLOR', 2, 4, 'Toner'),
	('106R03746', 'XERCOLOR', 12, 1, 'Toner'),
	('106R03747', 'XERCOLOR', 7, 3, 'Toner'),
	('106R03745', 'XERCOLOR', 5, 4, 'Toner'),
	('106R03748', 'XERCOLOR', 5, 2, 'Toner'),
	('113R00779', 'XERCOLOR', 3, null, 'Armazenador de Resíduos'),-- UPDATE 
	('56F0Z00', 'LEXMARK', 4, null, 'Armazenador de Resíduos'),
	('78C40K0', 'LEXMARK', 1, 4, 'Toner'),
	('78C4XY0', 'LEXMARK', 1, 1, 'Toner'),
	('78C4XM0', 'LEXMARK', 1, 3, 'Toner'),
	('56FBU00', 'LEXMARK', 2, 4, 'Toner')

-- TODO
INSERT INTO LinkImpressoraToner
VALUES
	(1, 1, '15-10-2020'),
	(1, 2, '25-05-2020'),
	(2, 4, '22-07-2020'),
	(3, 7, '16-11-2020'),
	(4, 10, '25-05-2020')

-- GRAÇA
SELECT * FROM Cor
SELECT * FROM Setor
SELECT * FROM Suprimento
SELECT * FROM Impressora
SELECT * FROM LinkImpressoraToner

UPDATE 
	Suprimento 
SET
	Marca = 'LEXMARK'
WHERE
	Marca = 'LexMark'


-- Views

GO
CREATE OR ALTER VIEW vwToner AS
	SELECT 
		S.Marca, S.Codigo, C.Nome AS Cor, S.Quantidade
	FROM
		Suprimento AS S INNER JOIN Cor AS C
			ON S.IDCor = C.IDCor
GO
SELECT * FROM vwToner ORDER BY Cor

GO
CREATE OR ALTER VIEW vwArmazenadorDeResiduos AS
	SELECT
		Marca, Codigo, Quantidade
	FROM
		Suprimento
	WHERE
		IDCor IS NULL
GO
SELECT * FROM vwArmazenadorDeResiduos ORDER BY Marca

GO
CREATE OR ALTER VIEW vwImpressora AS
	SELECT
		I.Nome AS Impressora, S.Nome AS Setor, S.Bloco
	FROM
		Impressora AS I INNER JOIN Setor AS S
			ON I.IDSetor = S.IDSetor
GO
SELECT * FROM vwImpressora ORDER BY Setor


-- 3. Explique para que serve a cláusula group by e dê 2 exemplos de sua utilização.
-- A cláusula GROUP BY agrupa linhas baseado em semelhanças entre elas. 
-- Pode-se fazer uma analogia com um filtro de café, que "deixa" passar apenas o liquido, e "agrupa" o pó, não o deixando passar,
-- e essa cláusula lembra um filtro, no sentido de não deixar passar algo, e agrupar por semelhanças, que no exemplo seria o pó.

-- GROUP BY 1
SELECT 
	S.Bloco, COUNT(*) ImpressoraPorBloco
FROM 
	Impressora AS I INNER JOIN Setor AS S
			ON I.IDSetor = S.IDSetor
GROUP BY
	S.Bloco

-- Mesma coisa que o de cima mas utilizando da View em vez de Inner join
SELECT
	Bloco, COUNT(*) ImpressoraPorBloco
FROM
	vwImpressora
GROUP BY
	Bloco

-- GROUP BY 2
-- Toners por cor
SELECT
	Cor, SUM(Quantidade) QtdPorCor
FROM
	vwToner
GROUP BY 
	Cor

-- Toners por Marca
SELECT
	Marca, SUM(Quantidade) QtdPorMarca
FROM
	vwToner
GROUP BY 
	Marca

-- 4. Explique para que serve a cláusula having e dê 1 exemplo de sua utilização.
--  A cláusula HAVING determina uma condição de busca para um grupo ou um conjunto de registros, 
-- definindo critérios para limitar os resultados obtidos a partir do agrupamento de registros.

-- Having
SELECT
	C.Nome AS Cor, SUM(S.Quantidade) QtdCorEspecifica
FROM
	Suprimento AS S INNER JOIN Cor AS C
		ON S.IDCor = C.IDCor
GROUP BY
	C.Nome
HAVING
	C.Nome LIKE 'Magenta'
-- Having 2
SELECT
	S.Bloco, COUNT(*) QtdImpressoraPorBlocoEspecifico
FROM
	Impressora AS I INNER JOIN Setor AS S
		ON I.IDSetor = S.IDSetor
GROUP BY
	S.Bloco
HAVING
	S.Bloco = 'E'

-- Retirada de um Toner Amarelo do Estoque do L.I
UPDATE 
	Suprimento
SET
	Quantidade = Quantidade - 1
WHERE
	IDCor = 1 AND Marca LIKE 'XERCOLOR'

-- 2. Exemplo de junção entre pelo menos 3 (três) tabelas que retorno várias linhas.
SELECT
	I.Nome, I.Marca, S.Nome, SP.Descricao, C.Nome, FORMAT(LK.DataTroca, 'dd/MM/yyyy') AS DataTroca
FROM
	LinkImpressoraToner AS LK INNER JOIN Impressora AS I
		ON LK.IDImpressora = I.IDImpressora
	INNER JOIN Setor AS S
		ON I.IDImpressora = S.IDSetor
	INNER JOIN Suprimento AS SP
		ON LK.IDToner = SP.IDSuprimento
	LEFT JOIN Cor AS C
		ON SP.IDCor = C.IDCor

-- 5. Para a criação das tabelas deste exercício foi necessário estabelecer uma ordem? Justifique.
-- Sim, devido ao fato de termos varias tabelas com chaves estrangeiras não nulas, precisou-se pensar em um critério de criação para as tabelas.
-- Começamos com a tabela Cor pois ela é a mais simples, posteriormente fomos para a tabela Setor, após a criação desses duas tabelas, ficou a escolha entre  
-- Impressora e Suprimento, e apenas com todas as tabelas criadas, ai sim, finalizamos com a tabela LinkImpressoraToner.

-- 7. Dê exemplo de um comando utilizando subconsultas que utilize o operador = ou <,>, <=, in, not in.
SELECT
	I.Nome, S.Nome
FROM
	Impressora AS I INNER JOIN Setor AS S 
		ON I.IDImpressora = S.IDSetor
	WHERE 
		I.IDSetor IN (SELECT IDSetor FROM Setor)

SELECT
	S.Codigo, S.Marca, S.Descricao, S.Quantidade
FROM
	Suprimento AS S
	WHERE 
		S.Quantidade > (SELECT AVG(Quantidade)MediaSuprimentos FROM Suprimento)