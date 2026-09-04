library(readxl)
library(dplyr)
library(ggplot2)

df <- read_excel("Dados/1929_Hubble.xlsx")
df$r_Mpc <- as.numeric(df$r_Mpc)
df$mt <- as.numeric(df$mt)
df$Mt <- as.numeric(df$Mt)

# Linear regression for all data with distance
fit_all <- lm(v_km_s ~ r_Mpc, data = df)
fit_all_no_int <- lm(v_km_s ~ 0 + r_Mpc, data = df)

# Linear regression for Star-based
df_star <- filter(df, distance_estimation == "Star-based / Luminosity")
fit_star <- lm(v_km_s ~ r_Mpc, data = df_star)
fit_star_no_int <- lm(v_km_s ~ 0 + r_Mpc, data = df_star)

# Linear regression for Velocity-based
df_vel <- filter(df, distance_estimation == "Velocity-based")
fit_vel <- lm(v_km_s ~ r_Mpc, data = df_vel)
fit_vel_no_int <- lm(v_km_s ~ 0 + r_Mpc, data = df_vel)

cat("=== MODELO COMPLETO (com intercepto) ===\n")
print(summary(fit_all))
cat("=== MODELO COMPLETO (sem intercepto) ===\n")
print(summary(fit_all_no_int))

cat("=== STAR-BASED (com intercepto) ===\n")
print(summary(fit_star))
cat("=== STAR-BASED (sem intercepto) ===\n")
print(summary(fit_star_no_int))

cat("=== VELOCITY-BASED (com intercepto) ===\n")
print(summary(fit_vel))
cat("=== VELOCITY-BASED (sem intercepto) ===\n")
print(summary(fit_vel_no_int))

# Correlation
cat("\nCorrelations:\n")
cat("All (v vs r):", cor(df$v_km_s, df$r_Mpc, use="complete.obs"), "\n")
cat("Star-based (v vs r):", cor(df_star$v_km_s, df_star$r_Mpc, use="complete.obs"), "\n")
cat("Velocity-based (v vs r):", cor(df_vel$v_km_s, df_vel$r_Mpc, use="complete.obs"), "\n")
