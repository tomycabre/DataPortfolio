#by Tomas Cabrera
#Antes de empezar, cargar los archivos .xslx de cada uno de los conjuntos de datos analizados.
#Asegurate de que estos tengan de nombre: "MedidasCorporales", "Dolor" y "Europa"

#Ahora, vamos a instalar y cargar las librerias que vamos a estar utilizando para los analisis
if (!require(factoextra)) install.packages("factoextra")
if (!require(forecast)) install.packages("forecast")
if (!require(stats)) install.packages("stats")
if (!require(magrittr)) install.packages("magrittr")

# Cargar los paquetes (no hace falta instalarlos si ya los instalaste previamente)
library(factoextra)
library(forecast)
library(stats)
library(magrittr)

###############
# Ejercicio 1 #
###############

###########
# PUNTO 1 #
###########

# Verificar la cantidad de registros y variables
dim(MedidasCorporales)

# Verificar si todas las variables son numéricas
sapply(MedidasCorporales, is.numeric)

###########
# PUNTO 2 #
###########

###############
# EJERCICIO a #
###############

# Realizar regresión lineal simple
modelo <- lm(Peso ~ Altura, data = MedidasCorporales)

# Escribir el modelo teórico
summary(modelo)

###############
# EJERCICIO b #
###############

# Estimaciones de la ordenada al origen y de la pendiente
coeficientes <- coef(summary(modelo))

# Mostrar las estimaciones
coeficientes[, "Estimate"]


###############
# EJERCICIO c #
###############

# Obtener el error estándar residual
error_estandar_residual <- sigma(modelo)

# Obtener el coeficiente de determinación R2
R2 <- summary(modelo)$r.squared

# Obtener el valor ajustado de R2
R2_ajustado <- summary(modelo)$adj.r.squared

# Mostrar los resultados
error_estandar_residual
R2
R2_ajustado

###########
# PUNTO 3 #
###########

###############
# EJERCICIO a #
###############

# Guardar la cantidad total de registros en la variable n
n <- nrow(MedidasCorporales)

# Mostrar el valor de n
n

###############
# EJERCICIO b #
###############

# Fijar la semilla
set.seed(1234)

# Crear la variable de muestras
muestras <- sample(1:n, size = n, replace = FALSE)

# Determinar el tamaño del conjunto de entrenamiento (80% de los datos)
tamaño_entrenamiento <- round(0.8 * n)

# Extraer los índices de los datos de entrenamiento y prueba
indices_entrenamiento <- muestras[1:tamaño_entrenamiento]
indices_prueba <- muestras[(tamaño_entrenamiento + 1):n]

# Calcular el porcentaje de datos en cada conjunto
porcentaje_entrenamiento <- length(indices_entrenamiento) / n
porcentaje_prueba <- 1 - porcentaje_entrenamiento

# Mostrar los porcentajes
porcentaje_entrenamiento * 100
porcentaje_prueba * 100


###############
# EJERCICIO c #
###############

# Crear el modelo de regresión lineal múltiple con todas las variables
modelo_multiple <- lm(Peso ~ ., data = MedidasCorporales[indices_entrenamiento, ])

# Mostrar el resumen del modelo
summary(modelo_multiple)


###############
# EJERCICIO d #
###############

# Seleccionar variables significativas al 95% de confianza
variables_significativas <- summary(modelo_multiple)$coefficients[summary(modelo_multiple)$coefficients[,4] < 0.05, ]

# Extraer los nombres de las variables significativas
nombres_variables_significativas <- rownames(variables_significativas)

# Asegurarse de que la variable "Peso" esté incluida
nombres_variables_significativas <- c("Peso", nombres_variables_significativas)

# Crear el modelo de regresión lineal múltiple con las variables significativas
modelo_multiple_significativo <- lm(Peso ~ ., data = MedidasCorporales[indices_entrenamiento, names(MedidasCorporales) %in% nombres_variables_significativas])

# Mostrar el resumen del nuevo modelo
summary(modelo_multiple_significativo)


###############
# EJERCICIO e #
###############

# Realizar predicciones con el modelo original
predicciones_original <- predict(modelo_multiple, newdata = MedidasCorporales[-indices_entrenamiento, ])

# Realizar predicciones con el modelo simplificado
predicciones_simplificado <- predict(modelo_multiple_significativo, newdata = MedidasCorporales[-indices_entrenamiento, ])

# Calcular el error cuadrático medio (MSE) para el modelo original
MSE_original <- mean((MedidasCorporales$Peso[-indices_entrenamiento] - predicciones_original)^2)

# Calcular el error cuadrático medio (MSE) para el modelo simplificado
MSE_simplificado <- mean((MedidasCorporales$Peso[-indices_entrenamiento] - predicciones_simplificado)^2)

# Mostrar los resultados
MSE_original
MSE_simplificado

#########################################################################################################################################################################

###############
# Ejercicio 2 #
###############

###########
# PUNTO 1 #
###########

# Cargar los datos del archivo "Dolor.xlsx"
data <- (Dolor)

# Eliminar filas con datos no numéricos en la columna "Colesterol"
data <- data[!is.na(as.numeric(data$Colesterol)), ]

# Ajustar el modelo de regresión logística
modelo <- glm(`Estrechamiento arterias coronarias` ~ Colesterol, data = data, family = "binomial")

# Resumen del modelo
summary(modelo)

# Calcular la probabilidad de estrechamiento arterial para un nivel de colesterol igual a 199
nuevo_data <- data.frame(Colesterol = 199)
predicciones <- predict(modelo, newdata = nuevo_data, type = "response")
predicciones

###########
# PUNTO 2 #
###########

# Identificar las variables no categóricas
variables_no_categoricas <- sapply(data, is.numeric)

# Ajustar el modelo de regresión logística múltiple
modelo_multiple <- glm(`Estrechamiento arterias coronarias` ~ ., data = data[, variables_no_categoricas], family = "binomial")

# Resumen del modelo
summary(modelo_multiple)

###########
# PUNTO 3 #
###########

# Dividir el conjunto de datos en dos grupos: mujeres y varones
data_mujeres <- subset(data, Sexo == 1)  # 1 representa mujeres
data_varones <- subset(data, Sexo == 0)  # 0 representa varones

# Ajustar el modelo de regresión logística múltiple para mujeres
modelo_multiple_mujeres <- glm(`Estrechamiento arterias coronarias` ~ ., data = data_mujeres[, variables_no_categoricas], family = "binomial")

# Resumen del modelo para mujeres
summary(modelo_multiple_mujeres)

# Ajustar el modelo de regresión logística múltiple para varones
modelo_multiple_varones <- glm(`Estrechamiento arterias coronarias` ~ ., data = data_varones[, variables_no_categoricas], family = "binomial")

# Resumen del modelo para varones
summary(modelo_multiple_varones)

#########################################################################################################################################################################

###############
# Ejercicio 3 #
###############

###########
# PUNTO 1 #
###########

# Cargamos el conjunto de datos
europa <- (Europa)

# Verificamos las variables del conjunto de datos
variables <- names(europa)
print(variables)

# Contamos el número de variables
num_variables <- length(variables)
print(num_variables)

###########
# PUNTO 2 #
###########
#Cargar la libreria magrittr al principio del codigo para que funcione este punto.

# Seleccionamos solo las columnas numéricas
europa_numeric <- europa[, sapply(europa, is.numeric)]

# Calculamos la matriz de covarianza
cov_matrix <- cov(europa_numeric)

# Verificamos si la matriz es inversible
tryCatch({
  inv_matrix <- solve(cov_matrix)
  print("La matriz es inversible.")
}, error = function(e) {
  print("La matriz no es inversible.")
})

###########
# PUNTO 3 #
###########

# Calculamos los autovalores
autovalores <- eigen(cov_matrix)$values

# Encontramos el mayor autovalor
mayor_autovalor <- max(autovalores)

# Imprimimos el mayor autovalor
print(mayor_autovalor)

###########
# PUNTO 4 #
###########
#Cargar la libreria stats al principio del codigo para que funcione este punto.

# Realizamos el PCA
pca <- prcomp(europa_numeric, scale. = TRUE)

# Calculamos la varianza explicada por cada componente principal
varianza_explicada <- pca$sdev^2 / sum(pca$sdev^2)

# Calculamos la varianza acumulada
varianza_acumulada <- cumsum(varianza_explicada)

# Encontramos la cantidad de componentes necesarios para explicar al menos el 90% de la varianza
num_componentes <- which(varianza_acumulada >= 0.9)[1]

# Imprimimos la cantidad de componentes
print(num_componentes)

###########
# PUNTO 5 #
###########
#Cargar la libreria factoextra al principio del codigo para que funcione este punto.

# Realizamos el PCA
pca <- prcomp(europa_numeric, scale. = TRUE)

# Creamos el gráfico de las contribuciones de las variables
fviz_contrib(pca, choice = "var", axes = 1, top = 10)
fviz_contrib(pca, choice = "var", axes = 2, top = 10)

#########################################################################################################################################################################

###############
# Ejercicio 4 #
###############

###########
# PUNTO 2 #
###########

# Cargar el conjunto de datos JohnsonJohnson
data("JohnsonJohnson")

# Convertir los datos a serie de tiempo
serie_tiempo <- ts(JohnsonJohnson, start = c(1960, 1), frequency = 4)

# Realizar la descomposición aditiva
decomp_aditiva <- decompose(serie_tiempo, type = "additive")

# Realizar la descomposición multiplicativa
decomp_multiplicativa <- decompose(serie_tiempo, type = "multiplicative")

# Graficar la serie de tiempo original
plot(serie_tiempo, main = "Serie de Tiempo Johnson & Johnson",
     ylab = "Ingresos Trimestrales (en millones de dólares)", xlab = "Año")

# Graficar la descomposición aditiva
plot(decomp_aditiva)

# Graficar la descomposición multiplicativa
plot(decomp_multiplicativa)


###########
# PUNTO 3 #
###########

# Cargar los datos de Johnson & Johnson denuevo.
data("JohnsonJohnson")

# Realizar la prueba de Box-Cox
boxcox_result <- boxcox(JohnsonJohnson ~ 1)

# Imprimir los resultados
print(boxcox_result)

# Graficar el perfil de verosimilitud
plot(boxcox_result)


###############
# PUNTO 4 & 5 #
###############
#Cargar la libreria forecast al principio del codigo para que funcione este punto.
# Tomar todos los datos excepto los dos últimos años
datos_entrenamiento <- window(JohnsonJohnson, end = c(1990, 12))

# Realizar un modelo ARIMA automático
modelo_auto <- auto.arima(datos_entrenamiento)

# Mostrar el modelo ARIMA automático
print(modelo_auto)

# Especificar los rangos para p y q
p_range <- 1:6  # Limitando p a 6, ya que ARIMA automático seleccionó p=1
q_range <- 1:6  # Limitando q a 6

# Inicializar variables para almacenar los resultados del mejor modelo personalizado
mejor_modelo_personalizado <- NULL
mejor_aic <- Inf

# Bucle para probar diferentes combinaciones de p y q
for (p in p_range) {
  for (q in q_range) {
    # Crear el modelo ARIMA personalizado
    modelo_personalizado <- try(arima(datos_entrenamiento, order = c(p, 0, q)))
    # Evitar errores y modelos no estacionarios
    if (!inherits(modelo_personalizado, "try-error") &&
        !any(is.na(coef(modelo_personalizado)))) {
      # Almacenar el modelo si tiene un AIC más bajo
      if (AIC(modelo_personalizado) < mejor_aic) {
        mejor_modelo_personalizado <- modelo_personalizado
        mejor_aic <- AIC(modelo_personalizado)
      }
    }
  }
}

# Mostrar el mejor modelo ARIMA personalizado
print(mejor_modelo_personalizado)

###########
# PUNTO 6 #
###########
#Cargar la libreria forecast al principio del codigo para que funcione este punto.
# Tomar todos los datos excepto los dos últimos años
datos_entrenamiento <- window(JohnsonJohnson, end = c(1980, 1))

# Realizar un modelo ARIMA automático
modelo_auto <- auto.arima(datos_entrenamiento)

# Mostrar el modelo ARIMA automático
print(modelo_auto)

# Predecir con el modelo ARIMA automático para los dos últimos años
prediccion_auto <- forecast(modelo_auto, h = 8)

# Recortar las predicciones para que coincidan con el número de observaciones en los datos de prueba
prediccion_auto_mean_recortada <- head(prediccion_auto$mean, length(JohnsonJohnson))

# Calcular el MAPE para el modelo ARIMA automático
MAPE_auto <- mean(abs((JohnsonJohnson - prediccion_auto_mean_recortada) / JohnsonJohnson)) * 100

# Mostrar el MAPE
print(MAPE_auto)

# Especificar los rangos para p y q
p_range <- 1:6  # Limitando p a 6, ya que ARIMA automático seleccionó p=1
q_range <- 1:6  # Limitando q a 6

# Inicializar variables para almacenar los resultados del mejor modelo personalizado
mejor_modelo_personalizado <- NULL
mejor_aic <- Inf

# Bucle para probar diferentes combinaciones de p y q
for (p in p_range) {
  for (q in q_range) {
    # Crear el modelo ARIMA personalizado
    modelo_personalizado <- try(arima(datos_entrenamiento, order = c(p, 0, q)))
    # Evitar errores y modelos no estacionarios
    if (!inherits(modelo_personalizado, "try-error") &&
        !any(is.na(coef(modelo_personalizado)))) {
      # Almacenar el modelo si tiene un AIC más bajo
      if (AIC(modelo_personalizado) < mejor_aic) {
        mejor_modelo_personalizado <- modelo_personalizado
        mejor_aic <- AIC(modelo_personalizado)
      }
    }
  }
}

# Mostrar el mejor modelo ARIMA personalizado
print(mejor_modelo_personalizado)

# Predecir con el mejor modelo ARIMA personalizado para los dos últimos años
prediccion_personalizada <- forecast(mejor_modelo_personalizado, h = 8)

# Recortar las predicciones para que coincidan con el número de observaciones en los datos de prueba
prediccion_personalizada_mean_recortada <- head(prediccion_personalizada$mean, length(JohnsonJohnson))

# Calcular el MAPE para el mejor modelo ARIMA personalizado
MAPE_personalizado <- mean(abs((JohnsonJohnson - prediccion_personalizada_mean_recortada) / JohnsonJohnson)) * 100

# Mostrar el MAPE
print(MAPE_personalizado)
