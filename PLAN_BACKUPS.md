# Plan de Backups - API REST DevOps

## 1. Objetivo

Establecer un procedimiento para proteger la información almacenada en la base de datos PostgreSQL de la API REST y permitir su recuperación ante fallos, pérdida de información o incidentes de infraestructura.

## 2. Información a respaldar

Se respaldará la información almacenada en la base de datos PostgreSQL de producción, incluyendo:

- Tabla de alumnos.
- Tabla de usuarios.
- Roles y permisos asociados a los usuarios.
- Información necesaria para la operación de la API.

No se almacenarán contraseñas en texto plano. Las contraseñas de los usuarios se almacenan mediante hashes utilizando bcrypt.

## 3. Frecuencia de los respaldos

Se establece el siguiente esquema:

- Backup diario: respaldo completo de la base de datos.
- Backup semanal: conservación de un respaldo semanal adicional.
- Backup mensual: conservación de un respaldo mensual para recuperación histórica.

Para un entorno académico, esta planificación permite simular una estrategia básica de respaldo de producción.

## 4. Lugar de almacenamiento

Los respaldos de la base de datos serán almacenados en un medio externo o servicio de almacenamiento seguro, separado de la aplicación principal.

Los archivos de respaldo no serán almacenados dentro del repositorio público de GitHub.

## 5. Seguridad

Los respaldos deberán:

- Mantenerse fuera del repositorio público.
- Contener únicamente información necesaria para la recuperación.
- Tener acceso restringido.
- Mantenerse protegidos mediante las medidas de seguridad disponibles en el servicio de almacenamiento utilizado.
- No incluir archivos `.env` ni credenciales dentro del repositorio GitHub.

## 6. Procedimiento de recuperación

Ante una pérdida o falla de la base de datos se seguirá el siguiente procedimiento:

1. Identificar el incidente.
2. Verificar el último backup disponible.
3. Crear o preparar una instancia PostgreSQL para recuperación.
4. Restaurar la información utilizando el backup seleccionado.
5. Verificar que las tablas y registros estén disponibles.
6. Configurar la variable `DATABASE_URL` con la base de datos recuperada.
7. Reiniciar o desplegar nuevamente la API.
8. Comprobar el endpoint `/health`.
9. Verificar que la API pueda consultar y registrar información correctamente.

## 7. Verificación de los respaldos

Periódicamente se realizará una prueba de restauración para comprobar que los archivos de backup son válidos y que pueden utilizarse para recuperar la información.

Una copia de seguridad se considera válida cuando puede ser restaurada correctamente y la información recuperada puede ser consultada.

## 8. Retención

Se propone conservar:

- Los últimos 7 backups diarios.
- Los últimos 4 backups semanales.
- Los últimos 3 backups mensuales.

Los respaldos antiguos podrán eliminarse de acuerdo con la política de retención definida.

## 9. Responsabilidad

La administración y verificación de los respaldos estará a cargo del responsable técnico de la aplicación.

## 10. Conclusión

El plan de backups permite reducir el riesgo de pérdida de información y establece un procedimiento básico para recuperar la base de datos y restablecer el funcionamiento de la API REST en caso de fallos.