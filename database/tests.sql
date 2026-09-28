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
