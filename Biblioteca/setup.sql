{
  "name": "biblioteca",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC",
  "description": "",
  "dependencies": {
    "cors": "^2.8.5",
    "mysql2": "^3.15.3"
  }
}
import mysql from "mysql2";
import dotenv from 'dotenv'; // Cargar variables de entorno desde .env

// Cargar variables de entorno (si existe un .env en la raíz)
dotenv.config();

// --- Tu Script SQL ---
// Pega el SQL de creación/seed aquí. Es idempotente (usa IF NOT EXISTS y checks antes de insertar).
const sqlScript = `
CREATE TABLE IF NOT EXISTS autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS libros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    autor_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (autor_id) REFERENCES autores(id)
    ON DELETE SET NULL
);

-- Insertar autores (solo si la tabla está vacía)
INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Alex Roce') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Alex Roce');

INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Joana Jones') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Joana Jones');

INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Imma Clenee') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Imma Clenee');

INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Maria Jose Paz') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Maria Jose Paz');

INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Dalex Chese') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Dalex Chese');

INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Joex Rose') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Joex Rose');

INSERT INTO autores (nombre)
SELECT * FROM (SELECT 'Jose Urbina') AS tmp
WHERE NOT EXISTS (SELECT nombre FROM autores WHERE nombre = 'Jose Urbina');


-- Insertar libros (solo si la tabla está vacía)
INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'El Arte De Ser Nosotros', 1) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'El Arte De Ser Nosotros');

INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'Estrellas En l Firmamento', 1) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'Estrellas En l Firmamento');

INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'Harry Potter', 2) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'Harry Potter');

INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'Rapidos Y Furiosos', 3) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'Rapidos Y Furioso');

INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'La Casa De Pepel', 4) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'La Casa De Pepel');

INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'Mi Pobre Angelito', 5) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'Mi Pobre Angelito');

INSERT INTO libros (titulo, autor_id)
SELECT * FROM (SELECT 'Titanic', 5) AS tmp
WHERE NOT EXISTS (SELECT titulo FROM libros WHERE titulo = 'Titanic');
`;
// --- Fin del Script SQL ---


// Configuración de la base de datos (variables de entorno con valores por defecto)
const dbUser = process.env.DB_USER || 'u6wkvkpw4poxudss';
const dbHost = process.env.DB_HOST || 'bim9emuljnocj9iulykp-mysql.services.clever-cloud.com';
const dbPassword = process.env.DB_PASSWORD || 'jea0TCmCfTc1FSNwgyRQ';
const dbName = process.env.DB_NAME || 'bim9emuljnocj9iulykp';
const dbPort = process.env.DB_PORT || 3306;

const connection = mysql.createConnection({
  host: dbHost,
  user: dbUser,
  password: dbPassword,
  database: dbName,
  port: Number(dbPort),
  multipleStatements: true // Permite ejecutar el script SQL completo
});

/*
  Nota: este script ejecuta las sentencias SQL al iniciar la conexión.
  - Si prefieres ejecutar la creación/seed sólo una vez, envuelve la ejecución
    en una comprobación externa o coméntala después de la primera ejecución.
  - Variables de entorno esperadas (añadir un archivo .env en la raíz):
      DB_HOST=localhost
      DB_USER=root
      DB_PASSWORD=tu_password
      DB_NAME=biblioteca
      DB_PORT=3306
*/

connection.connect((err) => {
  if (err) {
    console.error("❌ Error al conectar a MySQL:", err.message);
    console.error("Soluciones posibles:");
    console.error("1. Verifica que MySQL esté ejecutándose");
    console.error("2. Revisa las variables de entorno en .env o en tu entorno");
    console.error("3. Crea la base de datos si no existe: CREATE DATABASE biblioteca;");
    process.exit(1);
  }

  console.log("✅ Conexión exitosa a MySQL ✅");

  // Ejecutar script de creación/seed (idempotente)
  console.log("Creando tablas e insertando datos (si es necesario)...");
  connection.query(sqlScript, (err, results) => {
    if (err) {
      console.error("Error al ejecutar el script SQL:", err.message);
    } else {
      console.log("Tablas creadas y datos insertados (si procedía).\n");
    }

    // NOTA: No cerramos la conexión aquí para que el resto de la app pueda usarla.
    // Si quieres cerrarla después del setup, descomenta la siguiente línea:
    // connection.end();
  });
});

export default connection;