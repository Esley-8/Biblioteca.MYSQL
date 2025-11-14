const express = require('express');
const cors = require('cors');
const db = require('./conexion');

const app = express();
app.use(cors());
app.use(express.json());

// Ruta para buscar libros
app.get('/buscar', async (req, res) => {
  const { titulo = '', autor = '' } = req.query;

  try {
    const [rows] = await db.query(
      'SELECT * FROM libros WHERE titulo LIKE ? OR autor LIKE ?',
      [`%${titulo}%`, `%${autor}%`]
    );

    if (rows.length > 0) {
      res.json({ encontrado: true, libro: rows[0] });
    } else {
      res.json({ encontrado: false });
    }
  } catch (error) {
    console.error('❌ Error en la consulta:', error);
    res.status(500).json({ error: 'Error en la consulta a MySQL' });
  }
});

// Ruta para agregar libros
app.post('/agregar', async (req, res) => {
  const { titulo, autor } = req.body;

  try {
    const [result] = await db.query(
      'INSERT INTO libros (titulo, autor) VALUES (?, ?)',
      [titulo, autor]
    );
    res.json({ agregado: true, id: result.insertId });
  } catch (error) {
    console.error('❌ Error al insertar:', error);
    res.status(500).json({ error: 'Error al agregar el libro a MySQL' });
  }
});

app.listen(3000, () => {
  console.log('🚀 Servidor conectado a MySQL y escuchando en el puerto 3000');
});
