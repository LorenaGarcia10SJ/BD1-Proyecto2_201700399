USE prueba;
GO

EXEC crearCarrera 'Area Comun';      -- 10 VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Civil';       -- 1  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Industrial';  -- 2  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Sistemas';    -- 3  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Electronica'; -- 4  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Mecanica';    -- 5  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Mecatronica'; -- 6  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Quimica';     -- 7  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Ambiental';   -- 8  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Materiales';  -- 9  VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'Ingenieria Textil';      -- 10 VALIDAR QUE LES QUEDE ESTE ID EN LA CARRERA CORRESPONDIENTE
EXEC crearCarrera 'prueba';   

-- REGISTRO DE DOCENTES
EXEC registrarDocente 'Docente1','Apellido1','30-10-1999','aadf@ingenieria.usac.edu.gt',12345678,'direccion',12345678910,1;
EXEC registrarDocente 'Docente2','Apellido2','20-11-1999','docente2@ingenieria.usac.edu.gt',12345678,'direcciondocente2',12345678911,2;
EXEC registrarDocente 'Docente3','Apellido3','20-12-1980','docente3@ingenieria.usac.edu.gt',12345678,'direcciondocente3',12345678912,3;
EXEC registrarDocente 'Docente4','Apellido4','20-11-1981','docente4@ingenieria.usac.edu.gt',12345678,'direcciondocente4',12345678913,4;
EXEC registrarDocente 'Docente5','Apellido5','20-09-1982','docente5@ingenieria.usac.edu.gt',12345678,'direcciondocente5',12345678914,5;

-- REGISTRO DE ESTUDIANTES
-- SISTEMAS
EXEC registrarEstudiante 202000001,'Estudiante de','Sistemas Uno','30-10-1999','sistemasuno@gmail.com',12345678,'direccion estudiantes sistemas 1',337859510101,3 ;
EXEC registrarEstudiante 202000002,'Estudiante de','Sistemas Dos','3-5-2000','sistemasdos@gmail.com',12345678,'direccion estudiantes sistemas 2',32781580101,3 ;
EXEC registrarEstudiante 202000003,'Estudiante de','Sistemas Tres','3-5-2002','sistemastres@gmail.com',12345678,'direccion estudiantes sistemas 3',32791580101,3 ;
-- CIVIL
EXEC registrarEstudiante 202100001,'Estudiante de','Civil Uno','3-5-1990','civiluno@gmail.com',12345678,'direccion de estudiante civil 1',3182781580101,1 ;
EXEC registrarEstudiante 202100002,'Estudiante de','Civil Dos','03-08-1998','civildos@gmail.com',12345678,'direccion de estudiante civil 2',3181781580101,1 ;
-- INDUSTRIAL
EXEC registrarEstudiante 202200001,'Estudiante de','Industrial Uno','30-10-1999','industrialuno@gmail.com',12345678,'direccion de estudiante industrial 1',3878168901,2 ;
EXEC registrarEstudiante 202200002,'Estudiante de','Industrial Dos','20-10-1994','industrialdos@gmail.com',89765432,'direccion de estudiante industrial 2',29781580101,2 ;
-- ELECTRONICA
EXEC registrarEstudiante 202300001, 'Estudiante de','Electronica Uno','20-10-2005','electronicauno@gmail.com',89765432,'direccion de estudiante electronica 1',29761580101,4 ;
EXEC registrarEstudiante 202300002, 'Estudiante de','Electronica Dos', '01-01-2008','electronicados@gmail.com',12345678,'direccion de estudiante electronica 2',387916890101,4 ;
-- ESTUDIANTES RANDOM
EXEC registrarEstudiante 201710160, 'ESTUDIANTE','SISTEMAS RANDOM','20-08-1994','estudiasist@gmail.com',89765432,'direccionestudisist random',29791580101,3 ;
EXEC registrarEstudiante 201710161, 'ESTUDIANTE','CIVIL RANDOM','20-08-1995','estudiacivl@gmail.com',89765432,'direccionestudicivl random',30791580101,1 ;

-- AGREGAR CURSO
-- aqui se debe de agregar el AREA COMUN a carrera
-- Insertar el registro con id 0
INSERT INTO Carrera (id_carrera,nombre) VALUES (0,'Area Comun');
UPDATE Carrera SET id_carrera = 0 WHERE id_carrera = SCOPE_IDENTITY();

-- AREA COMUN
EXEC crearCurso 0006,'Idioma Tecnico 1',0,7,0,false ; 
EXEC crearCurso 0007,'Idioma Tecnico 2',0,7,0,false ;
EXEC crearCurso 101,'MB 1',0,7,0,true ; 
EXEC crearCurso 103,'MB 2',0,7,0,true ; 
EXEC crearCurso 017,'SOCIAL HUMANISTICA 1',0,4,0,true ; 
EXEC crearCurso 019,'SOCIAL HUMANISTICA 2',0,4,0,true ; 
EXEC crearCurso 348,'QUIMICA GENERAL',0,3,0,true ; 
EXEC crearCurso 349,'QUIMICA GENERAL LABORATORIO',0,1,0,true ;
-- INGENIERIA EN SISTEMAS
EXEC crearCurso 777,'Compiladores 1',80,4,3,true ; 
EXEC crearCurso 770,'INTR. A la Programacion y computacion 1',0,4,3,true ; 
EXEC crearCurso 960,'MATE COMPUTO 1',33,5,3,true ; 
EXEC crearCurso 795,'lOGICA DE SISTEMAS',33,2,3,true ;
EXEC crearCurso 796,'LENGUAJES FORMALES Y DE PROGRAMACIÓN',0,3,3,TRUE ;
-- INGENIERIA INDUSTRIAL
EXEC crearCurso 123,'Curso Industrial 1',0,4,2,true ; 
EXEC crearCurso 124,'Curso Industrial 2',0,4,2,true ;
EXEC crearCurso 125,'Curso Industrial enseñar a pensar',10,2,2,false ;
EXEC crearCurso 126,'Curso Industrial ENSEÑAR A DIBUJAR',2,4,2,true ;
EXEC crearCurso 127,'Curso Industrial 3',8,4,2,true ;
-- INGENIERIA CIVIL
EXEC crearCurso 321,'Curso Civil 1',0,4,1,true ;
EXEC crearCurso 322,'Curso Civil 2',4,4,1,true ;
EXEC crearCurso 323,'Curso Civil 3',8,4,1,true ;
EXEC crearCurso 324,'Curso Civil 4',12,4,1,true ;
EXEC crearCurso 325,'Curso Civil 5',16,4,1,false ;
EXEC crearCurso 0250,'Mecanica de Fluidos',0,5,1,true ;
-- INGENIERIA ELECTRONICA
EXEC crearCurso 421,'Curso Electronica 1',0,4,4,true ;
EXEC crearCurso 422,'Curso Electronica 2',4,4,4,true ;
EXEC crearCurso 423,'Curso Electronica 3',8,4,4,false ;
EXEC crearCurso 424,'Curso Electronica 4',12,4,4,true ;
EXEC crearCurso 425,'Curso Electronica 5',16,4,4,true ;