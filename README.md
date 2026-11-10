# ResoluÃ§Ã£o do Desafio SAEP: Sistema de GestÃ£o para ClÃ­nica VeterinÃ¡ria

**AvaliaÃ§Ã£o PrÃ¡tica de Desempenho dos Estudantes - SAEP**

**Tecnologias**: PHP 8.5, PostgreSQL, PDO (Prepared Statements)

**Arquitetura**: MVC Artesanal, Autoload PSR-4 via Composer

---

## ApresentaÃ§Ã£o do Projeto e VisÃ£o Geral

Este documento apresenta a resoluÃ§Ã£o integral para o **Sistema de GestÃ£o de ClÃ­nica VeterinÃ¡ria** - SGCV

- SeguranÃ§a LGPD
- SessÃ£o com Tempo de ExpiraÃ§Ã£o
- CÃ³digo Limpo e PrincÃ­pio SOLID
- Uso de Credenciais
- PrevenÃ§Ã£o de Vulnerabilidade (XSS, SQL Injection, CSRF)

## Entregas

### IdentificaÃ§Ã£o do Projeto
- **Nome do Sistema**: SisVet - Sistema de GestÃ£o de ClÃ­nica VeterinÃ¡ria
- **PÃºblico-Alvo**: VeterinÃ¡rios, Recepcionista e Gestores da ClÃ­nica
- **Problema**: EliminaÃ§Ã£o dos controles manuais, duplicidade de registro, perda de agendamentos e risco de vazamento de dados(LGPD)

### Requisitos Funcionais (RF)

- **RF-01**: AutenticaÃ§Ã£o do UsuÃ¡rio com SessÃ£o e ExpiraÃ§Ã£o => O sistema deve autenticar o usuÃ¡rio com e-mail e senha (hash de criptografia). Exibir alerta em caso de Erro. SessÃ£o deve expirar automaticamente apÃ³s 15 minutos de inatividade.
- **RF-02**: Logout => Encerramento de sessÃ£o, destruindo os dados do usuÃ¡rio (cookies).
- **RF-03**: Painel Principal (Dashboard) => Tela inicial apÃ³s o login, deve exibir o nome do usuÃ¡rio logado.
- **RF-04**: Cadastro de Tutores (LGPD) => Cadastrar informaÃ§Ãµes dos tutores criptografando dados sensÃ­veis (CPF).
- **RF-05**: Busca e Listagem de Tutores => Campo de pesquisa por termo e listagem dos resultados.
- **RF-06**: EdiÃ§Ã£o dos Tutores => Permitir a alteraÃ§Ã£o dos dados dos Tutores.
- **RF-07**: Cadastro dos Pets com VÃ­nculo em Tutor => Cadastro de Novo pet associado a um tutor.
- **RF-08**: Listagem dos Pets => Exibir a lista de pets cadastrados.
- **RF-09**: Agendamento e Listagem de Agendamento => O sistema deve permitir cadastrar um agendamento e listar todos os agendamentos (ordenados por data).
- **RF-10**: AtualizaÃ§Ã£o de Agendamento => Permitir alterar informaÃ§Ãµes do agendamento

### Requisitos NÃ£o Funcionais (RNF)

- RNF-01: Arquitetura MVC
- RNF-02: Mapeamento via PSR-04
- RNF-03: ProteÃ§Ã£o e Criptografia
- RNF-04: Armazenamento em Banco de Dados Relacional

### Diagrama de Entidades Relacionais (DER)

```mermaid

erDiagram
    title "DER - Sistema de GestÃ£o de ClÃ­nica VeterinÃ¡ria"

    usuarios {
        int id PK
        varchar nome
        varchar email UNIQUE
        varchar senha_hash
        varchar perfil
        timestamp criado_em
    }

    tutores {
        int id PK
        varchar nome
        varchar cpf_ciptografado
        varchar email
        timestamp criado_em
    }

    pets {
        int id PK
        int tutor_id FK
        varchar nome
        varchar especie
        varchar raca
        date data_nascimento
        timestamp cadastrado_em
    }

    agendamentos {
        int id PK
        int tutor_id FK
        int pet_id FK
        int usuario_id FK
        date data_agendamento
        time hora_agendamento
        varchar servico
        varchar status
        text observacao
        time
    }

    usuarios ||--o{ agendamentos : "agenda/gerencia"
    tutores ||--o{ pets : "possui (1:N)"
    tutores ||--o{ agendamentos : "responsavel (1:N)"
    pets ||--o{ agendamentos : "paciente (1:N)"
```

## Banco de Dados - Script de CriaÃ§Ã£o e PopulaÃ§Ã£o

CriaÃ§Ã£o do arquivo schema.sql

## ConstruÃ§Ã£o da AplicaÃ§Ã£o (`sistema/`)

### Composer.json

ConfiguraÃ§Ãµes do AutoLoad - PSR4
## Como executar

1. Instale PHP 8.2+ com as extensões `pdo_pgsql` e `openssl`, Composer e PostgreSQL.
2. Execute `composer install` dentro da pasta `sistema/` para gerar o autoload.
3. Crie o banco e as tabelas uma única vez, na raiz do projeto: `createdb -U postgres saep_db` e depois `psql -U postgres -d saep_db -f schema.sql`.
4. Confira host, porta, banco, usuário e senha em `sistema/config/database.ini`.
5. Na raiz do projeto, inicie o servidor:

   ```sh
   php -S 127.0.0.1:8000 -t sistema/public sistema/public/router.php
   ```

6. Acesse `http://127.0.0.1:8000/login` e entre com `camila.vet@sisvet.com` e senha `123456`.

Se o banco já foi criado com a versão antiga do `schema.sql`, corrija os hashes de senha provisórios no PostgreSQL:

```sql
UPDATE usuarios
SET senha_hash = '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e'
WHERE senha_hash = 'SUBSTITUA_PELO_HASH_ARGON2ID_GERADO_EM_PHP';
```
