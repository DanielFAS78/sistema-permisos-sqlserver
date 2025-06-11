# **Sistema de Control de Permisos en SQL Server** 🚀

## 🔹 **Introducción**
Este documento describe la implementación de un **sistema granular de control de permisos** en **SQL Server**, con una API basada en **Django Rest Framework (DRF)** exclusivamente para exposición de datos.

## 📐 **Arquitectura del Sistema**
1. **SQL Server** gestiona los permisos mediante:
   - Tablas de usuarios y permisos.
   - Procedimientos almacenados y funciones de validación.
   - Vistas seguras para restringir registros según el usuario.

2. **Django Rest Framework (DRF)** solo sirve para exponer la API:
   - No maneja lógica de permisos.
   - Consulta SQL Server mediante procedimientos almacenados.

## 🏗 **Estructura de Archivos**

## ⚡ **Implementación en SQL Server**
Ejecutar los scripts de `/sql/` para crear las siguientes estructuras:
```sql
CREATE TABLE Permisos (
    id_permiso INT PRIMARY KEY IDENTITY,
    id_usuario INT NOT NULL,
    id_tabla VARCHAR(50) NOT NULL,
    id_registro INT NULL,
    nivel_acceso VARCHAR(20) NOT NULL
);
-------------------------- se usa un procedimiento almacenado para validar permisos:
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
-----------------  La API usa consultas directas a SQL Server:
from django.db import connection

def obtener_permisos(id_usuario, id_tabla, id_registro):
    with connection.cursor() as cursor:
        cursor.execute("EXEC sp_verificar_permiso %s, %s, %s", [id_usuario, id_tabla, id_registro])
        resultado = cursor.fetchone()
    return resultado
