DROP TABLE IF EXISTS EQUIPO CASCADE;
DROP TABLE IF EXISTS INSTALACION_FRIGORIFICA CASCADE;
DROP TABLE IF EXISTS PERSONA CASCADE;
DROP TABLE IF EXISTS CLIENTE CASCADE;
DROP TABLE IF EXISTS TECNICO CASCADE;
DROP TABLE IF EXISTS REVISION CASCADE;
DROP TABLE IF EXISTS TIPO_REVISION CASCADE;
DROP TABLE IF EXISTS LINEA_REVISION CASCADE;
DROP DOMAIN IF EXISTS tipo_equipo;
DROP DOMAIN IF EXISTS tipo_res_revision;


CREATE TABLE PERSONA(
	dni character varying(9) NOT NULL,
	nombre_apellidos character varying(80) NOT NULL,
	tlf int,
	email character varying(50),
	CONSTRAINT cp_id_persona PRIMARY KEY (dni)
);

CREATE TABLE CLIENTE(
	dni character varying(9) NOT NULL,
	nombre_empresa character varying(30),
	direccion_empresa character varying(30),
	CONSTRAINT cp_id_cliente PRIMARY KEY (dni),
	CONSTRAINT caj_persona FOREIGN KEY (dni)
	REFERENCES PERSONA(dni)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE TECNICO(
	dni character varying(9) NOT NULL,
	rango character varying(30),
	fecha_incorporacion date,
	CONSTRAINT cp_id_tecnico PRIMARY KEY (dni),
	CONSTRAINT caj_persona FOREIGN KEY (dni)
	REFERENCES PERSONA(dni)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE INSTALACION_FRIGORIFICA(
	id_instalacion serial NOT NULL,
	nombre character varying(40) NOT NULL,
	dni_duenyo character varying(9) NOT NULL,
	direccion character varying(30) NOT NULL,
	CONSTRAINT cp_numero_reg PRIMARY KEY (id_instalacion),
	CONSTRAINT caj_duenyo FOREIGN KEY (dni_duenyo)
	REFERENCES CLIENTE(dni)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE DOMAIN tipo_equipo AS character varying(30)
CHECK(
	VALUE IN('compresor','evaporador','condensador')
);

CREATE TABLE EQUIPO(
	id_equipo serial NOT NULL,
	marca_modelo character varying(20) NOT NULL,
	tipo tipo_equipo NOT NULL,
	id_instalacion int NOT NULL,
	CONSTRAINT cp_id_equipo PRIMARY KEY(id_equipo),
	CONSTRAINT caj_instalacion FOREIGN KEY (id_instalacion)
	REFERENCES INSTALACION_FRIGORIFICA(id_instalacion)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE REVISION(
	id_revision serial NOT NULL,
	fecha date DEFAULT NOW(),
	id_instalacion int NOT NULL,
	validacion boolean NOT NULL DEFAULT FALSE, 
	dni_tecnico character varying(20) NOT NULL,
	CONSTRAINT cp_id_revision PRIMARY KEY (id_revision),
	
	CONSTRAINT caj_instalacion FOREIGN KEY (id_instalacion)
	REFERENCES INSTALACION_FRIGORIFICA(id_instalacion)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	
	CONSTRAINT caj_tecnico FOREIGN KEY (dni_tecnico)
	REFERENCES TECNICO(dni)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
);

CREATE TABLE TIPO_REVISION(
	id_tipo_revision serial NOT NULL,
	explicacion character varying(200) NOT NULL,
	CONSTRAINT cp_id_tipo_revision PRIMARY KEY (id_tipo_revision)
);

CREATE DOMAIN tipo_res_revision AS character varying(30)
CHECK(
	VALUE IN('no revisado','correcto','incorrecto','no aplica')
);

CREATE TABLE LINEA_REVISION(
	id_tipo_revision int NOT NULL,
	id_revision int NOT NULL,
	resultado tipo_res_revision NOT NULL DEFAULT 'no revisado',
	CONSTRAINT cp_id_linea_revision PRIMARY KEY (id_tipo_revision,id_revision),
	
	CONSTRAINT caj_revision FOREIGN KEY (id_revision)
	REFERENCES REVISION(id_revision)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	
	CONSTRAINT caj_tipo_revision FOREIGN KEY (id_tipo_revision)
	REFERENCES TIPO_REVISION(id_tipo_revision)
	ON DELETE CASCADE
	ON UPDATE CASCADE
);