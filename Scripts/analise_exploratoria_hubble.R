#==============================================================================#
# ATIVIDADE PRÁTICA I - MODELOS LINEARES (EST074) - UFJF
# Script: Análise Exploratória de Dados do Conjunto Histórico de Hubble (1929)
# Autores: Angelo dos Santos Luna Filho & Daniel Antonio Camargo Vieira
#==============================================================================#

# Limpeza e configuração do ambiente
rm(list = ls(all = TRUE))
options(scipen = 999)

# 1. Carregamento de Pacotes ---------------------------------------------------
suppressPackageStartupMessages({
  library(readxl)
  library(dplyr)
  library(ggplot2)
  library(patchwork)
})

# 2. Carregamento e Auditoria dos Dados ----------------------------------------
caminho_dados <- if (file.exists("Dados/1929_Hubble.xlsx")) {
  "Dados/1929_Hubble.xlsx"
} else if (file.exists("../Dados/1929_Hubble.xlsx")) {
  "../Dados/1929_Hubble.xlsx"
} else {
  stop("Arquivo de dados '1929_Hubble.xlsx' não encontrado.")
}

dados_brutos <- read_excel(caminho_dados, sheet = "Data")
cat("Dimensões do conjunto original:", dim(dados_brutos), "\n")

# Conversão de tipos de dados e tratamento de NAs
dados <- dados_brutos %>%
  mutate(
    distance_estimation = as.factor(distance_estimation),
    r_Mpc = as.numeric(r_Mpc),
    mt = as.numeric(mt),
    Mt = as.numeric(Mt),
    # Correção do sinal histórico das magnitudes absolutas
    Mt_corr = ifelse(!is.na(Mt), -abs(Mt), NA)
  )

cat("Observações válidas em distância:", sum(!is.na(dados$r_Mpc)), "\n\n")

# 3. Estatísticas Descritivas --------------------------------------------------
cat("=== ESTATÍSTICAS DESCRITIVAS GERAIS ===\n")
vars_num <- c("v_km_s", "vs_km_s", "r_Mpc", "mt", "Mt_corr")
resumo_geral <- dados %>%
  select(all_of(vars_num)) %>%
  summary()
print(resumo_geral)

cat("\n=== ESTATÍSTICAS POR METODOLOGIA DE DISTÂNCIA ===\n")
resumo_estrat <- dados %>%
  filter(!is.na(r_Mpc)) %>%
  group_by(distance_estimation) %>%
  summarise(
    N = n(),
    v_media = mean(v_km_s),
    v_dp = sd(v_km_s),
    r_media = mean(r_Mpc),
    r_dp = sd(r_Mpc),
    mt_media = mean(mt)
  )
print(resumo_estrat)

# 4. Análise de Correlação -----------------------------------------------------
dados_validos <- dados %>% filter(!is.na(r_Mpc))

cor_global <- cor(dados_validos$v_km_s, dados_validos$r_Mpc)
cor_star <- cor(filter(dados_validos, distance_estimation == "Star-based / Luminosity")$v_km_s,
                filter(dados_validos, distance_estimation == "Star-based / Luminosity")$r_Mpc)
cor_vel <- cor(filter(dados_validos, distance_estimation == "Velocity-based")$v_km_s,
               filter(dados_validos, distance_estimation == "Velocity-based")$r_Mpc)

cat("\n=== CORRELAÇÃO DE PEARSON (v vs r) ===\n")
cat("Global:         ", round(cor_global, 4), " (R² =", round(cor_global^2, 4), ")\n")
cat("Star-based:     ", round(cor_star, 4),   " (R² =", round(cor_star^2, 4), ")\n")
cat("Velocity-based: ", round(cor_vel, 4),    " (R² =", round(cor_vel^2, 4), ")\n\n")

# 5. Modelagem Linear Preliminar -----------------------------------------------
# Modelo 1: Com intercepto (irrestrito)
mod1 <- lm(v_km_s ~ r_Mpc, data = dados_validos)
sum_m1 <- summary(mod1)

# Modelo 2: Pela origem (fisicamente restrito, v = H0 * r)
mod0 <- lm(v_km_s ~ 0 + r_Mpc, data = dados_validos)
sum_m0 <- summary(mod0)

cat("=== REGRESSÃO LINEAR COM INTERCEPTO ===\n")
print(sum_m1)

cat("\n=== REGRESSÃO PELA ORIGEM (v = H0 * r) ===\n")
print(sum_m0)

# Estimativas de variância residual: QMRes (MQO) vs Sigma2_MV (EMV)
n <- nrow(dados_validos)
p1 <- length(coef(mod1))
p0 <- length(coef(mod0))

qmres1 <- sum_m1$sigma^2
sigma2_mv1 <- ((n - p1) / n) * qmres1

qmres0 <- sum_m0$sigma^2
sigma2_mv0 <- ((n - p0) / n) * qmres0

cat("\n=== COMPARATIVO DE VARIÂNCIAS RESIDUAIS ===\n")
cat("Modelo com Intercepto: QMRes =", round(qmres1, 2), "| Sigma2_MV =", round(sigma2_mv1, 2), "\n")
cat("Modelo pela Origem:    QMRes =", round(qmres0, 2), "| Sigma2_MV =", round(sigma2_mv0, 2), "\n\n")

# 6. Diagnóstico de Resíduos ---------------------------------------------------
shapiro_teste <- shapiro.test(residuals(mod1))
cat("=== TESTE DE NORMALIDADE DOS RESÍDUOS (Shapiro-Wilk) ===\n")
print(shapiro_teste)

cat("\nScript executado com sucesso!\n")
