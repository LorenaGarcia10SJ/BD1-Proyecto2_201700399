-- DROP DATABASE proyecto2;

CREATE DATABASE proyecto2;

USE proyecto2
GO

/* -- TABLA HISTORIAL PARA MANEJAR LO QUE SE ESTA HACIENDO CREACION DE DATOS, INSERTAR, ELIMINAR, ACTUALIZAR */
CREATE TABLE Historial (
	id_historial INTEGER IDENTITY(1,1) NOT NULL , 
	fecha DATE NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	PRIMARY KEY ( id_historial ) 
)
;
/* -- TABLA Carrera ------------------------------*/
CREATE TABLE Carrera (
     id_carrera INTEGER IDENTITY(0,1) NOT NULL , 
     nombre VARCHAR (50) NOT NULL,
	 PRIMARY KEY ( id_carrera ) 
    )
;

/*-- TABLA Curso -----------------------------------*/
CREATE TABLE Curso (
     id_curso INTEGER NOT NULL , 
     nombre VARCHAR (50) NOT NULL , 
     cre_necesarios INTEGER NOT NULL , 
     cre_otorga INTEGER NOT NULL , 
     CARRERA_id_carrera INTEGER NOT NULL , 
     obligatorio BIT NOT NULL , 
	 PRIMARY KEY ( id_curso ) ,
	 FOREIGN KEY ( CARRERA_id_carrera ) REFERENCES Carrera ( id_carrera )
    )
;

/*-- TABLA Docente ---------------------------------*/
CREATE TABLE Docente (
     nombres VARCHAR (50) NOT NULL , 
     apellidos VARCHAR (50) NOT NULL , 
     fecha_nac DATE NOT NULL , 
     correo VARCHAR (100) NOT NULL , 
     telefono INTEGER NOT NULL , 
     direccion VARCHAR (100) NOT NULL , 
     dpi BIGINT NOT NULL , 
     siif INTEGER NOT NULL , 
     fecha_creacion DATE NOT NULL,
	 PRIMARY KEY ( siif )
    )
;

/*-- TABLA Estudiante -------------------------------*/
CREATE TABLE Estudiante (
     carnet BIGINT NOT NULL , 
     nombres VARCHAR (50) NOT NULL , 
     apellidos VARCHAR (50) NOT NULL , 
     fecha_nac DATE NOT NULL , 
     correo VARCHAR (100) NOT NULL , 
     telefono INTEGER NOT NULL , 
     direccion VARCHAR (100) NOT NULL , 
     dpi BIGINT NOT NULL , 
     CARR_id_carrera INTEGER NOT NULL , 
     creditos INTEGER NOT NULL , 
     fecha_creacion DATE NOT NULL , 
	 PRIMARY KEY ( carnet ) ,
	 FOREIGN KEY ( CARR_id_carrera ) REFERENCES Carrera ( id_carrera )     
    )
;

/*-- TABLA AsignadosDetalle ----------------------------*/
CREATE TABLE AsignadosDetalle (
     id_asignados INTEGER IDENTITY(1,1) NOT NULL , 
	 PRIMARY KEY ( id_asignados )
	 
    )
;

/*-- TABLA CursoHabilitar ----------------------------------*/
CREATE TABLE CursoHabilitar (
     id_habilitar INTEGER IDENTITY(1,1) NOT NULL , 
     CURSO_id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
	 DOCENTE_siif INTEGER NOT NULL ,
     cupo INTEGER NOT NULL , 
     seccion VARCHAR (1) NOT NULL , 
     anio INT NOT NULL , 
     Cantidad_Asignados INTEGER NOT NULL DEFAULT 0, 
	 PRIMARY KEY ( id_habilitar ) ,
	 FOREIGN KEY ( CURSO_id_curso ) REFERENCES Curso ( id_curso ) ,
	 FOREIGN KEY ( DOCENTE_siif )   REFERENCES Docente ( siif )
    )
;


/*-- TABLA Desasignacion --------------------------*/
CREATE TABLE Desasignacion (
     id_desasignacion INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     PRIMARY KEY ( id_desasignacion ) ,
	 FOREIGN KEY ( id_curso ) REFERENCES Curso ( id_curso ) ,
	 FOREIGN KEY ( carnet )   REFERENCES Estudiante ( carnet ) 
    )
;

/*-- TABLA AsignacionCurso -------------------------*/
CREATE TABLE AsignacionCurso (
     id_asignacion INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL , --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     PRIMARY KEY ( id_asignacion ) ,
	 FOREIGN KEY ( id_curso ) REFERENCES Curso ( id_curso ) ,
	 FOREIGN KEY ( carnet )   REFERENCES Estudiante ( carnet )
    )
;

/*-- TABLA Acta -----------------------------------*/
CREATE TABLE Acta (
     id_acta INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL , --- 1S 2S VJ VD 
     seccion VARCHAR (1) NOT NULL , 
     fecha_creacion DATETIME NOT NULL , 
     PRIMARY KEY ( id_acta ) ,
	 FOREIGN KEY ( id_curso ) REFERENCES Curso ( id_curso )
)
;

/*-- TABLA Nota -----------------------------------*/
CREATE TABLE Nota (
     id_nota INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     nota DECIMAL(5, 2) NOT NULL , 
     anio INT NOT NULL , 
     PRIMARY KEY ( id_nota ) ,
	 FOREIGN KEY ( id_curso ) REFERENCES Curso ( id_curso ) ,
	 FOREIGN KEY ( carnet )   REFERENCES Estudiante ( carnet )
    )
;

/*-- TABLA Horario --------------------------------*/
CREATE TABLE Horario (
     id_horario INTEGER IDENTITY(1,1) NOT NULL , 
     id_habilitar INTEGER NOT NULL , 
     dia INTEGER NOT NULL , 
     horario VARCHAR (50) NOT NULL , 
     PRIMARY KEY ( id_horario ) ,
	 FOREIGN KEY ( id_habilitar ) REFERENCES CursoHabilitar ( id_habilitar )
    )
;

