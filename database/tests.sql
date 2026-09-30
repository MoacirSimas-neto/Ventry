USE ventry_v2;


-- =========================================
-- TESTE 1
-- COMPRA VÁLIDA
-- =========================================

CALL compra_com_estoque(1, 1, 2);

-- Esperado:
-- COMPRA_REALIZADA


SELECT *
FROM compra
ORDER BY id DESC;


SELECT *
FROM item_compra
ORDER BY id DESC;


SELECT *
FROM lote
WHERE id = 1;


-- Se começou com 100 ingressos,
-- quantidade_disponivel deve ficar em 98.



-- =========================================
-- TESTE 2
-- LOTE INEXISTENTE
-- =========================================

CALL compra_com_estoque(1, 999, 2);

-- Esperado:
-- LOTE_INEXISTENTE



-- =========================================
-- TESTE 3
-- CLIENTE INEXISTENTE
-- =========================================

CALL compra_com_estoque(999, 1, 2);

-- Esperado:
-- CLIENTE_INEXISTENTE



-- =========================================
-- TESTE 4
-- QUANTIDADE INVÁLIDA
-- =========================================

CALL compra_com_estoque(1, 1, 0);

-- Esperado:
-- QUANTIDADE_INVALIDA



-- =========================================
-- TESTE 5
-- ESTOQUE INSUFICIENTE
-- =========================================

CALL compra_com_estoque(1, 1, 500);

-- Esperado:
-- ESTOQUE_INSUFICIENTE



-- =========================================
-- TESTE DE CONCORRÊNCIA
-- =========================================

-- Este teste precisa ser executado em
-- duas conexões diferentes do MySQL.


-- SESSÃO A:

/*

START TRANSACTION;

UPDATE lote
SET quantidade_disponivel =
    quantidade_disponivel - 1
WHERE id = 1
AND quantidade_disponivel >= 1;

SELECT ROW_COUNT();

-- NÃO FAZER COMMIT AINDA

*/


-- SESSÃO B:

/*

START TRANSACTION;

UPDATE lote
SET quantidade_disponivel =
    quantidade_disponivel - 1
WHERE id = 1
AND quantidade_disponivel >= 1;

SELECT ROW_COUNT();

*/


-- A sessão B deve esperar a sessão A.

-- Depois execute na sessão A:

/*

COMMIT;

*/

-- A sessão B continua após a liberação
-- da linha.

-- Se não houver mais estoque suficiente,
-- ROW_COUNT() retorna 0.

-- 1. código duplicado
INSERT INTO ingresso (
    id_item_compra,
    codigo_unico
)
VALUES (
    1,
    'VTY-A81F92K2'
);


-- 2. status inválido
INSERT INTO ingresso (
    id_item_compra,
    codigo_unico,
    status
)
VALUES (
    1,
    'VTY-TESTE002',
    'PENDENTE'
);

-- 3. item_compra inexistente
INSERT INTO ingresso (
    id_item_compra,
    codigo_unico
)
VALUES (
    999,
    'VTY-TESTE003'
);




USE ventry_v2;


-- =========================================
-- FASE 4A
-- TESTE DE GERAÇÃO DE INGRESSOS
-- =========================================


-- =========================================
-- TESTE 6
-- CRIAR COMPRA COM 3 INGRESSOS
-- =========================================

CALL compra_com_estoque(1, 1, 3);

-- Esperado:
-- COMPRA_REALIZADA


-- Pega automaticamente o item_compra
-- criado na compra acima

SET @id_item_compra_teste = (
    SELECT id
    FROM item_compra
    ORDER BY id DESC
    LIMIT 1
);

SELECT @id_item_compra_teste;


-- =========================================
-- TESTE 7
-- GERAR INGRESSOS
-- =========================================

CALL gerar_ingressos(@id_item_compra_teste);

-- Esperado:
-- INGRESSOS_GERADOS
-- quantidade_gerada = 3


-- Confere os ingressos criados

SELECT *
FROM ingresso
WHERE id_item_compra = @id_item_compra_teste;

-- Esperado:
-- 3 registros
-- códigos diferentes
-- status = VALIDO
-- data_criacao preenchida


-- Confere a quantidade

SELECT COUNT(*) AS total_ingressos
FROM ingresso
WHERE id_item_compra = @id_item_compra_teste;

-- Esperado:
-- total_ingressos = 3


-- =========================================
-- TESTE 8
-- IMPEDIR GERAÇÃO DUPLICADA
-- =========================================

CALL gerar_ingressos(@id_item_compra_teste);

-- Esperado:
-- INGRESSOS_JA_GERADOS


-- =========================================
-- TESTE 9
-- ITEM_COMPRA INEXISTENTE
-- =========================================

CALL gerar_ingressos(999);

-- Esperado:
-- ITEM_COMPRA_INEXISTENTE