-- FUNCIONES UTILIZADAS PARA VALIDAR RESTRICCIONES
-- Entrada
USE prueba;
GO

-- Función para validar letras
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

-- Función para validar correo
CREATE FUNCTION validarEmail (@email VARCHAR(100))
RETURNS BIT
AS
BEGIN
    RETURN (
        CASE 
            WHEN @email LIKE '[a-zA-Z0-9]%@[a-zA-Z]%.[a-zA-Z]%' THEN 1
            ELSE 0
        END
    );
END
GO

-- PROCEDIMIENTOS 
-- proceso: crearCarrera
-- entrada: nombre
-- salida : id_carrera | nombre

CREATE PROCEDURE crearCarrera
    @inNombre VARCHAR(50)
AS
BEGIN
	-- instrucciones del cuerpo
	DECLARE @Mensaje varchar(50);

    IF dbo.validarLetra(@inNombre) = 0
    BEGIN
        EXEC @Mensaje 'El nombre debe contener solo letras';
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

-- TRIGGER para Carrera
-- Entrada: Carrera
-- Salida: informacion del insert
CREATE TRIGGER histo
ON Carrera
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se ha agregado una carrera', 'INSERT'
END;

-- proceso: registrarDocente
-- entrada: nombre
-- salida : id_carrera | nombre
CREATE PROCEDURE registrarDocente
	@inNombreD VARCHAR(50),
	@inApellidoD VARCHAR (50),
	@inFechaN	VARCHAR (50),
	@inCorreo VARCHAR (100),
	@inTelefono VARCHAR (8),
	@inDireccion VARCHAR (100),
	@inDPI BIGINT,
	@inSIIF INTEGER
	-- @inFechaC DATE
AS
BEGIN
	-- instrucciones del cuerpo
	DECLARE @Mensaje varchar(50);
	DECLARE @inFechaN2 DATE;

	SET @inFechaN2 = CONVERT(DATE, @inFechaN, 103); -- Convertir la fecha
    IF dbo.validarEmail(@inCorreo) = 0
    BEGIN
        EXEC @Mensaje 'Formato de correo invalido';
        RETURN;
    END

	-- Verificar la carrera
    IF EXISTS (SELECT 1 FROM Docente WHERE siif = @inSIIF)
    BEGIN
        SET @Mensaje = 'Docente ya registrado';
		PRINT @Mensaje
        RETURN;
    END

    -- Insertar carrera
    INSERT INTO Docente(nombres, apellidos, fecha_nac, correo, telefono, direccion,dpi,siif, fecha_creacion)
	VALUES (@inNombreD, @inApellidoD, @inFechaN2 , @inCorreo, @inTelefono, @inDireccion, @inDPI,@inSIIF, GETDATE());

    SET @Mensaje = 'Carrera registrada correctamente';
	PRINT @Mensaje

END
GO

-- TRIGGER para Docente
-- Entrada: Docente
-- Salida: informacion del insert
CREATE TRIGGER histoDocente
ON Docente
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Historial(fecha, descripcion, tipo)
    SELECT GETDATE(), 'Se ha agregado un docente', 'INSERT'
END;


CREATE PROCEDURE registrarEstudiante
	@inCarnet BIGINT,
	@inNombre VARCHAR(50),
	@inApellido VARCHAR (50),
	@inFechaN	DATE,
	@inCorreo VARCHAR (50),
	@inTelefono VARCHAR (8),
	@inDireccion VARCHAR (100),
	@inDPI BIGINT,
	@inCarrera INTEGER,
	@inFecha DATE
AS