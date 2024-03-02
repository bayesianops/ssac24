################################################################################
## setup

library(cmdstanr)
library(bayesplot)
library(tidyverse)
library(ggplot2)

################################################################################
## Data

data <- read.csv("golf_data.csv")
stan_data <- list(N = nrow(data), distance_feet = data$distance_feet,
                  tries = data$tries, successes = data$successes)

## plot data without axes
(ggplot(data, aes(x = distance_feet, y = successes / tries))
  + geom_point(size = 3)
  + xlim(0, 20) + ylim(0, 1)
  + theme_bw()
  + theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          plot.margin = margin(t = 0, b = 0),
          text = element_text(size = 20))
)

## plot data with axes
(ggplot(data, aes(x = distance_feet, y = successes / tries))
  + geom_point(size = 3)
  + geom_segment(aes(x = distance_feet, xend = distance_feet, y = successes / tries - 0.5, yend = successes / tries + 0.5))
  + xlim(0, 20) + ylim(0, 1)
  + theme_bw()
  + theme(plot.margin = margin(t = 0, b = 0),
          text = element_text(size = 20))
)


################################################################################
## Check that cmdstanr works

model <- cmdstanr::cmdstan_model("golf_setup.stan")
fit_mcmc <- model$sample(data = stan_data)
fit_optim <- model$optimize(data = stan_data)
fit_advi <- model$variational(data = stan_data)

################################################################################
## Fit linear model

model <- cmdstanr::cmdstan_model("golf_linear.stan")
fit_mcmc <- model$sample(data = stan_data)
fit_optim <- model$optimize(data = stan_data)
fit_advi <- model$variational(data = stan_data)


(ggplot(data, aes(x = distance_feet, y = successes / tries))
  + geom_point(size = 3)
  + stat_function(fun = function(x) fit_optim$mle()['a'] + fit_optim$mle()['b'] * x, linewidth = 2)
  + xlim(0, 20) + ylim(0, 1)
  + theme_bw()
  + theme(plot.margin = margin(t = 0, b = 0),
          text = element_text(size = 20))
  #+ theme(axis.title.x = element_blank(),
  #axis.title.y = element_blank())
)


bayesplot::mcmc_hist(fit_mcmc$draws(c('a', 'b', 'sigma')))

fit_optim$mle(c('a', 'b', 'sigma'))

################################################################################
## Fit logistic model

model <- cmdstanr::cmdstan_model("golf_logistic.stan")
fit_mcmc <- model$sample(data = stan_data)
fit_optim <- model$optimize(data = stan_data)
fit_advi <- model$variational(data = stan_data)


(ggplot(data, aes(x = distance_feet, y = successes / tries))
  + geom_point(size = 3)
  + stat_function(fun = function(x) boot::inv.logit(fit_optim$mle()['a'] + fit_optim$mle()['b'] * x), linewidth = 2)
  + xlim(0, 20) + ylim(0, 1)
  + theme_bw()
  + theme(plot.margin = margin(t = 0, b = 0),
          text = element_text(size = 20))
  #+ theme(axis.title.x = element_blank(),
  #        axis.title.y = element_blank())
)



################################################################################
## Fit angle model

model <- cmdstanr::cmdstan_model("golf_angle.stan")
fit_mcmc <- model$sample(data = stan_data)
fit_optim <- model$optimize(data = stan_data)
fit_advi <- model$variational(data = stan_data)

r = 1.68 / 12 / 2
R = 4.25 / 12 / 2


(ggplot(data, aes(x = distance_feet, y = successes / tries))
  + geom_point(size = 3)
  + stat_function(fun = function(x)
    2 * pnorm(asin((R - r) / x) / fit_optim$mle()['sigma']) - 1, linewidth = 2)
  + xlim(0, 20) + ylim(0, 1)
  + theme_bw()
  + theme(plot.margin = margin(t = 0, b = 0),
          text = element_text(size = 20))
  #+ theme(axis.title.x = element_blank(),
  #        axis.title.y = element_blank())
)



bayesplot::mcmc_hist(fit_mcmc$draws('sigma_degrees'))

