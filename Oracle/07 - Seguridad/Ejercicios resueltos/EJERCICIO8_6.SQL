COL GRANTEE FORMAT A30
COL OWNER FORMAT A15
COL TABLE_NAME FORMAT A15
COL GRANTOR FORMAT A15
COL PRIVILEGE FORMAT A20
SELECT *
FROM SESSION_PRIVS
/
SELECT *
FROM USER_TAB_PRIVS
/

--GRANTEE: El nombre del usuario al que se le otorgaron los privilegios.
--OWNER: El propietario de la tabla.
--TABLE_NAME: El nombre de la tabla a la que se otorgaron los privilegios.
--GRANTOR: El usuario que otorgó los privilegios.
--PRIVILEGE: El tipo de privilegio otorgado (por ejemplo, SELECT, INSERT, UPDATE, DELETE).
--GRANTABLE: Indica si el privilegio es con opción de otorgamiento (YES) o no (NO).
--HIERARCHY: Indica si el privilegio es parte de una jerarquía (YES) o no (NO).
--COMMON: Indica si el privilegio es común (se aplica a una tabla de sistema) (YES) o no (NO).
--TYPE: Tipo de privilegio (puede ser TABLE, VIEW, CLUSTER, o SYNOMYM).
--INHERITED: Indica si el privilegio es heredado (YES) o no (NO).