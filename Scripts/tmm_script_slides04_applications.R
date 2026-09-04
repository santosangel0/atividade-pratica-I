#------------------------------------------------------------------------------
#- Script tmm_slides04_applications
#------------------------------------------------------------------------------
# Goal: To fit dataset.
#
# Author: Tiago M. Magalhaes
#         21-may-2021
#------------------------------------------------------------------------------
Sys.setenv(LANG = "en")
rm(list = ls(all = TRUE))

setwd("D:/Work/UFJF/Undergraduate courses/EST074/Algorithms")

#------------------------------------------------------------------------------
#- Packages
#------------------------------------------------------------------------------
library("ggplot2")
# theme_set(theme_bw())
# library("xtable")

#------------------------------------------------------------------------------
#- Data - Westwood
#------------------------------------------------------------------------------
vLote <- c(30, 20, 60, 80, 40, 50, 60, 30, 70, 60) # Explanatory variable
vHoras <- c(73, 50, 128, 170, 87, 108, 135, 69, 148, 132) # Response variable
iN <- length(vHoras)

mDataWest <- data.frame(Horas = vHoras, Lote = vLote)

#------------------------------------------------------------------------------
#- Plot
#------------------------------------------------------------------------------
pGD <- ggplot(mDataWest, aes(x = Lote, y = Horas)) +
  geom_point(size = 3, color = "#4f43ae") + #191970
  labs(x = "Lot size", y = "Man-hours") +
  # theme(axis.text = element_text(size = 20),
  #       axis.title = element_text(size = 20),
  #       panel.background = element_rect(fill = "#DCDCDC",
  #                                       colour = "#DCDCDC",
  #                                       linewidth = 0.5, linetype = "solid"),
  #       panel.grid.major = element_line(linewidth = 0.9, linetype = 'solid',
  #                                       colour = "white"), 
  #       panel.grid.minor = element_line(linewidth = 0.5, linetype = 'solid',
  #                                       colour = "white")) +
  theme_bw()

#------------------------------------------------------------------------------
#- Fit
#------------------------------------------------------------------------------
outModel <- lm(Horas ~ Lote, data = mDataWest)
# anova(outModel)

vBetahat <- outModel$coefficients
iP <- length(vBetahat)
vHorasHat <- outModel$fitted.values

dQMRes <- summary(outModel)$sigma^2
dSigma2EMV <- ((iN-iP)/iN)*dQMRes

#------------------------------------------------------------------------------
#- Plot
#------------------------------------------------------------------------------
pGD <- pGD +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              colour = "#B85C9E", linewidth = 1.0, #FC4E07
              linetype = "longdash")

# pGD <- ggplot(mDataWest, aes(x = Lote, y = Horas)) +
#   geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
#               colour = "#FC4E07", linewidth = 1.0,
#               linetype = "longdash") +
#   geom_point(size = 4, color = "#191970") +
#   labs(x = "Tamanho do lote", y = "Horas trabalhadas") +
#   theme(axis.text = element_text(size = 20),
#         axis.title = element_text(size = 20),
#         panel.background = element_rect(fill = "#DCDCDC",
#                                         colour = "#DCDCDC",
#                                         linewidth = 0.5, linetype = "solid"),
#         panel.grid.major = element_line(linewidth = 0.9, linetype = 'solid',
#                                         colour = "white"), 
#         panel.grid.minor = element_line(linewidth = 0.5, linetype = 'solid',
#                                         colour = "white"))

sFN <- "../Slides/Figures/s04Westwoodfit.pdf"
ggsave(filename = sFN, plot = pGD, width = 9.0, height = 6.0)

#------------------------------------------------------------------------------
#- Data - Crickets
#------------------------------------------------------------------------------
mCrickets <- (
  "Species  Temperature   Pulse
  ex       20.8   67.9 
  ex       20.8   65.1 
  ex       24     77.3 
  ex       24     78.7 
  ex       24     79.4 
  ex       24     80.4 
  ex       26.2   85.8 
  ex       26.2   86.6 
  ex       26.2   87.5 
  ex       26.2   89.1 
  ex       28.4   98.6 
  ex       29    100.8 
  ex       30.4   99.3 
  ex       30.4  101.7 
  niv      17.2   44.3 
  niv      18.3   47.2 
  niv      18.3   47.6 
  niv      18.3   49.6 
  niv      18.9   50.3 
  niv      18.9   51.8 
  niv      20.4   60 
  niv      21     58.5 
  niv      21     58.9 
  niv      22.1   60.7 
  niv      23.5   69.8 
  niv      24.2   70.9 
  niv      25.9   76.2 
  niv      26.5   76.1 
  niv      26.5   77 
  niv      26.5   77.7 
  niv      28.6   84.7
  ")

mData <- read.table(file = textConnection(object = mCrickets), header = TRUE)
# mData <- data.frame(mData)
mData$Species <- as.factor(mData$Species)
iN <- dim(mData)[1]

#------------------------------------------------------------------------------
#- Plot
#------------------------------------------------------------------------------
pGD <- ggplot(mData,
              aes(x = Temperature, y = Pulse,
                  shape = Species, color = Species)) +
  geom_point(size = 3) +
  labs(x = "Temperature (\u00B0C)", y = "Pulses per second",
       color = "Species", shape = "Species") +
  # theme(legend.position = "bottom",
  #       axis.text = element_text(size = 20),
  #       axis.title = element_text(size = 20),
  #       legend.title = element_text(size = 15),
  #       legend.text = element_text(size = 15),
  #       panel.background = element_rect(fill = "#DCDCDC",
  #                                       colour = "#DCDCDC",
  #                                       linewidth = 0.5, linetype = "solid"),
  #       panel.grid.major = element_line(linewidth = 0.9, linetype = 'solid',
  #                                       colour = "white"), 
  #       panel.grid.minor = element_line(linewidth = 0.5, linetype = 'solid',
  #                                       colour = "white")) +
  theme_bw() +
  theme(legend.position = "bottom")

#------------------------------------------------------------------------------
#- Fit
#------------------------------------------------------------------------------
outModel <- lm(Pulse ~ ., data = mData)

vBetahat <- outModel$coefficients
iP <- length(vBetahat)
vPulseHat <- outModel$fitted.values

dQMRes <- sum((mData$Pulse - vPulseHat)^2)/(iN-iP)
dSigma2EMV <- mean((mData$Pulse - vPulseHat)^2)

#------------------------------------------------------------------------------
#- Plot
#------------------------------------------------------------------------------
pGD <- pGD +
  geom_abline(intercept = vBetahat[1],
              slope = vBetahat[3],
              color = "#F08080", linetype = "dashed",
              linewidth = 1.0) + # Specie 'ex'
  geom_abline(intercept = vBetahat[1] + vBetahat[2],
              slope = vBetahat[3],
              color = "#1E90FF", linetype = "longdash",
              linewidth = 1.0) # Specie 'niv'

sFN <- "../Slides/Figures/s04Cricketfit.pdf"
ggsave(filename = sFN, plot = pGD, width = 9.0, height = 6.0)