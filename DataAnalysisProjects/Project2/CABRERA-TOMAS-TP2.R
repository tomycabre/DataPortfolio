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
nuevo_data <- data.frame(Colesterol = c(199))
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

###########
# PUNTO 4 #
###########

###########
# PUNTO 5 #
###########

