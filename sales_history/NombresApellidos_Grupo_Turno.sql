-- =====================================================================
-- Sales History Sample Schema (SH) - versión rápida
-- Fuente: https://github.com/oracle-samples/db-sample-schemas/tree/main/sales_history
--         (tablas tomadas de sh_create.sql y datos de sh_populate.sql)
-- Ejercicio : Cantidad de ventas por canal
-- Alumno    : Nombres Apellidos - Grupo - Turno
--
-- Ejecutar en SQL Developer con F5 (Ejecutar script), conectado como SH.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 1. Borrar las tablas si ya existen (para poder ejecutarlo varias veces)
-- ---------------------------------------------------------------------
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sales PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE channels PURGE';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/


-- ---------------------------------------------------------------------
-- 2. Crear tablas (sh_create.sql)
-- ---------------------------------------------------------------------
CREATE TABLE channels
(
   channel_id         NUMBER         NOT NULL,
   channel_desc       VARCHAR2(20)   NOT NULL,
   channel_class      VARCHAR2(20)   NOT NULL,
   channel_class_id   NUMBER         NOT NULL,
   channel_total      VARCHAR2(13)   NOT NULL,
   channel_total_id   NUMBER         NOT NULL,
   CONSTRAINT channels_pk
      PRIMARY KEY (channel_id)
);

CREATE TABLE sales
(
   prod_id         NUMBER(6)      NOT NULL,
   cust_id         NUMBER         NOT NULL,
   time_id         DATE           NOT NULL,
   channel_id      NUMBER(1)      NOT NULL,
   promo_id        NUMBER(6)      NOT NULL,
   quantity_sold   NUMBER(3)      NOT NULL,
   amount_sold     NUMBER(10,2)   NOT NULL,
   CONSTRAINT sales_channel_fk
      FOREIGN KEY (channel_id) REFERENCES channels (channel_id)
);


-- ---------------------------------------------------------------------
-- 3. Insertar datos (sh_populate.sql)
-- ---------------------------------------------------------------------
INSERT INTO channels VALUES ( 3, 'Direct Sales', 'Direct',   12, 'Channel total', 1 );
INSERT INTO channels VALUES ( 9, 'Tele Sales',   'Direct',   12, 'Channel total', 1 );
INSERT INTO channels VALUES ( 5, 'Catalog',      'Indirect', 13, 'Channel total', 1 );
INSERT INTO channels VALUES ( 4, 'Internet',     'Indirect', 13, 'Channel total', 1 );
INSERT INTO channels VALUES ( 2, 'Partners',     'Others',   14, 'Channel total', 1 );

-- Una venta por canal (filas con el formato de sales.csv)
INSERT INTO sales VALUES ( 13,  987, DATE '2019-01-10', 3, 999, 1, 1232.16 );
INSERT INTO sales VALUES ( 13, 1660, DATE '2019-01-11', 9, 999, 1, 1232.16 );
INSERT INTO sales VALUES ( 13, 1762, DATE '2019-01-12', 2, 999, 1, 1232.16 );
INSERT INTO sales VALUES ( 13, 1843, DATE '2019-01-13', 4, 999, 1, 1232.16 );
INSERT INTO sales VALUES ( 13, 1948, DATE '2019-01-14', 5, 999, 1, 1232.16 );

COMMIT;


-- ---------------------------------------------------------------------
-- 4. Consulta: cantidad de ventas por canal
-- ---------------------------------------------------------------------
SELECT   c.channel_desc,
         COUNT(s.channel_id) AS cantidad
FROM     channels c
         LEFT JOIN sales s
                ON s.channel_id = c.channel_id
GROUP BY c.channel_desc
ORDER BY MIN(s.time_id);
