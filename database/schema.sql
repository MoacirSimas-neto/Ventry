CREATE DATABASE IF NOT EXISTS ventry_v2;
USE ventry_v2;


-- =========================================
-- LOCAL
-- =========================================

CREATE TABLE local (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado CHAR(2) NOT NULL,
    endereco VARCHAR(150) NOT NULL,
    numero VARCHAR(10),
    bairro VARCHAR(100) NOT NULL,

    CHECK (TRIM(nome) <> ''),
    CHECK (TRIM(cidade) <> ''),
    CHECK (TRIM(endereco) <> ''),
    CHECK (TRIM(bairro) <> '')
);


-- =========================================
-- ORGANIZADOR
-- =========================================

CREATE TABLE organizador (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    celular VARCHAR(15) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    endereco VARCHAR(150)
);


-- =========================================
-- EVENTO
-- =========================================

CREATE TABLE evento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    capacidade_maxima INT NOT NULL,
    horario TIME NOT NULL,
    data_evento DATE NOT NULL,
    dress_code VARCHAR(100),

    id_local INT NOT NULL,
    id_organizador INT NOT NULL,

    FOREIGN KEY (id_local)
        REFERENCES local(id),

    FOREIGN KEY (id_organizador)
        REFERENCES organizador(id),

    CHECK (capacidade_maxima > 0)
);


-- =========================================
-- TIPO DE INGRESSO
-- =========================================

CREATE TABLE tipo_ingresso (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    id_evento INT NOT NULL,

    FOREIGN KEY (id_evento)
        REFERENCES evento(id),

    UNIQUE (nome, id_evento)
);


-- =========================================
-- LOTE
-- =========================================

CREATE TABLE lote (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero_lote INT NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_total INT NOT NULL,
    quantidade_disponivel INT NOT NULL,
    id_tipo_ingresso INT NOT NULL,

    FOREIGN KEY (id_tipo_ingresso)
        REFERENCES tipo_ingresso(id),

    CHECK (numero_lote > 0),
    CHECK (preco >= 0),
    CHECK (quantidade_total > 0),
    CHECK (quantidade_disponivel >= 0),
    CHECK (quantidade_disponivel <= quantidade_total),

    UNIQUE (numero_lote, id_tipo_ingresso)
);


-- =========================================
-- CLIENTE
-- =========================================

CREATE TABLE cliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(15) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    endereco VARCHAR(150),
    data_nascimento DATE
);


-- =========================================
-- COMPRA
-- =========================================

CREATE TABLE compra (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data_hora DATETIME NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    id_cliente INT NOT NULL,

    FOREIGN KEY (id_cliente)
        REFERENCES cliente(id),

    CHECK (valor_total >= 0),

    CHECK (
        status IN (
            'PENDENTE',
            'PAGO',
            'CANCELADO',
            'REEMBOLSADO'
        )
    )
);


-- =========================================
-- ITEM DA COMPRA
-- =========================================

CREATE TABLE item_compra (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_compra INT NOT NULL,
    id_lote INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_compra)
        REFERENCES compra(id),

    FOREIGN KEY (id_lote)
        REFERENCES lote(id),

    CHECK (quantidade > 0),
    CHECK (preco_unitario >= 0)
);

-- =========================================
-- INGRESSO 
-- =========================================

CREATE TABLE ingresso (
    id INT PRIMARY KEY AUTO_INCREMENT,

    id_item_compra int NOT NULL,

    codigo_unico VARCHAR(20) NOT NULL UNIQUE,

    status varchar(20) NOT NULL DEFAULT 'VALIDO',

    data_criacao datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (id_item_compra)
        REFERENCES item_compra(id),

    CHECK (
        status IN (
            'VALIDO',
            'UTILIZADO',
            'CANCELADO'
        )
    )
);

describe ingresso;

select*
from ingresso;

INSERT INTO ingresso (
    id_item_compra,
    codigo_unico
)
VALUES (
    1,
    'VTY-A81F92K2'
);