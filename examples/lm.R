attach(cars)
out <- summary(lm(speed~dist))




coefficients <- as.matrix(out$coefficients)
residuals <- quantile(out$residual)
se <- out$sigma
se_df <-  out$df[2]
r_squared <- out$r.squared
adj_r_squared <- out$adj.r.squared
f_statistic <- as.matrix(out$fstatistic)
f_statistic_p <- 1 - pf(out[[10]][1],out[[10]][1],out[[10]][1])
rm(out)