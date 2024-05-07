
# Antes de empezar, cargar a RStudio los archivos .xlsx correspondientes para que el codigo funcione correctamente.
# Los nombres para los archivos son: 'Dieta' y 'Sociodemograficos'. (Los nombres de los archivos en la parte de "Environment" tienen
# que ser iguales a los mencionados).

###############
# Ejercicio 1 #
###############

###########
# PUNTO 1 #
###########

# Cargar la librería dplyr, recomendada por la profesora.
library(dplyr)

# Cargar los datos desde el archivo Dieta.xlsx
dieta_data <- (Dieta)

# Verificar si hay datos faltantes
any_missing <- any(is.na(dieta_data))

if (any_missing) {
  # Eliminar registros con datos faltantes
  dieta_data <- na.omit(dieta_data)
  print("Se han eliminado los registros con datos faltantes.")
} else {
  print("No se encontraron datos faltantes.")
}

###########
# PUNTO 2 #
###########

# Graficar box-plots de las variables numéricas
par(mfrow = c(1, 3)) # Organizar las gráficas en una fila y tres columnas
boxplot(Grasas ~ Sexo, data = dieta_data, main = "Consumo de Grasas por Sexo")
boxplot(Alcohol ~ Sexo, data = dieta_data, main = "Consumo de Alcohol por Sexo")
boxplot(Calorías ~ Sexo, data = dieta_data, main = "Consumo de Calorías por Sexo")

###########
# PUNTO 3 #
###########

# Resumen estadístico por Sexo
summary_by_sex <- tapply(dieta_data[, c("Grasas", "Alcohol", "Calorías")], dieta_data$Sexo, summary)
print(summary_by_sex)

###########
# PUNTO 4 #
###########

# Crear una nueva variable para categorizar el consumo de calorías
dieta_data$Categoria_Calorias <- ifelse(dieta_data$Calorías <= 1700, "MODERADA", "ALTA")

# Graficar el consumo de alcohol según las categorías de calorías
par(mfrow = c(1, 1))
boxplot(Alcohol ~ Categoria_Calorias, data = dieta_data,
        xlab = "Categoría de Calorías", ylab = "Consumo de Alcohol",
        main = "Consumo de Alcohol según Cantidad de Calorías")

##########################################################################################################################################

###############
# Ejercicio 2 #
###############

###########
# PUNTO 1 #
###########

# Cargar los datos desde el archivo Sociodemograficos.xlsx
datos <- (Sociodemograficos)

# Mostrar las variables de interés
variables_interes <- names(datos)
print(variables_interes)

# Contar la cantidad de países analizados
paises_analizados <- nrow(datos)
print(paises_analizados)

###########
# PUNTO 2 #
###########

# País con menor tasa de natalidad
pais_menor_natalidad <- datos[which.min(datos$`Tasa de natalidad`), "País"]
print(pais_menor_natalidad)

# País con mayor tasa de natalidad
pais_mayor_natalidad <- datos[which.max(datos$`Tasa de natalidad`), "País"]
print(pais_mayor_natalidad)


###########
# PUNTO 3 #
###########

# Diagrama de dispersión entre las tasas de natalidad y mortalidad
plot(datos$`Tasa de natalidad`, datos$`Tasa de mortalidad`, 
     xlab = "Tasa de natalidad", ylab = "Tasa de mortalidad",
     main = "Diagrama de dispersión: Tasa de natalidad vs Tasa de mortalidad")


###########
# PUNTO 4 #
###########

# Calcular el vector de medias y limitar el numero de decimales a 2.
medias <- round(colMeans(datos[, -1]), 2)
# Formatear las medias para evitar notación científica en la salida
medias_formateadas <- format(medias, scientific = FALSE)
print(medias_formateadas)

# Calcular el vector de medianas
medianas <- apply(datos[, -1], 2, median)
print(medianas)

# Calcular la diferencia relativa entre la media y la mediana
diferencia_relativa <- (medias - medianas) / medianas * 100
print(diferencia_relativa)

###########
# PUNTO 5 #
###########

# Calcular la matriz de covarianzas
cov_mat <- cov(datos[, -1])
print(cov_mat)

# Calcular la matriz de correlaciones
cor_mat <- cor(datos[, -1])
print(cor_mat)

##########################################################################################################################################

###############
# Ejercicio 3 #
###############

###########
# PUNTO 1 #
###########

#Cargar la base de datos y explorarla
data(swiss)
head(swiss)  # Mostrar las primeras filas de la base de datos
dim(swiss)   # Mostrar el número de filas y columnas (registros y variables)

###########
# PUNTO 2 #
###########

# Calcular la distancia Euclidiana entre las provincias
dist_euclidiana <- dist(swiss)  # Calcular la matriz de distancias Euclidianas
print(dist_euclidiana)

########### 
# PUNTO 3 #
###########

# Identificar datos atípicos utilizando la distancia de Mahalanobis
# Calcular el vector de medias y la matriz de covarianzas
medias <- colMeans(swiss)
covarianzas <- cov(swiss)

# Calcular la distancia de Mahalanobis para cada observación
dist_mahalanobis <- mahalanobis(swiss, center = medias, cov = covarianzas)

# Establecer un umbral para identificar los datos atípicos
umbral <- qchisq(0.95, df = ncol(swiss))

# Identificar las observaciones con distancia de Mahalanobis superior al umbral
datos_atipicos <- swiss[dist_mahalanobis > umbral, ]
print(datos_atipicos)

##########################################################################################################################################

###############
# Ejercicio 4 #
###############

###########
# PUNTO 1 #
###########

# Crear el data frame con los datos proporcionados
datos <- data.frame(
  "Asistencias" = c(11, 14, 7, 15, 11, 13, 11, 16, 10, 15, 18, 12, 9, 9, 10, 10, 15, 10, 14, 10, 10, 12, 14, 12, 15, 7, 13, 6, 10, 15, 20, 10, 13, 10, 6, 14, 8, 10, 8, 11,
                    13, 10, 12, 7, 6, 10, 10, 16, 9, 7, 7, 2, 6, 9, 9, 8, 8, 10, 3, 6, 5, 2, 9, 3, 4, 5, 10, 8, 5, 9, 10, 8, 13, 10, 0, 2, 1, 1, 0, 4,
                    6, 7, 3, 5, 9, 6, 1, 6, 0, 2, 5, 6, 11, 6, 7, 0, 5, 7, 5, 4, 7, 4, 2, 8, 9, 6, 1, 4, 7, 7, 8, 9, 7, 5, 1, 6, 9, 4, 7, 16),
  "Localidad" = rep(c("Ciudad A", "Ciudad B", "Ciudad C"), each = 40)
)


###########
# PUNTO 2 #
###########

# Análisis descriptivo
summary(datos)

#Grafico box-plot
boxplot(Asistencias ~ Localidad, data = datos, main = "Asistencias por Localidad", xlab = "Localidad", ylab = "Asistencias")

###########
# PUNTO 3 #
###########

# Test ANOVA
modelo_anova <- aov(Asistencias ~ Localidad, data = datos)
summary(modelo_anova)

###########
# PUNTO 4 #
###########

# Test de Tukey
tukey_test <- TukeyHSD(modelo_anova)
print(tukey_test)
