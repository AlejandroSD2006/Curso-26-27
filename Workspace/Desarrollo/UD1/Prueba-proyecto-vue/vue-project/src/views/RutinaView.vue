<script setup lang="ts">
import { ref } from 'vue'

const tipo = ref('Torso')
const objetivo = ref('Volumen')
const dias = ref(3)
const respuesta = ref('')
const cargando = ref(false)

async function generarRutina() {
  cargando.value = true
  try {
    const res = await fetch('/api/rutina', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        tipo: tipo.value,
        objetivo: objetivo.value,
        dias: dias.value
      })
    })
    const data = await res.json()
    if (!res.ok) {
      throw new Error(data.error || 'Error al generar la rutina.')
    }
    respuesta.value = data.respuesta
  } catch (error) {
    respuesta.value = error instanceof Error
      ? error.message
      : 'Error al generar la rutina. Inténtalo de nuevo.'
  } finally {
    cargando.value = false
  }
}
</script>

<template>
  <main class="page">
    <div class="card">
      <h1>Generador de rutinas</h1>
      <p class="subtitle">Rellena los campos y deja que la IA haga el resto</p>

      <form @submit.prevent="generarRutina" class="form">
        <label>
          <span>Tipo de entrenamiento</span>
          <select v-model="tipo">
            <option>Torso</option>
            <option>Pierna</option>
            <option>Full body</option>
            <option>Push / Pull</option>
          </select>
        </label>

        <label>
          <span>¿Qué ganancia quieres?</span>
          <select v-model="objetivo">
            <option>Volumen</option>
            <option>Definición</option>
            <option>Fuerza</option>
            <option>Resistencia</option>
          </select>
        </label>

        <label>
          <span>Rango de días</span>
          <select v-model="dias">
            <option :value="2">2</option>
            <option :value="3">3</option>
            <option :value="4">4</option>
            <option :value="5">5</option>
          </select>
        </label>

        <button type="submit" :disabled="cargando" class="btn">
          {{ cargando ? 'Generando...' : 'Generar rutina' }}
        </button>
      </form>

      <section v-if="respuesta" class="result">
        <h2>Tu rutina</h2>
        <pre>{{ respuesta }}</pre>
      </section>
    </div>
  </main>
</template>

<style scoped>
.page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  padding: 2rem;
}

.card {
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 1.5rem;
  padding: 2.5rem;
  width: 100%;
  max-width: 34rem;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
}

.card h1 {
  color: #f8fafc;
  margin: 0 0 0.5rem;
  font-size: 1.8rem;
}

.subtitle {
  color: #94a3b8;
  margin: 0 0 2rem;
}

.form {
  display: flex;
  flex-direction: column;
  gap: 1.2rem;
}

label {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

label span {
  color: #cbd5e1;
  font-weight: 500;
  font-size: 0.95rem;
}

select {
  background: #1e293b;
  border: 1px solid #334155;
  color: #f8fafc;
  border-radius: 0.6rem;
  padding: 0.8rem 1rem;
  font-size: 1rem;
  cursor: pointer;
  transition: border-color 0.2s;
}

select:focus {
  outline: none;
  border-color: #22c55e;
}

.btn {
  margin-top: 0.5rem;
  padding: 0.9rem;
  background: linear-gradient(135deg, #22c55e, #16a34a);
  color: white;
  border: none;
  border-radius: 0.75rem;
  font-size: 1.05rem;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 10px 30px rgba(34, 197, 94, 0.35);
  transition: transform 0.2s, box-shadow 0.2s;
}

.btn:hover:not(:disabled) {
  transform: translateY(-2px);
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.result {
  margin-top: 2rem;
  border-top: 1px solid #334155;
  padding-top: 1.5rem;
}

.result h2 {
  color: #f8fafc;
  font-size: 1.2rem;
  margin: 0 0 1rem;
}

pre {
  background: #0f172a;
  border: 1px solid #334155;
  border-radius: 0.75rem;
  padding: 1.2rem;
  color: #e2e8f0;
  white-space: pre-wrap;
  font-family: inherit;
  line-height: 1.6;
}

</style>
