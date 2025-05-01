/***********************************************************************
		-- Script para População do Banco de Dados BibliotecaDB
		-- Criador: Matheus Nunes Rossi
************************************************************************/

-- Define o contexto para o banco de dados BibliotecaDB
USE BibliotecaDB;
GO

-- Limpa dados existentes (caso o script seja reexecutado)
-- Ordem reversa devido às chaves estrangeiras
PRINT 
'Limpando dados existentes...';
DELETE FROM dbo.Emprestimos;
DELETE FROM dbo.LivroAutor;
DELETE FROM dbo.Livros;
DELETE FROM dbo.Autores;
DELETE FROM dbo.Editoras;
DELETE FROM dbo.Generos;
DELETE FROM dbo.Usuarios;
GO

-- Reseta a contagem IDENTITY para as tabelas (opcional, mas útil para consistência em reexecuções)
DBCC CHECKIDENT (
'dbo.Emprestimos', RESEED, 0);
DBCC CHECKIDENT (
'dbo.Livros', RESEED, 0);
DBCC CHECKIDENT (
'dbo.Autores', RESEED, 0);
DBCC CHECKIDENT (
'dbo.Editoras', RESEED, 0);
DBCC CHECKIDENT (
'dbo.Generos', RESEED, 0);
DBCC CHECKIDENT (
'dbo.Usuarios', RESEED, 0);
GO

-- Inserção de Dados

-- 1. Tabela Generos
PRINT 
'Inserindo dados em Generos...';
INSERT INTO dbo.Generos (Nome)
VALUES
('Ficção Científica'),
('Fantasia'),
('Romance'),
('Suspense'),
('Terror'),
('Aventura'),
('História'),
('Biografia'),
('Técnico'),
('Autoajuda'),
('Policial'),
('Drama');
GO

-- 2. Tabela Editoras
PRINT 
'Inserindo dados em Editoras...';
INSERT INTO dbo.Editoras (Nome, Cidade, Pais)
VALUES
('Aleph', 'São Paulo', 'Brasil'),
('Intrínseca', 'Rio de Janeiro', 'Brasil'),
('Rocco', 'Rio de Janeiro', 'Brasil'),
('Sextante', 'Rio de Janeiro', 'Brasil'),
('Companhia das Letras', 'São Paulo', 'Brasil'),
('Record', 'Rio de Janeiro', 'Brasil'),
('Darkside Books', 'Rio de Janeiro', 'Brasil'),
('Suma', 'São Paulo', 'Brasil'),
('Arqueiro', 'Rio de Janeiro', 'Brasil'),
('Planeta', 'São Paulo', 'Brasil');
GO

-- 3. Tabela Autores
PRINT 'Inserindo dados em Autores...';
INSERT INTO dbo.Autores (Nome, Sobrenome, DataNascimento, Nacionalidade)
VALUES
('Isaac', 'Asimov', '1920-01-02', 'Russo/Americano'),
('J.R.R.', 'Tolkien', '1892-01-03', 'Britânico'),
('Jane', 'Austen', '1775-12-16', 'Britânica'),
('Stephen', 'King', '1947-09-21', 'Americano'),
('George R. R.', 'Martin', '1948-09-20', 'Americano'),
('Agatha', 'Christie', '1890-09-15', 'Britânica'),
('Yuval Noah', 'Harari', '1976-02-24', 'Israelense'),
('Walter', 'Isaacson', '1952-05-20', 'Americano'),
('Andrew S.', 'Tanenbaum', '1944-03-16', 'Americano'),
('Dale', 'Carnegie', '1888-11-24', 'Americano'),
('Clarice', 'Lispector', '1920-12-10', 'Brasileira'),
('Machado', 'de Assis', '1839-06-21', 'Brasileiro'),
('Arthur Conan', 'Doyle', '1859-05-22', 'Britânico'),
('Mary', 'Shelley', '1797-08-30', 'Britânica'),
('H.P.', 'Lovecraft', '1890-08-20', 'Americano');
GO

-- 4. Tabela Usuarios
PRINT 'Inserindo dados em Usuarios...';
INSERT INTO dbo.Usuarios (Nome, Sobrenome, Email, Telefone)
VALUES
('Carlos', 'Silva', 'carlos.silva@email.com', '11987654321'),
('Ana', 'Pereira', 'ana.pereira@email.com', '21912345678'),
('Bruno', 'Costa', 'bruno.costa@email.com', '31999887766'),
('Fernanda', 'Oliveira', 'fernanda.oliveira@email.com', '41988776655'),
('Ricardo', 'Souza', 'ricardo.souza@email.com', '51977665544'),
('Juliana', 'Martins', 'juliana.martins@email.com', '61966554433'),
('Lucas', 'Almeida', 'lucas.almeida@email.com', '71955443322'),
('Mariana', 'Lima', 'mariana.lima@email.com', '81944332211'),
('Pedro', 'Rocha', 'pedro.rocha@email.com', '91933221100'),
('Sofia', 'Barbosa', 'sofia.barbosa@email.com', '11922110099');

-- Adicionar mais usuários se necessário para ter dezenas
INSERT INTO dbo.Usuarios (Nome, Sobrenome, Email, Telefone)
VALUES
('Gabriel', 'Ribeiro', 'gabriel.ribeiro@email.com', '21911009988'),
('Larissa', 'Carvalho', 'larissa.carvalho@email.com', '31900998877'),
('Matheus', 'Gomes', 'matheus.gomes@email.com', '41999887766'),
('Beatriz', 'Santos', 'beatriz.santos@email.com', '51988776655'),
('Thiago', 'Rodrigues', 'thiago.rodrigues@email.com', '61977665544');
GO

-- 5. Tabela Livros
PRINT 'Inserindo dados em Livros...';
INSERT INTO dbo.Livros (Titulo, EditoraID, GeneroID, AnoPublicacao, ISBN, NumeroPaginas, QuantidadeEstoque)
VALUES
-- Ficção Científica (GeneroID 1), Editora Aleph (EditoraID 1)
('Fundação', 1, 1, 1951, '978-8576570660', 240, 5),
('Eu, Robô', 1, 1, 1950, '978-8576570295', 320, 3),
('O Fim da Eternidade', 1, 1, 1955, '978-8576570714', 288, 4),

-- Fantasia (GeneroID 2), Editora Rocco (EditoraID 3), Martins Fontes (Não cadastrada, usar outra)
('O Senhor dos Anéis: A Sociedade do Anel', 3, 2, 1954, '978-8532511279', 576, 2),
('O Hobbit', 3, 2, 1937, '978-8532527966', 336, 6),
('A Guerra dos Tronos', 8, 2, 1996, '978-8556510785', 600, 1),

-- Romance (GeneroID 3), Editora Arqueiro (EditoraID 9)
('Orgulho e Preconceit', 9, 3, 1813, '978-8580419109', 416, 7),
('Razão e Sensibilidade', 9, 3, 1811, '978-8580419116', 448, 4),

-- Suspense/Terror (GeneroID 4, 5), Editora Suma (EditoraID 8), Darkside (EditoraID 7)
('O Iluminado', 8, 5, 1977, '978-8556510167', 520, 3),
('It: A Coisa', 8, 5, 1986, '978-8560280949', 1104, 2),
('Frankenstein', 7, 5, 1818, '978-8594540017', 320, 5),
('O Chamado de Cthulhu e outros contos', 7, 5, 1928, '978-8594540413', 368, 4),

-- Policial (GeneroID 11), Editora Record (EditoraID 6)
('Assassinato no Expresso do Oriente', 6, 11, 1934, '978-8501009088', 240, 6),
('Morte no Nilo', 6, 11, 1937, '978-8501014532', 288, 5),
('Um Estudo em Vermelho', 6, 11, 1887, '978-8501066500', 192, 7),

-- História/Biografia (GeneroID 7, 8), Companhia das Letras (EditoraID 5)
('Sapiens: Uma Breve História da Humanidade', 5, 7, 2011, '978-8535923877', 464, 8),
('Homo Deus: Uma Breve História do Amanhã', 5, 7, 2015, '978-8535928193', 448, 6),
('Steve Jobs', 5, 8, 2011, '978-8535919726', 624, 3),

-- Técnico (GeneroID 9), Editora Planeta (EditoraID 10) - Usar outra editora ou criar
('Redes de Computadores', 5, 9, 2011, '978-8576059240', 960, 2), -- Usando Cia das Letras temporariamente

-- Autoajuda (GeneroID 10), Editora Sextante (EditoraID 4)
('Como Fazer Amigos e Influenciar Pessoas', 4, 10, 1936, '978-8543108515', 288, 10),

-- Drama/Brasileiros (GeneroID 12), Rocco (EditoraID 3), Cia das Letras (EditoraID 5)
('A Hora da Estrela', 3, 12, 1977, '978-8532505995', 96, 5),
('Dom Casmurro', 5, 12, 1899, '978-8535910877', 368, 7);
GO

-- 6. Tabela LivroAutor (Associação N:N)
PRINT 'Inserindo dados em LivroAutor...';
INSERT INTO dbo.LivroAutor (LivroID, AutorID)
VALUES
-- Asimov
(1, 1), (2, 1), (3, 1),
-- Tolkien
(4, 2), (5, 2),
-- Martin
(6, 5),
-- Austen
(7, 3), (8, 3),
-- King
(9, 4), (10, 4),
-- Shelley
(11, 14),
-- Lovecraft
(12, 15),
-- Christie
(13, 6), (14, 6),
-- Doyle
(15, 13),
-- Harari
(16, 7), (17, 7),
-- Isaacson
(18, 8),
-- Tanenbaum
(19, 9),
-- Carnegie
(20, 10),
-- Lispector
(21, 11),
-- Machado de Assis
(22, 12);
GO

-- 7. Tabela Emprestimos
PRINT 'Inserindo dados em Emprestimos...';
-- Empréstimos Ativos
INSERT INTO dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataPrevistaDevolucao, StatusEmprestimo)
VALUES
(1, 1, DATEADD(day, -10, GETDATE()), DATEADD(day, 4, GETDATE()), 'Ativo'), -- Fundação para Carlos
(4, 2, DATEADD(day, -5, GETDATE()), DATEADD(day, 9, GETDATE()), 'Ativo'), -- Sociedade do Anel para Ana
(9, 3, DATEADD(day, -2, GETDATE()), DATEADD(day, 12, GETDATE()), 'Ativo'), -- O Iluminado para Bruno
(16, 4, DATEADD(day, -7, GETDATE()), DATEADD(day, 7, GETDATE()), 'Ativo'), -- Sapiens para Fernanda
(20, 5, DATEADD(day, -1, GETDATE()), DATEADD(day, 13, GETDATE()), 'Ativo'); -- Como Fazer Amigos para Ricardo

-- Empréstimos Devolvidos
INSERT INTO dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataPrevistaDevolucao, DataDevolucao, StatusEmprestimo)
VALUES
(2, 6, DATEADD(day, -20, GETDATE()), DATEADD(day, -6, GETDATE()), DATEADD(day, -7, GETDATE()), 
'Devolvido'), -- Eu, Robô para Juliana
(5, 7, DATEADD(day, -30, GETDATE()), DATEADD(day, -16, GETDATE()), DATEADD(day, -17, GETDATE()), 'Devolvido'), -- O Hobbit para Lucas
(7, 8, DATEADD(day, -15, GETDATE()), DATEADD(day, -1, GETDATE()), DATEADD(day, -2, GETDATE()), 'Devolvido'), -- Orgulho e Preconceito para Mariana
(13, 9, DATEADD(day, -25, GETDATE()), DATEADD(day, -11, GETDATE()), DATEADD(day, -11, GETDATE()), 'Devolvido'), -- Expresso do Oriente para Pedro
(22, 10, DATEADD(day, -18, GETDATE()), DATEADD(day, -4, GETDATE()), DATEADD(day, -5, GETDATE()), 'Devolvido'); -- Dom Casmurro para Sofia

-- Empréstimos Atrasados
INSERT INTO dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataPrevistaDevolucao, StatusEmprestimo)
VALUES
(3, 11, DATEADD(day, -22, GETDATE()), DATEADD(day, -8, GETDATE()), 'Atrasado'), -- Fim da Eternidade para Gabriel (Atrasado 8 dias)
(6, 12, DATEADD(day, -17, GETDATE()), DATEADD(day, -3, GETDATE()), 'Atrasado'), -- Guerra dos Tronos para Larissa (Atrasado 3 dias)
(10, 13, DATEADD(day, -35, GETDATE()), DATEADD(day, -21, GETDATE()), 'Atrasado'), -- It: A Coisa para Matheus (Atrasado 21 dias)
(11, 14, DATEADD(day, -12, GETDATE()), DATEADD(day, 2, GETDATE()), 'Ativo'), -- Frankenstein para Beatriz (Ainda no prazo, mas vamos emprestar outro)
(15, 15, DATEADD(day, -19, GETDATE()), DATEADD(day, -5, GETDATE()), 'Atrasado'); -- Estudo em Vermelho para Thiago (Atrasado 5 dias)

-- Mais alguns empréstimos para volume
INSERT INTO dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataPrevistaDevolucao, StatusEmprestimo)
VALUES
(1, 3, DATEADD(day, -8, GETDATE()), DATEADD(day, 6, GETDATE()), 'Ativo'),
(5, 1, DATEADD(day, -11, GETDATE()), DATEADD(day, 3, GETDATE()), 'Ativo'),(14, 4, DATEADD(day, -4, GETDATE()), DATEADD(day, 10, GETDATE()), 'Ativo');

INSERT INTO dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataPrevistaDevolucao, DataDevolucao, StatusEmprestimo)
VALUES
(8, 5, DATEADD(day, -28, GETDATE()), DATEADD(day, -14, GETDATE()), DATEADD(day, -15, GETDATE()), 'Devolvido'),
(17, 2, DATEADD(day, -21, GETDATE()), DATEADD(day, -7, GETDATE()), DATEADD(day, -7, GETDATE()), 'Devolvido');

INSERT INTO dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, DataPrevistaDevolucao, StatusEmprestimo)
VALUES
(19, 1, DATEADD(day, -40, GETDATE()), DATEADD(day, -26, GETDATE()), 'Atrasado'); -- Redes para Carlos (Atrasado)
GO

PRINT 'População do Banco de Dados BibliotecaDB concluída!';
