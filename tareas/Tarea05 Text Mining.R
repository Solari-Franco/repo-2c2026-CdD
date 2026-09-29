# Analisis de McKinsey
# Librerias ----
library(dplyr)
library(stringr)
library(tidytext)
library(tidyr)
library(ggplot2)
library("wordcloud")
library("reshape2")
library(topicmodels)

#Primeros pasos, desmenuzar y una palabra por linea ----

articulos_desmenuzados <- DATA_T9_mckinsey_mind_the_gap_articles_20251020 |>
  #1.Seleccionar solo el número de artículo, la fecha y el texto - Le da un nombre más facil de reconocer para luego comparar con la base original
  select(`...1`, date, article_text) |>
  #2.Renombrar '...1' para clarificar topico
  rename(id_articulo = `...1`) |>
  #3.Desarmar el texto: 'word' será la nueva columna, 'article_text' es la original
  unnest_tokens(output = word, input = article_text)

#Visualizacion de las primeras filas de nueva tabla
head(articulos_desmenuzados)


#Conectores, limpieza y aplicar Stopwords ------
#1.Definir vector con todas las palabras o letras clave que NO queremos borrar
terminos_clave <- c("x", "y", "z", "ai", "gen")

#2.Filtrar el diccionario: quedarse con las palabras que NO (!) están en nuestros términos
stop_words_modificado <- stop_words |>
  filter(!word %in% terminos_clave)

#3.Limpiar artículos con este nuevo diccionario hecho a medida
articulos_limpios <- articulos_desmenuzados |>
  anti_join(stop_words_modificado, by = "word")

#4.Limpieza extra

#Armar vector con las contracciones "rebeldes" (incluyendo ambas variantes de comillas) y sumamos palabras corporativas que son ruido para tu análisis de tópicos
basura_extra <- c(
  "it's", "they're", "we're", "don't", "there's", "you're", "doesn't", "isn't", "that's", "here's", 
  "it’s", "they’re", "we’re", "don’t", "there’s", "you’re", "doesn’t", "isn’t", "that’s", "here’s", 
  "percent", "mckinsey", "mckinsey.com", "coauthors", "partner", "alex", "axel"
)

#Convertir en un formato de tabla compatible para hacer el cruce
stop_words_personalizadas <- tibble(word = basura_extra)

#Aplicar el segundo filtro sobre tus artículos que ya estaban limpios
articulos_ultra_limpios <- articulos_limpios |>
  anti_join(stop_words_personalizadas, by = "word")

#Verificar cómo quedó el conteo de frecuencias
articulos_ultra_limpios |>
  count(word, sort = TRUE)

#De que trata el corpus? (nube de palabras) Son comparables los documentos? -------
#1.Nube con las 100 palabras más frecuentes
articulos_ultra_limpios |>
  count(word) |>
  with(wordcloud(word, n, max.words = 100, random.order = FALSE, colors = "steelblue"))

#2.Compara articulos
#Evaluamos la extensión: ¿Cuántas palabras luego de limpieza stopwords tiene cada artículo? (coherente comparar una nota de opinion con articulos más academicos)
longitud_articulos <- articulos_ultra_limpios |>
  count(id_articulo, name = "total_palabras")

#Un resumen estadístico rápido (mínimo, media, máximo) de la longitud 
summary(longitud_articulos$total_palabras) 

#¿En cuántos de los 50 artículos aparecen los top 5 términos?
#Extraer las 5 palabras más repetidas de todo el corpus
top_5_global <- articulos_ultra_limpios |>
  count(word, sort = TRUE) |>
  slice_head(n = 5) |>
  pull(word)

#Luego contar en cuántos id_articulo distintos aparece cada una
articulos_ultra_limpios |>
  filter(word %in% top_5_global) |>
  group_by(word) |>
  summarise(cantidad_articulos_donde_aparece = n_distinct(id_articulo)) |>
  arrange(desc(cantidad_articulos_donde_aparece))

#Extra: columna de porcentajes
#Guardar el total exacto de artículos en una variable
total_articulos <- n_distinct(articulos_ultra_limpios$id_articulo)

#Correr el mismo código sumando el mutate al final
articulos_ultra_limpios |>
  filter(word %in% top_5_global) |>
  group_by(word) |>
  summarise(cantidad_articulos_donde_aparece = n_distinct(id_articulo)) |>
  mutate(porcentaje = round((cantidad_articulos_donde_aparece / total_articulos) * 100, 1)) |>
  arrange(desc(cantidad_articulos_donde_aparece))

#resultados:
#word   cantidad_articulos_donde_aparece porcentaje
#<chr>                             <int>      <dbl>
#1 gen                                 143       97.9
#2 z                                   137       93.8
#3 zers                                126       86.3
#4 global                              119       81.5
#5 people                               92       63  


#Aspectos destacados del corpus utilizados, analisis de bigrams ----
#1.Volver a la base original para desarmarla de a dos palabras (bigramas)
bigramas_mckinsey <- DATA_T9_mckinsey_mind_the_gap_articles_20251020 |>
  select(`...1`, article_text) |>
  rename(id_articulo = `...1`) |>
  unnest_tokens(bigram, article_text, token = "ngrams", n = 2)

#2.Separar el bigrama en dos columnas para poder filtrar
bigramas_separados <- bigramas_mckinsey |>
  separate(bigram, c("word1", "word2"), sep = " ")

#3.Limpiar: exigir que NINGUNA de las dos palabras sea un stop word o basura
bigramas_limpios <- bigramas_separados |>
  filter(!word1 %in% stop_words_modificado$word) |>
  filter(!word2 %in% stop_words_modificado$word) |>
  filter(!word1 %in% basura_extra) |>
  filter(!word2 %in% basura_extra)

#4.Contar cuáles son los conceptos (bigramas) reales más frecuentes del corpus
conteo_bigramas <- bigramas_limpios |>
  count(word1, word2, sort = TRUE)
 
head(conteo_bigramas, 10) #encontre regularidad de liz hilton y hilton segel; es una señora liz hilton segel chief client oofficer, sacar todo
#segunda limpieza bigrams
#Actualizar el vector sumando a la directiva y los términos de su cargo
basura_extra <- c(
  "it's", "they're", "we're", "don't", "there's", "you're", "doesn't", "isn't", "that's", "here's", "z's",
  "it’s", "they’re", "we’re", "don’t", "there’s", "you’re", "doesn’t", "isn’t", "that’s", "here’s", "z’s",
  "percent", "mckinsey", "mckinsey.com", "coauthors", "partner", "alex", "axel",
  "liz", "hilton", "segel", "chief", "client", "officer", "hatami", "homayoun", "managing" # <- Nuevos intrusos
)

#Actualizar el formato tabla para el filtro
stop_words_personalizadas <- tibble(word = basura_extra)

#Volver a limpiar los bigramas separados
bigramas_limpios <- bigramas_separados |>
  filter(!word1 %in% stop_words_modificado$word) |>
  filter(!word2 %in% stop_words_modificado$word) |>
  filter(!word1 %in% stop_words_personalizadas$word) |>
  filter(!word2 %in% stop_words_personalizadas$word)

#Unir las columnas nuevamente y contamos
conteo_bigramas_final <- bigramas_limpios |>
  unite(bigram, word1, word2, sep = " ") |>
  count(bigram, sort = TRUE)

#Visualizar el top 10 definitivo
head(conteo_bigramas_final, 10) #siento que sigue habiendo muchos conceptos corporativos, pero ya no hay nombres propios de personas; igual el aspecto central prodria resumirse en estos
#resultados
#bigram                 n
#<chr>              <int>
#1 gen z                513
#2 gen zers             487
#3 social media         106
#4 mental health         93

#Sentimiento de las notas utilizando diccionarios binarios y con graduaciones ----
#Diccionario binario = "bing" -----
#Análisis Binario (bing)
sentimiento_binario <- articulos_ultra_limpios |>
  inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") |>
  count(id_articulo, sentiment) |>
#Pivotar para tener columnas de 'positive' y 'negative' y restarlas
  pivot_wider(names_from = sentiment, values_from = n, values_fill = 0) |>
  mutate(sentimiento_neto = positive - negative)
#Nube de palabras
articulos_ultra_limpios |>
  inner_join(get_sentiments("bing"), by = "word", relationship = "many-to-many") |>
  count(word, sentiment, sort = TRUE) |>
  acast(word ~ sentiment, value.var = "n", fill = 0) |>
  comparison.cloud(colors = c("#F8766D", "#00BFC4"), max.words = 100)
#Q articulos son los más negativos y positivos
#Top 3 artículos con mayor carga positiva
top_positivos <- sentimiento_binario |>
  slice_max(sentimiento_neto, n = 3)

top_positivos #38-89-124 

#Top 3 artículos con mayor carga negativa
top_negativos <- sentimiento_binario |>
  slice_min(sentimiento_neto, n = 3)

top_negativos #117-87-25-56-82-90

#Diccionario con graduacion = "afinn" ----
#Análisis con Graduaciones (afinn)
sentimiento_graduado <- articulos_ultra_limpios |>
  inner_join(get_sentiments("afinn"), by = "word", relationship = "many-to-many") |>
  group_by(id_articulo) |>
#Sumar los valores (-5 a 5) de todas las palabras del artículo
  summarise(sentimiento_neto_afinn = sum(value))
articulos_ultra_limpios |>
  inner_join(get_sentiments("afinn"), by = "word", relationship = "many-to-many") |>
#Si el valor numérico es mayor a 0, lo etiquetamos como positivo, de lo contrario negativo
  mutate(sentiment_category = ifelse(value > 0, "positive", "negative")) |>
  count(word, sentiment_category, sort = TRUE) |>
  acast(word ~ sentiment_category, value.var = "n", fill = 0) |>
  comparison.cloud(colors = c("#F8766D", "#00BFC4"), max.words = 100)
#Top 3 artículos con mayor carga positiva según afinn
top_positivos_afinn <- sentimiento_graduado |>
  slice_max(sentimiento_neto_afinn, n = 3)

top_positivos_afinn

#Top 3 artículos con mayor carga negativa según afinn
top_negativos_afinn <- sentimiento_graduado |>
  slice_min(sentimiento_neto_afinn, n = 3)

top_negativos_afinn
#Topic Modeling ----

#Transformar base limpia en una Matriz Documento-Término (DTM)
matriz_dtm <- articulos_ultra_limpios |>
  count(id_articulo, word) |>
  cast_dtm(document = id_articulo, term = word, value = n)

#Ejecutar el modelo para k = 10 tópicos
#Fijamos una semilla (seed = 1234) para que el componente aleatorio del algoritmo dé el mismo resultado cada vez que lo corras
modelo_lda_10 <- LDA(matriz_dtm, k = 10, control = list(seed = 1234))

#Ejecutar el modelo para k = 15 tópicos
modelo_lda_15 <- LDA(matriz_dtm, k = 15, control = list(seed = 1234))
#Extraer las probabilidades beta del modelo de 10 tópicos
topicos_10 <- tidy(modelo_lda_10, matrix = "beta")

#5 palabras principales de cada tópico para intentar nombrar de qué trata
topicos_10 |>
  group_by(topic) |>
  slice_max(beta, n = 5) |>
  arrange(topic, -beta)

#Manera visual de tematizar
#Extraer las probabilidades y filtramos el top 5 por tópico
#Nota: La función tidy() llama a las palabras "term" en lugar de "word"
top_terminos_10 <- tidy(modelo_lda_10, matrix = "beta") |>
  group_by(topic) |>
  slice_max(beta, n = 5) |>
  ungroup() |>
  arrange(topic, -beta)

#Generar el gráfico
top_terminos_10 |>
  # Ordenamos los términos adentro de cada tópico
  mutate(term = reorder_within(term, beta, topic)) |>
  ggplot(aes(x = beta, y = term, fill = factor(topic))) +
  geom_col(show.legend = FALSE) +
  # Creamos un mini-gráfico para cada tópico, permitiendo que el eje Y sea libre
  facet_wrap(~ topic, scales = "free_y", ncol = 2) +
  # Limpiamos las etiquetas del eje Y generadas por reorder_within
  scale_y_reordered() +
  labs(title = "Top 5 términos por tópico (k = 10)",
       x = "Probabilidad (beta)",
       y = NULL) +
  theme_minimal()

#Agregar titulos a la grafica de topicos
#Crear una nueva columna asignando tus títulos a cada número de tópico
top_terminos_10_nombrados <- top_terminos_10 |>
  mutate(nombre_topico = case_when(
    topic == 1 ~ "1. Consumo",
    topic == 2 ~ "2. Salud Mental",
    topic == 3 ~ "3. IA Global",
    topic == 4 ~ "4. Deporte",
    topic == 5 ~ "5. Social Media",
    topic == 6 ~ "6. Trabajo",
    topic == 7 ~ "7. Management",
    topic == 8 ~ "8. Mujeres",
    topic == 9 ~ "9. Tiempo IA",
    topic == 10 ~ "10. Style y Fashion"
  ))

#Generar el gráfico usando 'nombre_topico' en lugar de 'topic'
top_terminos_10_nombrados |>
  # Reordenamos las palabras adentro de cada categoría renombrada
  mutate(term = reorder_within(term, beta, nombre_topico)) |>
  # Usamos nombre_topico para el color (fill)
  ggplot(aes(x = beta, y = term, fill = nombre_topico)) +
  geom_col(show.legend = FALSE) +
  # Usamos nombre_topico para dividir los paneles (facet_wrap)
  facet_wrap(~ nombre_topico, scales = "free_y", ncol = 2) +
  scale_y_reordered() +
  labs(title = "Conceptos centrales por Tópico (k = 10)",
       x = "Probabilidad de pertenencia (beta)",
       y = NULL) +
  theme_minimal()