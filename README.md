# Resolução do Desafio SAEP: Sistema de Gestão para Clínica Veterinária

**Avaliação Prática de Desempenho dos Estudantes - SAEP**

**Tecnologias**: PHP 8.5, PostgreSQL, PDO (Prepared Statements)

**Arquitetura**: MVC Artesanal, Autoload PSR-4 via Composer

---

## Apresentação do Projeto e Visão Geral

Este documento apresenta a resolução integral para o **Sistema de Gestão de Clínica Veterinária** - SGCV

- Segurança LGPD
- Sessão com Tempo de Expiração
- Código Limpo e Princípio SOLID
- Uso de Credenciais
- Prevenção de Vulnerabilidade (XSS, SQL Injection, CSRF)

## Entregas

### Identificação do Projeto
- **Nome do Sistema**: SisVet - Sistema de Gestão de Clínica Veterinária
- **Público-Alvo**: Veterinários, Recepcionista e Gestores da Clínica
- **Problema**: Eliminação dos controles manuais, duplicidade de registro, perda de agendamentos e risco de vazamento de dados(LGPD)

### Requisitos Funcionais (RF)

- **RF-01**: Autenticação do Usuário com Sessão e Expiração => O sistema deve autenticar o usuário com e-mail e senha (hash de criptografia). Exibir alerta em caso de Erro. Sessão deve expirar automaticamente após 15 minutos de inatividade.
- **RF-02**: Logout => Encerramento de sessão, destruindo os dados do usuário (cookies).
- **RF-03**: Painel Principal (Dashboard) => Tela inicial após o login, deve exibir o nome do usuário logado.
- **RF-04**: Cadastro de Tutores (LGPD) => Cadastrar informações dos tutores criptografando dados sensíveis (CPF).
- **RF-05**: Busca e Listagem de Tutores => Campo de pesquisa por termo e listagem dos resultados.
- **RF-06**: Edição dos Tutores => Permitir a alteração dos dados dos Tutores.
- **RF-07**: Cadastro dos Pets com Vínculo em Tutor => Cadastro de Novo pet associado a um tutor.
- **RF-08**: Listagem dos Pets => Exibir a lista de pets cadastrados.
- **RF-09**: Agendamento e Listagem de Agendamento => O sistema deve permitir cadastrar um agendamento e listar todos os agendamentos (ordenados por data).
- **RF-10**: Atualização de Agendamento => Permitir alterar informações do agendamento

### Requisitos Não Funcionais (RNF)

- RNF-01: Arquitetura MVC
- RNF-02: Mapeamento via PSR-04
- RNF-03: Proteção e Criptografia
- RNF-04: Armazenamento em Banco de Dados Relacional

### Diagrama de Entidades Relacionais (DER)

```mermaid

erDiagram
    title "DER - Sistema de Gestão de Clínica Veterinária"

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

## Banco de Dados - Script de Criação e População

Criação do arquivo schema.sql

## Construção da Aplicação (`sistema/`)

### Composer.json

Configurações do AutoLoad - PSR4