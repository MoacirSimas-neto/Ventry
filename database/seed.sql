USE ventry_v2;


-- LOCAL

INSERT INTO local (
    nome,
    cidade,
    estado,
    endereco,
    numero,
    bairro
)
VALUES (
    'Arena Floripa',
    'Florianopolis',
    'SC',
    'Avenida Beira-Mar Norte',
    '1000',
    'Centro'
);


-- ORGANIZADOR

INSERT INTO organizador (
    nome,
    cpf,
    celular,
    email,
    endereco
)
VALUES (
    'Ventry Eventos',
    '12345678901',
    '48999999999',
    'contato@ventry.com',
    NULL
);


-- EVENTO

INSERT INTO evento (
    nome,
    capacidade_maxima,
    horario,
    data_evento,
    dress_code,
    id_local,
    id_organizador
)
VALUES (
    'Floripa Tech Summit',
    500,
    '20:00:00',
    '2026-10-29',
    NULL,
    1,
    1
);


-- TIPO DE INGRESSO

INSERT INTO tipo_ingresso (
    nome,
    id_evento
)
VALUES (
    'PISTA',
    1
);


-- LOTE

INSERT INTO lote (
    numero_lote,
    preco,
    quantidade_total,
    quantidade_disponivel,
    id_tipo_ingresso
)
VALUES (
    1,
    50.00,
    100,
    100,
    1
);


-- CLIENTE

INSERT INTO cliente (
    nome,
    cpf,
    telefone,
    email,
    endereco,
    data_nascimento
)
VALUES (
    'Cliente Teste',
    '98765432100',
    '48988888888',
    'cliente@teste.com',
    NULL,
    '2000-01-01'
);
