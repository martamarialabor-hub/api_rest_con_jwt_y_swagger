import 'dotenv/config';
import express from 'express';
import { prisma } from './src/config/prisma.js';
import alumnosRoutes from './src/routes/alumno.routes.js';
import authRoutes from './src/routes/auth.routes.js';
import { errorHandler } from './src/middlewares/errorHandler.js';

const app = express();
const PORT = process.env.PORT ?? 3000;

app.use(express.json());

// Endpoint de monitoreo y estado de la base de datos
app.get('/health', async (req, res) => {
  try {
    await prisma.$queryRaw`SELECT 1`;

    res.status(200).json({
      status: 'ok',
      database: 'connected',
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    res.status(503).json({
      status: 'error',
      database: 'disconnected',
      timestamp: new Date().toISOString()
    });
  }
});

// Rutas para alumnos
app.use('/api/alumnos', alumnosRoutes);

// Rutas de autenticación
app.use('/api/auth', authRoutes);

// Captura cualquier solicitud que no coincida con las rutas definidas
app.use((req, res) => {
  res.status(404).json({
    error: 'Ruta no encontrada'
  });
});

// Middleware de manejo de errores
app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`Servidor corriendo en: http://localhost:${PORT}`);
});