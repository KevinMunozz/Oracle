ALTER TABLESPACE BASEDATOS2
ADD DATAFILE 'ruta/nuevo_datafile.dbf' -- Sustituye 'ruta/nuevo_datafile.dbf' con la ruta y nombre deseado para el nuevo datafile
SIZE 2M
AUTOEXTEND ON NEXT 100K
MAXSIZE 5M
/