-- Tabla de Usuarios
CREATE TABLE Usuarios (
    id_usuario INT PRIMARY KEY IDENTITY,
    nombre VARCHAR(100),
    rol VARCHAR(50)
);

-- Tabla de Permisos
CREATE TABLE Permisos (
    id_permiso INT PRIMARY KEY IDENTITY,
    id_usuario INT NOT NULL,
    id_tabla VARCHAR(50) NOT NULL,
    id_registro INT NULL,
    nivel_acceso VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- Procedimiento almacenado para verificar permisos
CREATE PROCEDURE sp_verificar_permiso
    @id_usuario INT,
    @id_tabla VARCHAR(50),
    @id_registro INT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Permisos
        WHERE id_usuario = @id_usuario 
        AND id_tabla = @id_tabla 
        AND (id_registro IS NULL OR id_registro = @id_registro)
    )
    BEGIN
        RETURN 1;
    END
    ELSE
    BEGIN
        RETURN 0;
    END
END;

