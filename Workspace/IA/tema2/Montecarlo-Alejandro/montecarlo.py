import math
import random
# Parámetros del problema
V_objetivo = 330.0 # Volumen en cm^3 (330 ml)
N = 30 # Número de muestras aleatorias
# Restricciones del radio
r_min = 1.5
r_max = 8.0
# Inicializamos las variables para guardar el mejor resultado
# Comenzamos con un área "infinita" para asegurarnos de que cualquier cálculo inicial sea menor
mejor_area = float('inf')
mejor_r = 0.0
mejor_h = 0.0
# Fijamos la semilla
random.seed(42)
# Bucle de Montecarlo
for _ in range(N):
 # 1. Generar un radio aleatorio uniforme entre r_min y r_max
 r = random.uniform(r_min, r_max)

 # 2. Calcular la altura necesaria para mantener el volumen constante
 h = V_objetivo / (math.pi * r**2)

 # 3. Calcular la superficie total de aluminio para este r e h
 area = 2 * math.pi * r**2 + 2 * math.pi * r * h

 # 4. Verificar si es la menor superficie encontrada hasta el momento
 if area < mejor_area:
    mejor_area = area
    mejor_r = r
    mejor_h = h

    print(f"Nuevo mejor resultado encontrado: Radio = {mejor_r:.8f} cm, Altura = {mejor_h:.8f} cm, Área = {mejor_area:.8f} cm²")


N2 = 8000
r_min2 = mejor_r - 1.50
r_max2 = mejor_r + 1.50
for _ in range(N2):
 # 1. Generar un radio aleatorio uniforme entre r_min y r_max
 r = random.uniform(r_min2, r_max2)

 # 2. Calcular la altura necesaria para mantener el volumen constante
 h = V_objetivo / (math.pi * r**2)

 # 3. Calcular la superficie total de aluminio para este r e h
 area = 2 * math.pi * r**2 + 2 * math.pi * r * h

 # 4. Verificar si es la menor superficie encontrada hasta el momento
 if area < mejor_area:
    mejor_area = area
    mejor_r = r
    mejor_h = h

    print(f"Nuevo 2º mejor resultado encontrado: Radio = {mejor_r:.8f} cm, Altura = {mejor_h:.8f} cm, Área = {mejor_area:.8f} cm²")

# Impresión de resultados
# print(f"Radio óptimo: {mejor_r:.4f} cm")
# print(f"Altura óptima: {mejor_h:.4f} cm")
# print(f"Área mínima de aluminio: {mejor_area:.4f} cm²")