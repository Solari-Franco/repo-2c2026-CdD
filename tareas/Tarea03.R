### Tarea 3 ###

# Librerias ---------------------------------------------------
library(tidyverse)

library(palmerpenguins)

library(ggthemes)

# Penguins -------------------------------------------
penguins
# Exercises 1.2.5

nrow(penguins)
ncol(penguins)

?penguins # bill_depth_mm#

# 3. Diagrama de dispersion ------------
ggplot(data = penguins)

ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
)

ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm)
) +
  geom_point()

## Describe la relación entre estas dos variables.
## Describe la relación entre el largo y profundidad del pico de los pinguinos

# 4. Species vs bill_depth_mm -------------
ggplot(
  data = penguins,
  mapping = aes(x = species, y = bill_depth_mm)
)

ggplot(
  data = penguins,
  mapping = aes(x = species, y = bill_depth_mm)
) +
  geom_point()

# Mejor opcion que geom son las boxplot
# ggplot(penguins, aes(x = species, y = bill_depth_mm)) +
# geom_boxplot()

# 5.-----------------

ggplot(data = penguins) + 
  geom_point()
#El error ocurre ya que no hay datos a mapear de la fuente "penguis" y no se le asigna que datos iran al eje x y cuales al eje y
#Se podria mejorar dirigiendole los datos de que columna debe situarlos como datos eje X y cuales como eje Y

# 6. ----------------------

# na.rm en geom_point es para que ignore los missing data (NA) a la hora de poner puntos en la dispersion; el valor default es "false, que significa que en casos de haber datos NA te tira una advertencia en la consola, en cambio "true" los limpia automaticamente y no avisa. 
ggplot(
  data = penguins,
  mapping = aes(x = species, y = bill_depth_mm)
)

ggplot(
  data = penguins,
  mapping = aes(x = species, y = bill_depth_mm)
) +
  geom_point(na.rm=TRUE)

# 7. Agregar fuente+ label a los ejes+ color x especie+ titulo----------------

ggplot(
  data = penguins,
  mapping = aes(x = bill_length_mm, y = bill_depth_mm, color = species)
) +
  geom_point(na.rm = TRUE) +
  labs(
    title = "Relación entre largo y profundidad del pico",
    x = "Largo del pico (mm)",
    y = "Profundidad del pico (mm)",
    color = "Especie",
    caption = "Data come from the palmerpenguins package."
  )

#8. -----------------
#bill_depth_mm be mapped colores de los puntos en una escala de colores
#global es que mapea a todos los geoms (puntos + linea suave); geom level solo mapearia a los puntos, que es el caso ya que a la linea de tendencia no hay aplicacion de distintos gradientes del color 

#9. -------
#este codigo tendria que poner los puntos en el eje X el largo de las aletas y en el Y el peso corporal, los puntos tendran colores segun a la isla que pertenezca

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y = body_mass_g, color = island)
) +
  geom_point() +
  geom_smooth(se = FALSE) #linea de tendencias suavizada por cada isla sin banda de confianza

#10. Diferencias entre los graficos ------------
#ambos producen el mismo output pero el segundo es más repetitivo y ademas hay q definirle los parametros para cada "funcion" (geom point y smooth)

#1.4.3 Exercises 
#1. ------

ggplot(penguins, aes(y = species)) +
  geom_bar()
#en este caso las barras crecen hacia la derecha en vez de hacia arriba ya que las especies estan en el eje Y
#2. --------

ggplot(penguins, aes(x = species)) +
  geom_bar(fill = "red") #rellene de color rojo las barras

#3.Diamonds ------------
head(diamonds)
str(diamonds) #info
summary(diamonds$carat)

# binwidth muy grande (2) - pocas barras
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 2) +
  labs(title = "binwidth = 2")

# binwidth mediano (0.5)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5) +
  labs(title = "binwidth = 0.5")

# binwidth pequeño (0.1) - muchas barras - la mejorcita
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1) +
  labs(title = "binwidth = 0.1")

# binwidth muy pequeño (0.01) - muy detallado
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.01) +
  labs(title = "binwidth = 0.01")



#1.5.5 Exercises
# MPG Dataset ----------------------
mpg 
?mpg
str(mpg)
sapply(mpg, class)
#2. -------------
#Cylindros por color
ggplot(mpg, aes(x = displ, y = hwy, color = cyl)) +
  geom_point() #X = Litros del auto; Y= Millas en autopista/gallon; Tercera= N de cilindros (por color)
#Cylindros por tamaño
ggplot(mpg, aes(x = displ, y = hwy, size = cyl)) +
  geom_point()
#Cylindros por color y tamaño
ggplot(mpg, aes(x = displ, y = hwy, color = cyl, size = cyl)) +
  geom_point()
#Cylindros por shape, no funciona shape para variables numericas
ggplot(mpg, aes(x = displ, y = hwy, shape = cyl)) +
  geom_point()
#A continuous variable cannot be mapped to the shape aesthetic.
#3. ---------------
ggplot(mpg, aes(x = displ, y = hwy, linewidth = cyl)) +
  geom_point()
#linewidth no funciona para geom_point ya que es un comando aplicado para lineas y el comando anterior nos genera puntos así que no tiene utilidad alguna aplicarlo ya que se ignora la 3ra variable

#4. Redundancia y sobrecargar grafica-------------
ggplot(mpg, aes(x = displ, y = hwy, color = cyl, size = cyl, alpha = cyl)) +
  geom_point()

#5. -------------------
ggplot(penguins, aes(x = bill_length_mm, y = bill_depth_mm, color = species)) +
  geom_point(na.rm = TRUE) +
  labs(title = "Bill Length vs Bill Depth by Species",
       x = "Bill Length (mm)",
       y = "Bill Depth (mm)",
       color = "Species")
#Adelie=Rojo <--- Pico profundo y corto
#Chinstrap <--- Pico profundo y largo
#Gentoo <--- Pico poco profundo y largo

#6. --------------
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = bill_depth_mm, color = species, shape = species)
) +
  geom_point() +
  labs(color = "Species", shape = "Species")
#haces que haya un solo cuadro de labls
#7. Geom_bar -----------
ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill") #Usa en el eje X las islas y te permite reconocer visualimente quienes la habitan
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill") #En el eje X ves las especies y te permite ver en que isla habita cada especie

#1.6.1 Exercises

#1.6.1 
#1. -----------
ggplot(mpg, aes(x = class)) +
  geom_bar()
ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point()
ggsave("mpg-plot.png") #guarda el ultimo grafico realizado
ggsave("mpg-plot.pdf")
#2.------------
##.pdf // ?ggsave // help (ggsave)

