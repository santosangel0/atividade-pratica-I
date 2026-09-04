#------------------------------------------------------------------------------
#- Script tmm_slides04_behaviour
#------------------------------------------------------------------------------
# Goal: To evaluate the estimators behaviour.
#
# Author: Tiago M. Magalhaes
#         23-mai-2021
#------------------------------------------------------------------------------
Sys.setenv(LANG = "en")
rm(list = ls(all = TRUE))

setwd("D:/Work/UFJF/Undergraduate courses/EST074/Algorithms")

#------------------------------------------------------------------------------
#- Libraries, scripts etc
#------------------------------------------------------------------------------
library("ggplot2")
library("reshape")
# library("xtable")

#------------------------------------------------------------------------------
#- Setup
#------------------------------------------------------------------------------
iRpl <- 5*10^3 #- Number of Monte Carlo's replications
vN <- c(10, 20, 40, 80, 160) #- Sample size
iN <- length(vN)

vBeta <- matrix(c(0.5, 0.5), ncol = 1) #- Vector with true betas values
iP <- dim(vBeta)[1]
dSigma <- 1/10 #- True sigma
vParameters <- c(vBeta, rep(dSigma^2, 2))
set.seed(715)

mEstimation <- array(NA, dim = c(iP+2, 6, length(vN)),
                     dimnames = list(
                       c(paste(expression(beta), 1:iP, sep = ""), 
                         "QMRes", "Sigma2MV"),
                       c("True", "Estimated", "SE",
                         "Bias", "|Bias|", "MSE"),
                       vN))

#------------------------------------------------------------------------------
#- Sample sizes
#------------------------------------------------------------------------------
for(i in 1:iN)
{
  mX <- cbind(1, matrix(runif(vN[i] * (iP-1)), nrow = vN[i]))
  dMu <- mX %*% vBeta
  mTheta <- matrix(NA, nrow = iP + 2, ncol = iRpl) # Betas + sigma2
  rownames(mTheta) <- c(paste(expression(beta), 1:iP, sep = ""), 
                        "QMRes", "sigma2MLE")
  
  #----------------------------------------------------------------------------
  #- Replications
  #----------------------------------------------------------------------------
  for(j in 1:iRpl)
  {
    vY <- rnorm(vN[i], mean = dMu, sd = dSigma)
    mData <- data.frame(vY, mX[, -1])
    mModel <- lm(vY ~ ., data = mData)
    mTheta[1:iP, j] <- t(mModel$coefficients)
    mTheta[iP+1, j] <- (summary(mModel)$sigma^2)
    mTheta[iP+2, j] <- ((vN[i]-iP)/vN[i])*(summary(mModel)$sigma^2)
  }
  mEstimation[,, i] <- cbind(vParameters,
                   apply(mTheta, 1, mean),
                   apply(mTheta, 1, sd),
                   apply((mTheta - vParameters), 1, mean),
                   apply(abs(mTheta - vParameters), 1, mean),
                   apply((mTheta - vParameters)^2, 1, mean))
  print(vN[i])
}

mSizes <- apply(mEstimation, 3L, c)
colnames(mSizes) <- paste("n", vN, sep = "")
mParam <- expand.grid(dimnames(mEstimation)[1:2])
colnames(mParam) <- c("Parametro", "Medida")
mTable <- data.frame(mParam, mSizes)

mAux <- mTable[mTable$Medida == "|Bias|", ]
mAux <- mAux[, -2]
#- https://www.statmethods.net/management/reshape.html
mData <- melt(mAux, id = "Parametro")

levels(mData$variable) <- vN

#------------------------------------------------------------------------------
#- Plots
#------------------------------------------------------------------------------
pTS <- ggplot(data = mData[!mData$Parametro %in% c("QMRes", "Sigma2MV"), ],
              aes(x = variable, y = value, group = Parametro)) +
#pTS <- ggplot(data = mData[mData$Parametro != c("QMRes", "Sigma2MV"), ],
#              aes(x = variable, y = value, group = Parametro)) +
  geom_line(color = "#7B5AA6", linewidth = 0.9,
            linetype = "dashed") +
  geom_point(size = 3, color = "#4f43ae") +
  facet_grid(Parametro ~ .,
             labeller = as_labeller(
               c(beta1 = "beta[1]", beta2 = "beta[2]"),
               label_parsed)) +
  labs(x = "Sample size", y = "Absolute bias") +
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

sFN <- "../Slides/Figures/s04TSbeta.pdf"
ggsave(filename = sFN, plot = pTS, width = 9.0, height = 6.0)

pTS <- ggplot(data = mData[mData$Parametro != paste0(expression(beta), 1:iP), ],
              aes(x = variable, y = value, group = Parametro)) +
  geom_line(color = "#B85C9E", linewidth = 0.9,
            linetype = "dashed") +
  geom_point(size = 3, color = "#4f43ae") +
  facet_grid(Parametro ~ .,
             labeller = as_labeller(
    c(QMRes = "MSRes", Sigma2MV  = "hat(sigma)[MLE]^2"),
    label_parsed)) +
  labs(x = "Sample size", y = "Absolute bias") +
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

sFN <- "../Slides/Figures/s04TSsigma.pdf"
ggsave(filename = sFN, plot = pTS, width = 9.0, height = 6.0)