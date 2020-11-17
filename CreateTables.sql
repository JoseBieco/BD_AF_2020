CREATE TABLE Cor(
	IDCor int not null identity,
	Nome varchar(25) not null,
	CONSTRAINT PK_IDCor PRIMARY KEY (IDCor)
)

CREATE TABLE Suprimento(
	IDSuprimento int not null identity,
	Codigo varchar(10) not null,
	Marca varchar(50) not null,
	Quantidade int not null,
	IDCor int,
	Descricao varchar(50) not null,
	CONSTRAINT PK_IDSuprimento PRIMARY KEY (IDSuprimento),
	CONSTRAINT FK_IDCor FOREIGN KEY (IDCor) REFERENCES Cor(IDCor)
)

CREATE TABLE Setor(
	IDSetor int not null identity,
	Nome varchar(150) not null,
	Bloco char not null,
	CONSTRAINT PK_IDSetor PRIMARY KEY (IDSetor)
)

CREATE TABLE Impressora(
	IDImpressora int not null identity,
	IDSetor int not null,
	Marca varchar(50) not null,
	Nome varchar(70) not null,
	CONSTRAINT PK_IDImpressora PRIMARY KEY (IDImpressora),
	CONSTRAINT FK_IDSetor FOREIGN KEY (IDSetor) REFERENCES Setor(IDSetor)
)

CREATE TABLE LinkImpressoraToner(
	IDImpressora int not null,
	IDToner int not null,
	DataTroca datetime not null,
	CONSTRAINT PK_LinkImpressoraToner PRIMARY KEY (IDImpressora, IDToner),
	CONSTRAINT FK_IDImpressora FOREIGN KEY (IDImpressora) REFERENCES Impressora(IDImpressora),
	CONSTRAINT FK_IDSuprimento FOREIGN KEY (IDToner) REFERENCES Suprimento(IDSuprimento)
)

--DROP TABLE Impressora
--DROP TABLE LinkImpressoraToner
--DROP TABLE Suprimento
--DROP TABLE Impressora


SET DATEFORMAT DMY