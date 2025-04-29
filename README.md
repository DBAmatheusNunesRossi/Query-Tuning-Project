**Autor:** Matheus Nunes Rossi

## Introdução

Bem-vindo a este guia prático sobre Query Tuning no SQL Server! O objetivo deste material é fornecer uma visão abrangente e didática das principais técnicas e ferramentas utilizadas para otimizar o desempenho de consultas em bancos de dados SQL Server.

![Image](https://github.com/user-attachments/assets/cdd11ced-1d2f-4789-9d64-a47ad9f97dde)

Utilizaremos um banco de dados de exemplo chamado `BibliotecaDB`, que simula um sistema de gerenciamento de biblioteca simples. Os scripts SQL fornecidos (Criacao_Banco_Biblioteca e Populacao_Banco_Biblioteca) devem ser executados antes de prosseguir com os exemplos deste guia.

Este guia está dividido nas seguintes seções principais:

1.  **Query Tuning - Introdução:** Conceitos fundamentais sobre índices, planos de execução e o otimizador de consultas.
2.  **Query Tuning - Otimizando Consultas:** Estratégias práticas para melhorar o desempenho de suas queries, incluindo indexação avançada e boas práticas de escrita.
3.  **Query Tuning - Monitoramento de Consultas:** Ferramentas e técnicas para monitorar o desempenho do banco de dados e identificar gargalos.

Vamos começar explorando os conceitos introdutórios!

---

## Seção 1: Query Tuning - Introdução

Nesta seção, abordaremos os conceitos fundamentais que formam a base do Query Tuning no SQL Server.

### 1.a. Arquitetura de Índices B-Tree

Índices B-Tree (Balanced Tree) são a estrutura de índice mais comum no SQL Server para a maioria dos tipos de dados. Eles organizam os dados de forma hierárquica, semelhante a uma árvore invertida, permitindo buscas, inserções, atualizações e exclusões eficientes.

**Estrutura:**

*   **Nó Raiz (Root Node):** O nível mais alto da árvore.
*   **Nós Intermediários (Intermediate Nodes):** Nós entre a raiz e as folhas.
*   **Nós Folha (Leaf Nodes):** O nível mais baixo, contendo os valores das chaves do índice e ponteiros:
    *   Para as linhas de dados reais (em **índices clusterizados**).
    *   Para os localizadores das linhas (Row Locators) em **índices não clusterizados** (que apontam para a Heap ou para a chave do índice clusterizado).

**Tipos Principais de Índices B-Tree:**

1.  **Índice Clusterizado (Clustered Index):**
    *   Define a **ordem física** dos dados na tabela. Uma tabela só pode ter **UM** índice clusterizado.
    *   Os nós folha **CONTÊM** os dados reais da linha.
    *   Geralmente criado na chave primária (PK), mas não obrigatoriamente.
    *   *Exemplo:* A tabela `Autores` no nosso script tem um índice clusterizado implícito em `AutorID` (PK).

2.  **Índice Não Clusterizado (Non-Clustered Index):**
    *   Estrutura **separada** da tabela de dados.
    *   Os nós folha contêm os valores das chaves do índice e um **ponteiro (Row Locator)** para a linha de dados correspondente.
    *   Uma tabela pode ter múltiplos índices não clusterizados (até 999).
    *   Útil para acelerar buscas em colunas que não são a chave do índice clusterizado ou em tabelas Heap (sem índice clusterizado).
    *   *Exemplo:* Podemos criar um índice não clusterizado na coluna `Titulo` da tabela `Livros` para acelerar buscas por título.

**Benefícios:**

*   Eficiência em buscas pontuais (`WHERE Coluna = Valor`).
*   Eficiência em buscas por faixa (`WHERE Coluna BETWEEN Valor1 AND Valor2`).
*   Mantém os dados ordenados (logicamente no índice), o que pode ajudar em cláusulas `ORDER BY` se as colunas do índice corresponderem.

**Considerações:**

*   Ocupam espaço em disco.
*   Podem tornar operações de `INSERT`, `UPDATE`, `DELETE` mais lentas, pois o índice também precisa ser atualizado.
*   A escolha das colunas a serem indexadas é crucial (seletividade é importante).
