-- Comentario para la tabla CARRERAS
COMMENT ON TABLE CARRERAS IS 'Tabla de carreras';

-- Comentarios para las columnas de la tabla CARRERAS
COMMENT ON COLUMN CARRERAS.ID_CARRERA IS 'Identificador único de la carrera.';
COMMENT ON COLUMN CARRERAS.NOMBRE_CARRERA IS 'Nombre de la carrera.';
COMMENT ON COLUMN CARRERAS.TOTAL_HORAS IS 'Total de horas requeridas para la carrera.';
COMMENT ON COLUMN CARRERAS.TITULO_HABILITANTE IS 'Título habilitante otorgado al estudiante.';
COMMENT ON COLUMN CARRERAS.FECHA_HABILITACION IS 'Fecha en que se habilita la carrera.';
COMMENT ON COLUMN CARRERAS.FECHA_CANCELACION IS 'Fecha en que se cancela eventualmente la carrera.';
COMMENT ON COLUMN CARRERAS.TOTAL_CREDITOS IS 'Total de créditos para la carrera.';
