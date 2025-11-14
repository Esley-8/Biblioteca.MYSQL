
 
tbody.addEventListener("click", async (e) => { 
  const t = e.target; 
  if (t.matches(".edit")) { 
    const id = t.getAttribute("data-id"); 
    const row = t.closest("tr"); 
    inputId.value = id; 
    inputTitulo.value = row.children[1].textContent; 
    // Buscamos el autor por texto en el select 
    const autorNombre = row.children[2].textContent; 
    const option = Array.from(selectAutor.options).find(o => o.textContent 
=== autorNombre); 
    if (option) selectAutor.value = option.value; 
    inputTitulo.focus(); 
  } 
  if (t.matches(".delete")) { 
    const id = t.getAttribute("data-id"); 
    if (!confirm("¿Eliminar este libro?")) return; 
    const res = await fetch($ (API)/$ (id), { method: "DELETE" }); 
    if (res.ok) { 
      await loadBooks(); 
    } else { 
      alert("Error al eliminar libro"); 
    } 
  } 
}); 
 
form.addEventListener("submit", async (e) => { 
  e.preventDefault(); 
  const payload = { 
    titulo: inputTitulo.value.trim(), 
    autorId: Number(selectAutor.value), 
  }; 
  const id = inputId.value; 
  const isEdit = Boolean(id); 
  const res = await fetch(isEdit ? $(API)/$(id0): { 
    method: isEdit ? "PUT" : "POST", 
    headers: { "Content-Type": "application/json" }, 
    body: JSON.stringify(payload), 
  }); 
  if (res.ok) { 
    form.reset(); 
    inputId.value = ""; 
    await loadBooks(); 
  } else { 
    const { message } = await res.json().catch(() => ({ message: "Error" 
})); 
    alert(message || "Ocurrió un error"); 
  } 
}); 
 
btnReset.addEventListener("click", () => { 
  form.reset(); 
  inputId.value = ""; 
}); 
 
btnReload.addEventListener("click", loadBooks); 
 
Promise.all([loadAutores(), loadBooks()]);