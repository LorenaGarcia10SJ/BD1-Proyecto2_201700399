
CREATE DATABASE proyecto2;

use proyecto2;

CREATE TABLE ACTA 
    (
     id_acta INTEGER NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL , --- 1S 2S VJ VD 
     seccion VARCHAR (1) NOT NULL , 
     fecha_creacion DATE NOT NULL , 
     HABILITAR_CURSO_id_habilitar INTEGER NOT NULL 
);

ALTER TABLE ACTA ADD CONSTRAINT ACTA_PK PRIMARY KEY CLUSTERED (id_acta)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE ASIGNACION_CURSO 
    (
     id_asignacion_curso INTEGER NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL , --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     HABILITAR_CURSO_id_habilitar INTEGER NOT NULL , 
     ESTUDIANTE_carnet BIGINT NOT NULL 
    )
;

ALTER TABLE ASIGNACION_CURSO ADD CONSTRAINT ASIGNACION_CURSO_PK PRIMARY KEY CLUSTERED (id_asignacion_curso)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE ASIGNADOS 
    (
     id_asignados INTEGER NOT NULL , 
     HABILITAR_CURSO_id_habilitar INTEGER NOT NULL 
    )
;

ALTER TABLE ASIGNADOS ADD CONSTRAINT ASIGNADOS_PK PRIMARY KEY CLUSTERED (id_asignados)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE CARRERA 
    (
     id_carrera INTEGER NOT NULL , 
     nombre VARCHAR (50) NOT NULL 
    )
;

ALTER TABLE CARRERA ADD CONSTRAINT CARRERA_PK PRIMARY KEY CLUSTERED (id_carrera)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE CURSO 
    (
     id_curso INTEGER NOT NULL , 
     nombre VARCHAR (50) NOT NULL , 
     cre_necesarios INTEGER NOT NULL , 
     cre_otorga INTEGER NOT NULL , 
     id_carrera INTEGER NOT NULL , 
     obligatorio BIT NOT NULL , 
     CARRERA_id_carrera INTEGER NOT NULL 
    )
;

ALTER TABLE CURSO ADD CONSTRAINT CURSO_PK PRIMARY KEY CLUSTERED (id_curso)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE DESASIGNACION_CURSO 
    (
     id_desasignacion INTEGER NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     HABILITAR_CURSO_id_habilitar INTEGER NOT NULL , 
     ESTUDIANTE_carnet BIGINT NOT NULL 
    )
;

ALTER TABLE DESASIGNACION_CURSO ADD CONSTRAINT DESASIGNACION_CURSO_PK PRIMARY KEY CLUSTERED (id_desasignacion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE DOCENTE 
    (
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

ALTER TABLE DOCENTE ADD CONSTRAINT DOCENTE_PK PRIMARY KEY CLUSTERED (siif)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE ESTUDIANTE 
    (
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
     CARRERA_id_carrera INTEGER NOT NULL 
    )
;

ALTER TABLE ESTUDIANTE ADD CONSTRAINT ESTUDIANTE_PK PRIMARY KEY CLUSTERED (carnet)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE HABILITAR_CURSO 
    (
     id_habilitar INTEGER NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     id_docente INTEGER NOT NULL , 
     cupo INTEGER NOT NULL , 
     seccion VARCHAR (1) NOT NULL , 
     anio VARCHAR (4) NOT NULL , 
     id_asignados INTEGER NOT NULL , 
     CURSO_id_curso INTEGER NOT NULL , 
     DOCENTE_siif INTEGER NOT NULL 
    )
;

ALTER TABLE HABILITAR_CURSO ADD CONSTRAINT HABILITAR_CURSO_PK PRIMARY KEY CLUSTERED (id_habilitar)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE HORARIO 
    (
     id_horario INTEGER NOT NULL , 
     id_curso_habilitado INTEGER NOT NULL , 
     dia INTEGER NOT NULL , 
     horario VARCHAR (50) NOT NULL , 
     HABILITAR_CURSO_id_habilitar INTEGER NOT NULL 
    )
;

ALTER TABLE HORARIO ADD CONSTRAINT HORARIO_PK PRIMARY KEY CLUSTERED (id_horario)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

CREATE TABLE NOTA 
    (
     id_nota INTEGER NOT NULL , 
     id_curso INTEGER NOT NULL , 
     ciclo VARCHAR (2) NOT NULL ,  --- 1S 2S VJ VD
     seccion VARCHAR (1) NOT NULL , 
     carnet BIGINT NOT NULL , 
     nota DECIMAL (28) NOT NULL , 
     anio VARCHAR (4) NOT NULL , 
     HABILITAR_CURSO_id_habilitar INTEGER NOT NULL , 
     ESTUDIANTE_carnet BIGINT NOT NULL 
    )
;

ALTER TABLE NOTA ADD CONSTRAINT NOTA_PK PRIMARY KEY CLUSTERED (id_nota)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
;

ALTER TABLE ACTA 
    ADD CONSTRAINT ACTA_HABILITAR_CURSO_FK FOREIGN KEY 
    ( 
     HABILITAR_CURSO_id_habilitar
    ) 
    REFERENCES HABILITAR_CURSO 
    ( 
     id_habilitar
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE ASIGNACION_CURSO 
    ADD CONSTRAINT ASIGNACION_CURSO_ESTUDIANTE_FK FOREIGN KEY 
    ( 
     ESTUDIANTE_carnet
    ) 
    REFERENCES ESTUDIANTE 
    ( 
     carnet 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE ASIGNACION_CURSO 
    ADD CONSTRAINT ASIGNACION_CURSO_HABILITAR_CURSO_FK FOREIGN KEY 
    ( 
     HABILITAR_CURSO_id_habilitar
    ) 
    REFERENCES HABILITAR_CURSO 
    ( 
     id_habilitar 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE ASIGNADOS 
    ADD CONSTRAINT ASIGNADOS_HABILITAR_CURSO_FK FOREIGN KEY 
    ( 
     HABILITAR_CURSO_id_habilitar
    ) 
    REFERENCES HABILITAR_CURSO 
    ( 
     id_habilitar
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE CURSO 
    ADD CONSTRAINT CURSO_CARRERA_FK FOREIGN KEY 
    ( 
     CARRERA_id_carrera
    ) 
    REFERENCES CARRERA 
    ( 
     id_carrera 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE DESASIGNACION_CURSO 
    ADD CONSTRAINT DESASIGNACION_CURSO_ESTUDIANTE_FK FOREIGN KEY 
    ( 
     ESTUDIANTE_carnet
    ) 
    REFERENCES ESTUDIANTE 
    ( 
     carnet 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE DESASIGNACION_CURSO 
    ADD CONSTRAINT DESASIGNACION_CURSO_HABILITAR_CURSO_FK FOREIGN KEY 
    ( 
     HABILITAR_CURSO_id_habilitar
    ) 
    REFERENCES HABILITAR_CURSO 
    ( 
     id_habilitar
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE ESTUDIANTE 
    ADD CONSTRAINT ESTUDIANTE_CARRERA_FK FOREIGN KEY 
    ( 
     CARRERA_id_carrera
    ) 
    REFERENCES CARRERA 
    ( 
     id_carrera 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE HABILITAR_CURSO 
    ADD CONSTRAINT HABILITAR_CURSO_CURSO_FK FOREIGN KEY 
    ( 
     CURSO_id_curso
    ) 
    REFERENCES CURSO 
    ( 
     id_curso 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE HABILITAR_CURSO 
    ADD CONSTRAINT HABILITAR_CURSO_DOCENTE_FK FOREIGN KEY 
    ( 
     DOCENTE_siif
    ) 
    REFERENCES DOCENTE 
    ( 
     siif 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE HORARIO 
    ADD CONSTRAINT HORARIO_HABILITAR_CURSO_FK FOREIGN KEY 
    ( 
     HABILITAR_CURSO_id_habilitar
    ) 
    REFERENCES HABILITAR_CURSO 
    ( 
     id_habilitar
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE NOTA 
    ADD CONSTRAINT NOTA_ESTUDIANTE_FK FOREIGN KEY 
    ( 
     ESTUDIANTE_carnet
    ) 
    REFERENCES ESTUDIANTE 
    ( 
     carnet 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;

ALTER TABLE NOTA 
    ADD CONSTRAINT NOTA_HABILITAR_CURSO_FK FOREIGN KEY 
    ( 
     HABILITAR_CURSO_id_habilitar
    ) 
    REFERENCES HABILITAR_CURSO 
    ( 
    id_habilitar
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
;