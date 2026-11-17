<script setup lang="ts">
</script>

<template>
  <main class="home">
    <section class="hero">
      <h1>🏋️ Generador de rutinas con IA</h1>
      <p>Crea tu rutina personalizada rellenando unos pocos campos.</p>
      <RouterLink to="/rutina" class="btn">Ir al generador</RouterLink>
    </section>
  </main>
</template>

<style scoped>
.home {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
  padding: 2rem;
}

.hero {
  text-align: center;
  background: rgba(255, 255, 255, 0.05);
  border:​1px solid rgba(255, 255, 255,​0.1);
  border-radius:​1.5rem;
  padding:​3.5rem 3rem;
  max-width:​36rem;
  box-shadow:​0 20px 60px rgba(0,​0,​0,​0.4);
}

.hero h1 {
  color: #f8fafc;
  font-size:​2.5rem;
  margin:​0 0 1rem;
}

.hero p {
  color: #94a3b8;
  font-size:​1.1rem;
  margin-bottom:​2rem;
}

.btn {
  display: inline-block;
  padding:​0.9rem 2.2rem;
  background: linear-gradient(135deg, #22c55e, #16a34a);
  color: white;
  text-decoration: none;
  border-radius:​0.75rem;
  font-weight: 600;
}

</style>