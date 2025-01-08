prompt PL/SQL Developer import file
prompt Created on lunes, 04 de febrero de 2013 by Admin
set feedback off
set define off
prompt Creating B_AREAS...
create table B_AREAS
(
  ID               NUMBER(6) not null,
  NOMBRE_AREA      VARCHAR2(40) not null,
  FECHA_CREA       DATE not null,
  ACTIVA           VARCHAR2(1) default 'S' not null,
  ID_AREA_SUPERIOR NUMBER(6)
)
;
comment on table B_AREAS
  is 'AREAS DE LA ORGANIZACION';
alter table B_AREAS
  add constraint PKAREAS primary key (ID);
alter table B_AREAS
  add constraint R_PADRE_AREA foreign key (ID_AREA_SUPERIOR)
  references B_AREAS (ID);

prompt Creating B_ARTICULOS...
create table B_ARTICULOS
(
  ID            NUMBER(8) not null,
  NOMBRE        VARCHAR2(40) not null,
  UNIDAD_MEDIDA VARCHAR2(10) not null,
  PRECIO        NUMBER(9) default 0 not null,
  COSTO         NUMBER(9) default 0 not null,
  PORC_IVA      NUMBER(3,2) default 0 not null,
  PORC_COMISION NUMBER(3,2) default 0 not null,
  STOCK_ACTUAL  NUMBER(8) not null,
  STOCK_MINIMO  NUMBER(8) not null,
  ULTIMA_COMPRA DATE default SYSDATE
)
;
comment on table B_ARTICULOS
  is 'ARTICULOS';
alter table B_ARTICULOS
  add constraint PKARTICULOS primary key (ID);

prompt Creating B_CATEGORIAS_SALARIALES...
create table B_CATEGORIAS_SALARIALES
(
  COD_CATEGORIA VARCHAR2(3) not null,
  NOMBRE_CAT    VARCHAR2(30) not null,
  ASIGNACION    NUMBER(8) not null,
  FECHA_INI     DATE not null,
  FECHA_FIN     DATE
)
;
comment on table B_CATEGORIAS_SALARIALES
  is 'CATEGORIAS SALARIALES';
alter table B_CATEGORIAS_SALARIALES
  add constraint PKCATEG_SALARIAL primary key (COD_CATEGORIA);

prompt Creating B_TIPO_CUENTA...
create table B_TIPO_CUENTA
(
  ID               NUMBER(4) not null,
  NOMBRE_CATEGORIA VARCHAR2(40) not null
)
;
comment on table B_TIPO_CUENTA
  is 'TIPO DE CUENTA';
alter table B_TIPO_CUENTA
  add constraint PKCATEGORIA primary key (ID);

prompt Creating B_CUENTAS...
create table B_CUENTAS
(
  CODIGO_CTA     NUMBER(7) not null,
  NOMBRE_CTA     VARCHAR2(40) not null,
  ID_TIPO        NUMBER(4) not null,
  NIVEL          NUMBER(1) not null,
  CTA_SUPERIOR   NUMBER(7),
  ORDEN          VARCHAR2(1) not null,
  FECHA_APERTURA DATE default SYSDATE not null,
  IMPUTABLE      VARCHAR2(1) default 'S' not null
)
;
comment on table B_CUENTAS
  is 'CUENTAS CONTABLES';
alter table B_CUENTAS
  add constraint PKCUENTAS primary key (CODIGO_CTA);
alter table B_CUENTAS
  add constraint R_CUENTASUP_CUENTA foreign key (CTA_SUPERIOR)
  references B_CUENTAS (CODIGO_CTA);
alter table B_CUENTAS
  add constraint R_TIPO_CUENTAS foreign key (ID_TIPO)
  references B_TIPO_CUENTA (ID);
alter table B_CUENTAS
  add constraint CK_DEUD_ACR4
  check (ORDEN IN ('D', 'C'));
alter table B_CUENTAS
  add constraint CK_SI_NO14
  check (IMPUTABLE IN ('S', 'N'));

prompt Creating B_LOCALIDAD...
create table B_LOCALIDAD
(
  NOMBRE         VARCHAR2(40) not null,
  ID             NUMBER(8) not null,
  ID_GOBERNACION NUMBER(8)
)
;
comment on table B_LOCALIDAD
  is 'LOCALIDAD GEOGR√ÅFICA';
alter table B_LOCALIDAD
  add constraint PKLOCALIDAD primary key (ID);

prompt Creating B_PERSONAS...
create table B_PERSONAS
(
  ID                 NUMBER(8) not null,
  TIPO_PERSONA       VARCHAR2(1) not null,
  NOMBRE             VARCHAR2(40) not null,
  APELLIDO           VARCHAR2(40),
  DIRECCION          VARCHAR2(40) not null,
  TELEFONO           VARCHAR2(40) not null,
  RUC                VARCHAR2(12),
  CEDULA             VARCHAR2(15),
  CORREO_ELECTRONICO VARCHAR2(40) not null,
  ES_CLIENTE         VARCHAR2(1) not null,
  ES_PROVEEDOR       VARCHAR2(40) not null,
  FECHA_NACIMIENTO   DATE not null,
  CODIGO_CTA         NUMBER(7),
  ID_LOCALIDAD       NUMBER(8) 
)
;
alter table B_PERSONAS
  add constraint PKPERSONAS primary key (ID);
alter table B_PERSONAS
  add constraint R_CTA_PERSONA foreign key (CODIGO_CTA)
  references B_CUENTAS (CODIGO_CTA);
alter table B_PERSONAS
  add constraint R_LOCALIDAD_PERSONA foreign key (ID_LOCALIDAD)
  references B_LOCALIDAD (ID);

prompt Creating B_COMPRAS...
create table B_COMPRAS
( ID           NUMBER not null,
  FECHA        DATE not null,
  ID_PROVEEDOR NUMBER(8) not null,
  ID_CONDICION NUMBER(8),
  MONTO_TOTAL  NUMBER(9) default 0 not null
)
;
comment on table B_COMPRAS
  is 'COMPRAS DE REPOSICION';
alter table B_COMPRAS
  add constraint PKCOMPRAS primary key (ID);
alter table B_COMPRAS
  add constraint R_PROVEEDOR_COMPRA foreign key (ID_PROVEEDOR)
  references B_PERSONAS (ID);

prompt Creating B_DETALLE_COMPRAS...
create table B_DETALLE_COMPRAS
(
  ID_COMPRA     NUMBER not null,
  ID_ARTICULO   NUMBER(8) not null,
  CANTIDAD      NUMBER(8) not null,
  PRECIO_COMPRA NUMBER(9) default 0 not null
)
;
comment on table B_DETALLE_COMPRAS
  is 'DETALLE DE LAS COMPRAS';
alter table B_DETALLE_COMPRAS
  add constraint PKDETALLE_COMPRAS primary key (ID_COMPRA, ID_ARTICULO);
alter table B_DETALLE_COMPRAS
  add constraint R_ARTICULO_COMPRA foreign key (ID_ARTICULO)
  references B_ARTICULOS (ID);
alter table B_DETALLE_COMPRAS
  add constraint R_COMPRA_DETALLE foreign key (ID_COMPRA)
  references B_COMPRAS (ID);

prompt Creating B_EMPLEADOS...
create table B_EMPLEADOS
(
  CEDULA       NUMBER(11) not null,
  NOMBRE       VARCHAR2(30) not null,
  APELLIDO     VARCHAR2(30) not null,
  FECHA_ING    DATE not null,
  FECHA_NACIM  DATE not null,
  CEDULA_JEFE  NUMBER(11),
  TELEFONO     VARCHAR2(15) not null,
  DIRECCION    VARCHAR2(60) not null,
  BARRIO       VARCHAR2(100) not null,
  ID_LOCALIDAD NUMBER(8)
)
;
comment on table B_EMPLEADOS
  is 'EMPLEADOS (VENDEDORES)';
alter table B_EMPLEADOS
  add constraint PKEMPLEADOS primary key (CEDULA);
alter table B_EMPLEADOS
  add constraint R_JEFE_EMPLEADO foreign key (CEDULA_JEFE)
  references B_EMPLEADOS (CEDULA);
create index INDB_EMPLEADOS on B_EMPLEADOS (APELLIDO);

prompt Creating B_VENTAS...
create table B_VENTAS
(
  ID              NUMBER(8) not null,
  NUMERO_FACTURA  NUMBER(8) not null,
  FECHA           DATE default SYSDATE not null,
  MONTO_TOTAL     NUMBER(9) default 0 not null,
  PLAZO           NUMBER(2) not null,
  TIPO_VENTA      VARCHAR2(2) default 'CO' not null,
  ID_CLIENTE      NUMBER(8) not null,
  CEDULA_VENDEDOR NUMBER(11) not null
)
;
comment on table B_VENTAS
  is 'VENTAS REALIZADAS';
alter table B_VENTAS
  add constraint PKVENTAS primary key (ID);
alter table B_VENTAS
  add constraint R_CLIENTE_VENTA foreign key (ID_CLIENTE)
  references B_PERSONAS (ID);
alter table B_VENTAS
  add constraint R_VENDEDOR_VENTA foreign key (CEDULA_VENDEDOR)
  references B_EMPLEADOS (CEDULA);
alter table B_VENTAS
  add constraint CK_CONT_CR4
  check (TIPO_VENTA IN ('CR', 'CO'));

prompt Creating B_DETALLE_VENTAS...
create table B_DETALLE_VENTAS
(
  ID_VENTA    NUMBER(8) not null,
  ID_ARTICULO NUMBER(8) not null,
  CANTIDAD    NUMBER(8) not null,
  NUMERO_ITEM NUMBER(8) not null,
  PRECIO      NUMBER(9) default 0 not null
)
;
comment on table B_DETALLE_VENTAS
  is 'DETALLE DE LAS VENTAS REALIZADAS';
alter table B_DETALLE_VENTAS
  add constraint PKDETALLE_VENTAS primary key (ID_VENTA, NUMERO_ITEM);
alter table B_DETALLE_VENTAS
  add constraint R_ARTICULO_VENTA foreign key (ID_ARTICULO)
  references B_ARTICULOS (ID);
alter table B_DETALLE_VENTAS
  add constraint R_VENTA_DETALLE foreign key (ID_VENTA)
  references B_VENTAS (ID);

prompt Creating B_DIARIO_CABECERA...
create table B_DIARIO_CABECERA
(
  ID           NUMBER(8) not null,
  FECHA        DATE default SYSDATE not null,
  CONCEPTO     VARCHAR2(100) not null,
  USUARIO      VARCHAR2(10) not null,
  FECHA_CIERRE DATE default SYSDATE,
  ID_AREA      NUMBER(6) not null
)
;
comment on table B_DIARIO_CABECERA
  is 'ASIENTOS DIARIOS';
alter table B_DIARIO_CABECERA
  add constraint PKDIARIO_CABECERA primary key (ID);
alter table B_DIARIO_CABECERA
  add constraint R_AREA_DIARIO foreign key (ID_AREA)
  references B_AREAS (ID);

prompt Creating B_DIARIO_DETALLE...
create table B_DIARIO_DETALLE
(
  ID         NUMBER(8) not null,
  CODIGO_CTA NUMBER(7) not null,
  DEBE_HABER VARCHAR2(1) not null,
  IMPORTE    NUMBER(9) default 0 not null,
  NRO_LINEA  NUMBER(4) not null
)
;
comment on table B_DIARIO_DETALLE
  is 'DETALLE DE LOS ASIENTOS
';
alter table B_DIARIO_DETALLE
  add constraint PKDIARIO_DETALLE primary key (ID, NRO_LINEA);
alter table B_DIARIO_DETALLE
  add constraint R_CUENTAS_DIARIO_DETALLE foreign key (CODIGO_CTA)
  references B_CUENTAS (CODIGO_CTA);
alter table B_DIARIO_DETALLE
  add constraint R_DIARIO_DETALLE foreign key (ID)
  references B_DIARIO_CABECERA (ID);

prompt Creating B_LIQUIDACION...
create table B_LIQUIDACION
( ID                NUMBER(8) not null,
  FECHA_LIQUIDACION DATE default SYSDATE not null,
  ANIO              NUMBER(4) default 0 not null,
  MES               NUMBER(2) default 1 not null
)
;
comment on table B_LIQUIDACION
  is 'LIQUIDACION DE SALARIO';
alter table B_LIQUIDACION
  add constraint PKLIQUIDACION primary key (ID);
alter table B_LIQUIDACION
  add constraint CK_MES7
  check (MES BETWEEN 1 AND 12);

prompt Creating B_MAYOR...
create table B_MAYOR
(
  ID_MAYOR     NUMBER(8) not null,
  CODIGO_CTA   NUMBER(7) not null,
  ANIO         NUMBER(4) not null,
  MES          NUMBER(2) default 1 not null,
  ACUM_DEBITO  NUMBER(9) default 0 not null,
  ACUM_CREDITO NUMBER(9) default 0 not null
)
;
comment on table B_MAYOR
  is 'MAYOR CUENTAS CONTABLES';
alter table B_MAYOR
  add constraint PKMAYOR primary key (ID_MAYOR);
alter table B_MAYOR
  add constraint R_CUENTAS_MAYOR foreign key (CODIGO_CTA)
  references B_CUENTAS (CODIGO_CTA);
alter table B_MAYOR
  add constraint CK_MES8
  check (MES BETWEEN 1 AND 12);

prompt Creating B_PLANILLA...
create table B_PLANILLA
(
  ID_LIQUIDACION        NUMBER(8) not null,
  CEDULA                NUMBER(11) not null,
  SALARIO_BASICO        NUMBER(8) default 0 not null,
  DESCUENTO_IPS         NUMBER(9) default 0 not null,
  BONIFICACION_X_VENTAS NUMBER(8) default 0 not null,
  LIQUIDO_COBRADO       NUMBER(9) default 0 not null
)
;
comment on table B_PLANILLA
  is 'PLANILLA CON DETALLE DE LA LIQUIDACION';
alter table B_PLANILLA
  add constraint PKPLANILLA primary key (ID_LIQUIDACION, CEDULA);
alter table B_PLANILLA
  add constraint R_EMP_PLANILLA foreign key (CEDULA)
  references B_EMPLEADOS (CEDULA);
alter table B_PLANILLA
  add constraint R_LIQUIDA_PLANILLA foreign key (ID_LIQUIDACION)
  references B_LIQUIDACION (ID);

prompt Creating B_PLAN_PAGO...
create table B_PLAN_PAGO
(
  ID_VENTA     NUMBER(8) not null,
  NUMERO_CUOTA NUMBER(8) not null,
  MONTO_CUOTA  NUMBER(9) default 0 not null,
  VENCIMIENTO  DATE default SYSDATE not null,
  FECHA_PAGO   DATE
)
;
comment on table B_PLAN_PAGO
  is 'PLAN DE PAGOS';
alter table B_PLAN_PAGO
  add constraint PKPLAN_PAGO primary key (NUMERO_CUOTA, ID_VENTA);
alter table B_PLAN_PAGO
  add constraint R_VENTA_PAGO foreign key (ID_VENTA)
  references B_VENTAS (ID);

prompt Creating B_POSICION_ACTUAL...
create table B_POSICION_ACTUAL
(
  ID            NUMBER not null,
  COD_CATEGORIA VARCHAR2(3) not null,
  CEDULA        NUMBER(11) not null,
  ID_AREA       NUMBER(6) not null,
  FECHA_INI     DATE not null,
  FECHA_FIN     DATE
)
;
comment on table B_POSICION_ACTUAL
  is 'POSICION QUE OCUPA EL EMPLEADO';
alter table B_POSICION_ACTUAL
  add constraint PKPOSICION_ACTUAL primary key (ID);
alter table B_POSICION_ACTUAL
  add constraint R_CATEGORIA_POS foreign key (COD_CATEGORIA)
  references B_CATEGORIAS_SALARIALES (COD_CATEGORIA);
alter table B_POSICION_ACTUAL
  add constraint R_DEP_POS foreign key (ID_AREA)
  references B_AREAS (ID);
alter table B_POSICION_ACTUAL
  add constraint R_EMP_CAT foreign key (CEDULA)
  references B_EMPLEADOS (CEDULA);

prompt Loading B_AREAS...
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (1, 'Gerencia General', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', null);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (2, 'Gerencia Comercial', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 1);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (3, 'Gerencia Administrativa', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 1);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (4, 'Ventas', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 2);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (5, 'Marketing', to_date('04-09-2000', 'dd-mm-yyyy'), 'S', 2);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (6, 'Atencion al Cliente', to_date('20-06-2000', 'dd-mm-yyyy'), 'S', 4);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (7, 'Promociones', to_date('01-11-2004', 'dd-mm-yyyy'), 'S', 5);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (8, 'Innovacion', to_date('01-01-2004', 'dd-mm-yyyy'), 'S', 5);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (9, 'Ventas Mayoristas', to_date('01-01-1995', 'dd-mm-yyyy'), 'S', 4);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (10, 'Ventas de Salon', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 4);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (11, 'Tesoreria', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 3);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (12, 'Contabilidad', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 3);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (13, 'Creditos y Cobranzas', to_date('01-01-1990', 'dd-mm-yyyy'), 'S', 3);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (14, 'Servicios Generales', to_date('30-05-2009', 'dd-mm-yyyy'), 'S', 3);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (15, 'Informatica', to_date('01-01-1995', 'dd-mm-yyyy'), 'S', 3);
insert into B_AREAS (ID, NOMBRE_AREA, FECHA_CREA, ACTIVA, ID_AREA_SUPERIOR)
values (16, 'Auditoria', to_date('03-03-2012 19:25:21', 'dd-mm-yyyy hh24:mi:ss'), 'S', 3);
commit;
prompt 16 records loaded
prompt Loading B_ARTICULOS...
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (646237, 'Sarten profesional Tramontina', 'Unidad', 208182, 173485, .1, .5, 2, 1, to_date('01-05-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (725410, 'Juego de Ollas Tramontina x 5pz', 'Unidad', 499091, 415909, .1, .5, 0, 1, to_date('01-05-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (907667, 'Mantel Alba 160x270 ', 'Unidad', 108182, 90152, .1, .6, 6, 2, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (907679, 'Mantel Cadence 140x250', 'Unidad', 62727, 52273, .1, .6, 4, 6, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (801028, 'Individuales x 8Pz', 'Unidad', 9000, 7500, .1, .6, 10, 6, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (634817, 'Almohada Plumi 50x70 Altenburg', 'Unidad', 62727, 52273, .1, .6, 5, 6, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (739461, 'Juego Edredon Vacor 170x240 Altenburg', 'Unidad', 226364, 188636, .1, .6, 2, 6, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (717431, 'Juego de Sabanas Pilar Super King 2x2', 'Unidad', 180909, 150758, .1, .6, 6, 6, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (701631, 'Juego Toalla Marg. Buddemeyer ', 'Unidad', 144545, 120455, .1, .6, 6, 3, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (795299, 'Toalla Felpa Hilo Egipcio', 'Unidad', 22636, 18864, .1, .6, 10, 6, to_date('04-03-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (774449, 'Reloj de Mesa 24cm', 'Unidad', 11727, 9773, .1, .3, 10, 6, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (788993, 'Velador Rattan Redondo', 'Unidad', 271818, 226515, .1, .3, 5, 2, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (750135, 'Florero 31x15cm ', 'Unidad', 36273, 30227, .1, .3, 6, 2, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (802908, 'Adorno (Jirafa) 18x11.5x47.5cm ', 'Unidad', 117273, 97727, .1, .3, 4, 2, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (894795, 'Figura decorativa Buho', 'Unidad', 30909, 25758, .1, .3, 6, 2, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (894883, 'Porta utensilios Cheff', 'Unidad', 71818, 59848, .1, .3, 4, 2, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (791332, 'Alfombra Bali 1 x 1,5', 'Unidad', 108182, 90152, .1, .3, 6, 3, to_date('07-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (689649, 'Juego de Accesorios P/Cocina ', 'Unidad', 90000, 75000, .1, .45, 4, 2, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (721343, 'Juego de Jarra Saloma x 3', 'Unidad', 108182, 90152, .1, .5, 10, 1, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (783773, 'Plato Hondo 8''5', 'Unidad', 8091, 6742, .1, .5, 60, 12, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (783754, 'Bandeja redonda 12"', 'Unidad', 22636, 18864, .1, .5, 20, 12, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (783783, 'Plato Playo 11"', 'Unidad', 16273, 13561, .1, .5, 24, 12, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (783787, 'Taza 14 Oz', 'Unidad', 9000, 7500, .1, .5, 12, 6, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (792240, 'Asadera Acero Inox. 32x20 BRINOX', 'Unidad', 290000, 241667, .1, .5, 0, 3, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (679347, 'Vaso Bohemia 470 ml', 'Unidad', 16273, 13561, .1, .5, 0, 12, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (566179, 'Cuchara mesa Tramontina', 'Unidad', 4455, 3712, .1, .5, 124, 60, to_date('01-05-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (567052, 'Cuchillo Tramontina Asado M/M', 'Unidad', 4455, 3712, .1, .5, 38, 60, to_date('01-05-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (567053, 'Cuchara Mango De Madera 2223 ', 'Unidad', 4455, 3712, .1, .5, 145, 60, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (626021, 'Cuchara Postre Tabola 2805', 'Unidad', 4455, 3712, .1, .5, 145, 60, to_date('02-01-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (567054, 'Tenedor Mango De Madera Tramontina', 'Unidad', 5364, 4469, .1, .5, 123, 60, to_date('01-05-2011', 'dd-mm-yyyy'));
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (888999, 'Servilletas de papel', 'Unidad', 2500, 2000, .1, .1, 4, 1, null);
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (989898, 'Esquinero para bar', 'Unidad', 150000, 10000, .1, .25, 10, 2, null);
insert into B_ARTICULOS (ID, NOMBRE, UNIDAD_MEDIDA, PRECIO, COSTO, PORC_IVA, PORC_COMISION, STOCK_ACTUAL, STOCK_MINIMO, ULTIMA_COMPRA)
values (876564, 'Cristal tÈrmico para apoyar', 'Unidad', 30000, 25000, .1, .03, 20, 2, null);
commit;
prompt 33 records loaded
prompt Loading B_CATEGORIAS_SALARIALES...
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('1', 'Gerente General', 1030000, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('2', 'Gerente Comercial', 824000, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('3', 'Gerente Administrativo', 803400, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('4', 'Contador General', 515000, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('5', 'Tesorero', 309000, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('6', 'Encargado de Creditos', 257500, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('7', 'Vendedor de Salon', 206000, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('8', 'Auxiliar Contable', 154500, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('9', 'Cajero', 206000, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('10', 'Auxiliar Administrativo', 154500, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('11', 'Jefe de Salon', 257500, to_date('01-01-1990', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('35', 'Encargado de Marketing', 1236000, to_date('04-09-2000', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('45', 'Encargado de Marketing', 1545000, to_date('01-09-2002', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('55', 'Encargado de Marketing', 3605000, to_date('01-09-2005', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('21', 'Gerente General', 1339000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('31', 'Gerente General', 2060000, to_date('01-01-1996', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('53', 'Gerente General', 6180000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('67', 'Gerente General', 10300000, to_date('01-01-2005', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('32', 'Gerente Comercial', 2060000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('52', 'Gerente Comercial', 8240000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('23', 'Gerente Administrativo', 3090000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('33', 'Gerente Administrativo', 7725000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('30', 'Auxiliar Administrativo', 1545000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('29', 'Cajero', 2060000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('28', 'Auxiliar Contable', 1545000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('37', 'Vendedor de Salon', 2060000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('46', 'Encargado de Creditos', 2060000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('36', 'Tesorero', 2575000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('24', 'Contador General', 3605000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('51', 'Jefe de Salon', 2575000, to_date('01-01-1992', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('44', 'Contador General', 6695000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('15', 'Tesorero', 5665000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('26', 'Encargado de Creditos', 4120000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('27', 'Vendedor de Salon', 2060000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('49', 'Auxiliar Contable', 2575000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('48', 'Cajero', 2575000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('40', 'Auxiliar Administrativo', 2575000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('41', 'Jefe de Salon', 4635000, to_date('01-01-1999', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('65', 'Encargado de Marketing', 4635000, to_date('04-09-2000', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('60', 'Auxiliar de Atencion', 3090000, to_date('20-06-2000', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('16', 'Auxiliar de Promociones', 2060000, to_date('01-11-2004', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('17', 'Innovacion', 4120000, to_date('01-01-2004', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('34', 'Encargado de Ventas Mayoristas', 3605000, to_date('01-01-1995', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('43', 'Vendedor Mayorista', 2575000, to_date('01-01-1995', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('56', 'Vendedor de Salon', 2060000, to_date('01-01-1995', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('50', 'Aux. Servicios Grales.', 2060000, to_date('30-05-2009', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('42', 'Encargado Servicios Grales.', 3090000, to_date('30-05-2009', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('66', 'Auxiliar Informatica', 2575000, to_date('01-01-1995', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('64', 'Programador', 3605000, to_date('01-01-1998', 'dd-mm-yyyy'), null);
insert into B_CATEGORIAS_SALARIALES (COD_CATEGORIA, NOMBRE_CAT, ASIGNACION, FECHA_INI, FECHA_FIN)
values ('71', 'Encargado de Informatica', 5150000, to_date('23-10-2008', 'dd-mm-yyyy'), null);
commit;
prompt 50 records loaded
prompt Loading B_TIPO_CUENTA...
insert into B_TIPO_CUENTA (ID, NOMBRE_CATEGORIA)
values (1, 'ACTIVO');
insert into B_TIPO_CUENTA (ID, NOMBRE_CATEGORIA)
values (2, 'PASIVO');
insert into B_TIPO_CUENTA (ID, NOMBRE_CATEGORIA)
values (3, 'PATRIMONIO');
insert into B_TIPO_CUENTA (ID, NOMBRE_CATEGORIA)
values (4, 'INGRESOS');
insert into B_TIPO_CUENTA (ID, NOMBRE_CATEGORIA)
values (5, 'GASTOS');
commit;
prompt 5 records loaded
prompt Loading B_CUENTAS...
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1000000, 'ACTIVO', 1, 1, null, 'D', to_date('29-01-2012 18:27:16', 'dd-mm-yyyy hh24:mi:ss'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (2000000, 'PASIVO', 2, 1, null, 'C', to_date('29-01-2012 18:27:16', 'dd-mm-yyyy hh24:mi:ss'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3000000, 'PATRIMONIO', 3, 1, null, 'C', to_date('29-01-2012 18:27:16', 'dd-mm-yyyy hh24:mi:ss'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4000000, 'INGRESOS', 4, 1, null, 'C', to_date('29-01-2012 18:27:16', 'dd-mm-yyyy hh24:mi:ss'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5000000, 'GASTOS', 5, 1, null, 'D', to_date('29-01-2012 18:27:57', 'dd-mm-yyyy hh24:mi:ss'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1100000, 'ACTIVO CORRIENTE', 1, 2, 1000000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1110000, 'CAJA', 1, 3, 1100000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1110100, 'CAJA CHICA', 1, 4, 1110000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1120000, 'BANCOS', 1, 3, 1100000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1120100, 'Cta. Cte. 386881 Banco ITAU', 1, 4, 1120000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1120200, 'Cta.Cte. 504 Banco Nacional de Fomento', 1, 4, 1120000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1130000, 'Cuentas por cobrar CLIENTES', 1, 3, 1100000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1130100, 'Cadena Hiperseis', 1, 4, 1130000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1130200, 'Supermercado STOCK', 1, 4, 1130000, 'D', to_date('22-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1130300, 'Supermercado Gran Via', 1, 4, 1130000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1200000, 'ACTIVO FIJO', 1, 2, 1000000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1210000, 'Rodados', 1, 3, 1200000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1220000, 'Inmuebles', 1, 3, 1200000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (2100000, 'PASIVO CORRIENTE', 2, 2, 2000000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (2110000, 'CUENTAS POR PAGAR', 2, 3, 2100000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (2110100, 'PROVEEDORES', 2, 4, 2110000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (2110101, 'Proveeduria General BR Ltda', 2, 5, 2110100, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (2110200, 'APORTE PATRONAL', 2, 4, 2110000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3100000, 'PATRIMONIO NETO', 3, 2, 3000000, 'C', to_date('22-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3110000, 'CAPITAL SUSCRIPTO', 3, 3, 3100000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3120000, 'RESERVAS', 3, 3, 3100000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3120100, 'RESERVA LEGAL', 3, 4, 3120000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3130000, 'UTILIDADES O PERDIDAS ACUM.', 3, 3, 3100000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3130100, 'UTILIDADES O PERDIDAS DEL EJERC.', 3, 4, 3130000, 'C', to_date('22-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (3130200, 'UTILIDADES O PERDIDAS DEL EJERC. ANT.', 3, 4, 3130000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4100000, 'INGRESOS OPERACIONALES', 4, 2, 4000000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4110000, 'VENTAS GRAVADAS CON IVA', 4, 3, 4100000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4110100, 'VENTAS DE MERCADERIAS', 4, 4, 4110000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4110200, 'VENTA DE SERVICIOS', 4, 4, 4110000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4120000, 'OTROS INGRESOS', 4, 3, 4100000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4120100, 'INTERESES GANADOS', 4, 4, 4120000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (4120200, 'UTILIDAD EN VENTA DE ACTIVOS ', 4, 4, 4120000, 'C', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5100000, 'COSTO DE VENTAS', 5, 2, 5000000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5110000, 'COMPRA DE MERCADERIAS', 5, 3, 5100000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5120000, 'COSTOS EMBALAJE Y TRANSPORTE', 5, 3, 5100000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5200000, 'SERVICIOS BASICOS', 5, 2, 5000000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5210000, 'AGUA', 5, 3, 5200000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5220000, 'LUZ ', 5, 3, 5200000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5230000, 'TELEFONIA FIJA Y MOVIL', 5, 3, 5200000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5300000, 'GASTOS NO OPERACIONALES', 5, 2, 5000000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (5310000, 'PERDIDA EN ACTIVOS FIJOS', 5, 3, 5300000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1300000, 'INVENTARIO MERCADERIAS', 1, 2, 1000000, 'D', to_date('22-01-2012', 'dd-mm-yyyy'), 'N');
insert into B_CUENTAS (CODIGO_CTA, NOMBRE_CTA, ID_TIPO, NIVEL, CTA_SUPERIOR, ORDEN, FECHA_APERTURA, IMPUTABLE)
values (1310000, 'MERCADERIAS', 1, 3, 1300000, 'D', to_date('29-01-2012', 'dd-mm-yyyy'), 'S');
commit;
prompt 48 records loaded
prompt Loading B_LOCALIDAD...
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Capiata', 1, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Altos', 2, 3);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Aregua', 3, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Caacupe', 4, 3);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Caaguazu', 5, 5);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Caazapa', 6, 6);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Coronel Oviedo', 7, 5);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Emboscada', 8, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Encarnacion', 9, 7);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Fernando de la Mora', 10, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Filadelfia', 11, 14);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Asuncion', 13, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Guarambare', 12, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Limpio', 15, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Lambare', 14, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Itaugua', 16, 4);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('—emby', 17, 12);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Paraguari', 18, 9);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Piribebuy', 19, 12);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Pilar', 20, 12);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('San Lorenzo', 21, 11);
insert into B_LOCALIDAD (NOMBRE, ID, ID_GOBERNACION)
values ('Luque', 22, 11);
commit;
prompt 22 records loaded
prompt Loading B_PERSONAS...
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (1, 'F', 'Jorge Amado', 'Pereira Gonzalez', 'Dr. Molinas c/ Juan de Salazar', '021601382', null, '429987', 'jpereira@hotmail.com', 'S', 'N', to_date('10-01-1980', 'dd-mm-yyyy'), 6, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (2, 'F', 'Roberto', 'Abente Gomez', 'Juan B. Gill e/ J.G Benitez', '021558676', null, '1207876', 'rag939@live.com', 'S', 'N', to_date('30-10-1967', 'dd-mm-yyyy'), 20, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (3, 'J', 'Avente Comercial', null, 'Aviadores del Chaco Local 153', '0984239887', '80003943-2', null, 'avente_comercial@acsa.com.py', 'S', 'N', to_date('20-01-1970', 'dd-mm-yyyy'), 1, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (4, 'J', 'EARG S.A.', null, 'Cap.Lombardo c/Via Ferrea', '021294058', '864892-4', null, 'eargsa@tigo.net.py', 'S', 'N', to_date('05-05-1976', 'dd-mm-yyyy'), 13, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (5, 'F', 'Alfonso', 'Brizuela Cuevas', 'Boqueron 153 c/Felix P. Cardozo', '021494930', '702098-8', null, 'alfons_briz@hotmail.com', 'S', 'N', to_date('03-01-1958', 'dd-mm-yyyy'), 12, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (6, 'J', 'Cristhian', 'Achucarro', 'Andres Barbero e/Soldado Ovelar', '0971120998', '2281987-9', '2281987', 'crisach81@gmail.com', 'S', 'N', to_date('01-01-1970', 'dd-mm-yyyy'), 12, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (7, 'J', 'Amalgama S.A.', null, 'Pacheco N∫ 4235 c/ Choferes del Chaco', '021607750', '80023399-4', null, 'ventas@amalgama.com.py', 'N', 'S', to_date('01-06-1960', 'dd-mm-yyyy'), 12, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (8, 'J', 'Atlantic S.A.E.C.A.', null, 'Av. R.I. 18 Pitiantuta y Rivarola Matto', '021520670', '80098743-2', null, 'info@atlantic.com.py', 'N', 'S', to_date('10-09-2001', 'dd-mm-yyyy'), 12, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (9, 'J', 'Cima S.R.L.', null, 'Av. Zavala y Andres Barbero', '021510558', '80023356-3', null, 'climasrl@yahoo.com', 'N', 'S', to_date('10-01-2012', 'dd-mm-yyyy'), 21, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (10, 'F', 'Reina', 'Rios', 'Ruta San Lorenzo a Luque', '021649580', '310098-1', '310098', 'rr1949@gmail.com', 'N', 'S', to_date('07-03-1978', 'dd-mm-yyyy'), 22, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (11, 'J', 'Emac S.R.L.', null, 'Mcal. Estigarribia 999 c/ Curupayty', '071203043', '80024874-6', null, 'emac@emac.com.py', 'N', 'S', to_date('07-03-1997', 'dd-mm-yyyy'), 9, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (12, 'F', 'Roque', 'Talavera', 'Inocencio Lezcano N∫ 1338', '021229292', '1298876-0', '1298876', 'roque@rieder.net', 'S', 'N', to_date('10-01-1975', 'dd-mm-yyyy'), 10, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (13, 'J', 'Sanimax', null, 'Ruta Mcal. Estigarribia 2605', '02833092', '80026499-3', null, 'sanimax@hotmail.com', 'S', 'N', to_date('04-05-1998', 'dd-mm-yyyy'), 1, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (14, 'F', 'Ramon', 'Gauto', 'Pte.Franco y Montevideo', '021446097', '2209982-9', '2209982', 'ramongauto_construcciones@gmail.com', 'S', 'N', to_date('01-06-1990', 'dd-mm-yyyy'), 14, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (15, 'J', 'Servimex', null, 'Felix Bogado  2435', '021311282', '80098773-3', null, 'info@servimex.com', 'N', 'S', to_date('09-09-1970', 'dd-mm-yyyy'), 14, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (16, 'J', 'Libreria y Papeleria NOVA', null, 'Gral. Diaz c/ 15 de Agosto', '021448877', '80027649-5', null, 'nova.libreria@gmail.com', 'N', 'S', to_date('07-09-1989', 'dd-mm-yyyy'), 13, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (17, 'J', 'Estaciones de Servicio ZUZA', null, 'Avda. Eusebio Ayala c/ Cedro', '021550987', '80087699-1', null, 'ventas@zuza.com.py', 'N', 'S', to_date('07-09-2000', 'dd-mm-yyyy'), 13, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (18, 'J', 'Lubricantes Paraguayos S.A.', null, 'Sgto. Nicasio Villalba 1987', '021680262', '80054681-6', null, 'lubripar@lubri.com.py', 'N', 'S', to_date('05-06-1999', 'dd-mm-yyyy'), 10, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (19, 'F', 'Juan I.', 'Reyez S.', 'Ayolas Esq.Pte.Franco N∞1298', '0985339287', '1984562-1', '1984562', 'jirs_com@yahoo.com', 'N', 'S', to_date('02-02-1987', 'dd-mm-yyyy'), 7, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (20, 'J', 'AdministraciÛn Nacional de Electricidad', '(ANDE)', 'EspaÒa 1268  c/ Padre Cardozo', '021200987', '800615765', null, 'reclamos@ande.gov.py', 'N', 'S', to_date('16-07-1996', 'dd-mm-yyyy'), 13, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (21, 'J', 'Empresa de Servicios Sanitarios del Py', '(ESAP)', 'Jose Berges 516 c/ Saturio Rios', '021220596', '80098755-4', null, 'info@esap.gov.py', 'N', 'S', to_date('15-04-1990', 'dd-mm-yyyy'), 13, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (22, 'J', 'CompaÒia de Comunicaciones del Paraguay', '(COPACO)', 'Gral. Diaz N∞ 446', '021440400', '800654876-1', null, 'atc@copaco.gov.py', 'N', 'S', to_date('15-02-1959', 'dd-mm-yyyy'), 13, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (23, 'F', 'Bienvenido', 'Alfonso Santos', 'Yacyreta c/ Gral. Diaz', '0521204123', '334654-4', '334654', 'bienvenido.alfonso@', 'S', 'N', to_date('07-06-1970', 'dd-mm-yyyy'), 7, null);
insert into B_PERSONAS (ID, TIPO_PERSONA, NOMBRE, APELLIDO, DIRECCION, TELEFONO, RUC, CEDULA, CORREO_ELECTRONICO, ES_CLIENTE, ES_PROVEEDOR, FECHA_NACIMIENTO, ID_LOCALIDAD, CODIGO_CTA)
values (99, 'F', 'Mario Luis', 'Martinez', 'Felix Bogado y 4ta.', '02302991', '883393-2', '883393', 'mario@hotmail.com', 'S', 'N', to_date('01-03-1990', 'dd-mm-yyyy'), null, null);
commit;
prompt 24 records loaded
prompt Loading B_COMPRAS...
insert into B_COMPRAS (ID_PROVEEDOR, MONTO_TOTAL, FECHA, ID_CONDICION, ID)
values (8, 8758598, to_date('01-05-2018', 'dd-mm-yyyy'), 2, 1);
insert into B_COMPRAS (ID_PROVEEDOR, MONTO_TOTAL, FECHA, ID_CONDICION, ID)
values (9, 10088669, to_date('04-03-2018', 'dd-mm-yyyy'), 2, 2);
insert into B_COMPRAS (ID_PROVEEDOR, MONTO_TOTAL, FECHA, ID_CONDICION, ID)
values (7, 8219974, to_date('02-01-2018', 'dd-mm-yyyy'), 2, 3);
insert into B_COMPRAS (ID_PROVEEDOR, MONTO_TOTAL, FECHA, ID_CONDICION, ID)
values (8, 8137427, to_date('07-01-2018', 'dd-mm-yyyy'), 2, 4);
commit;
prompt 4 records loaded
prompt Loading B_DETALLE_COMPRAS...
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (646237, 12, 173485, 1);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (725410, 13, 415909, 1);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (566179, 134, 3712, 1);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (567052, 48, 3712, 1);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (567054, 133, 4469, 1);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (907667, 16, 90152, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (907679, 14, 52273, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (801028, 20, 7500, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (634817, 15, 52273, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (739461, 12, 188636, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (717431, 16, 150758, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (701631, 16, 120455, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (795299, 20, 18864, 2);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (567053, 155, 3712, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (626021, 155, 3712, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (679347, 10, 13561, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (689649, 14, 75000, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (721343, 20, 90152, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (783754, 30, 18864, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (783773, 70, 6742, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (783783, 34, 13561, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (783787, 22, 7500, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (792240, 10, 241667, 3);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (774449, 20, 9773, 4);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (788993, 15, 226515, 4);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (750135, 16, 30227, 4);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (802908, 14, 97727, 4);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (894795, 16, 25758, 4);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (894883, 14, 59848, 4);
insert into B_DETALLE_COMPRAS (ID_ARTICULO, CANTIDAD, PRECIO_COMPRA, ID_COMPRA)
values (791332, 16, 90152, 4);
commit;
prompt 30 records loaded
prompt Loading B_EMPLEADOS...
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1607843, 'Olaf', 'Brandenstein', to_date('01-01-2000', 'dd-mm-yyyy'), to_date('05-10-1960', 'dd-mm-yyyy'), null, '021601210', 'Justo Roman 612 e/Cap. Maciel y Sgto. Marecos', 'Carmelitas', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (952160, 'Jose', 'Caniza Livieres', to_date('01-01-1990', 'dd-mm-yyyy'), to_date('23-01-1955', 'dd-mm-yyyy'), 1607843, '21200848', 'Juan de Salazar 638', 'Jara', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1098169, 'Carmen', 'Ferreira', to_date('04-09-2000', 'dd-mm-yyyy'), to_date('04-12-1975', 'dd-mm-yyyy'), 952160, '021227066', 'Teodoro S. Mongelos N∫. 271', 'Seminario', 2);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1309873, 'Martin', 'Moreno', to_date('20-06-2000', 'dd-mm-yyyy'), to_date('30-04-1980', 'dd-mm-yyyy'), 952160, '021214688', 'Av. Peru N∫ 1044 esq. Romulo Rios', 'Ciudad Nueva', 7);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2207185, 'Gustavo', 'Olmedo', to_date('01-11-2004', 'dd-mm-yyyy'), to_date('20-02-1978', 'dd-mm-yyyy'), 1309873, '021200284', 'Avda. EspaÒa, esq. Avda. Peru', 'Boqueron', 2);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2149060, 'Fernanda Maria', 'Zacarias', to_date('01-01-2004', 'dd-mm-yyyy'), to_date('22-11-1980', 'dd-mm-yyyy'), 1309873, '021490608', 'Buongermini 1174', 'San Antonio', 17);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (3008180, 'Eva', 'Gonzalez', to_date('01-01-1995', 'dd-mm-yyyy'), to_date('01-07-1970', 'dd-mm-yyyy'), 952160, '021497225', 'Milan 1763', 'Sajonia', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2981474, 'Amanda', 'Perez', to_date('01-01-2000', 'dd-mm-yyyy'), to_date('03-01-1980', 'dd-mm-yyyy'), 3008180, '028211536', 'Juan Manuel Frutos Pane 397', 'Capiata', 1);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2608701, 'Ricardo', 'Meza', to_date('23-06-2004', 'dd-mm-yyyy'), to_date('03-05-1983', 'dd-mm-yyyy'), 3008180, '0982202486', 'Federacion Rusa 1249 c/ San Benigno', 'Las Lomas', null);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (3212543, 'Ruben', 'Aguayo', to_date('12-02-2011', 'dd-mm-yyyy'), to_date('03-05-1990', 'dd-mm-yyyy'), 3008180, '0971225202', 'Estados Unidos 182', 'San Roque', 21);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (800909, 'Carmelo', 'Caballero', to_date('01-01-1990', 'dd-mm-yyyy'), to_date('02-07-1959', 'dd-mm-yyyy'), 952160, '021661964', 'Santa Ana 1180', 'Manora', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1825679, 'Sandra', 'Ocampos', to_date('01-01-1990', 'dd-mm-yyyy'), to_date('25-03-1963', 'dd-mm-yyyy'), 1098169, '021200948', 'Mcal. Estigarribia 1240 c/Constitucion', 'San Roque', 21);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (4099480, 'Gloria', 'Mendoza', to_date('30-04-2010', 'dd-mm-yyyy'), to_date('30-03-1987', 'dd-mm-yyyy'), 1098169, '021201607', 'Tte. FariÒa 1076 e/ EE.UU y Brasil', 'Gral. Diaz', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2998388, 'Edgar', 'Aguilera', to_date('01-02-2012', 'dd-mm-yyyy'), to_date('02-09-1986', 'dd-mm-yyyy'), 1098169, '021208218', 'Rio de Janeiro y Rosa Peralta', 'Mcal. Lopez', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (4433245, 'Hugo', 'Adorno', to_date('24-08-2007', 'dd-mm-yyyy'), to_date('01-10-1988', 'dd-mm-yyyy'), 1098169, '096165433', 'Jose F. Bogado y 22 Pydas', 'Obrero', null);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1333394, 'Jose', 'Balmaceda', to_date('01-01-2012', 'dd-mm-yyyy'), to_date('07-07-1976', 'dd-mm-yyyy'), 952160, '021207374', 'Rio de Janeiro 598 c/ San Jose', 'Centro', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2204219, 'Sebastian', 'Benitez', to_date('01-03-2011', 'dd-mm-yyyy'), to_date('07-01-1979', 'dd-mm-yyyy'), 1607843, '0972208218', 'Mayor Bullo 315 c/ Mcal. Estigarribia', 'San Roque', 21);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1372876, 'Marta', 'Franco de Nu√±ez', to_date('06-05-2006', 'dd-mm-yyyy'), to_date('23-08-1974', 'dd-mm-yyyy'), 2204219, '021570105', 'Lomas Valentinas 715', 'San Lorenzo', 21);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1621456, 'Sun Jin', 'Lee', to_date('07-06-2006', 'dd-mm-yyyy'), to_date('06-05-1978', 'dd-mm-yyyy'), 2204219, '021227522', 'Mary Lions 130 c/ Mcal. Lopez', 'Ciudad Nueva', 7);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (983287, 'Felicia', 'Da Rosa', to_date('04-01-2008', 'dd-mm-yyyy'), to_date('21-04-1966', 'dd-mm-yyyy'), 2204219, '0961939043', 'Brasil 165 e/Mcal. Lopez y Jose Berges', 'Mcal. Lopez', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1493022, 'Maria Victoria', 'Romero', to_date('07-02-2005', 'dd-mm-yyyy'), to_date('05-01-1979', 'dd-mm-yyyy'), 983287, '021493209', 'Pai≠Perez 448 e/Cerro Cora y 25 de Mayo', 'Petirossi', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1234440, 'Fabiola', 'Ca√±ete', to_date('06-01-2003', 'dd-mm-yyyy'), to_date('24-09-1980', 'dd-mm-yyyy'), 1098169, '0982893993', 'Libertad 977 c/ Brasilia', 'Las Mercedes', 15);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (3009309, 'Jorge', 'Medina', to_date('25-09-2007', 'dd-mm-yyyy'), to_date('10-01-1987', 'dd-mm-yyyy'), 983287, '0961692909', 'Bernardino Caballero 282', 'Limpio', 15);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1998898, 'Juan', 'Villalba', to_date('01-02-2010', 'dd-mm-yyyy'), to_date('10-01-1980', 'dd-mm-yyyy'), 1621456, '0212009301', 'Peru N∫ 749 c/ Defensa Nacional', 'Ciudad Nueva', 7);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (3387765, 'Gilda', 'Esquivel', to_date('01-03-2011', 'dd-mm-yyyy'), to_date('12-12-1988', 'dd-mm-yyyy'), 1621456, '021982839', 'Dr. J. Eulogio Estigarribia 4515 e/ Saravi', 'Recoleta', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2988665, 'Roberto Jesus', 'Benitez Franco', to_date('01-11-2011', 'dd-mm-yyyy'), to_date('05-12-1981', 'dd-mm-yyyy'), 1372876, '021300314', '24 de Mayo 2543 c/ Esperanza', 'Lambare', 14);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (2103209, 'Cinthia', 'Diaz Galeano', to_date('23-01-2009', 'dd-mm-yyyy'), to_date('01-07-1982', 'dd-mm-yyyy'), 1372876, '028299091', 'Ruta 2 km 22', 'Capiata', 1);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (1008277, 'Ronald', 'O¥Higgins', to_date('05-06-2005', 'dd-mm-yyyy'), to_date('30-06-1980', 'dd-mm-yyyy'), 1372876, '021558886', 'Julia Miranda Cueto 1730 c/ Ytororo', 'San Lorenzo', 21);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (123566, 'Marcio', 'Balmaceda', to_date('03-03-2012 19:46:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('04-02-1970', 'dd-mm-yyyy'), 952160, '021207374', 'Rio de Janeiro 598 c/ San Jose', 'Centro', 13);
insert into B_EMPLEADOS (CEDULA, NOMBRE, APELLIDO, FECHA_ING, FECHA_NACIM, CEDULA_JEFE, TELEFONO, DIRECCION, BARRIO, ID_LOCALIDAD)
values (444765, 'Javier Luis', 'Mieres', to_date('18-03-2012 11:46:33', 'dd-mm-yyyy hh24:mi:ss'), to_date('09-01-1980', 'dd-mm-yyyy'), 1607843, '021449332', 'Iturbe y 4ta.', 'Microcentro', 13);
commit;
prompt 30 records loaded
prompt Loading B_VENTAS...
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (1, 1, to_date('02-01-2018', 'dd-mm-yyyy'), 7215470, 60, 'CR', 2, 1493022);
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (2, 2, to_date('15-02-2018', 'dd-mm-yyyy'), 8260000, 90, 'CR', 3, 3009309);
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (3, 3, to_date('22-05-2018', 'dd-mm-yyyy'), 2370910, 1, 'CO', 2, 3009309);
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (4, 4, to_date('22-07-2018', 'dd-mm-yyyy'), 3233640, 60, 'CR', 5, 1493022);
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (5, 5, to_date('17-08-2018', 'dd-mm-yyyy'), 3198180, 90, 'CR', 6, 1234440);
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (6, 6, to_date('02-08-2018', 'dd-mm-yyyy'), 4779090, 1, 'CO', 2, 1998898);
insert into B_VENTAS (ID, NUMERO_FACTURA, FECHA, MONTO_TOTAL, PLAZO, TIPO_VENTA, ID_CLIENTE, CEDULA_VENDEDOR)
values (7, 2334, to_date('18-03-2019', 'dd-mm-yyyy hh24:mi:ss'), 300000, 30, 'CR', 5, 1998898);
commit;
prompt 7 records loaded
prompt Loading B_DETALLE_VENTAS...
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (1, 646237, 10, '1', 208182);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (1, 725410, 10, '2', 499091);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (1, 566179, 10, '3', 4455);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (1, 567052, 10, '4', 4455);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (1, 567054, 10, '5', 5364);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 907667, 10, '1', 108182);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 907679, 10, '2', 62727);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 801028, 10, '3', 9000);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 634817, 10, '4', 62727);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 739461, 10, '5', 226364);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 717431, 10, '6', 180909);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 701631, 10, '7', 144545);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 795299, 10, '8', 22636);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 567053, 10, '9', 4455);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (2, 626021, 10, '10', 4455);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (3, 679347, 10, '1', 16273);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (3, 689649, 10, '2', 90000);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (3, 721343, 10, '3', 108182);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (3, 783754, 10, '4', 22636);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (4, 783773, 10, '1', 8091);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (4, 783783, 10, '2', 16273);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (4, 783787, 10, '3', 9000);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (4, 792240, 10, '4', 290000);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (5, 774449, 10, '1', 11727);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (5, 788993, 10, '2', 271818);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (5, 750135, 10, '3', 36273);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (6, 802908, 10, '1', 117273);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (6, 894795, 10, '2', 30909);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (6, 894883, 10, '3', 71818);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (6, 791332, 10, '4', 108182);
insert into B_DETALLE_VENTAS (ID_VENTA, ID_ARTICULO, CANTIDAD, NUMERO_ITEM, PRECIO)
values (6, 725410, 3, '5', 499090);
commit;
prompt 31 records loaded
prompt Loading B_DIARIO_CABECERA...
insert into B_DIARIO_CABECERA (ID, FECHA, CONCEPTO, USUARIO, FECHA_CIERRE, ID_AREA)
values (1, to_date('03-01-2019', 'dd-mm-yyyy'), 'APORTE DE CAPITAL INICIAL', 'CMARTINEZ', to_date('18-02-2012 17:15:34', 'dd-mm-yyyy hh24:mi:ss'), 3);
insert into B_DIARIO_CABECERA (ID, FECHA, CONCEPTO, USUARIO, FECHA_CIERRE, ID_AREA)
values (2, to_date('02-02-2019', 'dd-mm-yyyy'), 'COMPRA DE MERCADERIAS', 'CMARTINEZ', to_date('18-02-2012 17:15:34', 'dd-mm-yyyy hh24:mi:ss'), 3);
insert into B_DIARIO_CABECERA (ID, FECHA, CONCEPTO, USUARIO, FECHA_CIERRE, ID_AREA)
values (3, to_date('06-02-2019', 'dd-mm-yyyy'), 'VENTA DE MATERIALES', 'CMARTINEZ', to_date('18-02-2012 17:15:34', 'dd-mm-yyyy hh24:mi:ss'), 3);
insert into B_DIARIO_CABECERA (ID, FECHA, CONCEPTO, USUARIO, FECHA_CIERRE, ID_AREA)
values (4, to_date('06-02-2019', 'dd-mm-yyyy'), 'VENTA DE MATERIALES A CREDITO', 'CMARTINEZ', to_date('18-02-2012 17:15:34', 'dd-mm-yyyy hh24:mi:ss'), 3);
insert into B_DIARIO_CABECERA (ID, FECHA, CONCEPTO, USUARIO, FECHA_CIERRE, ID_AREA)
values (5, to_date('14-02-2019', 'dd-mm-yyyy'), 'PAGO DE SERVICIOS ', 'BASICOS', to_date('18-02-2012 17:15:34', 'dd-mm-yyyy hh24:mi:ss'), 3);
insert into B_DIARIO_CABECERA (ID, FECHA, CONCEPTO, USUARIO, FECHA_CIERRE, ID_AREA)
values (6, to_date('05-03-2019', 'dd-mm-yyyy'), 'PAGO DE SERVICIOS', 'CMARTINEZ', to_date('20-05-2012 10:36:57', 'dd-mm-yyyy hh24:mi:ss'), 3);
commit;
prompt 6 records loaded
prompt Loading B_DIARIO_DETALLE...
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (1, 1120200, 'D', 200000000, 1);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (1, 3110000, 'C', 200000000, 2);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (2, 1310000, 'D', 10000000, 1);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (2, 1120200, 'C', 10000000, 2);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (3, 1110100, 'D', 3000000, 1);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (3, 5110000, 'D', 2300000, 2);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (4, 5110000, 'D', 2300000, 2);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (3, 1310000, 'C', 2300000, 3);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (3, 4110100, 'C', 3000000, 4);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (4, 1130200, 'D', 3000000, 1);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (4, 4110100, 'C', 3000000, 3);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (4, 1310000, 'C', 2300000, 4);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (5, 5230000, 'D', 1300000, 1);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (5, 1120200, 'C', 1300000, 2);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (6, 5220000, 'D', 1200000, 1);
insert into B_DIARIO_DETALLE (ID, CODIGO_CTA, DEBE_HABER, IMPORTE, NRO_LINEA)
values (6, 1120200, 'C', 1200000, 2);
commit;
prompt 16 records loaded
prompt Loading B_LIQUIDACION...
insert into B_LIQUIDACION (FECHA_LIQUIDACION, ANIO, MES, ID)
values (to_date('01-04-2019 19:23:45', 'dd-mm-yyyy hh24:mi:ss'), 2011, 8, 1);
commit;
prompt 1 records loaded
prompt Loading B_MAYOR...
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (26, 5220000, 2019, 3, 1200000, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (1, 1110100, 2019, 2, 3000000, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (2, 1120100, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (3, 1120200, 2019, 2, 0, 11300000);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (4, 1130100, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (5, 1130200, 2019, 2, 3000000, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (6, 1130300, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (7, 1210000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (8, 1220000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (9, 2110101, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (10, 2110200, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (11, 3110000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (12, 3120100, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (13, 3130100, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (14, 3130200, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (15, 4110100, 2019, 2, 0, 6000000);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (16, 4110200, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (17, 4120100, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (18, 4120200, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (19, 5110000, 2019, 2, 4600000, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (20, 5120000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (21, 5210000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (22, 5220000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (23, 5230000, 2019, 2, 1300000, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (24, 5310000, 2019, 2, 0, 0);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (25, 1310000, 2019, 2, 10000000, 4600000);
insert into B_MAYOR (ID_MAYOR, CODIGO_CTA, ANIO, MES, ACUM_DEBITO, ACUM_CREDITO)
values (27, 1120200, 2019, 3, 0, 1200000);
commit;
prompt 27 records loaded
prompt Loading B_PLANILLA...
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1607843, 10300000, 927000, 0, 9373000);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2204219, 8240000, 741600, 0, 7498400);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 952160, 7725000, 695250, 0, 7029750);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1372876, 3605000, 324450, 0, 3280550);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1621456, 3605000, 324450, 0, 3280550);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 983287, 4635000, 417150, 0, 4217850);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1493022, 2060000, 185400, 0, 1874600);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1234440, 2060000, 185400, 959454, 2834054);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 3009309, 2060000, 185400, 0, 1874600);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 3387765, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1998898, 2575000, 231750, 984546, 3327796);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2988665, 2060000, 185400, 0, 1874600);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2103209, 3090000, 278100, 0, 2811900);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1008277, 4120000, 370800, 0, 3749200);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 3008180, 5150000, 463500, 0, 4686500);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 800909, 4120000, 370800, 0, 3749200);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1333394, 3090000, 278100, 0, 2811900);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1309873, 5665000, 509850, 0, 5155150);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2981474, 3605000, 324450, 0, 3280550);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 3212543, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 4433245, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2998388, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 4099480, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 1825679, 3090000, 278100, 0, 2811900);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2207185, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2149060, 2575000, 231750, 0, 2343250);
insert into B_PLANILLA (ID_LIQUIDACION, CEDULA, SALARIO_BASICO, DESCUENTO_IPS, BONIFICACION_X_VENTAS, LIQUIDO_COBRADO)
values (1, 2608701, 3605000, 324450, 0, 3280550);
commit;
prompt 27 records loaded
prompt Loading B_PLAN_PAGO...
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (2, 2, 2891000, to_date('16-04-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (2, 3, 2891000, to_date('16-05-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (5, 1, 1119363, to_date('16-09-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (1, 1, 3715967, to_date('01-02-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (1, 2, 3715967, to_date('03-03-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (2, 1, 2891000, to_date('17-03-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (5, 2, 1119363, to_date('16-10-2018', 'dd-mm-yyyy'), null);
insert into B_PLAN_PAGO (ID_VENTA, NUMERO_CUOTA, MONTO_CUOTA, VENCIMIENTO, FECHA_PAGO)
values (5, 3, 1119363, to_date('15-11-2018', 'dd-mm-yyyy'), null);
commit;
prompt 8 records loaded
prompt Loading B_POSICION_ACTUAL...
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (1, '67', 1607843, 1, to_date('01-01-2009', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (2, '52', 2204219, 2, to_date('04-01-2006', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (3, '33', 952160, 3, to_date('09-06-2007', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (4, '55', 1372876, 5, to_date('01-12-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (5, '34', 1621456, 9, to_date('01-06-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (6, '41', 983287, 4, to_date('03-04-2004', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (7, '56', 1493022, 4, to_date('01-04-2011', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (8, '56', 1234440, 4, to_date('02-01-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (9, '56', 3009309, 4, to_date('03-07-2009', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (10, '43', 3387765, 4, to_date('01-06-2011', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (11, '43', 1998898, 4, to_date('01-06-2011', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (12, '16', 2988665, 5, to_date('01-11-2011', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (13, '60', 2103209, 5, to_date('23-01-2009', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (14, '17', 1008277, 5, to_date('05-06-2005', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (15, '71', 3008180, 15, to_date('01-01-2009', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (16, '26', 800909, 13, to_date('01-01-2011', 'dd-mm-yyyy'), to_date('19-05-2012', 'dd-mm-yyyy'));
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (18, '42', 1333394, 14, to_date('01-10-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (19, '15', 1309873, 11, to_date('01-01-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (20, '64', 2981474, 15, to_date('01-10-2008', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (21, '66', 2608701, 15, to_date('01-09-2011', 'dd-mm-yyyy'), to_date('04-03-2012 16:56:07', 'dd-mm-yyyy hh24:mi:ss'));
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (22, '66', 3212543, 15, to_date('21-05-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (23, '49', 4433245, 12, to_date('01-09-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (24, '49', 2998388, 12, to_date('01-05-2011', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (25, '40', 4099480, 12, to_date('01-06-2008', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (26, '42', 1825679, 12, to_date('01-01-2010', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (27, '48', 2207185, 11, to_date('01-01-2009', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (28, '48', 2149060, 11, to_date('01-01-2011', 'dd-mm-yyyy'), null);
insert into B_POSICION_ACTUAL (ID, COD_CATEGORIA, CEDULA, ID_AREA, FECHA_INI, FECHA_FIN)
values (29, '64', 2608701, 15, to_date('04-03-2012 17:00:11', 'dd-mm-yyyy hh24:mi:ss'), null);
commit;
prompt 28 records loaded
set feedback on
set define on
prompt Done.
