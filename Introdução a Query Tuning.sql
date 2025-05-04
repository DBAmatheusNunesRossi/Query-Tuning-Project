/************************************************************
		-- Script Hands-on: Query Tuning - Introdução
		-- Criador: Matheus Nunes Rossi
		-- Banco de Dados: BibliotecaDB
*************************************************************/
-- Garante que estamos no contexto do banco de dados correto
USE BibliotecaDB;
GO

--------------------------------------------------------------------------------
-- Query Tuning - Introdução
-------------------------------------------------------------------------------- 

-- ==============================================================================
-- 1. Arquitetura de Índices B-Tree (Explicação)
-- ==============================================================================


/*
Índices B-Tree (Balanced Tree) são a estrutura de índice mais comum no SQL Server
para a maioria dos tipos de dados. Eles organizam os dados de forma hierárquica,
semelhante a uma árvore invertida, permitindo buscas, inserções, atualizações e
exclusões eficientes.

Estrutura:
- Nó Raiz (Root Node): O nível mais alto da árvore.
- Nós Intermediários (Intermediate Nodes): Nós entre a raiz e as folhas.
- Nós Folha (Leaf Nodes): O nível mais baixo, contendo os valores das chaves
  do índice e ponteiros para as linhas de dados reais (em índices clusterizados)
  ou ponteiros para os localizadores das linhas (Row Locators) em índices não
  clusterizados (Heap ou Chave Clusterizada).

Tipos Principais de Índices B-Tree:
1. Índice Clusterizado (Clustered Index):
   - Define a ordem física dos dados na tabela. Uma tabela só pode ter UM índice
     clusterizado.
   - Os nós folha CONTÊM os dados reais da linha.
   - Geralmente criado na chave primária (PK), mas não obrigatoriamente.
   - Exemplo: A tabela `Autores` tem um índice clusterizado implícito em `AutorID` (PK).

2. Índice Não Clusterizado (Non-Clustered Index):
   - Estrutura separada da tabela de dados.
   - Os nós folha contêm os valores das chaves do índice e um ponteiro (Row Locator)
     para a linha de dados correspondente (seja na Heap ou no índice clusterizado).
   - Uma tabela pode ter múltiplos índices não clusterizados (até 999).
   - Útil para acelerar buscas em colunas que não são a chave do índice clusterizado
     ou em tabelas Heap (sem índice clusterizado).
   - Exemplo: Podemos criar um índice não clusterizado na coluna `Titulo` da tabela `Livros`
     para acelerar buscas por título.

Benefícios:
- Eficiência em buscas pontuais (WHERE Coluna = Valor).
- Eficiência em buscas por faixa (WHERE Coluna BETWEEN Valor1 AND Valor2).
- Mantém os dados ordenados, o que pode ajudar em cláusulas ORDER BY.

Considerações:
- Ocupam espaço em disco.
- Podem tornar operações de INSERT, UPDATE, DELETE mais lentas, pois o índice
  também precisa ser atualizado.
- A escolha das colunas a serem indexadas é crucial (seletividade).
*/


-- Verificando o índice clusterizado existente na tabela Autores (criado pela PK)



-- ==============================================================================
-- 2. Criação de Índices B-Tree (Não Clusterizados)
-- ==============================================================================


/*
Vamos criar alguns índices não clusterizados para otimizar consultas comuns
no nosso banco `BibliotecaDB`.

Sintaxe básica:
CREATE NONCLUSTERED INDEX IX_NomeDoIndice
ON NomeDaTabela (Coluna1 [ASC|DESC], Coluna2 [ASC|DESC], ...);
*/

-- Exemplo 1: Criar um índice na coluna Titulo da tabela Livros
-- Útil para consultas como: SELECT * FROM Livros WHERE Titulo = 'Fundação';
IF NOT EXISTS (SELECT *
				FROM sys.indexes
				WHERE name = 'IX_Livros_Titulo' AND object_id = OBJECT_ID('dbo.Livros'))
BEGIN
	PRINT 'Criando Indece IX_Livros_Titulo';

	CREATE NONCLUSTERED INDEX IX_Livros_Titulo
	ON dbo.Livros (Titulo);

	PRINT 'Índice IX_Livros_Titulo Criado com sucesso';
END
ELSE
BEGIN
	PRINT 'Índice IX_Livros_Titulo já existe';
END
GO


-- Exemplo 2: Criar um índice composto nas colunas Nome e Sobrenome da tabela Autores
-- Útil para consultas como: SELECT * FROM Autores WHERE Nome = 'Isaac' AND Sobrenome = 'Asimov';
-- A ordem das colunas no índice importa!
IF NOT EXISTS (SELECT *
			   FROM sys.indexes 
			   WHERE name = 'IX_Autores_NomeSobrenome' AND object_id = OBJECT_ID('dbo.Autores'))
BEGIN
	PRINT 'Criando Índice Composto IX_Autores_NomeSobrenome';

	CREATE NONCLUSTERED INDEX IX_Autores_NomeSobrenome
	ON dbo.Autores (Nome, Sobrenome);

	PRINT 'Índice IX_Autores_NomeSobrenome Criado com Sucesso';
END
ELSE
BEGIN
	PRINT 'Índice IX_Autores_NomeSobrenome já existe';
END
GO

-- Exemplo 3: Criar um índice na chave estrangeira EditoraID na tabela Livros
-- Chaves estrangeiras são ótimas candidatas para indexação, pois são frequentemente usadas em JOINs.
IF NOT EXISTS (SELECT * 
			   FROM sys.indexes 
               WHERE name = 'IX_Livros_EditoraID' 
               AND object_id = OBJECT_ID('dbo.Livros'))
BEGIN
    PRINT 'Criando índice IX_Livros_EditoraID...';
    
    CREATE NONCLUSTERED INDEX IX_Livros_EditoraID
    ON dbo.Livros (EditoraID)
    WITH (ONLINE = OFF, FILLFACTOR = 90);
    
    PRINT 'Índice IX_Livros_EditoraID criado com sucesso.';
END
ELSE
BEGIN
    PRINT 'Índice IX_Livros_EditoraID já existe.';
END
GO


-- Exemplo 4: Criar um índice na chave estrangeira GeneroID na tabela Livros
IF NOT EXISTS (SELECT *
			   FROM sys.indexes
			   WHERE name = 'IX_Livros_GeneroID' AND object_id = OBJECT_ID('dbo.Livros'))
BEGIN
	PRINT 'Criando índice IX_Livros_GeneroID...';

	CREATE NONCLUSTERED INDEX IX_Livros_GeneroID
	ON dbo.Livros (GeneroID);

	PRINT 'Índice IX_Livros_GeneroID criado com sucesso.';
END
ELSE
BEGIN
	PRINT 'O índice IX_Livros_GeneroID já existe.';
END
GO


-- Exemplo 5: Criar um índice na chave estrangeira UsuarioID na tabela Emprestimos
IF NOT EXISTS (SELECT *
			   FROM sys.indexes
			   WHERE name = 'IX_Emprestimos_UsuarioID' AND object_id = OBJECT_ID('dbo.Emprestimos'))
BEGIN
	PRINT 'Criando Índice IX_Emprestimos_UsuarioID';

	CREATE NONCLUSTERED INDEX IX_Emprestimos_UsuarioID
	ON dbo.Emprestimos (UsuarioID);

	PRINT 'Índice IX_Emprestimos_UsuarioID criado com sucesso.';
END
ELSE
BEGIN
	PRINT 'O Índice IX_Emprestimos_UsuarioID já existe';
END
GO


-- Exemplo 6: Criar um índice na chave estrangeira LivroID na tabela Emprestimos
IF NOT EXISTS (SELECT *
			   FROM sys.indexes
			   WHERE name = 'IX_Emprestimos_LivroID' AND object_id = OBJECT_ID('dbo.Emprestimos'))
BEGIN
	PRINT 'Criando Índice IX_Emprestimos_LivroID';

	CREATE NONCLUSTERED INDEX IX_Emprestimos_LivroID
	ON dbo.Emprestimos (LivroID);

	PRINT 'O Índice IX_Emprestimos_LivroID criado com sucesso';
END
ELSE
BEGIN
	PRINT 'O Índice IX_Emprestimos_LivroID já existe';
END
GO


-- ==============================================================================
-- 3. Arquitetura de Índices Columnstore
-- ==============================================================================

/*
Introduzidos no SQL Server 2012, os índices Columnstore são projetados
principalmente para cargas de trabalho de Data Warehouse e Analytics (OLAP),
onde grandes volumes de dados são agregados e consultados.

Funcionamento:
- Armazenam dados por COLUNA, em vez de por linha (como os B-Trees).
- Cada coluna é armazenada separadamente em segmentos.
- Utilizam alta compressão, reduzindo o I/O e o espaço de armazenamento.
- São otimizados para operações de agregação (SUM, COUNT, AVG, MIN, MAX) e
  varreduras (scans) em grandes conjuntos de dados.

Tipos:
1. Índice Columnstore Clusterizado (Clustered Columnstore Index - CCI):
   - Define o armazenamento físico da tabela inteira no formato colunar.
   - Uma tabela só pode ter UM índice clusterizado (seja B-Tree ou Columnstore).
   - Ideal para tabelas de fatos em Data Warehouses.
   - Não permite outras constraints como PK, FK, UNIQUE diretamente (embora PK/UNIQUE
     possam ser impostas com constraints não clusterizadas).

2. Índice Columnstore Não Clusterizado (Nonclustered Columnstore Index - NCCI):
   - Um índice secundário no formato colunar, criado sobre uma tabela Heap ou
     com índice clusterizado B-Tree.
   - Pode incluir um subconjunto de colunas da tabela.
   - Útil para cenários de "Operational Analytics" (análise em tempo real sobre
     dados transacionais OLTP).

Benefícios:
- Desempenho excepcional em consultas analíticas e de agregação.
- Alta taxa de compressão.
- Processamento em lote (Batch Mode Execution) que opera sobre múltiplos valores
  de uma coluna de uma vez.

Considerações:
- Menos eficientes para buscas pontuais (lookup) de linhas individuais.
- Podem tornar DML (INSERT, UPDATE, DELETE) mais lento, especialmente em NCCIs
  sobre tabelas OLTP muito voláteis (devido à manutenção do deltastore e
  processo de "tuple mover").
- Não são ideais para todas as tabelas em um sistema OLTP como o nosso `BibliotecaDB`,
  mas podem ser úteis em tabelas maiores ou para relatórios específicos.

Exemplo (Conceitual - Pode não ser ideal para `BibliotecaDB` neste tamanho):
-- Poderíamos criar um NCCI na tabela Emprestimos para análises rápidas,
-- mas com poucos dados, o benefício pode não ser evidente.

-- Sintaxe (Não executar neste script, apenas para demonstração):
-- CREATE NONCLUSTERED COLUMNSTORE INDEX NCCI_Emprestimos_Analise
-- ON dbo.Emprestimos (LivroID, UsuarioID, DataEmprestimo, StatusEmprestimo);
*/

-- ==============================================================================
-- 4. Manutenção de Índices
-- ==============================================================================

/*
Com o tempo e as operações DML (INSERT, UPDATE, DELETE), os índices (B-Tree)
podem se tornar fragmentados.

Fragmentação:
- Interna: Espaço desperdiçado dentro das páginas de dados/índice.
- Externa: A ordem lógica das páginas do índice não corresponde à ordem física
  no disco, exigindo mais I/O para leituras sequenciais.

Estatísticas:
- São objetos que contêm informações sobre a distribuição dos valores nas colunas.
- O Otimizador de Consultas usa estatísticas para estimar quantas linhas serão
  retornadas por diferentes partes de uma consulta e escolher o plano de execução
  mais eficiente.
- Estatísticas desatualizadas podem levar a planos de execução ruins.

Comandos de Manutenção:

1. REORGANIZE (ALTER INDEX ... REORGANIZE):
   - Reorganiza os nós folha do índice, corrigindo a fragmentação externa e
     compactando as páginas para remover algum espaço vazio (fragmentação interna).
   - Operação geralmente ONLINE (permite acesso concorrente à tabela).
   - Menos intensiva que REBUILD, mas pode não ser tão eficaz para alta fragmentação.
   - Recomendado para fragmentação baixa a média (ex: 5% a 30%).

2. REBUILD (ALTER INDEX ... REBUILD):
   - Recria completamente o índice. Remove toda a fragmentação.
   - Pode ser feito ONLINE (Enterprise Edition) ou OFFLINE (padrão).
     Offline bloqueia o acesso à tabela durante a operação.
   - Mais intensivo que REORGANIZE, mas mais eficaz para alta fragmentação.
   - Atualiza automaticamente as estatísticas do índice com FULLSCAN (por padrão).
   - Recomendado para fragmentação alta (ex: > 30%).

3. UPDATE STATISTICS:
   - Atualiza as informações estatísticas sobre a distribuição de dados.
   - Crucial para o otimizador tomar boas decisões.
   - Pode ser executado para uma tabela inteira ou para estatísticas específicas.
   - Opções: FULLSCAN (lê todas as linhas, mais preciso, mais lento) vs SAMPLE
     (lê uma amostra, mais rápido, menos preciso).
   - O SQL Server geralmente atualiza estatísticas automaticamente (Auto Update Statistics),
     mas atualizações manuais podem ser necessárias após grandes cargas de dados ou
     quando o comportamento automático não é suficiente.

Como verificar a fragmentação (Exemplo usando DMV):
*/

PRINT 'Verificando fragmentação de índices no banco de dados atual...'

SELECT
	OBJECT_SCHEMA_NAME(ips.object_id) + '.' + OBJECT_NAME(ips.object_id) AS Tabela,
    si.name AS Indice,
    ips.index_type_desc AS Tipo_Indice,
    CAST(ips.avg_fragmentation_in_percent AS DECIMAL(5,2)) AS Fragmentacao_Porc,
    ips.page_count AS Paginas,
    CASE
        WHEN ips.avg_fragmentation_in_percent > 30 THEN 'Reconstruir (ALTER INDEX REBUILD)'
        WHEN ips.avg_fragmentation_in_percent BETWEEN 5 AND 30 THEN 'Reorganizar (ALTER INDEX REORGANIZE)'
        ELSE 'OK'
    END AS Acao_Recomendada
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'DETAILED') ips
INNER JOIN sys.indexes si ON ips.object_id = si.object_id AND ips.index_id = si.index_id
WHERE ips.avg_fragmentation_in_percent > 5 -- Filtra apenas índices com fragmentação significativa
	  AND si.name IS NOT NULL -- Ignora heaps sem índices
	  AND ips.page_count > 100 -- Ignora índices muito pequenos
ORDER BY ips.avg_fragmentation_in_percent DESC;
GO



-- Exemplo de Reorganização (Executar se houver fragmentação > 5% e < 30%) 
PRINT 'Executando REORGANIZE no índice';

BEGIN TRY
    EXEC('ALTER INDEX [IX_Livros_EditoraID] ON dbo.Livros REORGANIZE');
    PRINT '✔ REORGANIZE concluído com sucesso';
END TRY
BEGIN CATCH
    PRINT '✖ Erro durante REORGANIZE: ' + ERROR_MESSAGE();
END CATCH
GO


-- Exemplo de Reconstrução (Executar se houver fragmentação > 30%) 
PRINT 'Executando REBUILD no índice';

BEGIN TRY
    EXEC('ALTER INDEX [IX_Livros_Titulo] ON dbo.Livros REBUILD WITH (ONLINE = OFF)');
    PRINT '✔ REBUILD concluído com sucesso';
END TRY
BEGIN CATCH
    PRINT '✖ Erro durante REBUILD: ' + ERROR_MESSAGE();
END CATCH
GO


-- Exemplo de Atualização de Estatísticas (Para a tabela Livros) 
PRINT 'Atualizando estatísticas da tabela';

BEGIN TRY
    UPDATE STATISTICS dbo.Livros;
    PRINT '✔ Estatísticas atualizadas com sucesso';
END TRY
BEGIN CATCH
    PRINT '✖ Erro ao atualizar estatísticas: ' + ERROR_MESSAGE();
END CATCH
GO


-- Exemplo de Atualização de Estatísticas (Para um índice específico com FullScan) 
PRINT 'Atualizando estatísticas com FULLSCAN para o índice';

BEGIN TRY
    UPDATE STATISTICS dbo.Livros [IX_Livros_GeneroID] WITH FULLSCAN;
    PRINT '✔ FULLSCAN concluído com sucesso';
END TRY
BEGIN CATCH
    PRINT '✖ Erro durante FULLSCAN: ' + ERROR_MESSAGE();
END CATCH
GO


-- ==============================================================================
-- 5. Plano de Execução
-- ============================================================================== 
/*
O Plano de Execução é a "receita" que o SQL Server cria para executar uma consulta.
Ele detalha os passos (operadores) que o motor de banco de dados seguirá para
retornar os dados solicitados.

Analisar planos de execução é FUNDAMENTAL para o Query Tuning, pois revela:
- Como os dados estão sendo acessados (Index Scan, Index Seek, Table Scan).
- Quais índices estão sendo usados (ou não).
- Onde estão os custos mais altos da consulta (operadores mais caros).
- Estimativas vs. Realidade (número de linhas estimado vs. real).
- Advertências (Warnings) sobre problemas potenciais (conversões implícitas, etc.).

Tipos de Planos:
- Plano Estimado (Estimated Execution Plan): Gerado pelo otimizador ANTES da
  execução da consulta, baseado nas estatísticas disponíveis. Útil para uma
  análise rápida sem executar a query.
- Plano Real (Actual Execution Plan): Gerado APÓS a execução da consulta.
  Contém informações reais sobre o número de linhas, tempo de execução por
  operador, etc. Mais preciso para diagnóstico.

Como Visualizar (no SSMS ou Azure Data Studio):
- Plano Estimado: Selecione a query e pressione Ctrl+L ou clique no botão
  "Display Estimated Execution Plan".
- Plano Real: Selecione a query e pressione Ctrl+M ou clique no botão
  "Include Actual Execution Plan". Depois, execute a query (F5).

Operadores Comuns:
- Table Scan: Lê a tabela inteira (geralmente ruim para tabelas grandes).
- Clustered Index Scan: Lê o índice clusterizado inteiro.
- Clustered Index Seek: Usa o índice clusterizado para ir direto aos dados (bom).
- Nonclustered Index Scan: Lê um índice não clusterizado inteiro.
- Nonclustered Index Seek: Usa um índice não clusterizado para encontrar ponteiros
  para os dados (bom).
- Key Lookup / RID Lookup: Ocorre após um Index Seek em um índice não clusterizado
  quando colunas adicionais (não presentes no índice) são necessárias. O motor
  precisa buscar essas colunas na tabela base (usando a chave clusterizada - Key
  Lookup - ou o Row ID - RID Lookup em Heaps). Pode ser custoso se ocorrer muitas vezes.
- Hash Match / Merge Join / Nested Loops: Operadores de JOIN.
- Sort: Operador de ordenação (pode ser caro).
- Compute Scalar: Realiza cálculos.

Exemplo: Analisar o plano de uma consulta simples
*/


-- Habilite o "Include Actual Execution Plan" (Ctrl+M) antes de executar esta query
SELECT
	L.Titulo,
	L.AnoPublicacao,
	E.Nome AS NomeEditora,
	G.Nome AS NomeGenero
FROM dbo.Livros AS L
INNER JOIN dbo.Editoras AS E ON L.EditoraID = E.EditoraID
INNER JOIN dbo.Generos AS G ON L.GeneroID = G.GeneroID
WHERE L.AnoPublicacao > 1950;
GO


/*
Após executar com o Plano Real habilitado, observe:
- Os operadores usados (Seeks nos índices de FK? Scan na tabela Livros?)
- O custo relativo de cada operador.
- O número de linhas estimado vs. real em cada seta.
- Se há algum Key Lookup (indicando que o índice usado não "cobria" a consulta).
*/ 

-- ==============================================================================
-- 6. Otimizador de Consultas e Estatísticas
-- ==============================================================================

/*
O Otimizador de Consultas (Query Optimizer - QO) é o "cérebro" do SQL Server
responsável por gerar os planos de execução.

Processo (Simplificado):
1. Parsing: Verifica a sintaxe da query.
2. Binding (Algebrizer): Resolve nomes de objetos (tabelas, colunas), verifica
   permissões e tipos de dados. Gera uma árvore lógica da consulta.
3. Otimização (Query Optimization): Esta é a fase principal.
   - O QO é baseado em CUSTO (Cost-Based Optimizer).
   - Ele explora vários planos de execução alternativos possíveis para a consulta.
   - Usa as ESTATÍSTICAS para estimar o custo (I/O, CPU) de cada plano alternativo.
   - Escolhe o plano com o menor custo estimado.

Estatísticas são CRUCIAIS:
- Se as estatísticas estão desatualizadas ou ausentes, as estimativas de custo
  do QO serão imprecisas.
- Estimativas imprecisas levam à escolha de planos de execução subótimos, resultando
  em baixo desempenho.

O SQL Server cria e atualiza estatísticas automaticamente em muitos casos:
- Auto Create Statistics: Cria estatísticas em colunas usadas em predicados (WHERE)
  quando elas ainda não existem.
- Auto Update Statistics: Atualiza estatísticas quando um número significativo de
  linhas foi modificado (baseado em um limiar).

No entanto, às vezes é necessário gerenciamento manual:
- Após grandes cargas de dados.
- Quando o limiar de atualização automática não é atingido, mas a distribuição
  dos dados mudou significativamente.
- Para garantir estatísticas mais precisas (usando FULLSCAN).

Como visualizar estatísticas existentes:
*/ 

-- Mostra estatísticas criadas para a tabela Livros (incluindo as de índices)
EXEC sp_helpstats Livros
GO

-- Mostra o cabeçalho e o histograma de uma estatística específica
-- (Substitua '_WA_Sys_...' pelo nome real de uma estatística da tabela Livros,
-- obtido com sp_helpstats, ou o nome de um índice como IX_Livros_Titulo)



-- Para um índice:
DBCC SHOW_STATISTICS(Livros, IX_Livros_Titulo);
GO

/*
O histograma mostra a distribuição dos dados em até 200 "steps" (faixas).
O QO usa essa informação para estimar quantas linhas correspondem a um determinado
valor ou faixa de valores em um predicado WHERE.

Atualizando Estatísticas Manualmente (Revisão):
*/

-- Atualiza todas as estatísticas da tabela Livros (usando a amostragem padrão)
-- UPDATE STATISTICS dbo.Livros;

-- Atualiza todas as estatísticas da tabela Livros com leitura completa (mais preciso)
-- UPDATE STATISTICS dbo.Livros WITH FULLSCAN;

-- Atualiza apenas as estatísticas do índice IX_Livros_Titulo com leitura completa
-- UPDATE STATISTICS dbo.Livros IX_Livros_Titulo WITH FULLSCAN;
