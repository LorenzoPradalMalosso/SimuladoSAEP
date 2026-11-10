-- ================================================
-- Script de Criação e População do Banco de Dados
-- ================================================

-- 1. Criação da Banco de Dados
-- Execute este arquivo conectado ao banco saep_db.

-- 2. Criação da Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    senha_hash VARCHAR(128) NOT NULL,
    perfil VARCHAR(128) NOT NULL CHECK (perfil IN ('admin', 'veterinario', 'recepcionista')),
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Criação de Tabela Tutores
CREATE TABLE IF NOT EXISTS tutores (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(128) NOT NULL,
    cpf_criptografado VARCHAR(128) NOT NULL,
    telefone VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Criação da Tabela de Pets
CREATE TABLE IF NOT EXISTS pets (
    id SERIAL PRIMARY KEY,
    tutor_id INTEGER NOT NULL REFERENCES tutores(id) ON DELETE CASCADE,
    nome VARCHAR(128) NOT NULL,
    especie VARCHAR(128) NOT NULL,
    raca VARCHAR(128) NOT NULL,
    data_nascimento DATE NOT NULL,
    cadastrado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Criação da Tabela de Agendamentos - Ordenada
CREATE TABLE IF NOT EXISTS agendamentos (
    id SERIAL PRIMARY KEY,
    tutor_id INTEGER NOT NULL REFERENCES tutores(id),
    pet_id INTEGER NOT NULL REFERENCES pets(id),
    usuario_id INTEGER NOT NULL REFERENCES usuarios(id),
    data_agendamento DATE NOT NULL,
    hora_agendamento TIME NOT NULL,
    servico VARCHAR(128) NOT NULL,
    status VARCHAR(128) NOT NULL DEFAULT 'AGENDADO' CHECK (status IN ('AGENDADO', 'CONCLUIDO', 'CANCELADO')),
    observacao TEXT,
    criado_em TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- =============================================================================
-- CARGA INICIAL DE DADOS (Pelo menos 3 registros por tabela)
-- =============================================================================

-- Usuários: Senha padrão para todos: '123456'
-- Senha de demonstracao para os usuarios abaixo: 123456 (hash bcrypt).
INSERT INTO usuarios (nome, email, senha_hash, perfil) VALUES
('Dra. Camila Alencar', 'camila.vet@sisvet.com', '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e', 'veterinario'),
('Lucas Fernandes', 'lucas.recepcao@sisvet.com', '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e', 'recepcionista'),
('Mariana Rocha', 'gestao@sisvet.com', '$2y$12$vIkXeCv8cOXjJ5QFpbRSxODd27KOZIYEad6xXhBVHVAd8HJLxS21e', 'admin');


-- Tutores: CPFs armazenados criptografados em Base64 (OpenSSL AES-256-CBC)
-- Valores originais dos CPFs de teste:
-- 1. '111.222.333-44' -> 'VmV0Q2FyZTE=' (cifra representativa)
-- 2. '555.666.777-88' -> 'VmV0Q2FyZTI='
-- 3. '999.888.777-66' -> 'VmV0Q2FyZTM='
INSERT INTO tutores (id, nome, cpf_criptografado, telefone, email) VALUES
(1, 'Carlos Eduardo Silva', 'DO4MNjpa36yzQoBfshuHSU94ekhyV3ltcjJaeVNmT2ZTOWFBMWc9PQ==', '(11) 98765-4321', 'carlos.silva@email.com'),
(2, 'Beatriz Souza Martins', '5imS5ExyZKDDK+aPyHJeIE5vZ2ZSd2o3V0pscS9jZFNRSWJnU1E9PQ==', '(11) 97654-3210', 'beatriz.martins@email.com'),
(3, 'Fernando Henrique Lima', '+mMnLn7CGBtrm4rZoK9Ip05zck5PakFIWDRrVjg1T1U0azQ1Nmc9PQ==', '(19) 99123-4567', 'fernando.lima@email.com');


-- Pets: Cada pet obrigatoriamente associado ao seu tutor
INSERT INTO pets (id, tutor_id, nome, especie, raca, data_nascimento) VALUES
(1, 1, 'Thor', 'Canina', 'Golden Retriever', '2021-05-10'),
(2, 2, 'Mia', 'Felina', 'Siamês', '2022-08-15'),
(3, 3, 'Bob', 'Canina', 'Bulldog Francês', '2020-02-20');


-- Agendamentos: Com anos distintos (2024, 2025, 2026) para demonstrar a ordenação por ano
INSERT INTO agendamentos (id, tutor_id, pet_id, usuario_id, data_agendamento, hora_agendamento, servico, status, observacao) VALUES
(1, 1, 1, 1, '2024-11-15', '09:30:00', 'Consulta Geral e Vacinação Anual', 'CONCLUIDO', 'Animal dócil e com carteira atualizada'),
(2, 2, 2, 1, '2025-06-20', '14:00:00', 'Profilaxia Dentária e Tartarectomia', 'CONCLUIDO', 'Exames pré-operatórios normais'),
(3, 3, 3, 2, '2026-03-10', '10:30:00', 'Check-up Preventivo e Exame de Sangue', 'AGENDADO', 'Paciente alérgico a dipirona');


-- Ajuste dos contadores das sequências para inserções futuras
SELECT setval('usuarios_id_seq', (SELECT MAX(id) FROM usuarios));
SELECT setval('tutores_id_seq', (SELECT MAX(id) FROM tutores));
SELECT setval('pets_id_seq', (SELECT MAX(id) FROM pets));
SELECT setval('agendamentos_id_seq', (SELECT MAX(id) FROM agendamentos));
