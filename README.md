# Processamento e Transformação de Dados com Power BI

## Objetivo

Desenvolver um projeto de análise e transformação da base Company, conforme o desafio da formação Power BI Analyst da DIO.

## Tecnologias utilizadas

- MariaDB
- DBeaver
- SQL
- Git e GitHub
- Power BI (integração ainda pendente)

## Estrutura do projeto

- `01_criar_base_company.sql`: cria o banco de estudo, as tabelas e carrega os dados de exemplo.
- `02_analises_e_transformacoes.sql`: contém consultas para analisar dados e demonstrar transformações.
- `README.md`: documenta o projeto e as decisões tomadas.

## Análises e transformações previstas

1. Conferência da estrutura e dos tipos de dados.
2. Verificação de valores nulos.
3. Identificação de colaboradores sem supervisor e departamentos sem gerente.
4. Análise das horas trabalhadas por projeto.
5. Separação de campos complexos, como endereço.
6. Junção de colaboradores e departamentos.
7. Associação dos colaboradores aos respectivos gerentes.
8. Combinação dos nomes dos departamentos com suas localizações.
9. Agrupamento da quantidade de colaboradores por gerente.
10. Seleção das colunas necessárias ao relatório.

## Mesclar e acrescentar consultas

Mesclar consultas combina informações de tabelas relacionadas usando uma chave comum, como o número do departamento. Acrescentar consultas empilha linhas de tabelas com estruturas compatíveis. Para associar o departamento de cada colaborador, a operação adequada é mesclar.

## Fonte dos dados

Os scripts de referência estão disponíveis no repositório da formação:

[Repositório Power BI Analyst](https://github.com/julianazanelatto/power_bi_analyst)

A amostra SQL utilizada contém oito funcionários. Os resultados precisam ser conferidos com a base apresentada na aula.

## Status do projeto

- [x] Repositório criado.
- [x] Scripts SQL publicados.
- [x] Documentação inicial.
- [x] Executar e validar os scripts no MariaDB.
- [ ] Registrar evidências das consultas.
- [ ] Realizar a integração com Power BI, se viável no ambiente disponível.

## Resultados da validação SQL

As consultas foram executadas no MariaDB local, utilizando o DBeaver.

| Verificação | Resultado |
|---|---:|
| Funcionários sem supervisor cadastrado | 1 |
| Departamentos sem gerente cadastrado | 0 |
| Total de funcionários | 8 |

A consulta identificou um funcionário sem supervisor cadastrado. Nenhum departamento apresentou ausência de gerente. A base utilizada contém oito funcionários.

A integração com o Power BI Desktop ainda não foi realizada neste ambiente. O desenvolvimento SQL foi executado no MariaDB local como alternativa à configuração MySQL na Azure proposta originalmente.
