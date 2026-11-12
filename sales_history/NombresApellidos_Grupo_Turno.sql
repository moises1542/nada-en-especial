-- =====================================================================
-- Esquema   : SH (Sales History Sample Schema)
--             https://github.com/oracle-samples/db-sample-schemas/tree/main/sales_history
-- Ejercicio : Cantidad de ventas por canal
-- Alumno    : Nombres Apellidos  -  Grupo  -  Turno
-- =====================================================================
--
-- Tablas que se usan:
--   CHANNELS (channel_id PK, channel_desc, ...)  -> catálogo de canales
--   SALES    (prod_id, cust_id, time_id, channel_id FK, ...) -> una fila por venta
--
-- Relación: CHANNELS 1 ---- N SALES  (sales.channel_id -> channels.channel_id)
--
-- Se usa LEFT JOIN desde CHANNELS para que salgan los 5 canales,
-- incluido el que no tiene ventas (Catalog, que sale con 0).
-- COUNT(s.channel_id) no cuenta los NULL, por eso Catalog da 0 y no 1.
-- =====================================================================

SELECT   c.channel_desc,
         COUNT(s.channel_id) AS cantidad
FROM     sh.channels c
         LEFT JOIN sh.sales s
                ON s.channel_id = c.channel_id
GROUP BY c.channel_desc
ORDER BY cantidad DESC;

-- Resultado esperado (datos de la versión actual del esquema):
--
--    CHANNEL_DESC   CANTIDAD
--    ------------   --------
--    Direct Sales     540328
--    Partners         258025
--    Internet         118416
--    Tele Sales         2074
--    Catalog               0
--
--    Total de filas en SALES: 918843
