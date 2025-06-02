CREATE DATABASE IF NOT EXISTS tipsdata_db;
USE tipsdata_db;
USE tipsdata_db;

-- Tabla para los partidos (Big Data y Análisis IA)
CREATE TABLE IF NOT EXISTS matches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    home_team VARCHAR(255) NOT NULL,
    away_team VARCHAR(255) NOT NULL,
    league VARCHAR(255),
    match_date VARCHAR(255), -- Podrías usar DATE si quieres un formato de fecha real, pero VARCHAR es más simple por ahora
    home_form VARCHAR(255),
    home_goals_scored DECIMAL(4,2),
    home_goals_conceded DECIMAL(4,2),
    home_clean_sheets INT,
    home_avg_corners DECIMAL(4,2),
    away_form VARCHAR(255),
    away_goals_scored DECIMAL(4,2),
    away_goals_conceded DECIMAL(4,2),
    away_clean_sheets INT,
    away_avg_corners DECIMAL(4,2),
    h2h_home_wins INT,
    h2h_draws INT,
    h2h_away_wins INT,
    h2h_last5 TEXT, -- Almacenar como texto, quizás JSON string si hay muchos detalles
    ai_analysis TEXT -- Para el texto del análisis IA
);

-- Tabla para las predicciones
CREATE TABLE IF NOT EXISTS predictions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    match_id INT, -- Relaciona con la tabla 'matches' si quieres más detalle
    home_team VARCHAR(255) NOT NULL,
    away_team VARCHAR(255) NOT NULL,
    prediction_type VARCHAR(255) NOT NULL, -- 'favoritos', 'over25', 'corners', 'btts'
    odds DECIMAL(5,2),
    confidence INT, -- 1 a 5 estrellas
    analysis TEXT, -- Análisis breve de la predicción
    FOREIGN KEY (match_id) REFERENCES matches(id) ON DELETE SET NULL
);
INSERT INTO matches (home_team, away_team, league, match_date, home_form, home_goals_scored, home_goals_conceded, home_clean_sheets, home_avg_corners, away_form, away_goals_scored, away_goals_conceded, away_clean_sheets, away_avg_corners, h2h_home_wins, h2h_draws, h2h_away_wins, h2h_last5, ai_analysis) VALUES
('Atlético Estrellas', 'Dinamo FC', 'Liga Nacional', '31 Mayo', 'WWDLW', 2.1, 0.8, 6, 5.8, 'LDDWL', 1.2, 1.9, 2, 4.5, 3, 2, 1, 'H 2-0 A, A 1-1 H, H 3-1 A, A 0-2 H, H 1-0 A', 'Atlético Estrellas en casa es una fortaleza (78% prob. de ganar) por su defensa y la forma del oponente. Prevemos -3.5 goles. Alto promedio de córners para el local.'),
('Real Cosmos', 'FC Gladiadores', 'Primera División', '31 Mayo', 'DDWWW', 1.9, 1.0, 4, 6.2, 'LLDDW', 0.9, 2.1, 1, 3.9, 4, 1, 0, 'H 3-0 A, A 2-2 H, H 1-0 A, A 0-1 H, H 2-0 A', 'Real Cosmos muestra una racha dominante en casa (85% prob. de victoria), impulsado por su efectividad ofensiva. Los visitantes luchan con la portería a cero y defensas. Posible Over 2.5.'),
('Unión Verde', 'Club Marrón', 'Serie A', '31 Mayo', 'WLWWL', 1.5, 1.2, 3, 5.0, 'WLWLW', 1.6, 1.3, 2, 4.8, 2, 3, 1, 'H 1-1 A, A 2-1 H, H 0-0 A, A 1-2 H, H 1-1 A', 'Partido muy parejo según IA (Empate 35% prob.). Ambos equipos tienen tendencias ofensivas similares. Alta probabilidad de Ambos Marcan y más de 8.5 córners.'),
('Deportivo Naranja', 'Rayo Azul', 'Bundesliga', '31 Mayo', 'WWWWL', 2.5, 0.7, 7, 6.5, 'LLLLD', 0.7, 2.8, 0, 3.2, 5, 0, 0, 'H 4-0 A, A 0-3 H, H 2-0 A, A 1-4 H, H 5-1 A', 'Deportivo Naranja es un claro favorito (90% prob. victoria). Rayo Azul en crisis. Se espera una goleada y más de 3.5 goles para el local. El Hándicap -1.5 es atractivo.'),
('Fénix Dorado', 'Titán Negro', 'Ligue 1', '31 Mayo', 'DLDWW', 1.4, 1.1, 3, 4.7, 'WWDLW', 1.8, 0.9, 5, 5.5, 1, 2, 3, 'H 1-2 A, A 1-1 H, H 0-1 A, A 2-0 H, H 2-2 A', 'Partido con tendencia a la visita (Titán Negro 55% prob. de ganar). Fénix Dorado lucha en casa. Pocos goles esperados, Under 2.5 podría ser un pick de valor.'),
('Pumas Rojos', 'Jaguares Azules', 'MLS', '31 Mayo', 'WLDLD', 1.3, 1.5, 2, 4.9, 'WWDLL', 1.7, 1.4, 3, 5.3, 2, 1, 2, 'H 1-0 A, A 2-2 H, H 1-2 A, A 3-1 H, H 0-1 A', 'Un clásico divisional. IA prevé un partido abierto (Ambos Marcan 68% prob.). Las defensas no son su fuerte y los ataques son inconsistentes pero capaces. Más de 9.5 córners.'),
('Leones Verdes', 'Águilas Amarillas', 'Liga MX', '31 Mayo', 'WWWWL', 2.3, 0.6, 7, 6.0, 'LLLLD', 0.8, 2.5, 1, 3.5, 5, 0, 0, 'H 3-0 A, A 1-2 H, H 4-1 A, A 0-2 H, H 2-0 A', 'Leones Verdes es la máquina de ganar en casa (88% prob. de victoria). Águilas Amarillas está en caída libre. Se espera un partido con muchos goles del local y quizás un hándicap -1.5 para Leones.'),
('Dragones Azules', 'Grifos Rojos', 'Liga Portuguesa', '31 Mayo', 'DLDWW', 1.6, 1.0, 4, 5.2, 'WDDLW', 1.5, 1.2, 3, 4.8, 2, 3, 1, 'H 1-1 A, A 2-2 H, H 0-0 A, A 1-0 H, H 2-1 A', 'Un empate es el resultado más probable según la IA (40% prob.). Ambos equipos tienen un rendimiento similar y un historial de empates en H2H. Under 2.5 y BTTS NO son opciones a considerar.'),
('Lobos Blancos', 'Ciervos Negros', 'Eredivisie', '31 Mayo', 'LWWLL', 1.1, 1.8, 1, 4.0, 'WWWWD', 2.2, 0.7, 6, 6.3, 1, 1, 3, 'H 0-2 A, A 1-3 H, H 1-1 A, A 0-1 H, H 2-0 A', 'Ciervos Negros es el claro favorito fuera de casa (65% prob. de victoria). Lobos Blancos está en muy mala forma. IA prevé un partido con más de 2.5 goles, mayoritariamente de los visitantes.'),
('Ángeles Verdes', 'Demonios Rojos', 'J-League', '31 Mayo', 'WDLDW', 1.7, 1.1, 3, 5.5, 'DLWWL', 1.4, 1.5, 2, 4.0, 2, 2, 1, 'H 2-1 A, A 0-0 H, H 1-1 A, A 3-2 H, H 1-0 A', 'Partido que la IA ve como un potencial empate (45% prob.) o una victoria ajustada del local. Ambos equipos marcan con frecuencia. Los córners podrían ser un mercado interesante por su estilo de juego.');
-- Para 'favoritos'
INSERT INTO predictions (home_team, away_team, prediction_type, odds) VALUES
('FC Barcelona', 'Deportivo Alavés', 'favoritos', 1.25),
('Manchester United', 'Crystal Palace', 'favoritos', 1.40),
('Borussia Dortmund', 'Mainz 05', 'favoritos', 1.30),
('Inter de Milán', 'Genoa', 'favoritos', 1.33),
('Ajax', 'FC Utrecht', 'favoritos', 1.20),
('Porto', 'Boavista', 'favoritos', 1.28),
('Benfica', 'Estoril', 'favoritos', 1.22),
('Atlético Mineiro', 'Cuiabá', 'favoritos', 1.45),
('River Plate', 'Talleres', 'favoritos', 1.38),
('LA Galaxy', 'San Jose Earthquakes', 'favoritos', 1.60);

-- Para 'over25'
INSERT INTO predictions (home_team, away_team, prediction_type, odds) VALUES
('Bayern Múnich', 'Werder Bremen', 'over25', 1.55),
('Napoli', 'Fiorentina', 'over25', 1.70),
('Arsenal', 'Leicester City', 'over25', 1.65),
('PSV Eindhoven', 'Vitesse', 'over25', 1.50),
('Real Betis', 'Rayo Vallecano', 'over25', 1.80),
('Hoffenheim', 'Freiburg', 'over25', 1.68),
('Marsella', 'Montpellier', 'over25', 1.72),
('Grêmio', 'Fortaleza', 'over25', 1.85),
('Fluminense', 'Coritiba', 'over25', 1.78),
('Seattle Sounders', 'Portland Timbers', 'over25', 1.62);

-- Para 'corners'
INSERT INTO predictions (home_team, away_team, prediction_type, odds) VALUES
('Tottenham', 'Everton', 'corners', 1.70),
('West Ham', 'Wolves', 'corners', 1.85),
('Sevilla', 'Celta Vigo', 'corners', 1.78),
('Monaco', 'Reims', 'corners', 1.90),
('Villarreal', 'Athletic Bilbao', 'corners', 1.82),
('Leipzig', 'Union Berlin', 'corners', 1.77),
('Sporting CP', 'Braga', 'corners', 1.92),
('Santos', 'Botafogo', 'corners', 1.88),
('Charlotte FC', 'Atlanta United', 'corners', 1.75),
('Dynamo Kyiv', 'Shakhtar Donetsk', 'corners', 1.95);

-- Para 'btts'
INSERT INTO predictions (home_team, away_team, prediction_type, odds) VALUES
('Aston Villa', 'Brighton', 'btts', 1.80),
('Fenerbahçe', 'Galatasaray', 'btts', 1.75),
('Valencia', 'Getafe', 'btts', 1.95),
('Lille', 'Rennes', 'btts', 1.85),
('Eintracht Frankfurt', 'Augsburg', 'btts', 1.90),
('Boca Juniors', 'Racing Club', 'btts', 1.83),
('Atlético Nacional', 'Millonarios', 'btts', 1.98),
('Vasco da Gama', 'Bahia', 'btts', 1.87),
('New York City FC', 'Philadelphia Union', 'btts', 1.82),
('Al Ahly', 'Zamalek', 'btts', 1.77);