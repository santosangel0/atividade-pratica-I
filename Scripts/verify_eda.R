library(readxl)
library(dplyr)
library(ggplot2)
library(patchwork)
library(knitr)
library(kableExtra)

df <- read_excel("Dados/1929_Hubble.xlsx")
df$r_Mpc <- as.numeric(df$r_Mpc)
df$mt <- as.numeric(df$mt)
df$Mt <- as.numeric(df$Mt)

cat("Total observações:", nrow(df), "\n")
cat("Valores faltantes por coluna:\n")
print(colSums(is.na(df)))

# Resumo estatístico
desc_stats <- function(x) {
  x <- x[!is.na(x)]
  c(
    N = length(x),
    Média = mean(x),
    DP = sd(x),
    Mediana = median(x),
    IQR = IQR(x),
    Mín = min(x),
    Máx = max(x)
  )
}

vars <- c("v_km_s", "r_Mpc", "mt", "Mt")
tab_desc <- t(sapply(df[vars], desc_stats))
print(round(tab_desc, 2))

# Modelos
m1 <- lm(v_km_s ~ r_Mpc, data = df)
m0 <- lm(v_km_s ~ 0 + r_Mpc, data = df)

cat("\nModelo com intercepto:\n")
print(coef(m1))
cat("QMRes:", summary(m1)$sigma^2, "\n")
cat("R2:", summary(m1)$r.squared, "\n")

cat("\nModelo pela origem:\n")
print(coef(m0))
cat("QMRes:", summary(m0)$sigma^2, "\n")
cat("R2:", summary(m0)$r.squared, "\n")

# Check Mt calculation
df$Mt_calc <- df$mt - 5 * log10(df$r_Mpc) - 25
df$Mt_corrected <- -abs(df$Mt)
dif_vec <- df$Mt_calc - df$Mt_corrected

cat("\nDiferença entre Mt calculado pela fórmula do módulo de distância e Mt da tabela corrigido com sinal negativo:\n")
print(summary(dif_vec))
print(head(data.frame(object = df$object, mt = df$mt, r = df$r_Mpc, Mt_tabela = df$Mt, Mt_calc = round(df$Mt_calc, 2), dif = round(dif_vec, 2)), 10))

