CREATE OR REPLACE VIEW V_EMPLEADOS AS
SELECT *
FROM B_EMPLEADOS

--Después de ejecutar este comando, puede insertar nuevos empleados a través de la vista.


ALTER VIEW V_EMPLEADOS
WITH READ ONLY
/
--Después de ejecutar este comando, la vista se vuelve de solo lectura y cualquier intento de realizar una operación de inserción a través de la vista generará un error.