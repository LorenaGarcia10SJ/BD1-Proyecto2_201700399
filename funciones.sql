-- FUNCIONES UTILIZADAS PARA VALIDAR RESTRICCIONES
-- Entrada
USE proyecto2
GO

/*				CREAR BASE DE DATOS				*/
CREATE FUNCTION crearBaseDatos()
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @Mensaje NVARCHAR(MAX);

    -- Crear la base de datos
    CREATE DATABASE proyecto2;
    SET @Mensaje = 'Base de datos creada correctamente';
	-- PRINT @Mensaje;
    -- Usar la base de datos 
    USE proyecto2;
    SET @Mensaje = 'Utilizando base de datos proyecto2';

    RETURN @Mensaje;
END
GO

/* -- Función para validar letras ------------------------------------------------------*/
CREATE FUNCTION validarLetra (@cadena VARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @valido BIT;
    IF (PATINDEX('%[^a-zA-Z ]%', @cadena) = 0)
        SET @valido = 1;	-- La cadena contiene solo letras y espacios
    ELSE
        SET @valido = 0;	-- La cadena contiene otros caracteres además de letras y espacios
    RETURN @valido;
END
GO

/* -- Función para validar correo ------------------------------------------------------ */
CREATE FUNCTION validarEmail (@email VARCHAR(100))
RETURNS BIT
AS
BEGIN
    RETURN (
        CASE 
            WHEN @email LIKE '[a-zA-Z0-9]%@[a-zA-Z]%.[a-zA-Z]%' THEN 1
            ELSE 0
        END );
END
GO

/*-- Función para verificar si es numero ----------------------------------------------*/
CREATE FUNCTION soloNumeros (@num VARCHAR(100))
RETURNS BIT
AS
BEGIN
    RETURN (
        CASE 
            WHEN @num NOT LIKE '%[^0-9]%' THEN 1
            ELSE 0
        END
    );
END
GO

CREATE FUNCTION validarDiasSemana ( @dia INT )
RETURNS BIT
AS
BEGIN
    DECLARE @valido BIT;

    IF @dia BETWEEN 1 AND 7
        SET @valido = 1; -- Verdadero (TRUE)
		-- Lunes Martes Miercoles Jueves Viernes Sabado Domingo
    ELSE
        SET @valido = 0; -- Falso (FALSE)

    RETURN @valido;
END
GO

/*-- Función para validar creditos que sea 0 o positivo -------------------------------*/
CREATE FUNCTION ValidarEnteroPositivo (@numero INT)
RETURNS BIT
AS
BEGIN
    DECLARE @valido BIT;

    IF @numero >= 0
        SET @valido = 1; -- Es un entero positivo o cero
    ELSE
        SET @valido = 0; -- No es un entero positivo

    RETURN @valido;
END
GO
/*-- Función para validar el ciclo ----------------------------------------------------*/
CREATE FUNCTION validarCicloDos (@ciclo VARCHAR(2))
RETURNS BIT
AS
BEGIN
    DECLARE @result BIT;
    SET @result = 0;

    IF (@ciclo = '1S' OR @ciclo = '2S' OR @ciclo = 'VD' OR @ciclo = 'VJ')
    BEGIN
        SET @result = 1;
    END

    RETURN @result;
END
GO
/* -- Función para validar seccion --------------------------------------------------*/
CREATE FUNCTION validarLetraSeccion (@seccion VARCHAR(1))
RETURNS BIT
AS
BEGIN
    DECLARE @valido BIT;

    IF (@seccion LIKE '[a-zA-Z]')
    BEGIN
        SET @valido = 1;
    END
    ELSE
    BEGIN
        SET @valido = 0;
    END

    RETURN @valido;
END
GO

/*-- FIN FUNCIONES ------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: crearCarrera
-- entrada: nombre
-- salida : id_carrera | nombre
*/
CREATE PROCEDURE crearCarrera
    @inNombre VARCHAR(50)
AS
BEGIN
	-- instrucciones del cuerpo 
	DECLARE @Mensaje varchar(70);

    IF dbo.validarLetra(@inNombre) = 0
    BEGIN
        EXEC @Mensaje 'El nombre debe contener solo letras';
		PRINT @Mensaje;
        RETURN;
    END

	-- Verificar la carrera 
    IF EXISTS (SELECT 1 FROM Carrera WHERE nombre = @inNombre)
    BEGIN
        SET @Mensaje = 'La carrera ya esta registrada';
		PRINT @Mensaje
        RETURN;
    END

    -- Insertar carrera 
    INSERT INTO Carrera (nombre) VALUES (@inNombre);

    SET @Mensaje = 'Carrera registrada correctamente';
	PRINT @Mensaje
END
GO

/*-- TRIGGER para Carrera
-- Entrada: Carrera
-- Salida: informacion del insert
*/
CREATE TRIGGER histoC
ON Carrera
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se ha agregado una carrera', 'INSERT'
END
GO
/*----------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: registrarDocente
-- entrada: nombre, apellido, fecha_nac, correo, telefono, direccion, dpi, siif
-- salida : insertar docente
*/
CREATE PROCEDURE registrarDocente
	@inNombreD VARCHAR(50),
	@inApellidoD VARCHAR (50),
	@inFechaN	VARCHAR (50),
	@inCorreo VARCHAR (100),
	@inTelefono VARCHAR (8),
	@inDireccion VARCHAR (100),
	@inDPI BIGINT,
	@inSIIF INTEGER

AS
BEGIN
	-- instrucciones del cuerpo
	DECLARE @Mensaje varchar(70);
	DECLARE @inFechaN2 DATE;

	SET @inFechaN2 = CONVERT(DATE, @inFechaN, 103); -- Convertir la fecha
    IF dbo.validarEmail(@inCorreo) = 0
    BEGIN
        EXEC @Mensaje 'Formato de correo invalido';
		PRINT @Mensaje;
        RETURN;
    END

	-- Verificar el docente
    IF EXISTS (SELECT 1 FROM Docente WHERE siif = @inSIIF)
    BEGIN
        SET @Mensaje = 'Docente ya registrado';
		PRINT @Mensaje
        RETURN;
    END

    -- Insertar docente
    INSERT INTO Docente(nombres, apellidos, fecha_nac, correo, telefono, direccion,dpi,siif, fecha_creacion)
	VALUES (@inNombreD, @inApellidoD, @inFechaN2 , @inCorreo, @inTelefono, @inDireccion, @inDPI,@inSIIF, GETDATE());

    SET @Mensaje = 'Carrera registrada correctamente';
	PRINT @Mensaje

END
GO

/*-- TRIGGER para Docente
-- Entrada: Docente
-- Salida: informacion del insert
*/
CREATE TRIGGER histoDocente
ON Docente
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se ha agregado un docente', 'INSERT'
END
GO
/*--------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: registrarEstudiante
-- entrada: 202000001,'Estudiante de','Sistemas Uno','30-10-1999','sistemasuno@gmail.com',12345678,'direccion estudiantes sistemas 1',337859510101,3
-- salida : id_carrera | nombre
*/
CREATE PROCEDURE registrarEstudiante
	@inCarnet BIGINT,
	@inNombre VARCHAR(50),
	@inApellido VARCHAR (50),
	@inFechaN VARCHAR(50),
	@inCorreo VARCHAR (100),
	@inTelefono INTEGER,
	@inDireccion VARCHAR (100),
	@inDPI BIGINT,
	@inCarrera INTEGER   -- id_carrera

AS
BEGIN
	-- instrucciones del cuerpo
	DECLARE @Mensaje varchar(70);
	DECLARE @inFechaNE DATE;
	DECLARE @inCredito INTEGER;

	SET @inCredito = 0;
	SET @inFechaNE = CONVERT(DATE, @inFechaN, 103); -- Convertir la fecha
	-- SET @inCreditos =  0;

    IF dbo.validarEmail(@inCorreo) = 0
    BEGIN
        EXEC @Mensaje 'Formato de correo invalido';
		PRINT @Mensaje;
        RETURN;
    END

	IF dbo.ValidarEnteroPositivo(@inCredito) = 0
    BEGIN
        EXEC @Mensaje 'Creditos debe ser un numero positivo';
		PRINT @Mensaje;
        RETURN;
    END

	-- Verificar el docente
    IF EXISTS (SELECT 1 FROM Estudiante WHERE carnet = @inCarnet)
    BEGIN
        SET @Mensaje = 'Estudiante ya registrado';
		PRINT @Mensaje
        RETURN;
    END

    -- Insertar Estudiante
    INSERT INTO Estudiante(carnet, nombres, apellidos, fecha_nac, correo, telefono, direccion, dpi, CARR_id_carrera, creditos, fecha_creacion)
	VALUES (@inCarnet, @inNombre, @inApellido , @inFechaNE, @inCorreo, @inTelefono, @inDireccion, @inDPI, @inCarrera, @inCredito , GETDATE());

    SET @Mensaje = 'Estudiante registrado correctamente';
	PRINT @Mensaje


END
GO

/*-- TRIGGER para Estudiante
-- Entrada: Estudiante
-- Salida: informacion del insert
*/
CREATE TRIGGER histoEstudiante
ON Estudiante
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se agrego un estudiante', 'INSERT'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: crearCurso
-- entrada: 0006,'Idioma Tecnico 1',0,7,0,false 
-- salida : información
*/
CREATE PROCEDURE crearCurso
	@inCurso INTEGER,
	@inNombre VARCHAR(50),
	@inCredN INTEGER,
	@inCredO INTEGER,
	@inCarrera INTEGER ,  -- id_carrera
	@inObligatorio VARCHAR (10)
AS
BEGIN
	-- instrucciones del cuerpo
	DECLARE @Mensaje varchar(70);
	DECLARE @ObligatorioC BIT;

	
	IF dbo.ValidarEnteroPositivo(@inCredN) = 0
    BEGIN
        EXEC @Mensaje 'Creditos necesarios debe ser 0 o entero positivo';
		PRINT @Mensaje;
        RETURN;
    END

	IF dbo.ValidarEnteroPositivo(@inCredO) = 0
    BEGIN
        EXEC @Mensaje 'Creditos que otorga debe ser un entero positivo';
		PRINT @Mensaje;
        RETURN;
    END

	-- Convierte el valor a BIT
	SET @ObligatorioC = CASE 
						  WHEN UPPER(@inObligatorio) = 'TRUE' THEN 1
						  WHEN UPPER(@inObligatorio) = 'FALSE' THEN 0
						END;

	-- Verificar el Curso
    IF EXISTS (SELECT 1 FROM Curso WHERE id_curso = @inCurso)
    BEGIN
        SET @Mensaje = 'El curso ya existe';
		PRINT @Mensaje
        RETURN;
    END

    -- Insertar Estudiante  EXEC crearCurso 0006,'Idioma Tecnico 1',0,7,0,false ; 
    INSERT INTO Curso(id_curso, nombre, cre_necesarios, cre_otorga, CARRERA_id_carrera, obligatorio)
	VALUES (@inCurso, @inNombre, @inCredN , @inCredO, @inCarrera, @ObligatorioC);

    SET @Mensaje = 'Curso registrado correctamente';
	PRINT @Mensaje

END
GO

/*-- TRIGGER para Curso
-- Entrada: Curso
-- Salida: informacion del insert
*/
CREATE TRIGGER histoCurso
ON Curso
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se agrego un curso', 'INSERT'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: habilitarCurso
-- entrada: id_ha,id_curso,1S,ID_DOCENTE,CUPO,A,  AÑO , ID_ASIGNADOS 
-- salida : información
*/
CREATE PROCEDURE habilitarCurso
	@inCurso INTEGER,
	@inCiclo VARCHAR(2),
	@inDocente INTEGER,
	@inCupo INTEGER ,  
	@inSeccion VARCHAR(1)
	-- @inCantiEstu INTEGER
AS
BEGIN
    -- DECLARE @busquedaC INT;
    DECLARE @bsSeccion VARCHAR(1);
	DECLARE @bsCiclo VARCHAR(2);
	DECLARE @bsCurso INTEGER;
	DECLARE @Mensaje varchar(70);
	-- SET @inCantiEstu= 0;
   
    IF EXISTS (SELECT 1 FROM Curso WHERE id_curso = @inCurso)  -- validar que exista el curso
    BEGIN
        IF dbo.validarCicloDos(@inCiclo) = 1 -- Validar ciclo
        BEGIN
            IF dbo.ValidarEnteroPositivo(@inCupo) = 1 -- validar cupo 
            BEGIN
                IF dbo.validarLetraSeccion(@inSeccion) = 1
                BEGIN
                    SET @bsSeccion = (SELECT COUNT(id_habilitar) FROM CursoHabilitar WHERE Seccion = UPPER(@inSeccion));
					SET @bsCiclo = (SELECT COUNT(id_habilitar) FROM CursoHabilitar WHERE Ciclo = UPPER(@inCiclo));
					SET @bsCurso = (SELECT COUNT(id_habilitar) FROM CursoHabilitar WHERE CURSO_id_curso =@inCurso);
                    IF @bsSeccion > 0 AND @bsCiclo > 0 AND @bsCurso > 0
                    BEGIN
						SET @Mensaje = 'La sección ya esta registrada para el curso' + @inCurso;
						PRINT @Mensaje;  
                    END
                    ELSE
                    BEGIN
                        INSERT INTO CursoHabilitar(CURSO_id_curso, ciclo, DOCENTE_siif, cupo, seccion, anio)
                        VALUES (@inCurso, @inCiclo, @inDocente, @inCupo, UPPER(@inSeccion), YEAR(GETDATE()));
						SET @Mensaje = 'Curso habilitado correctamente';
						PRINT @Mensaje; 
						RETURN ;
                    END
                END -- Termina if de validarSeccion 
                ELSE
                BEGIN
                    SET @Mensaje = 'Solo se acepta una letra ejem: A';
					PRINT @Mensaje;   
					RETURN ;
                END
            END
            ELSE
            BEGIN
                SET @Mensaje = 'Solo se acepta numero positivo';
				PRINT @Mensaje;
				RETURN ;
            END
        END
        ELSE
        BEGIN
            SET @Mensaje = 'Solo se acepta 1S, 2S, VJ, VD';
			PRINT @Mensaje;
			RETURN ;
        END
    END -- termina if de curso 
    ELSE
    BEGIN
		SET @Mensaje = 'El curso no existe, ingrese un codigo de curso existente';
		PRINT @Mensaje
		RETURN ;
    END
END
GO

/*-- TRIGGER para HabilitarCurso
-- Entrada: HabilitarCurso
-- Salida: informacion del insert
*/
CREATE TRIGGER histoHabilitarCurso
ON CursoHabilitar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se habilito el curso correctamente', 'INSERT'
END
GO
/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: agregarHorario
-- entrada:  id_habilitar , dia , horario
-- salida : información
*/
CREATE PROCEDURE agregarHorario
	@inHabilitar INTEGER,
	@inDia INTEGER,
	@inHorario VARCHAR(50)
AS
BEGIN
	DECLARE @Mensaje varchar(70);

	-- Validar curso habilitado
    IF EXISTS (SELECT 1 FROM CursoHabilitar WHERE id_habilitar = @inHabilitar)
    BEGIN
		IF dbo.validarDiasSemana(@inDia) = 1
		BEGIN
			-- Insertar horario
			INSERT INTO Horario(id_habilitar, dia, horario)
			VALUES (@inHabilitar, @inDia, @inHorario );

			SET @Mensaje = 'Se agrego un horario';
			PRINT @Mensaje
		END
		ELSE
		BEGIN
			SET @Mensaje = 'Debe ser dentro del dominio [1,7]';
			PRINT @Mensaje;
		END
    END
	ELSE
	BEGIN
		SET @Mensaje = 'El curso no esta habilitado';
		PRINT @Mensaje;
		RETURN ;
	END
END
GO

/*-- TRIGGER para agregarHorario
-- Entrada: Horario
-- Salida: informacion del insert
*/
CREATE TRIGGER histoHorario
ON Horario
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se ingreso un horario', 'INSERT'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: asignarCurso
-- entrada:  id_curso , ciclo , seccion, carnet
-- salida : información
*/

CREATE PROCEDURE asignarCurso
    @inCurso INTEGER,
    @inCiclo VARCHAR(2),
    @inSeccion VARCHAR(1),
    @inCarnet BIGINT
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);

    -- Verificar si el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM Estudiante WHERE carnet = @inCarnet)
    BEGIN
        SET @Mensaje = 'El carnet proporcionado no existe';
		PRINT @Mensaje;
        RETURN;
    END

    -- Verificar si la sección existe y no ha alcanzado el cupo máximo
    IF NOT EXISTS (SELECT 1 FROM CursoHabilitar WHERE ciclo = @inCiclo AND seccion = @inSeccion)
    BEGIN
        SET @Mensaje= 'La sección especificada no existe o ha alcanzado el cupo máximo';
		PRINT @Mensaje;
        RETURN;
    END

    -- Verificar si el estudiante ya está asignado a la misma u otra sección del mismo curso
    IF EXISTS (
        SELECT 1 
        FROM AsignacionCurso a
        INNER JOIN CursoHabilitar ch ON a.id_curso = ch.id_habilitar
        WHERE a.carnet = @inCarnet 
        AND ch.ciclo = @inCiclo
        AND a.seccion = @inSeccion
    )
    BEGIN
        PRINT 'El estudiante ya está asignado a la misma u otra sección del curso.';
        RETURN;
    END

    -- Verificar si el estudiante cuenta con los créditos necesarios y pertenece al curso correspondiente a su carrera o área común
    IF NOT EXISTS (
        SELECT 1 
        FROM Estudiante e
        INNER JOIN Carrera c ON e.CARR_id_carrera = c.id_carrera
        INNER JOIN Curso cu ON cu.id_curso = @inCurso
        WHERE e.carnet = @inCarnet 
        AND e.creditos >= cu.cre_necesarios
        AND (cu.CARRERA_id_carrera = e.CARR_id_carrera OR cu.CARRERA_id_carrera IS NULL)
    )
    BEGIN
        PRINT 'El estudiante no cuenta con los créditos necesarios o el curso no corresponde a su carrera o área común.';
        RETURN;
    END

    -- Verificar si el curso está habilitado para el año actual, ciclo y sección
    DECLARE @idCursoHabilitado INTEGER;
    SELECT @inCurso = CURSO_id_curso
    FROM CursoHabilitar
    WHERE ciclo = @inCiclo
    AND seccion = @inSeccion
    AND CURSO_id_curso = @inCurso

    IF @inCurso IS NULL
    BEGIN
        PRINT 'El curso no está habilitado para el año actual, ciclo y sección especificados.';
        RETURN;
    END

	    -- Disminuir el cupo de la sección del curso
    UPDATE CursoHabilitar
    SET cupo = cupo - 1
    WHERE CURSO_id_curso = @inCurso
    AND ciclo = @inCiclo
    AND seccion = @inSeccion;

    -- Realizar la asignación del curso
    INSERT INTO AsignacionCurso (id_curso, ciclo, seccion, carnet)
    VALUES (@inCurso, @inCiclo, UPPER(@inSeccion), @inCarnet); -- 1 puede ser el estado de asignación activa, ajusta según tus necesidades
    
    SET @Mensaje= 'Asignación de curso realizada exitosamente';
	PRINT @Mensaje;
END
GO

/*-- TRIGGER para asignarCurso
-- Entrada: AsignacionCurso
-- Salida: informacion del insert
*/
CREATE TRIGGER histoAsignarCurso
ON AsignacionCurso
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se asigno un curso', 'INSERT'
END
GO

/*-- TRIGGER para asignarCurso
-- Entrada: AsignacionCurso
-- Salida: informacion del insert
*/

CREATE TRIGGER ActualizarIdAsignados
ON AsignacionCurso
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @idCursoAS INT;

    -- Obtener el id del curso habilitado
    SELECT @idCursoAS = id_curso
    FROM inserted;

    -- Actualizar id_asignados en HabilitarCurso
    UPDATE CursoHabilitar
    SET Cantidad_Asignados = Cantidad_Asignados + 1
    WHERE CURSO_id_curso = @idCursoAS;

	INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se actualizo cantidad de asignados', 'UPDATE'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: desasignarCurso
-- entrada:  id_curso , ciclo , seccion, carnet
-- salida : información
*/

CREATE PROCEDURE desasignarCurso 
    @inCurso INTEGER,
    @inCiclo VARCHAR(2),
    @inSeccion VARCHAR(1),
    @inCarnet BIGINT
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);
    -- Verificar si el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM Estudiante WHERE carnet = @inCarnet)
    BEGIN
        SET @Mensaje= 'El carnet no existe';
		PRINT @Mensaje;
        RETURN;
    END

    -- Verificar si el estudiante está asignado a la sección del curso especificado
    IF NOT EXISTS (
        SELECT 1
        FROM AsignacionCurso a
        INNER JOIN CursoHabilitar ch ON a.id_curso = ch.CURSO_id_curso
        WHERE a.carnet = @inCarnet 
        AND ch.ciclo = @inCiclo
        AND a.seccion = @inSeccion
        AND ch.CURSO_id_curso = @inCurso
    )
    BEGIN
        SET @Mensaje= 'El estudiante no está asignado a la sección del curso especificado';
		PRINT @Mensaje;
        RETURN;
    END

	-- registrar la desasignacion
	INSERT INTO Desasignacion(id_curso, ciclo, seccion, carnet)
    VALUES (@inCurso, @inCiclo, UPPER(@inSeccion), @inCarnet); 
    

    -- Realizar la desasignación del estudiante
    DELETE FROM AsignacionCurso
    WHERE carnet = @inCarnet 
    AND seccion = @inSeccion
    AND id_curso = @inCurso;


    -- Incrementar el cupo de la sección del curso
    UPDATE CursoHabilitar
    SET cupo = cupo + 1
    WHERE CURSO_id_curso = @inCurso
    AND ciclo = @inCiclo
    AND seccion = @inSeccion;

    SET @Mensaje= 'Desasignación de curso realizada exitosamente';
	PRINT @Mensaje;
END
GO

/*-- TRIGGER para desasignarCurso
-- Entrada: Desasignacion
-- Salida: informacion del insert
*/
CREATE TRIGGER histoDesasignar
ON Desasignacion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Desasignacion completada', 'DELETE'
END
GO

/*-- TRIGGER para desasignarCurso
-- Entrada: Desasignacion
-- Salida: informacion del insert
*/

CREATE TRIGGER ActualizarIdDesasignados 
ON Desasignacion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @idCursoAS INT;

    -- Obtener el id del curso habilitado
    SELECT @idCursoAS = id_curso
    FROM inserted;

    -- Actualizar id_asignados en HabilitarCurso
    UPDATE CursoHabilitar
    SET Cantidad_Asignados = Cantidad_Asignados - 1
    WHERE CURSO_id_curso = @idCursoAS;

	INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se desasigno un estudiante', 'UPDATE'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: ingresarNota
-- entrada: id_curso, ciclo, seccion, carnet, nota
-- salida : información
*/

CREATE PROCEDURE ingresarNota 
    @inCurso INTEGER,
    @inCiclo VARCHAR(2),
    @inSeccion VARCHAR(1),
    @inCarnet BIGINT,
    @inNota DECIMAL(5, 2) 
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);
    -- Verificar que el estudiante existe
    IF NOT EXISTS (SELECT 1 FROM Estudiante WHERE carnet = @inCarnet)
    BEGIN
        SET @Mensaje= 'El carnet no existe';
		PRINT @Mensaje;
        RETURN;
    END

    -- Verificar que la nota sea positiva
    IF dbo.ValidarEnteroPositivo(@inNota) = 0
    BEGIN
        SET @Mensaje= 'La nota debe ser un valor positivo';
		PRINT @Mensaje;
        RETURN;
    END

    -- Redondear la nota al entero más cercano
    DECLARE @notaRedondeada INTEGER;
    SET @notaRedondeada = ROUND(@inNota, 0);

    -- Insertar la nota 
    INSERT INTO Nota(id_curso, ciclo, seccion, carnet, nota, anio)
    VALUES (@inCurso, @inCiclo, @inSeccion, @inCarnet, @notaRedondeada, YEAR(GETDATE()));

    -- Verificar si el estudiante aprobó el curso
    IF @notaRedondeada >= 61
    BEGIN
        -- Obtener la cantidad de créditos del estudiante
        DECLARE @creditosEstudiante INTEGER;
        SELECT @creditosEstudiante = creditos FROM Estudiante WHERE carnet = @inCarnet;

        -- Obtener la cantidad de créditos del curso aprobado
        DECLARE @creditosCurso INT;
        SELECT @creditosCurso = cre_otorga FROM Curso WHERE id_curso = @inCurso;

        -- Sumar los créditos del estudiante y del curso aprobado
        DECLARE @totalCreditos INT;
        SET @totalCreditos = @creditosEstudiante + @creditosCurso;

        -- Actualizar la cantidad de créditos del estudiante en la tabla Estudiante
        UPDATE Estudiante
        SET creditos = @totalCreditos
        WHERE carnet = @inCarnet;
    END

    SET @Mensaje= 'Nota ingresada correctamente';
	PRINT @Mensaje;
END
GO


/*-- TRIGGER para ingresarNota
-- Entrada: Nota
-- Salida: informacion del insert
*/
CREATE TRIGGER histoNota
ON Nota
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Nota ingresada', 'INSERT'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: generarActa
-- entrada: id_curso, ciclo , seccion , fecha_creacion
-- salida : información
*/

CREATE PROCEDURE generarActa
    @inCurso INTEGER,
    @inCiclo VARCHAR(2),
    @inSeccion VARCHAR(1)
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);
    -- Verificar si todas las notas de los estudiantes asignados se han ingresado
    IF NOT EXISTS (
        SELECT 1
        FROM AsignacionCurso a
        WHERE a.id_curso = @inCurso
        AND a.ciclo = @inCiclo
        AND a.seccion = @inSeccion
        EXCEPT
        SELECT 1
        FROM Nota n
        WHERE n.id_curso = @inCurso
        AND n.ciclo = @inCiclo
        AND n.seccion = @inSeccion
    )
    BEGIN
        SET @Mensaje= 'Se debe ingresar todas las notas';
		PRINT @Mensaje;
        RETURN;
    END

    -- Insertar el registro del acta en la tabla Actas
    INSERT INTO Acta(id_curso, ciclo, seccion, fecha_creacion)
    VALUES (@inCurso, @inCiclo, @inSeccion, GETDATE());

    SET @Mensaje= 'Acta generada correctamente';
	PRINT @Mensaje;
END
GO


/*-- TRIGGER para generarActa
-- Entrada: Acta
-- Salida: informacion del insert
*/
CREATE TRIGGER histoActa
ON Acta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Acta generada', 'INSERT'
END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: consultarPensum
-- entrada: id_carrera
-- salida : Nombre del curso, Es obligatorio (sí o no) , Créditos necesarios
*/

CREATE PROCEDURE consultarPensum
    @inCarrera INTEGER
AS
BEGIN
    -- Consulta carrera
    SELECT cu.id_curso AS 'Código del curso',
           cu.nombre AS 'Nombre del curso',
           CASE WHEN cu.obligatorio = 1 THEN 'SI' ELSE 'NO' END AS 'Obligatorio',
           cu.cre_necesarios AS 'Créditos necesarios'
    FROM Carrera c
    INNER JOIN Curso cu ON c.id_carrera = cu.CARRERA_id_carrera
    WHERE c.id_carrera = @inCarrera;

	INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Consulta de pensum ', 'CONSULTA'

END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: Consultar estudiante
-- entrada: Carnet
-- salida : Carnet, Nombre completo , Fecha de nacimiento,Correo,Teléfono,Dirección,DPI,Carrera,Créditos
*/

CREATE PROCEDURE consultarEstudiante
    @inCarnet BIGINT
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);
    -- Verificar el carnet
    IF NOT EXISTS (SELECT 1 FROM Estudiante WHERE carnet = @inCarnet)
    BEGIN
        SET @Mensaje= 'El carnet no existe';
		PRINT @Mensaje;
        RETURN;
    END

	-- Mostrar información
     -- Consultar la información del estudiante
    SELECT carnet,
           CONCAT(nombres, ' ', apellidos) AS 'Nombre completo',
           fecha_nac,
           correo,
           telefono,
           direccion,
           dpi,
           (SELECT nombre FROM Carrera WHERE id_carrera = Estudiante.CARR_id_carrera) AS 'Carrera',
           creditos
    FROM Estudiante
    WHERE carnet = @inCarnet;

	INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Consulta de estudiante ', 'CONSULTA'

END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: consultarDocente
-- entrada: SIIF
-- salida : SIIF, Nombre completo , Fecha de nacimiento,Correo,Teléfono,,Dirección,DPI
*/

CREATE PROCEDURE consultarDocente
    @inSIIF INTEGER
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);
    -- Verificar el SIIF
    IF NOT EXISTS (SELECT 1 FROM Docente WHERE siif = @inSIIF)
    BEGIN
        SET @Mensaje= 'SIIF no existe';
		PRINT @Mensaje;
        RETURN;
    END

	-- Mostrar información
    SELECT siif as 'SIIF',
           CONCAT(nombres, ' ', apellidos) AS 'Nombre completo',
           fecha_nac AS 'Fecha nacimiento',
           correo,
           telefono,
           direccion,
           dpi
    FROM Docente
    WHERE siif = @inSIIF;

	INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Consulta de Docente ', 'CONSULTA'

END
GO

/*----------------------------------------------------------------------------------------------------------------------------
-- PROCEDIMIENTO
-- proceso: consultarAsignados
-- entrada: id_curso, ciclo, año, seccion
-- salida : Carnet, Nombre Completo , Créditos que posee
*/

CREATE PROCEDURE consultarAsignados
    @inCurso INTEGER,
	@inCiclo VARCHAR(2),
	@inAnio INT,
	@inSeccion VARCHAR(1)
AS
BEGIN
	DECLARE @Mensaje VARCHAR(70);
    -- Verificar el carnet
    IF NOT EXISTS (SELECT 1 FROM Curso WHERE id_curso = @inCurso)
    BEGIN
        SET @Mensaje= 'El curso no existe';
		PRINT @Mensaje;
        RETURN;
    END

	-- Mostrar información
	IF NOT EXISTS (SELECT 1 FROM CursoHabilitar WHERE CURSO_id_curso = @inCurso AND ciclo = @inCiclo AND anio = @inAnio AND seccion = @inSeccion)
    BEGIN
        SET @Mensaje= 'No se reconoce el ciclo, año o sección';
		PRINT @Mensaje;
        RETURN;
    END

    -- Mostrar información
    SELECT a.carnet AS 'Carnet',
           CONCAT(e.nombres, ' ', e.apellidos) AS 'Nombre completo',
           e.creditos AS 'Créditos que posee'
    FROM AsignacionCurso a
    INNER JOIN Estudiante e ON a.carnet = e.carnet
    INNER JOIN CursoHabilitar ch ON a.id_curso = ch.CURSO_id_curso
    WHERE ch.CURSO_id_curso = @inCurso
    AND ch.ciclo = @inCiclo
    AND ch.anio = @inAnio
    AND ch.seccion = @inSeccion;

	INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Consulta de Estudiantes asignados ', 'CONSULTA'
END
GO