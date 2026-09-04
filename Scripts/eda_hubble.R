library(readxl)

df <- read_excel("Dados/1929_Hubble.xlsx")
cat("Dimensions:", dim(df), "\n")
cat("Column names:", colnames(df), "\n\n")

# Check NA counts in raw
print(colSums(is.na(df)))

# Convert columns to numeric
df_clean <- df
df_clean$r_Mpc <- as.numeric(df_clean$r_Mpc)
df_clean$mt <- as.numeric(df_clean$mt)
df_clean$Mt <- as.numeric(df_clean$Mt)

cat("\nSummary of cleaned data:\n")
print(summary(df_clean))

cat("\nGroup by distance_estimation:\n")
by_group <- split(df_clean, df_clean$distance_estimation)
lapply(by_group, function(sub) {
  cat("\nGroup:", unique(sub$distance_estimation), "\n")
  print(summary(sub[, c("v_km_s", "vs_km_s", "r_Mpc", "mt", "Mt")]))
})

