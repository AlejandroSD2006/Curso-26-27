import { createRouter, createWebHistory } from 'vue-router'
import RutinaView from '../views/RutinaView.vue'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    { path: '/', name: 'home', component: HomeView },
    { path: '/rutina', name: 'rutina', component: RutinaView }
  ]
})

export default router
