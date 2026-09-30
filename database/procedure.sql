USE ventry_v2;

DELIMITER %%

DROP PROCEDURE IF EXISTS compra_com_estoque%%

CREATE PROCEDURE compra_com_estoque(
    IN p_id_cliente INT,
    IN p_id_lote INT,
    IN p_quantidade INT
)

SQL SECURITY DEFINER
NOT DETERMINISTIC

BEGIN

    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_lote_existe INT;
    DECLARE v_cliente_existe INT;
    DECLARE v_id_compra INT;


    -- Faz rollback caso qualquer erro aconteça
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;


    -- Valida lote

    SELECT COUNT(*)
    INTO v_lote_existe
    FROM lote
    WHERE id = p_id_lote;

    IF v_lote_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'LOTE_INEXISTENTE';
    END IF;


    -- Valida cliente

    SELECT COUNT(*)
    INTO v_cliente_existe
    FROM cliente
    WHERE id = p_id_cliente;

    IF v_cliente_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'CLIENTE_INEXISTENTE';
    END IF;


    -- Valida quantidade

    IF p_quantidade IS NULL
       OR p_quantidade <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'QUANTIDADE_INVALIDA';

    END IF;


    -- Busca preço atual do lote

    SELECT preco
    INTO v_preco
    FROM lote
    WHERE id = p_id_lote;


    START TRANSACTION;


    -- Reserva o estoque de forma atômica

    UPDATE lote

    SET quantidade_disponivel =
        quantidade_disponivel - p_quantidade

    WHERE id = p_id_lote
      AND quantidade_disponivel >= p_quantidade;


    -- Nenhuma linha alterada = estoque insuficiente

    IF ROW_COUNT() = 0 THEN

        ROLLBACK;

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ESTOQUE_INSUFICIENTE';

    END IF;


    -- Cria compra

    INSERT INTO compra (
        data_hora,
        valor_total,
        status,
        id_cliente
    )
    VALUES (
        NOW(),
        v_preco * p_quantidade,
        'PAGO',
        p_id_cliente
    );


    SET v_id_compra = LAST_INSERT_ID();


    -- Cria item da compra

    INSERT INTO item_compra (
        id_compra,
        id_lote,
        quantidade,
        preco_unitario
    )
    VALUES (
        v_id_compra,
        p_id_lote,
        p_quantidade,
        v_preco
    );


    COMMIT;


    SELECT
        'COMPRA_REALIZADA' AS situacao,
        v_id_compra AS id_compra;


END%%

DELIMITER ;

DELIMITER %%

DROP PROCEDURE IF EXISTS gerar_ingressos%%

CREATE PROCEDURE gerar_ingressos(
    IN p_id_item_compra INT
)

BEGIN

    DECLARE v_quantidade INT;
    DECLARE v_contador INT DEFAULT 1;
    DECLARE v_item_existe INT;
    DECLARE v_ingressos_existentes INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    SELECT COUNT(*)
    INTO v_item_existe
    FROM item_compra
    WHERE id = p_id_item_compra;

    IF v_item_existe = 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ITEM_COMPRA_INEXISTENTE';

    END IF;
    
    
    START TRANSACTION;
    
    select quantidade
    into v_quantidade
    from item_compra
    where id = p_id_item_compra;
    
    Select COUNT(*)
    INTO v_ingressos_existentes
    FROM ingresso
    WHERE id_item_compra = p_id_item_compra
    FOR UPDATE;
    
    IF v_ingressos_existentes > 0 then 
    
      Signal sqlstate '45000'
      Set MESSAGE_TEXT = 'INGRESSOS_JA_GERADOS';
      
      end if;
      
      WHILE v_contador <= v_quantidade DO

INSERT INTO ingresso (
    id_item_compra,
    codigo_unico
)
VALUES (
    p_id_item_compra,
    CONCAT(
        'VTY-',
        UPPER(
            SUBSTRING(
                REPLACE(UUID(), '-', ''),
                1,
                16
            )
        )
    )
);

    SET v_contador = v_contador + 1;

END WHILE;

COMMIT;

SELECT
    'INGRESSOS_GERADOS' AS situacao,
    p_id_item_compra AS id_item_compra,
    v_quantidade AS quantidade_gerada;
    
    END%%

DELIMITER ;

SHOW PROCEDURE STATUS
WHERE Db = 'ventry_v2';
