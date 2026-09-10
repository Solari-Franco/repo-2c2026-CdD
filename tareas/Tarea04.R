# Librerias ------
library(nycflights13)
library(tidyverse)
library(dplyr)
library(tidyr)
library(tibble)
library(Lahman)
install.packages("maps")

# Visualización de datos y sus caracteristicas -----
?flights
View(flights)
print(flights, width = Inf)
glimpse(flights)

#Ejercicios Filas-----------
#1. ---------------
# Tuvo un retraso de llegada de dos o más horas
flights |> 
  filter(arr_delay >= 120)
##Voló a Houston (IAH o HOU )
flights |> 
  filter(dest %in% c("HOU","IAH"))
##Fueron operados por United, American o Delta
flights |>
  filter(carrier %in% c("UA", "AA", "DL"))
##Salió en verano (julio, agosto y septiembre)
flights |>
  filter(month %in% c(7, 8, 9))
##Llegó con más de dos horas de retraso pero no salió tarde
flights |>
  filter(arr_delay > 120 & dep_delay <= 0)
##Se retrasaron al menos una hora, pero recuperaron más de 30 minutos de vuelo
flights |>
  filter(dep_delay >= 60 & (dep_delay - arr_delay) > 30)
#2. ----------------
#Ordene los vuelos con los retrasos de salida más largos. Encuentra los vuelos que salieron más temprano en la mañana.
flights |> 
  arrange(desc(dep_delay))
#Encuentra los vuelos que salieron más temprano en la mañana.
flights |>
  arrange(dep_time) 
#3.----
flights |>
  mutate(air_time_hours = air_time / 60) |>
  arrange(air_time)
#4.Solo se queda una fila si hay un vuelo ese día; de haber 365 filas, ya que no es año viciesto es que hubo vuelo todos los días -----
flights |>
  distinct(month, day) |>
  nrow()== 365

#5 Vuelo más largo y más corto -----------
flights |>
  filter(distance == max(distance)) |>
  select(flight, carrier, origin, dest, distance)
#aclaración de que efectivamente hay una sola ruta más larga
flights |>
  filter(distance == max(distance)) |>
  distinct(origin, dest)
#ruta más corta
flights |>
  filter(distance == min(distance)) |>
  select(flight, carrier, origin, dest, distance)
#6. ------
#filter() ANTES de arrange() porque:
#Reduces el dataset primero
#Luego ordenas menos datos; Menos trabajo = más rápido



#Ejercicios Columnas------------------
#1.
#dep_time es la hora efectiva de salida
#sched_dep_time es el horario que estaba planeado en salir
#dep_delay es la diferencia entre el primero y segundo, la cual puede ser positiva si se atrasa el vuelo (dep_time>sched_dep_time) o negativo (inversa); hay que tener cuidado si el vuelo esta planeado antes de medianoche y sale luego de la misma pq se rompe la relación y hay q plantear un operador en el medio
#3.
#Nada, el sistema hace una tibble con el numero de columnas que no se repite, no duplica la columna
#4.
variables <- c("year", "month", "day", "dep_delay", "arr_delay")

flights |>
  select(any_of(variables)) #la función any_of recorta la tabla a las variables unicamente nombradas arriba. El vector variables le asigna que columnas tomar
#5.
flights |> select(contains("TIME")) #toma todos las columnas con time, sin distinguir si estan en mayuscula o minuscula; si se quiere discriminar se debe agregar un operador extra
#6. Rename y mover adelante de todo
flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min)

flights |> 
  select(tailnum) |> 
  arrange(arr_delay)
#el problema es que a traves de la funcion select te quedas unicamente con la columna tailnum y luego pedir que ordene segun el delay, pero es una fila que ya no existe en el codigo; debieras primero ordenar por delay y luego filtrar la columna

#Ejercicios Grupos---------------------
#1. ¿Qué aerolínea tiene los peores retrasos promedio? Desafío: ¿puedes desentrañar los efectos de los malos aeropuertos vs. ¿malos transportistas? ¿por qué/por qué no? (Pista: piensa enflights |> group_by(carrier, dest) |> summarize(n()) )-------
#ver lo de desafio
flights |>
  group_by(carrier) |>
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n_vuelos = n(),
    .groups = 'drop'
  ) |>
  arrange(desc(avg_arr_delay)) ## F9 es la aerolinea con más retrasos
#Malos aeropuertos vs Malas aerolineas
# A que destinos vuela F9(la aerolinea con mayores retrasos)
f9_dests <- flights |>
  filter(carrier == "F9") |>
  pull(dest) |>
  unique()

# Dentro de los destinos que opera F9, las comparo con las aerolineas que tambien operan vuelos alli para saber si es un delay de la compañia o del aeropuerto
flights |>
  filter(dest %in% f9_dests) |>
  group_by(carrier) |>
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n_vuelos = n(),
    .groups = 'drop'
  ) |>
  arrange(desc(avg_arr_delay))


#2.Encontramos el vuelo que más retraso sufrio a la salir para cada destino --------
flights |>
  group_by(dest) |>
  slice_max(dep_delay, n = 1) |>
  select(carrier, flight, dest, dep_delay, arr_delay)
#3. ------------
flights |>
  group_by(hour) |>
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE),
    n_vuelos = n(),
    .groups = 'drop'
  )
#plot de barras de retraso
flights |>
  group_by(hour) |>
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    .groups = 'drop'
  ) |>
  ggplot(aes(x = factor(hour), y = avg_dep_delay, fill = avg_dep_delay)) +
  geom_col() +
  scale_fill_gradient(low = "green", high = "red") +
  labs(
    title = "Retrasos promedio de salida por hora",
    x = "Hora del día",
    y = "Retraso promedio (minutos)",
    fill = "Retraso (min)"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#4. -------------
#con slice_min no funciona el n<0, ya que te muestra todos los resultado de la columna
flights |>
  slice_min(arr_delay, n = 3)
flights |>
  slice_min (arr_delay, n= -3)
flights |>
  slice_max(arr_delay, n = 3)
flights |>
  slice_max (arr_delay, n= -3)
#5. ----------
#count: es una funcion que agrupa y contabiliza; unicamente se tiene que aclarar que se quiere agrupar (por ejemplo aeropuerto de origen, o linea aerea) y te devuelve una columna con el argumento aclarado contando cantidad de vuelos que salen desde allí o cuantos vuelos hizo la aerolinea; se pueden poner varios argumentos creando grupos más complejos
#sort con count: es un verbo asociado a count que permite ordenar; su argumento predeterminado es false que es ordenar alfabeticamente la columna de las variables elejidas, mientras que TRUE ordena de manera descendente la frencuencia
flights |>
  count(carrier)
flights |>
  count(carrier, sort = TRUE)
#6 ---------
df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)
#A.group_by leera la columna "y" y vera luego cuantos grupos se pueden agrupar por elementos similares; en la columna hay 2 elementos "a" y "b" entonces debiera poner que hay 2 grupos en la columna "y"
#B.arrange las va a acomodar por grupos; se reeordenaraon las filas, el orden sera de menor a mayor o de la A la Z dependiendo el elemento
#C.group_by es contar grupos segun los caracteres de la Y; summarize contabilizara cada grupo de Y los elementos de la columna X y luego via mean X saca el promedio de la columna, el df se modifica y quedan grupos de Y con su par que sea el promedio en X de estos elementos
#D.vamos a tener una matriz de 3x3, ya que se compararan pares identicos de Y,Z y luego se sacara la media de X para estos pares para columna X
#E.Te va quitar la agrupación por Y que te aparece en el ejemplo anterior, ademas de los signos de infomación
#F.El primer pipe es igual al del inciso D donde veremos la matriz 3x3 con los grupos contabilizados segun Y y con la columna X llamada ahora media_X que nos dara los valores medios de los grupos de pares identicos Y,Z; para comando mutate agregamos una columna mostrando los promedio de las X
#Ejercicios 19.2.4 --------
#1.weather tiene los datos del clima de los 3 aeropuertos de NYC, mientras que en airports en la columna FAA visualizamos todos los aeropuertos (origenes y destinos), entonces el vinculo sera weather$origin  ←→  airports$faa solo mostrando para los aeropuertos de la ciudad de NY
#2.flights$dest  ←→  weather$origin
#3. 
duplicates <- weather %>%
group_by(year, month, day, hour, origin) %>%
  summarise(n = n(), .groups = "drop") %>%
  filter(n > 1)

print(duplicates) #---> Cambio de uso horario
#4. Dias especiales
#En caso de crear un df diferente para tener como referencia dias festivos, utilizaria el día,mesy año + el nombre del festivo para tenerlos ubicados. La primary key para los festivos debiera sera la fecha, pero de manera combinada entre día, mes y año, ya que si solo aplicamos el dia, nos quedamos con 12 primero del mes por ejemplo, y no todos son festivos. Y si estaria conectada a los df actuales 

special_days <- tibble(
  year  = 2013,
  month = c(1, 7, 11, 12, 12, 12),
  day   = c(1, 4, 28, 24, 25, 31),
  holiday_name = c("Año Nuevo", "Día de la Independencia", "Acción de Gracias", 
                   "Nochebuena", "Navidad", "Nochevieja")
)
#nuevo df con columna extra al final que marca si es dia festivo o no, conexion con df "special days"
flights_with_holidays <- flights %>%
  left_join(special_days, by = c("year", "month", "day"))
#5.
install.packages("Lahman")
view(Batting)
view(People)
view(Salaries)
# 1. Descubrir qué conecta a People con Batting
intersect(names(People), names(Batting))
# Devuelve: "playerID" 
# 2. Descubrir qué conecta a People con Salaries
intersect(names(People), names(Salaries))
#Devuelve: "playerID"
# 3. Descubrir qué conecta a Batting con Salaries
intersect(names(Batting), names(Salaries))
# Devuelve: "playerID", "yearID", "teamID", "lgID"

# 1. ¿Qué conecta a la tabla general de Personas con la de Entrenadores?
intersect(names(People), names(Managers))
#Devuelve: "playerID"
# 2. ¿Qué conecta a la tabla de Personas directamente con los Premios?
intersect(names(People), names(AwardsManagers))
#Devuelve: "playerID"


# 3. ¿Qué conecta la tabla de Entrenadores con la tabla de sus Premios?
intersect(names(Managers), names(AwardsManagers))
#Devuelve: "playerID", "yearID", "lgID"
#Relación de batting, pitching y fielding
#"Las tablas Batting, Pitching y Fielding son tablas paralelas que comparten una relación de uno a uno. Comparten exactamente la misma clave primaria compuesta (playerID, yearID, stint), lo que significa que representan el mismo nivel de observación estadístico, pero dividido en tres dimensiones complementarias: ofensiva, lanzamiento y defensa."

#19.3.4--------------
#1.El peor delay del año en 48hs---------
view(weather)
vuelos_diarios_robustos <- flights %>%
  # 1. Agrupar por día
  group_by(year, month, day) %>%
  
  # 2 y 3. Calcular métricas del día (promedio, suma total y cantidad de cancelados)
  summarise(
    retraso_promedio = mean(arr_delay, na.rm = TRUE),
    retraso_total = sum(arr_delay, na.rm = TRUE),
    vuelos_cancelados = sum(is.na(arr_delay)), # Cuenta cuántos NA hubo
    .groups = "drop"
  ) %>%
  arrange(year, month, day) %>%
  
  # 4. Columnas de acumulado de 48 horas (actual + día previo)
  mutate(
    promedio_48h = retraso_promedio + lag(retraso_promedio, default = 0),
    cancelados_48h = vuelos_cancelados + lag(vuelos_cancelados, default = 0)
  ) %>%
  
  # Ordenamos para ver los peores días, esta vez priorizando las cancelaciones
  arrange(desc(cancelados_48h), desc(promedio_48h))

# Revisamos los resultados
head(vuelos_diarios_robustos)

clima_diario <- weather %>%
  # Agrupamos por fecha (ignorando la hora y el aeropuerto)
  group_by(year, month, day) %>%
  summarise(
    visibilidad_minima = min(visib, na.rm = TRUE),      # La peor visibilidad del día
    precip_total = sum(precip, na.rm = TRUE),           # Toda el agua/nieve que cayó
    viento_maximo = max(wind_speed, na.rm = TRUE),      # La ráfaga más fuerte
    .groups = "drop"
  )
analisis_final <- vuelos_diarios_robustos %>%
  left_join(clima_diario, by = c("year", "month", "day")) %>%
  # Vemos los peores días en la parte superior
  head(10)

# Imprimir el resultado
print(analisis_final)
#el patron final es claro, los días 8 y 9 de febrero concentran el "peor dia para volar" y lo aclaro así ya que el retraso promedio no luce tan grande pero nos perderiamos parte del analisis, ya que ese día hay gran cantidad de vuelos cancelados por eso no hay datos sobre las demoras; esto coincide con un dia de muy baja visibilidad y viento rapido durante el día. 
#2 -----------
# 1. Primero, creas la tabla flights2 (versión reducida de flights)
flights2 <- flights |> 
  select(year:day, hour, origin, dest, tailnum, carrier)

# 2. Ahora sí, ejecutas tu código original (¡que está perfecto!)
top_dest <- flights2 |>
  count(dest, sort = TRUE) |>
  head(10)

# Ver el resultado
print(top_dest)

vuelos_top_10 <- flights2 |> 
  semi_join(top_dest, by = "dest") #vemos todos los vuelos a los top10 destinos
#3------------
vuelos_sin_clima <- flights |> 
  anti_join(weather, by = c("origin", "time_hour"))

# Contamos cuántas filas quedaron
nrow(vuelos_sin_clima) #en caso de que haya filas es que efectivamente hay vuelos que no tienen medidas climaticas que coincidan con su time-hour que no es su hora exacta de salida sino de la que tenian más cerca de manera redondeada
#4. -----------
# 1. Encontrar los vuelos que NO tienen registro en la tabla planes
vuelos_huerfanos <- flights %>%
  anti_join(planes, by = "tailnum")

# 2. Extraer la lista única de esos números de cola problemáticos
numeros_de_cola_faltantes <- vuelos_huerfanos %>%
  distinct(tailnum)

# Mostrar los primeros resultados
head(numeros_de_cola_faltantes)
# extra. Contamos por aerolínea y calculamos el porcentaje del total de problemas
aerolineas_problematicas <- vuelos_huerfanos |> 
  count(carrier, sort = TRUE) |> 
  mutate(porcentaje = (n / sum(n)) * 100)

# Imprimimos el resultado
print(aerolineas_problematicas)
#5. ---------
flights |> 
  # 1. Filtramos los vuelos que no tienen avión registrado
  filter(!is.na(tailnum)) |> 
  
  # 2. Nos quedamos solo con las combinaciones únicas de avión y aerolínea
  distinct(tailnum, carrier) |> 
  
  # 3. Agrupamos por avión para resumir la información
  group_by(tailnum) |> 
  
  # 4. Creamos la columna con la lista de aerolíneas y otra contando cuántas son
  summarise(
    lista_aerolineas = paste(carrier, collapse = ", "),
    cantidad_aerolineas = n()
  ) |> 
  
  # 5. Unimos esto a la tabla de aviones (añadiendo nuestras nuevas columnas)
  right_join(planes, by = "tailnum") |> 
  
  # 6. Ordenamos para ver los aviones volados por más aerolíneas arriba
  arrange(desc(cantidad_aerolineas))# en caso de que un avión haya sido pilotado por solo una aerolinea, debiera aparecer en la nueva columna creada "cantidad de aerolineas" siempre uno, usamos arrange para que en caso de que haya un numero mayor a 1, enumere cuanto, y usamos listas de aerolineas para explicitar cuales aerolineas "compartieron" uso del avion durante algun periodo del año
#6. -------
flights |> 
  # 1. Primera unión: Aeropuerto de origen
  left_join(
    airports |> select(faa, lat_origen = lat, lon_origen = lon), 
    by = c("origin" = "faa")
  ) |> 
  
  # 2. Segunda unión: Aeropuerto de destino
  left_join(
    airports |> select(faa, lat_destino = lat, lon_destino = lon), 
    by = c("dest" = "faa")
  ) |> 
  
  # Seleccionamos algunas columnas solo para ver rápidamente el resultado
  select(year, month, day, origin, lat_origen, lon_origen, dest, lat_destino, lon_destino)
#conviene hacerlo antes ya que es más limpio, sino pasariamos a tener 2 columnas de lat y lon pq tenemos el destino y origen
#7. ------
flights |> 
  # 1. Agrupamos por destino
  group_by(dest) |> 
  
  # 2. Calculamos el retraso promedio (usando arr_delay para mayor precisión)
  summarise(retraso_promedio = mean(arr_delay, na.rm = TRUE), .groups = "drop") |> 
  
  # 3. Unimos con la tabla de aeropuertos para obtener lat y lon
  # Usamos inner_join para descartar los destinos que no tienen coordenadas en la tabla airports
  inner_join(airports, by = c("dest" = "faa")) |> 
  
  # 4. Dibujamos el mapa directamente (el gráfico aparecerá en la pestaña "Plots")
  ggplot(aes(x = lon, y = lat, color = retraso_promedio)) +
  borders("state") +
  geom_point(size = 2, alpha = 0.8) +
  coord_quickmap() +
  # Un toque estético: colorear de amarillo/rojo los peores retrasos
  scale_color_viridis_c(option = "inferno", name = "Retraso (min)") +
  theme_minimal() +
  labs(title = "Distribución espacial de los retrasos promedio",
       x = "Longitud", y = "Latitud")
#8 June 13 de 2013------
#paso uno testear si el problema es origen ergo NYC
flights |> 
  filter(year == 2013, month == 6, day == 13) |> 
  # Agrupamos por los aeropuertos de origen en NY
  group_by(origin) |> 
  summarise(
    vuelos_programados = n(),
    # Usamos dep_delay (retraso de salida) porque estamos midiendo el origen
    cancelados_en_origen = sum(is.na(dep_delay)),
    retraso_salida_prom = mean(dep_delay, na.rm = TRUE),
    .groups = "drop"
  )
#testear que destinos tuvieron mayores demoras y problemas; super mapa que evalua delay y cancelaciones
# 1. Forzamos a R a cargar la tabla original y completa
data("flights", package = "nycflights13")

# 2. Ahora corremos tu código exactamente como lo escribiste
flights |> 
  filter(year == 2013, month == 6, day == 13) |> 
  group_by(dest) |> 
  
  summarise(
    retraso_promedio = mean(arr_delay, na.rm = TRUE),
    vuelos_programados = n(),
    tasa_cancelacion = (sum(is.na(arr_delay)) / vuelos_programados) * 100,
    .groups = "drop"
  ) |> 
  inner_join(airports, by = c("dest" = "faa")) |> 
  filter(lon > -130) |> 
  
  ggplot(aes(x = lon, y = lat)) +
  borders("state") +
  geom_point(aes(color = retraso_promedio, size = tasa_cancelacion), alpha = 0.7) +
  coord_quickmap() +
  scale_color_viridis_c(option = "inferno", name = "Retraso Promedio\n(min)") +
  scale_size_continuous(name = "Tasa Cancelación\n(%)", range = c(1, 8)) +
  theme_minimal() +
  labs(
    title = "Impacto Multidimensional: 13 de Junio de 2013 desde NYC",
    subtitle = "Intensidad de Color: Retraso de Llegada | Tamaño del Punto: Tasa de Cancelación",
    x = "Longitud", 
    y = "Latitud"
  )

#para que usar google si tenemos la tabla de weather; de no haber ser algo meteorologico debiera ser algo humano como un paro o huelga de aerolineas pero esa data no la tenemos así que ahi si valdria googlear
flights |> 
  # 1. Filtramos el día y agrupamos SOLO por aeropuerto de origen
  filter(year == 2013, month == 6, day == 13) |> 
  group_by(origin) |> 
  summarise(
    vuelos_programados = n(),
    cancelados = sum(is.na(dep_delay)),
    retraso_salida_prom = mean(dep_delay, na.rm = TRUE)
  ) |> 
  
  # 2. Unimos con un sub-resumen del clima calculado "al vuelo"
  inner_join(
    weather |> 
      filter(year == 2013, month == 6, day == 13) |> 
      group_by(origin) |> 
      summarise(
        precip_promedio = mean(precip, na.rm = TRUE),
        viento_promedio = mean(wind_speed, na.rm = TRUE),
        visibilidad_promedio = mean(visib, na.rm = TRUE)
      ),
    by = "origin"
  ) ## googleando despues te das cuenta que efectivamente hubo un lio climatico "severe storms moving across the mid-Atlantic region USA Today caused major disruptions and delays at multiple major airports."