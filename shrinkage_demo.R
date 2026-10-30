# mgcv version of the demonstration (not run here -- no R in this session).
# Shows that a ridge-penalized factor (random effect) breaks the balance principle
# that makes exp(coef) a rating factor in a GLM, and that the penalized score
# equation  sum_{i in k}(y_i - mu_i) = lambda * theta_k  holds exactly.
library(mgcv)
set.seed(20261029)

K <- 40; tau <- 0.35
n_k <- round(exp(runif(K, log(40), log(8000)))); n_k[1] <- max(n_k) + 1   # level 1 = largest = base
terr <- factor(rep(seq_len(K), n_k)); N <- length(terr)
theta <- rnorm(K, 0, tau); theta <- theta - mean(theta)
age <- runif(N, 18, 80)
g <- 0.9 * exp(-(age - 18) / 10) + 0.25 * pmax((age - 60) / 20, 0)^2; g <- g - mean(g)
expo <- runif(N, 0.25, 1)
y <- rpois(N, expo * exp(log(0.10) + theta[terr] + g))
age_band <- cut(age, c(18, 21, 25, 30, 40, 50, 60, 70, 80), include.lowest = TRUE)
d <- data.frame(y, terr, age_band, expo)

m_glm <- gam(y ~ age_band + terr,               offset = log(expo), family = poisson, data = d)
m_re  <- gam(y ~ age_band + s(terr, bs = "re"), offset = log(expo), family = poisson, data = d,
             method = "REML")

# (a) balance by level: zero for the GLM, lambda*theta_k for the random effect
res_glm <- tapply(y - fitted(m_glm), terr, sum)
res_re  <- tapply(y - fitted(m_re),  terr, sum)
theta_re <- coef(m_re)[grep("s\\(terr\\)", names(coef(m_re)))]
lambda   <- m_re$sp
print(max(abs(res_glm)))                          # ~1e-10
print(max(abs(res_re - lambda * theta_re)))       # ~1e-10 : the identity
print(sum(theta_re))                              # 0 : intercept unpenalized

# (b) shrinkage vs volume: theta_re / theta_glm  ~  C_k / (C_k + lambda), C_k = fitted claims in level k
theta_glm <- c(0, coef(m_glm)[grep("^terr", names(coef(m_glm)))]); theta_glm <- theta_glm - mean(theta_glm)
C_k <- tapply(fitted(m_re), terr, sum)
Z_k <- C_k / (C_k + lambda)
print(cbind(policies = n_k, claims = tapply(y, terr, sum), GLM = exp(theta_glm), RE = exp(theta_re),
            ratio = theta_re / theta_glm, Z = Z_k,
            AE_glm = tapply(y, terr, sum) / tapply(fitted(m_glm), terr, sum),
            AE_re  = tapply(y, terr, sum) / C_k)[order(n_k), ])

# (c) one-way A/E correction of the pooled factors reconstructs the GLM factors
AE_re <- tapply(y, terr, sum) / C_k
corr  <- theta_re + log(AE_re); corr <- corr - mean(corr)
print(max(abs(corr - theta_glm)))                 # ~0

# (e) ridge on treatment-coded dummies is not invariant to the base level; the GLM is
#     (paraplt: paraPen puts a ridge on a parametric factor's dummies)
d$terr0  <- relevel(d$terr, ref = "1")            # base = largest
d$terrS  <- relevel(d$terr, ref = as.character(which.min(n_k)))   # base = smallest
X0 <- model.matrix(~ terr0, d)[, -1]; XS <- model.matrix(~ terrS, d)[, -1]
m_r0 <- gam(y ~ age_band + X0, offset = log(expo), family = poisson, data = d,
            paraPen = list(X0 = list(diag(K - 1))), sp = lambda)
m_rS <- gam(y ~ age_band + XS, offset = log(expo), family = poisson, data = d,
            paraPen = list(XS = list(diag(K - 1))), sp = lambda)
print(max(abs(fitted(m_r0) - fitted(m_rS))))      # > 0 : different models
