CREATE OR REPLACE VIEW V_VENTAS_CONTADO AS
SELECT *
FROM B_VENTAS V
WHERE V.TIPO_VENTA = 'CO'

----El de insert  debería ser exitoso ya que la vista no tiene una cláusula CHECK que restrinja el tipo de venta.

ALTER VIEW V_VENTAS_CONTADO
ADD CONSTRAINT VENTAS_CONTADO_TIPO_VENTA_C CHECK (TIPO_VENTA = 'CO')
/
--En Oracle, no se puede agregar directamente una restricción CHECK a una vista
--Si necesitas imponer restricciones específicas a nivel de vista, podrías considerar crear una vista materializada con la restricción que deseas.
--Vista Normal (o simplemente "Vista"):

--Es una consulta almacenada que se ve como una tabla virtual.
No almacena datos de forma independiente; en cambio, se ejecuta la consulta subyacente cada vez que se consulta la vista.
Proporciona una forma de simplificar consultas complejas al ocultar la complejidad detrás de una interfaz más sencilla.
No almacena datos físicamente y siempre refleja el estado actual de los datos en las tablas subyacentes.
Vista Materializada (o "Materialized View"):

--Es una copia física de los resultados de una consulta que se almacena y se mantiene actualizada periódicamente.
Almacena los resultados de la consulta en forma de tabla física, por lo que puede mejorar significativamente el rendimiento de consultas repetitivas.
Los datos se actualizan mediante programación (por ejemplo, mediante un proceso de actualización periódica), lo que permite que los resultados se mantengan sincronizados con las tablas subyacentes.
Puede ser útil en situaciones donde el rendimiento es crítico y la consulta es compleja o costosa.