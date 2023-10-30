
CREATE DATABASE prueba;
USE prueba;

-- TABLA HISTORIAL
CREATE TABLE Historial (
	id_historial INTEGER IDENTITY(1,1) NOT NULL , 
	fecha DATE NOT NULL,
	descripcion VARCHAR(50) NOT NULL,
	tipo VARCHAR(50) NOT NULL,
	PRIMARY KEY ( id_historial ) 
)
;
-- TABLA Acta
CREATE TABLE Acta (
     id_acta INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL , --- 1S 2S VJ VD 
     seccion VARCHAR (1) NOT NULL , 
     fecha_creacion DATETIME NOT NULL , 
     HabilitarCurso_id_habilitar INTEGER NOT NULL 
);
-- llave primaria -> id_acta  (incremental)
ALTER TABLE Acta ADD CONSTRAINT Acta_PK PRIMARY KEY CLUSTERED (id_acta)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA AsignacionCurso
CREATE TABLE AsignacionCurso (
     id_asignacion INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL , --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     HabilitarCurso_id_habilitar INTEGER NOT NULL , 
     Estudiante_carnet BIGINT NOT NULL 
    )
;
-- llave primaria -> id_asignacion (incremental)
ALTER TABLE AsignacionCurso ADD CONSTRAINT AsignacionCurso_PK PRIMARY KEY CLUSTERED (id_asignacion)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA AsignadosDetalle
CREATE TABLE AsignadosDetalle (
     id_asignados INTEGER IDENTITY(1,1) NOT NULL , 
     HabilitarCurso_id_habilitar INTEGER NOT NULL 
    )
;
-- llave primaria -> id_asignados  (incremental)
ALTER TABLE AsignadosDetalle ADD CONSTRAINT AsignadosDetalle_PK PRIMARY KEY CLUSTERED (id_asignados)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA Carrera
CREATE TABLE Carrera (
     id_carrera INTEGER IDENTITY(0,1) NOT NULL , 
     nombre VARCHAR (50) NOT NULL 
    )
;
-- llave primaria -> id_carrera (incremental)
ALTER TABLE Carrera ADD CONSTRAINT Carrera_PK PRIMARY KEY CLUSTERED (id_carrera)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA Curso
CREATE TABLE Curso (
     id_curso INTEGER NOT NULL , 
     nombre VARCHAR (50) NOT NULL , 
     cre_necesarios INTEGER NOT NULL , 
     cre_otorga INTEGER NOT NULL , 
     id_carrera INTEGER NOT NULL , 
     obligatorio BIT NOT NULL , 
     Carrera_id_carrera INTEGER NOT NULL 
    )
;
-- llave primaria -> id_curso
ALTER TABLE Curso ADD CONSTRAINT Curso_PK PRIMARY KEY CLUSTERED (id_curso)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA Desasignacion
CREATE TABLE Desasignacion (
     id_desasignacion INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     HabilitarCurso_id_habilitar INTEGER NOT NULL , 
     Estudiante_carnet BIGINT NOT NULL 
    )
;
-- llave primaria -> id_desasignación (incremental)
ALTER TABLE Desasignacion ADD CONSTRAINT Desasignacion_PK PRIMARY KEY CLUSTERED (id_desasignacion)
     WITH ( ALLOW_PAGE_LOCKS = ON ,  ALLOW_ROW_LOCKS = ON )
;
-- TABLA Docente
CREATE TABLE Docente (
     nombres VARCHAR (50) NOT NULL , 
     apellidos VARCHAR (50) NOT NULL , 
     fecha_nac DATE NOT NULL , 
     correo VARCHAR (100) NOT NULL , 
     telefono VARCHAR (8) NOT NULL , 
     direccion VARCHAR (100) NOT NULL , 
     dpi BIGINT NOT NULL , 
     siif INTEGER NOT NULL , 
     fecha_creacion DATE NOT NULL 
    )
;
-- lave primaria -> siif 
ALTER TABLE Docente ADD CONSTRAINT Docente_PK PRIMARY KEY CLUSTERED (siif)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA Estudiante 
CREATE TABLE Estudiante (
     carnet BIGINT NOT NULL , 
     nombres VARCHAR (50) NOT NULL , 
     apellidos VARCHAR (50) NOT NULL , 
     fecha_nac DATE NOT NULL , 
     correo VARCHAR (100) NOT NULL , 
     telefono VARCHAR (8) NOT NULL , 
     direccion VARCHAR (100) NOT NULL , 
     dpi BIGINT NOT NULL , 
     id_carrera INTEGER NOT NULL , 
     creditos INTEGER NOT NULL , 
     fecha_creacion DATE NOT NULL , 
     Carrera_id_carrera INTEGER NOT NULL 
    )
;
-- llave primaria -> carnet 
ALTER TABLE Estudiante ADD CONSTRAINT Estudiante_PK PRIMARY KEY CLUSTERED (carnet)
     WITH (  ALLOW_PAGE_LOCKS = ON ,  ALLOW_ROW_LOCKS = ON )
;
-- TABLA HabilitarCurso
CREATE TABLE HabilitarCurso (
     id_habilitar INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
	 Docente_siif INTEGER NOT NULL ,
     cupo INTEGER NOT NULL , 
     seccion VARCHAR (1) NOT NULL , 
     anio VARCHAR (4) NOT NULL , 
     id_asignados INTEGER NOT NULL , 
     Curso_id_curso INTEGER NOT NULL 
    )
;
-- llave primaria -> id_habilitar (incremental)
ALTER TABLE HabilitarCurso ADD CONSTRAINT HabilitarCurso_PK PRIMARY KEY CLUSTERED (id_habilitar)
     WITH ( ALLOW_PAGE_LOCKS = ON ,  ALLOW_ROW_LOCKS = ON )
;
-- TABLA Horario
CREATE TABLE Horario (
     id_horario INTEGER IDENTITY(1,1) NOT NULL , 
     id_habilitar INTEGER NOT NULL , 
     dia INTEGER NOT NULL , 
     horario VARCHAR (50) NOT NULL , 
     HabilitarCurso_id_habilitar INTEGER NOT NULL 
    )
;
-- llave primaria -> id_horario (incremental)
ALTER TABLE Horario ADD CONSTRAINT Horario_PK PRIMARY KEY CLUSTERED (id_horario)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- TABLA Nota
CREATE TABLE Nota (
     id_nota INTEGER IDENTITY(1,1) NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     nota DECIMAL (28) NOT NULL , 
     anio VARCHAR (4) NOT NULL , 
     HabilitarCurso_id_habilitar INTEGER NOT NULL , 
     Estudiante_carnet BIGINT NOT NULL 
    )
;
-- llave primaria -> id_nota (incremental)
ALTER TABLE Nota ADD CONSTRAINT Nota_PK PRIMARY KEY CLUSTERED (id_nota)
     WITH ( ALLOW_PAGE_LOCKS = ON , ALLOW_ROW_LOCKS = ON )
;
-- agrega relacion de tablas -> llaves foraneas
ALTER TABLE Acta ADD CONSTRAINT Acta_HabilitarCurso_FK FOREIGN KEY ( HabilitarCurso_id_habilitar ) 
    REFERENCES HabilitarCurso ( id_habilitar ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE AsignacionCurso ADD CONSTRAINT AsignacionCurso_Estudiante_FK FOREIGN KEY (  Estudiante_carnet ) 
    REFERENCES Estudiante ( carnet ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE AsignacionCurso ADD CONSTRAINT AsignacionCurso_HabilitarCurso_FK FOREIGN KEY ( HabilitarCurso_id_habilitar ) 
    REFERENCES HabilitarCurso ( id_habilitar ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE AsignadosDetalle ADD CONSTRAINT AsignadosDetalle_HabilitarCurso_FK FOREIGN KEY ( HabilitarCurso_id_habilitar ) 
    REFERENCES HabilitarCurso ( id_habilitar ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Curso ADD CONSTRAINT Curso_Carrera_FK FOREIGN KEY ( Carrera_id_carrera ) 
    REFERENCES Carrera ( id_carrera ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Desasignacion ADD CONSTRAINT Desasignacion_Estudiante_FK FOREIGN KEY ( Estudiante_carnet ) 
    REFERENCES Estudiante ( carnet ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Desasignacion  ADD CONSTRAINT Desasignacion_HabilitarCurso_FK FOREIGN KEY ( HabilitarCurso_id_habilitar ) 
    REFERENCES HabilitarCurso ( id_habilitar ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Estudiante ADD CONSTRAINT Estudiante_Carrera_FK FOREIGN KEY ( Carrera_id_carrera ) 
    REFERENCES Carrera  ( id_carrera ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE HabilitarCurso ADD CONSTRAINT HabilitarCurso_Curso_FK FOREIGN KEY ( Curso_id_curso )  
	REFERENCES Curso  ( id_curso ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE HabilitarCurso ADD CONSTRAINT HabilitarCurso_Docente_FK FOREIGN KEY ( Docente_siif ) 
    REFERENCES Docente( siif ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Horario ADD CONSTRAINT Horario_HabilitarCurso_FK FOREIGN KEY( HabilitarCurso_id_habilitar) 
	REFERENCES HabilitarCurso ( id_habilitar) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Nota ADD CONSTRAINT Nota_Estudiante_FK FOREIGN KEY( Estudiante_carnet)
	REFERENCES Estudiante ( carnet ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE Nota ADD CONSTRAINT Nota_HabilitarCurso_FK FOREIGN KEY (  HabilitarCurso_id_habilitar ) 
    REFERENCES HabilitarCurso ( id_habilitar ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;


