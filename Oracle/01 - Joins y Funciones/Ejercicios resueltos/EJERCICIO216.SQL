SELECT A.ID AS CODIGO,
	A.NOMBRE AS NOMBRE
FROM B_ARTICULOS A
MINUS
SELECT V.ID_ARTICULO AS CODIGO,
	BA.NOMBRE AS NOMBRE
FROM B_DETALLE_VENTAS V
INNER JOIN B_ARTICULOS BA ON BA.ID = V.ID_ARTICULO
/
