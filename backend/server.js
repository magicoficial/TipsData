// server.js
require('dotenv').config(); // Carga las variables de entorno desde .env

const express = require('express');
const mysql = require('mysql2/promise'); // Usamos la versión de promesas para async/await
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000; // El puerto en el que correrá tu API

// Middleware para habilitar CORS
// Esto es CRÍTICO para que tu frontend pueda hacer peticiones al backend
app.use(cors({
    origin: '*', // Permitir cualquier origen por ahora (¡solo para desarrollo!)
                 // En producción, deberías cambiar esto a la URL de tu frontend,
                 // ej. 'https://tudominio.com' o ['https://tudominio.com', 'http://localhost:80']
}));

// Middleware para parsear JSON en el cuerpo de las peticiones
app.use(express.json());

// Configuración de la conexión a la base de datos MySQL
const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '', // ¡Cambia esto a tu contraseña de MySQL!
    database: process.env.DB_NAME || 'tipsdata_db'
};

let pool; // Usaremos un pool de conexiones para mejor rendimiento

async function connectDb() {
    try {
        pool = mysql.createPool(dbConfig);
        await pool.getConnection(); // Intenta obtener una conexión para verificar que funciona
        console.log('Conexión a la base de datos MySQL establecida correctamente.');
    } catch (err) {
        console.error('Error al conectar a la base de datos:', err.message);
        console.error('Detalles de la configuración de DB:', dbConfig);
        // Salir del proceso si no se puede conectar a la DB (crítico para la aplicación)
        process.exit(1);
    }
}

// Rutas de la API

// Ruta para obtener todos los partidos (Big Data y Análisis IA)
app.get('/api/matches', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM matches');
        // Convertir el formato de los datos para que coincida con el frontend si es necesario
        const formattedMatches = rows.map(match => ({
            id: match.id,
            homeTeam: match.home_team,
            awayTeam: match.away_team,
            league: match.league,
            date: match.match_date,
            homeStats: {
                form: match.home_form,
                goalsScored: parseFloat(match.home_goals_scored),
                goalsConceded: parseFloat(match.home_goals_conceded),
                cleanSheets: match.home_clean_sheets,
                avgCorners: parseFloat(match.home_avg_corners)
            },
            awayStats: {
                form: match.away_form,
                goalsScored: parseFloat(match.away_goals_scored),
                goalsConceded: parseFloat(match.away_goals_conceded),
                cleanSheets: match.away_clean_sheets,
                avgCorners: parseFloat(match.away_avg_corners)
            },
            h2h: {
                homeWins: match.h2h_home_wins,
                draws: match.h2h_draws,
                awayWins: match.h2h_away_wins,
                last5: match.h2h_last5 ? match.h2h_last5.split(', ') : [] // Asumiendo que guardaste como "A, B, C"
            },
            aiAnalysis: match.ai_analysis
        }));
        res.json(formattedMatches);
    } catch (err) {
        console.error('Error al obtener partidos:', err);
        res.status(500).json({ message: 'Error interno del servidor al obtener partidos.' });
    }
});

// Ruta para obtener predicciones por tipo
app.get('/api/predictions', async (req, res) => {
    const { type } = req.query; // Obtener el tipo de predicción del query parameter (ej. /api/predictions?type=favoritos)

    if (!type) {
        return res.status(400).json({ message: 'El parámetro "type" es requerido.' });
    }

    try {
        const [rows] = await pool.query('SELECT * FROM predictions WHERE prediction_type = ?', [type]);
        const formattedPredictions = rows.map(pred => ({
            home: pred.home_team,
            away: pred.away_team,
            odds: parseFloat(pred.odds).toFixed(2), // Formatear a 2 decimales
            prediction: pred.prediction_text, // Si tuvieras un campo de texto para la predicción
            confidence: pred.confidence,
            analysis: pred.analysis
        }));
        res.json(formattedPredictions);
    } catch (err) {
        console.error(`Error al obtener predicciones de tipo ${type}:`, err);
        res.status(500).json({ message: 'Error interno del servidor al obtener predicciones.' });
    }
});


// Inicia el servidor después de conectar a la base de datos
connectDb().then(() => {
    app.listen(PORT, () => {
        console.log(`Servidor Express escuchando en el puerto ${PORT}`);
        console.log(`Accede a la API de partidos en: http://localhost:${PORT}/api/matches`);
        console.log(`Accede a la API de predicciones en: http://localhost:${PORT}/api/predictions?type=favoritos`);
    });
});