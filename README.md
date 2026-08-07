# Colegio San Marcos - API Backend

API REST para la gestión académica del Colegio San Marcos, construida con **Node.js**, **Express 5**, **Prisma ORM** y **PostgreSQL**. Permite administrar alumnos y manejar autenticación de usuarios (registro, login y roles) mediante JWT.

## Tecnologías

- Node.js (ES Modules)
- Express 5
- Prisma ORM + `@prisma/adapter-pg`
- PostgreSQL
- JSON Web Tokens (`jsonwebtoken`)
- Bcrypt (`bcryptjs`) para hash de contraseñas

## Requisitos previos

- Node.js 18 o superior
- PostgreSQL 14 o superior instalado y corriendo localmente (o accesible remotamente)
- npm

## Instalación

1. Clonar el repositorio:

   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd colegio_san_marcos
   ```

2. Instalar dependencias:

   ```bash
   npm install
   ```

3. Crear el archivo de variables de entorno a partir del ejemplo:

   ```bash
   cp .env.example .env
   ```

   Luego editar `.env` con tus propios valores:

   ```env
   PORT=3000
   API_KEY=tu_api_key
   DATABASE_URL="postgresql://usuario:password@localhost:5432/colegio_san_marcos"
   JWT_SECRET=un_secreto_largo_y_aleatorio
   ```

4. Crear la base de datos en PostgreSQL:

   ```bash
   createdb colegio_san_marcos
   ```

5. Cargar el esquema y los datos semilla (seed):

   ```bash
   psql -U <usuario> -d colegio_san_marcos -f database/schema.sql
   ```

   Esto crea las tablas `alumnos` y `usuarios`, y agrega datos de ejemplo, incluyendo un usuario administrador de prueba.

   > **Alternativa con Prisma:** si prefieres generar el esquema desde `prisma/schema.prisma` en lugar del script SQL manual, puedes correr `npx prisma migrate dev` (requiere que `DATABASE_URL` esté configurado). El archivo `database/schema.sql` se mantiene como entregable independiente y como forma rápida de levantar la base de datos sin depender de Prisma CLI.

6. Iniciar el servidor en modo desarrollo:

   ```bash
   npm run dev
   ```

   El servidor quedará disponible en `http://localhost:3000` (o el puerto configurado en `.env`).

## Usuario de prueba (seed)

| Email                                 | Password    | Rol         |
|----------------------------------------|-------------|-------------|
| admin@colegiosanmarcos.edu.sv          | Admin123!   | ADMIN       |
| ana.lopez@colegiosanmarcos.edu.sv      | Admin123!   | COORDINADOR |

> Estas credenciales son solo para desarrollo/pruebas. No usarlas en producción.

## Endpoints principales

### Autenticación (`/api/auth`)

| Método | Ruta                     | Descripción                              | Requiere token |
|--------|--------------------------|-------------------------------------------|----------------|
| POST   | `/api/auth/registrar`    | Registra un nuevo usuario                 | No             |
| POST   | `/api/auth/login`        | Inicia sesión y devuelve un JWT           | No             |
| POST   | `/api/auth/cambiar-password` | Cambia la contraseña del usuario     | Sí             |
| GET    | `/api/auth/perfil`       | Devuelve el perfil del usuario autenticado| Sí             |
| GET    | `/api/auth/usuarios`     | Lista todos los usuarios                  | Sí             |

**Ejemplo - Login:**

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@colegiosanmarcos.edu.sv","password":"Admin123!"}'
```

### Alumnos (`/api/alumnos`)

| Método | Ruta                | Descripción                              |
|--------|---------------------|--------------------------------------------|
| GET    | `/api/alumnos`      | Lista todos los alumnos (filtro opcional `?grado=`) |
| GET    | `/api/alumnos/:id`  | Obtiene un alumno por ID                  |
| POST   | `/api/alumnos`      | Crea un nuevo alumno                      |
| PUT    | `/api/alumnos/:id`  | Actualiza campos de un alumno             |
| DELETE | `/api/alumnos/:id`  | Elimina un alumno                         |

**Ejemplo - Crear alumno:**

```bash
curl -X POST http://localhost:3000/api/alumnos \
  -H "Content-Type: application/json" \
  -d '{"nombre":"Pedro","apellido":"Alvarado","grado":"2do Grado","seccion":"A"}'
```

## Estructura del proyecto

```
colegio_san_marcos/
├── database/
│   └── schema.sql              # Esquema + seed de la base de datos
├── prisma/
│   └── schema.prisma           # Modelo de datos (Prisma)
├── src/
│   ├── config/
│   │   └── prisma.js           # Instancia de PrismaClient (adapter-pg)
│   ├── routes/
│   │   ├── alumno.routes.js
│   │   └── auth.routes.js
│   ├── controllers/
│   │   ├── alumno.controller.js
│   │   └── auth.controller.js
│   ├── services/
│   │   ├── alumno.service.js
│   │   └── auth.service.js
│   ├── repositories/
│   │   ├── alumno.repository.js
│   │   └── usuario.repository.js
│   ├── middlewares/
│   │   ├── apiKey.js           # Protege rutas con x-api-key
│   │   ├── auth.js             # requireAuth: valida JWT
│   │   ├── requireRole.js      # Restringe acceso por rol
│   │   └── errorHandler.js     # Manejo centralizado de errores
│   ├── errors/
│   │   └── appError.js         # Clase de error personalizada
│   └── utils/
│       ├── password.js         # Hash y comparación (bcrypt)
│       └── token.js            # Firma y verificación de JWT
├── index.js                    # Punto de entrada de la app
├── prisma.config.js             # Configuración de Prisma
├── .env.example
└── README.md
```

### Middlewares de protección

| Middleware      | Uso                                                              |
|------------------|-------------------------------------------------------------------|
| `apiKey`         | Requiere header `x-api-key` (usado en creación/edición/borrado de alumnos) |
| `requireAuth`    | Requiere JWT válido en `Authorization: Bearer <token>`            |
| `requireRole()`  | Requiere que el usuario autenticado tenga uno de los roles indicados (ej. `ADMIN`) |

## Scripts disponibles

```bash
npm run dev    # Inicia el servidor con recarga automática (node --watch)
```
