/***********************************************************************************
		-- Script para Criação do Banco de Dados e Tabelas - BibliotecaDB
		-- Criador: Matheus Nunes Rossi
************************************************************************************/
-- Verifica se o banco de dados já existe e o cria se não existir
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'BibliotecaDB')
BEGIN
	CREATE DATABASE BibliotecaDB;
END;
GO

USE BibliotecaDB;
GO

-- Remove tabelas existentes (para permitir reexecução do script)
-- Ordem reversa devido às chaves estrangeiras
IF OBJECT_ID('dbo.Emprestimo', 'U') IS NOT NULL
	DROP TABLE dbo.Emprestimo;
GO

IF OBJECT_ID('dbo.LivroAutor', 'U') IS NOT NULL
	DROP TABLE dbo.LivroAutor;
GO

IF OBJECT_ID('dbo.Livros', 'U') IS NOT NULL
    DROP TABLE dbo.Livros;
GO

IF OBJECT_ID('dbo.Autores', 'U') IS NOT NULL
    DROP TABLE dbo.Autores;
GO

IF OBJECT_ID('dbo.Editoras', 'U') IS NOT NULL
    DROP TABLE dbo.Editoras;
GO

IF OBJECT_ID('dbo.Generos', 'U') IS NOT NULL
    DROP TABLE dbo.Generos;
GO

IF OBJECT_ID('dbo.Usuarios', 'U') IS NOT NULL
    DROP TABLE dbo.Usuarios;
GO

-- Criação da Tabela Autores
PRINT 'Criando Tabela Autores...';
CREATE TABLE dbo.Autores (
	AutorID INT IDENTITY(1,1) PRIMARY KEY,
	Nome VARCHAR(100) NOT NULL,
	Sobrenome VARCHAR(100) NOT NULL,
	DataNascimento DATE NULL,
	Nacionalidade VARCHAR(50) NULL
);
GO

-- Criação da Tabela Editoras
PRINT 'Criando Tabela Editoras...';
CREATE TABLE dbo.Editoras (
	EditoraID INT IDENTITY(1,1) PRIMARY KEY,
	Nome VARCHAR(150) NOT NULL UNIQUE, -- Nome da editora deve ser único
	Cidade VARCHAR(100) NULL,
	Pais VARCHAR(50) NULL
);
GO

-- Criação da Tabela Generos
PRINT 'Criando Tabela Generos...';
CREATE TABLE dbo.Generos (
    GeneroID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL UNIQUE -- Nome do gênero deve ser único
);
GO

-- Criação da Tabela Usuarios
PRINT 'Criando Tabela Usuarios...';
CREATE TABLE dbo.Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Sobrenome VARCHAR(100) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE, -- Email deve ser único
    Telefone VARCHAR(20) NULL,
    DataCadastro DATETIME DEFAULT GETDATE() -- Data de cadastro padrão é a data atual
);
GO

-- Criação da Tabela Livros
CREATE TABLE dbo.Livros (
	LivroID INT IDENTITY(1,1) PRIMARY KEY,
	Titulo VARCHAR(255) NOT NULL,
	EditoraID INT NOT NULL,
	GeneroID INT NOT NULL,
	AnoPublicacao INT NULL,
	ISBN VARCHAR(20) UNIQUE, -- ISBN deve ser único
	NumeroPaginas INT NULL CHECK (NumeroPaginas > 0), -- Número de páginas deve ser positivo
	QuantidadeEstoque INT NOT NULL DEFAULT 1 CHECK (QuantidadeEstoque >= 0), -- Quantidade não pode ser negativa
CONSTRAINT FK_Livros_Editoras FOREIGN KEY (EditoraID) REFERENCES dbo.Editoras(EditoraID),
CONSTRAINT FK_Livros_Generos FOREIGN KEY (GeneroID) REFERENCES dbo.Generos(GeneroID)
);
GO

-- Criação da Tabela de Associação LivroAutor (Relação N:N)
PRINT 'Criando Tabela LivroAutor...';
CREATE TABLE dbo.LivroAutor (
    LivroID INT NOT NULL,
    AutorID INT NOT NULL,
    CONSTRAINT PK_LivroAutor PRIMARY KEY (LivroID, AutorID), -- Chave primária composta
    CONSTRAINT FK_LivroAutor_Livros FOREIGN KEY (LivroID) REFERENCES dbo.Livros(LivroID) ON DELETE CASCADE, -- Se excluir livro, remove a associação
    CONSTRAINT FK_LivroAutor_Autores FOREIGN KEY (AutorID) REFERENCES dbo.Autores(AutorID) ON DELETE CASCADE -- Se excluir autor, remove a associação
);
GO

-- Criação da Tabela Emprestimos
PRINT 'Criando Tabela Emprestimos...';
CREATE TABLE dbo.Emprestimos (
    EmprestimoID INT IDENTITY(1,1) PRIMARY KEY,
    LivroID INT NOT NULL,
    UsuarioID INT NOT NULL,
    DataEmprestimo DATETIME NOT NULL DEFAULT GETDATE(),
    DataPrevistaDevolucao DATETIME NOT NULL,
    DataDevolucao DATETIME NULL, -- Permite nulo até a devolução
    StatusEmprestimo VARCHAR(20) NOT NULL DEFAULT 'Ativo' CHECK (StatusEmprestimo IN ('Ativo', 'Devolvido', 'Atrasado')),
    CONSTRAINT FK_Emprestimos_Livros FOREIGN KEY (LivroID) REFERENCES dbo.Livros(LivroID),
    CONSTRAINT FK_Emprestimos_Usuarios FOREIGN KEY (UsuarioID) REFERENCES dbo.Usuarios(UsuarioID),
    CONSTRAINT CHK_DatasEmprestimo CHECK (DataDevolucao IS NULL OR DataDevolucao >= DataEmprestimo), -- Data de devolução não pode ser anterior ao empréstimo
    CONSTRAINT CHK_DataPrevista CHECK (DataPrevistaDevolucao > DataEmprestimo) -- Data prevista deve ser posterior ao empréstimo
);
GO
