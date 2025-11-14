async function buscarLibro() {
  const titulo = document.getElementById('titulo').value.trim();
  const autor = document.getElementById('autor').value.trim();
  const resultado = document.getElementById('resultado');
  const agregarBtn = document.getElementById('agregarBtn');

  try {
    const res = await fetch(`http://localhost:3000/buscar?titulo=${encodeURIComponent(titulo)}&autor=${encodeURIComponent(autor)}`);
    const data = await res.json();

    if (data.encontrado) {
      resultado.innerHTML = `<strong>${data.libro.titulo}</strong> por <em>${data.libro.autor}</em>`;
      agregarBtn.classList.add('hidden');
    } else {
      resultado.innerHTML = `No se encuentra el libro, pero puedes agregarlo a la biblioteca.`;
      agregarBtn.classList.remove('hidden');
    }
  } catch (error) {
    resultado.innerHTML = `Error al conectar con la biblioteca cósmica.`;
    agregarBtn.classList.add('hidden');
  }
}

async function agregarLibro() {
  const titulo = document.getElementById('titulo').value.trim();
  const autor = document.getElementById('autor').value.trim();
  const resultado = document.getElementById('resultado');
  const agregarBtn = document.getElementById('agregarBtn');

  try {
    const res = await fetch('http://localhost:3000/agregar', { // <-- Ajusta según tu API real
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ titulo, autor })
    });

    const data = await res.json();

    if (data.agregado) {
      resultado.innerHTML = `Libro agregado con éxito. ID: ${data.id}`;
      agregarBtn.classList.add('hidden');
    } else {
      resultado.innerHTML = `No se pudo agregar el libro.`;
    }
  } catch (error) {
    resultado.innerHTML = `Error al intentar agregar el libro.`;
  }
}

function limpiarCampos() {
  document.getElementById('titulo').value = '';
  document.getElementById('autor').value = '';
  document.getElementById('resultado').innerHTML = '';
  document.getElementById('agregarBtn').classList.add('hidden');
}

function regresar() {
  window.history.back();
}

