# Relativities, Partial Dependence, and Coefficients

Oct 12, 2026 · @Ariel Balter

## Summary

1. A coefficient is a property of the model. A marginal relativity, the normalized partial dependence, is an average of the model over some data.
2. Fix every variable that interacts with the ones being measured, and the average equals the coefficient on any data; the data cancels. Fix fewer, and the average depends on which data was used.
3. So, for rating factors, report the model's own tables, relative to a base cell, one per term with interactions included. They need no data and do not move when the book moves.
4. If someone wants one number per level for a variable that interacts, that number is an average over some book and must say which book.

Everything that follows elaborates one of these four points and changes none of them. "Three operations, three words" fixes the vocabulary. "The rating table is the model" and the sections on gauge, estimation, and the mgcv recipe are point 3. "Where the familiar relativities land," the worked example, and "When marginal relativities are the right tool" are points 2 and 4. "When the model is misspecified" is the one caveat, on points 1 and 3. The notation, the operators, and the proof of point 2 are in the appendices.

**What this adds.** CAS Monograph 16 (§9.3) shows that setting a variable to each level across the book and taking the ratio of summed predictions returns the GLM relativity when the variable is in no interaction, and becomes a portfolio average when it is. Lindholm & Palmquist (2024) give the algebra. This guide takes the next steps: it states the condition variable by variable in terms of the model's terms; shows that the average moves with the book, and by how much; gives the operation that returns the coefficient on any book when interactions are present; and identifies which interaction coefficients survive averaging and when averaging manufactures one. We are not aware of these steps in the actuarial literature. The mathematical ingredients are in the functional-ANOVA and anchored-decomposition literatures, cited in "Where this sits in the literature."

## Three operations, three words

*The vocabulary clash that motivates the guide, and the words used from here on.*

Every relativity in this guide is built from one of three operations on a model $\hat\mu$ and a data set, followed by the same ratio to a base value. The operations differ only in what happens to the variables other than the ones being measured.

| Operation | The other variables | Operator form | Sum form | Word used here | Also called |
| --- | --- | --- | --- | --- | --- |
| Filter | whatever the selected rows have | $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{F}_S(z)\, D$ | $\sum_{i:\, x_{i,S} = z} w_i\, \hat\mu(x_i) \big/ \sum_{i:\, x_{i,S} = z} w_i$ | **conditional** (one-way) | one-way relativity; Apley & Zhu's "M-plot" (M for marginal, the reverse of the statistics usage) |
| Set and average | keep each row's own values and are averaged over | $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, D$ | $\sum_i w_i\, \hat\mu(z_S; x_{i,\bar S}) \big/ \sum_i w_i$ | **marginal** | Friedman's "partial dependence" (PDP); the econometric average marginal effect |
| Set and hold | held at the base cell | $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, \{x^0\} = \hat\mu(z_S; x^0_{\bar S})$ | no sum: one evaluation | **partial** | the GLM coefficient relativity; pricing shop talk's "partial relativity"; the econometric partial effect at a representative point; the anchored decomposition |

$\mathbb{F}_S(z)\, D$ keeps the rows of $D$ with $x_S = z$. $\mathbb{T}_S(z)\, D$ overwrites $x_S$ with $z$ in every row and leaves exposure untouched. $\boldsymbol{\Sigma}_w\, f\, D$ is the exposure-weighted mean of $f$ over the rows of $D$. $\{x^0\}$ is the one-row data set holding the base cell. Appendix A has the definitions.

The words follow the statistics usage. *Conditional* is $E[\hat\mu \mid X_S = z]$. *Marginal* integrates the other variables out against their marginal distribution. *Partial* is the partial derivative's finite cousin, everything else held fixed, which is also what pricing teams mean by a partial relativity. The cost is that the machine-learning literature attached "partial" to the marginal operation when it named partial dependence, so the table is the translation. Earlier drafts of this guide used "partial relativity" for the marginal operation; from here on, the marginal relativity $\bar r_S(z; P)$ is the set-and-average ratio, and the partial relativity $r_t(z)$ is the held-at-base ratio, which is the coefficient. Point 2 in one line: the marginal relativity equals the partial relativity exactly when no term overlaps $S$ partway.

## The rating table is the model

*Point 3: what to report, and why it needs no data.*

Take any set $S$ that no term overlaps partway. Then the marginal relativity $\bar r_S(z; P)$ does not depend on $P$, and it equals the product of the partial relativities of the terms inside $S$:

$$
r_S(z) = \prod_{t \in M,\; t \subseteq S} \exp\big(\beta_t(z_t) - \beta_t(x^0_t)\big)
$$

So the model's term tables, expressed relative to a base cell, are the unique population-free relativities. Delivered one per main effect and one per interaction, they multiply with the base rate to reproduce $\hat\mu(x)$ at every cell, for any future book in which the way loss depends on the variables has not changed.

**Reading any coefficient off the model.** Every coefficient is a ratio of model evaluations in which the variables of its term are set and every other variable is held at the base cell $x^0$:

$$
\begin{aligned}
e^{\beta_j(z)} &= \frac{\hat\mu(z_j,\, x^0_{\text{rest}})}{\hat\mu(x^0)}\\[6pt]
e^{\beta_{jk}(z_j, z_k)} &= \frac{\hat\mu(z_j, z_k,\, x^0_{\text{rest}})\;\hat\mu(x^0)}{\hat\mu(z_j,\, x^0_{\text{rest}})\;\hat\mu(z_k,\, x^0_{\text{rest}})}
\end{aligned}
$$

and for higher orders the same alternating pattern over the subsets of the term. On the log scale these are $\beta_j(z)$ and $\beta_{jk}(z_j, z_k)$: the coefficients themselves, relative to the base cell. This returns the coefficient exactly, in the gauge whose base cell is $x^0$, for any model built from terms, and it needs no data: every variable outside the term is held at one value. Written as a sum over data rows instead, any variable that shares no interaction term with the term's variables may be left moving, because its contribution appears identically in numerator and denominator and cancels; any variable that does share one must be pinned. Leaving such a variable moving is the only way to obtain a number that is not the coefficient, and that is the whole content of the lemma.

**What "coefficient" means for a smooth or penalized term.** For a factor in a GLM the coefficient table is the vector of fitted $\beta$'s, one per non-base level. For a smooth $s(\text{age})$ in a GAM the basis coefficients mean nothing one at a time; the coefficient is the term function on a grid, $s(0), s(1), \ldots$, and the partial relativity is $\exp(s(z) - s(z^0))$. For a tensor-product interaction the same holds on a two-dimensional grid: `te()` carries the whole joint surface in one term, `ti()` carries the pure interaction under sum-to-zero constraints over the training margins (Gauge section). For a penalized or random-effect factor (`bs = "re"`, or a lasso-penalized level set) the coefficients are the shrunken level effects, and those, not the raw per-level means, are the table. In every case the recipe is the same: evaluate $\hat\mu$ on the grid with everything else at the base cell and take ratios, which never touches the software's internal parameterization.

Everything else is an average of them. A marginal relativity over a set that some term overlaps partway depends on $P$, by the lemma, and is a $P$-weighted average of the partial relativities. The weights are the population. Change the book and the number moves while $\hat\mu$ stays put.

Two things follow for practice. "Report the coefficients" means report every table the model has, interactions included; a main-effect table on its own, for a variable that interacts, is one of the averages. And the only decision left is which cell is the base cell (the Gauge section), not which population.

## Where the familiar relativities land

*Points 2 and 4: which averages equal coefficients, and what the others are.*

Each familiar relativity is one of the three operations over some set, against some population. The table says which operation, which population, and whether the population cancels.

| Relativity | Operation | Set | Reference population $P$ | $P$-free? |
| --- | --- | --- | --- | --- |
| Conditional (one-way) actual: exposure-weighted mean of $y$ over the rows with $x_j = z$ | filter | $\{j\}$ | the rows that have $x_j = z$: a different population at each level | No, and the per-level populations differ, which is confounding |
| Conditional (one-way) fitted: the same with $\hat y$ | filter | $\{j\}$ | same | No, same reason |
| Marginal relativity on the training data | set and average | $\{j\}$ | the training data | Only if $j$ is in no interaction |
| Marginal relativity on a forecast book | set and average | $\{j\}$ | the forecast book | Only if $j$ is in no interaction |
| Partial relativity: the treatment-contrast main effect $\exp(\beta_j(z) - \beta_j(x^0_j))$ | set and hold | $\{j\}$ | a single cell: the base cell | Yes; with interactions present it is the effect at the base levels of the others |
| Two-way marginal relativity over $\{j, k\}$ | set and average | $\{j, k\}$ | any | Only if no term overlaps $\{j, k\}$ partway; the double ratio can survive regardless (Appendix B) |
| Partial relativities: the term tables $\exp(\beta_t)$, every $t$ in $M$ | set and hold | all | none: nothing is averaged | Yes, by construction |

**Confounding is the one-way case.** The one-way relativity at level $z$ averages $\hat\mu$ over whatever other characteristics the policies at level $z$ happen to have. If age correlates with tenure, the age one-way carries tenure's effect. In this notation it is the statement that $P$ changes with $z$.

**A partial relativity is a single-cell marginal relativity.** With $\beta_{AB}$ in the model, $\exp(\beta_A(a) - \beta_A(a^0))$ is the effect of $A$ for policies at the base level of $B$. That is a legitimate conditional effect. It is not "the" effect of $A$, because there is no such thing when $\beta_{AB} \neq 0$; there is one effect per level of $B$, and every one-way number is some average of them. The full set of tables is the answer.

**Overlapping interactions need every variable they touch.** With $A \times B$ and $B \times C$ both in the model, a two-way partial dependence over $(A, B)$ averages over $C$:

$$
\mathrm{PD}_{AB}(a, b; P) = e^{\beta_0+\beta_A(a)+\beta_B(b)+\beta_{AB}(a,b)} \cdot E_P\!\left[e^{\beta_C(c)+\beta_{BC}(b,c)}\right]
$$

The trailing average depends on $b$ through $\beta_{BC}$, so the $(A, B)$ relativity depends on the mix of $C$ in $P$. The term tables $\exp(\beta_{AB})$ and $\exp(\beta_{BC})$ have no such problem: they are separate and multiply. The interaction factor alone does survive as the double ratio $\mathrm{PD}(a,b) \cdot \mathrm{PD}(a^0,b^0) / \big(\mathrm{PD}(a,b^0) \cdot \mathrm{PD}(a^0,b)\big)$, where the averages cancel because the $C$-dependent factor is a function of $b$ alone; this holds provided no third variable interacts with both $A$ and $B$ (Appendix B gives the condition and a counterexample), and it is also how to read an interaction off a two-dimensional partial-dependence plot of a model that has no terms to tabulate.

## A worked 2×2 example

*Point 2, with numbers.*

Two binary factors with an interaction:

$$
\ln \hat\mu = \beta_0 + \beta_A[A{=}a_1] + \beta_B[B{=}b_1] + \gamma[A{=}a_1,\,B{=}b_1]
$$

The model has two conditional relativities for $A$: $\exp(\beta_A)$ when $B = b_0$, and $\exp(\beta_A + \gamma)$ when $B = b_1$. The marginal relativity of $A$ on a population in which a fraction $p$ of the exposure has $B = b_1$ is

$$
r_A(a_1; p) = e^{\beta_A}\cdot\frac{(1-p) + p\,e^{\beta_B+\gamma}}{(1-p) + p\,e^{\beta_B}}
$$

The two conditional relativities are blended with weights $(1 - p)$ and $p \cdot \exp(\beta_B)$: frequency times base prediction, because the relativity is a ratio of averages. With $\beta_A = 0.5$, $\beta_B = 0.3$, $\gamma = 0.4$:

| $B$ mix, $p$ | $r_A(a_1; p)$ | What it is |
| --- | --- | --- |
| 0 | 1.65 | $\exp(\beta_A)$: the partial relativity, the treatment-contrast main effect |
| 0.5 | 2.11 | the marginal relativity on a book that is half $b_1$ |
| 0.9 | 2.40 | the marginal relativity on a book that is 90% $b_1$ |
| 1 | 2.46 | $\exp(\beta_A + \gamma)$ |

Set $\gamma = 0$ and every row reads 1.65. That is the lemma in one table: the number moves with $p$ exactly when a term joins $A$ to another variable.

The same in R, with a helper that takes the reference population as an argument:

```r
pd_curve <- function(model, S, grid, P, w = rep(1, nrow(P)),
                     pred = function(m, d) predict(m, newdata = d, type = "response")) {
  sapply(grid, function(z) {
    cf <- P
    cf[[S]] <- if (is.factor(P[[S]])) factor(z, levels = levels(P[[S]])) else z
    weighted.mean(pred(model, cf), w)             # PD_S(z; P): set, score, average
  })
}
marginal_rel <- function(model, S, grid, P, z0 = grid[1], ...) {
  pd <- pd_curve(model, S, grid, P, ...)
  pd / pd[match(z0, grid)]                        # marginal relativity r-bar_S(z; P)
}

sim <- function(n, pA, pB) {
  d <- data.frame(A = factor(sample(c("a0", "a1"), n, TRUE, c(1 - pA, pA))),
                  B = factor(sample(c("b0", "b1"), n, TRUE, c(1 - pB, pB))))
  mu  <- exp(0.5 * (d$A == "a1") + 0.3 * (d$B == "b1") + 0.4 * (d$A == "a1" & d$B == "b1"))
  d$y <- rpois(n, mu)
  d
}
set.seed(1)
D   <- sim(2e5, pA = 0.5, pB = 0.5)
Dp  <- sim(2e5, pA = 0.2, pB = 0.9)
mD  <- glm(y ~ A * B, data = D,  family = poisson)
mDp <- glm(y ~ A * B, data = Dp, family = poisson)
rbind(exp(coef(mD)), exp(coef(mDp)))              # same coefficients from either sample

grid <- c("a0", "a1")
marginal_rel(mD,  "A", grid, P = D )[2]           # 2.11  fit on D,  evaluated on D
marginal_rel(mDp, "A", grid, P = D )[2]           # 2.11  fit on D', evaluated on D
marginal_rel(mD,  "A", grid, P = Dp)[2]           # 2.40  fit on D,  evaluated on D'
marginal_rel(mDp, "A", grid, P = Dp)[2]           # 2.40  fit on D', evaluated on D'
marginal_rel(mD,  "A", grid, P = D[D$B == "b0", ][1, ])[2]
                                                  # 1.65: a one-row P at base B is the partial relativity
```

The coefficients depend on the data-generating process; the marginal relativity depends on the evaluation population and not at all on the fitting data. The mix of $A$ itself never enters: the counterfactual overwrites $A$, so only the distribution of the other variables matters.

## Gauge: the base cell and the base rate

*Point 3: "relative to a base cell" is a choice, and this is how to make it.*

"Gauge" here means the convention that decides which cell every table reads 1.0 at. The split of $\hat\mu$ into tables is unique only up to that convention: any function of $a$ alone can be moved between $\beta_{AB}$ and $\beta_A$, any function of $b$ alone between $\beta_{AB}$ and $\beta_B$, and constants into $\beta_0$, without changing $\hat\mu$. Software fixes the freedom by a default, and each default is a hidden choice of population.

- Treatment contrasts (R's default for factors) force the interaction table to be 1 along the base row and base column. The main-effect table is then the effect at the base levels of the other variables.
- mgcv constrains each smooth to sum to zero over the observed covariate values in the training data, so the intercept and the level of every smooth are set by the training population. `ti()` splits a tensor product into mains and a pure interaction under the same training-data constraints; `te()` keeps the whole joint surface in one term.

The consequence is that coefficients and intercepts move on every refit, even when the model is correctly specified and $\hat\mu$ has not changed. The convention moved, not the model.

Express everything relative to a named base cell $x^0$ at delivery. Each one-way table is the model's profile through $x^0$, each interaction table is the double ratio about $x^0$, and the base rate absorbs the rest:

$$
r_j(z) = \frac{\hat\mu(z_j,\, x^0_{V\setminus\{j\}})}{\hat\mu(x^0)}, \qquad r_{jk}(z_j, z_k) = \frac{\hat\mu(z_j, z_k,\, x^0_{V\setminus\{j,k\}})\; \hat\mu(x^0)}{\hat\mu(z_j,\, x^0_{V\setminus\{j\}})\; \hat\mu(z_k,\, x^0_{V\setminus\{k\}})}, \qquad \text{base rate} = \hat\mu(x^0)
$$

These are ratios of $\hat\mu$ on grids anchored at $x^0$, so they need no access to the software's internal term labels and are exact for any term structure. Every table reads 1.0 at the base cell, the base rate is the fitted rate there, and base rate × tables reproduces $\hat\mu$ at every cell. Under a correct model the tables are stable across refits.

Choose the base cell for stability, not habit: a cell with heavy exposure, so that its fitted value, and with shrinkage its shrunken effect, is well determined. Write the base cell down next to the tables.

## When the model is misspecified

*The one caveat, on points 1 and 3: they assume the model is right.*

The lemma is a statement about the fitted function $\hat\mu$ and holds whether or not the model is correctly specified: pin the partners and the data cancels, for any $\hat\mu$ built from terms. Correct specification matters for a different claim, that the coefficients themselves stay put when the model is refit on a different mix. Omit a term the data-generating process has, and that claim fails: the fitted coefficients become population-dependent before any relativity is computed.

**Why.** The maximum-likelihood fit converges to the best approximation of the truth within the model family, where "best" is judged on average over the covariate distribution of the training data. When the family contains the truth, the approximation is exact and the covariate distribution drops out. When it does not, "best on average over the training data" is the same operation a marginal relativity performs.

**The 2×2 case is exact.** Fit $\ln \hat\mu = \beta_0 + \beta_A + \beta_B$, with no interaction, to the interacting process of the worked 2×2 example, with $A$ and $B$ independent in the sample. The score equations match the sample's one-way margins, and in the large-sample limit

$$
e^{\hat\beta_A} = \frac{\sum_b q_b\, \mu_{a_1 b}}{\sum_b q_b\, \mu_{a_0 b}}
$$

with $q_b$ the sample frequencies of $B$ and $\mu_{ab}$ the true cell means. That is the true model's marginal relativity on the training mix. The misspecified main effect is a marginal relativity wearing coefficient clothing.

```r
exp(coef(glm(y ~ A + B, data = D,  family = poisson)))["Aa1"]   # 2.11
exp(coef(glm(y ~ A + B, data = Dp, family = poisson)))["Aa1"]   # 2.40
```

Compare the table in the worked 2×2 example: same numbers, now produced by refitting rather than by changing the evaluation population.

**Implications.**

- A rating model that omits interactions on purpose has coefficients standardized to the training mix. They drift on refit as the book drifts. That is the mechanism, not noise.
- Marginal relativities of a misspecified model do not help. A partial dependence is computed from $\hat\mu$ and cannot restore a term $\hat\mu$ lacks. If the fitted model is additive on the log scale, its marginal relativities equal its partial relativities for every $P$.
- The levers are the model or the fitting weights. Add the missing term, which a flexible model's partial-dependence plots are a good way to find, or fit under weights that match the expected future mix. The summary is never the lever.

## Estimation: credibility and intervals

*Point 3: how well the tables are estimated. This section is also a standalone practical note for colleagues on shrinkage as credibility; it stays in the guide and is not part of the manuscript.*

Identification and estimation are separate questions. The lemma says which quantities are population-free; shrinkage and uncertainty say how well they are estimated. Nothing in this section changes which tables to report.

**Shrinkage is credibility.** A factor with many thin levels, fit as a ridge-penalized or random-effect term, is the generalized-linear-mixed-model analog of Bühlmann–Straub credibility. Each level's effect is pulled toward a complement with a weight that rises with the level's exposure, and the credibility constant is estimated by REML rather than assumed. In mgcv, `s(breed, bs = "re")` shrinks toward the book average on the log scale; `bs = "mrf"` shrinks territories toward their neighbors; a smooth over an ordered index shrinks adjacent bands toward each other.

Two consequences for the table. The base level must carry heavy exposure, because a thin base level is itself shrunk and the whole table would be normalized to a shrunken number. And the shrunken relativities are the ones to report: they are the model's estimate, and the raw per-level means are what the model was built to replace.

**Intervals on every cell.** The posterior covariance $\Sigma$ of the coefficients gives intervals on any derived quantity, ratios included. Draw coefficient vectors from $N(\hat\beta, \Sigma)$, evaluate the table for each draw, and take quantiles. Thin levels show wide bands. That is the honest display of credibility, and it usually ends the argument about whether a level "has enough data". The recipe section has the code.

## Recipe: building the table from an mgcv GAM

*Point 3: the code.*

Every table below is a ratio of $\hat\mu$ on a grid anchored at the base cell, so the recipe is exact for any term structure and never touches the software's internal term labels. It works unchanged for a glm.

```r
library(mgcv)

# 1. Fit. Few-level factors as parametric terms, thin factors as random effects,
#    continuous variables as smooths, interactions as pure tensor interactions.
m <- gam(claims ~ sex + s(age) + s(weight) + ti(age, weight) + s(breed, bs = "re")
                + offset(log(exposure)),
         family = poisson, data = D, method = "REML")

# 2. Base cell x0: heavy exposure, named once, written down next to the tables.
x0 <- data.frame(sex = "F", age = 4, weight = 25, breed = "mixed", exposure = 1)
x0$sex   <- factor(x0$sex,   levels = levels(D$sex))
x0$breed <- factor(x0$breed, levels = levels(D$breed))
eta <- function(model, d) as.numeric(predict(model, newdata = d, type = "link"))   # ln mu_hat

# Copies of the base cell with chosen columns overwritten by z; factor levels kept.
at_base <- function(...) {
  z <- list(...)
  g <- x0[rep(1, length(z[[1]])), ]
  for (v in names(z))
    g[[v]] <- if (is.factor(D[[v]])) factor(z[[v]], levels = levels(D[[v]])) else z[[v]]
  g
}

# 3. One-way tables r_j(z): the profile through the base cell. 1.0 at the base value.
one_way <- function(model, var, z) {
  g <- do.call(at_base, setNames(list(z), var))
  setNames(exp(eta(model, g) - eta(model, x0)), z)
}
r_sex    <- one_way(m, "sex",    levels(D$sex))
r_age    <- one_way(m, "age",    0:14)
r_weight <- one_way(m, "weight", c(5, 10, 15, 25, 40, 60))
r_breed  <- one_way(m, "breed",  levels(D$breed))      # shrunken effects

# 4. Two-way table r_jk(z_j, z_k): the double ratio about the base cell.
#    1.0 along the base row and base column.
two_way <- function(model, v1, z1, v2, z2) {
  g  <- expand.grid(z1, z2)
  gg <- do.call(at_base, setNames(list(g[[1]], g[[2]]), c(v1, v2)))
  E  <- matrix(eta(model, gg), length(z1), length(z2), dimnames = list(z1, z2))
  i0 <- match(x0[[v1]], z1); j0 <- match(x0[[v2]], z2)
  exp(E - E[, j0] - rep(E[i0, ], each = length(z1)) + E[i0, j0])
}
r_aw <- two_way(m, "age", 0:14, "weight", c(5, 10, 15, 25, 40, 60))

# 5. Base rate: the fitted rate at the base cell, per unit exposure.
base_rate <- exp(eta(m, x0))

# Check at any cell: base_rate * r_sex * r_age * r_weight * r_aw[age, weight] * r_breed
# equals exp(eta(m, cell)).

# 6. Intervals: posterior draws of a whole table through the linear-predictor matrix.
g  <- at_base(age = 0:14)
Xp <- predict(m, newdata = rbind(x0, g), type = "lpmatrix")
B  <- MASS::mvrnorm(2000, coef(m), vcov(m, unconditional = TRUE))
L  <- Xp %*% t(B)                               # row 1 = base cell, then the grid; one column per draw
age_draws <- exp(sweep(L[-1, ], 2, L[1, ]))     # each column is one draw's age table
t(apply(age_draws, 1, quantile, c(0.05, 0.5, 0.95)))
```

Notes.

- The base cell's values must appear in every grid they anchor (age 4 in the age grid, weight 25 in the weight grid).
- For a variable that sits in an interaction, its one-way table is the profile at base and the rating needs the interaction table as well: the age rating at a cell is $r_{\text{age}} \times r_{\text{aw}}[\text{age}, \text{weight}]$. Deliver both, never the one-way alone.
- `predict(type = "terms")` shows the same contributions in mgcv's own sum-to-zero convention and is useful for inspection; the subtraction against the base cell is the re-expression relative to $x^0$.
- `vcov(m, unconditional = TRUE)` includes smoothing-parameter uncertainty. The same draw-through-lpmatrix pattern gives intervals for the two-way table and the base rate.

## When marginal relativities are the right tool

*Point 4: when an average over a book is what is wanted.*

A marginal relativity is a summary of a model over a book. It answers a question about that book, and it is the right tool when that is the question and the book is named.

- **Reading a model that has no terms.** A gradient-boosted model has no $\beta_t$ to tabulate. Its one- and two-dimensional partial dependence on a named reference set is how you see what it learned, and the double ratio of a two-dimensional partial dependence exposes an interaction a GLM could then include as a term.
- **Reporting an average effect.** "What does age do, on average, across our book?" is a question about a population, and the marginal relativity of age on that book answers it. Label it with the book and the as-of date.
- **Stress-testing.** Partial dependence on a synthetic grid probes how $\hat\mu$ behaves away from the training support. Treat the output as a sensitivity check, not a relativity; the model was never validated there.
- **Detecting interactions, with one caveat.** The double ratio of a two-dimensional partial dependence, the H-statistic, and Monograph 16's permutation score all respond to an $A \times B$ interaction, and all three also respond when $A$ and $B$ each interact with a third variable $C$ and not with each other, because averaging over a shared partner manufactures a log-scale $A \times B$ effect (Appendix B has a numerical example). Before adding $A \times B$ to a GLM on that evidence, hold $C$ at base and recompute: a real $A \times B$ survives, a manufactured one vanishes.

**Effect sizes.** A partial dependence fixes two different problems only one of which is widely known. Intervening on a variable instead of filtering on it removes confounding; that is the well-known one, and it is why marginal relativities are preferred to conditional (one-way) relativities. It does not remove interaction blending: a one-variable partial dependence on $A$ lets $A$'s interaction partners move, and what comes back is a mix-weighted blend of $A$'s conditional effects, not $A$'s coefficient. So the one-variable marginal relativity is the effect size for a variable in no interaction, on any data; for a variable in an interaction, hold its partners at base (the tool has to be told to) or report the two-way table. Letting the partners move is where "the marginal relativities changed when we refit" comes from: the book moved, and the number followed it.

What it is not is a rating factor for a model you can read term by term. For a well-specified GLM or GAM the term tables are population-free, and a marginal relativity is an average of them: strictly less information, with a population attached that the reader cannot see.

One rule covers every marginal relativity that leaves the team: the reference population is written on it.

## Checklist

**Deliver**

- [ ] One table per term, interactions included, re-gauged to a named base cell with heavy exposure
- [ ] The base rate: the fitted rate at the base cell, per unit exposure
- [ ] Intervals on each table from posterior draws
- [ ] The model formula and the base cell, in the same document as the tables

**Label**

- [ ] Any marginal relativity: the reference population and its as-of date
- [ ] Any one-way exhibit: "diagnostic, not a rating factor"
- [ ] Any main-effect table for a variable that interacts: "profile at base; rate with the interaction table"

**Avoid**

- [ ] A main-effect table alone when the model has an interaction on that variable
- [ ] A two-way partial-dependence table over $(A, B)$ when some term overlaps $\{A, B\}$ partway (a $B \times C$ term, say); deliver the term tables instead
- [ ] Marginal relativities of a misspecified model offered as a correction for the misspecification; fix the model or reweight the fit
- [ ] A base level chosen by habit rather than exposure

## Where this sits in the literature

*What is already known, in which field, and what this guide adds.*

Every piece of the argument exists somewhere. No source found states it as a unit for term-based pricing models, and the three fields that hold the pieces do not cite each other.

**Two meanings of "partial relativity."** In pricing shop talk a partial relativity is the factor for one variable with the other factors held constant, as opposed to a one-way relativity read off raw experience; in that sense it is the GLM coefficient relativity, and this guide's conclusion reads as "report the partial relativities." The machine-learning literature attached the same adjective to the opposite treatment of the other variables when Friedman named partial dependence, which averages them out, so a normalized partial dependence has also been called a partial relativity, including in earlier drafts of this guide. The two coincide exactly when no term overlaps the fixed set partway, and the guide is about what happens when they do not. This guide follows the statistics usage: conditional for the filtered one-way, marginal for the set-and-average ratio, partial for the held-at-base ratio ("Three operations, three words"). The phrase "partial relativity" does not appear in the written actuarial literature under either meaning; the CAS material speaks of relativities, GLM relativities and one-way relativities.

**Actuarial literature.** The nearest practical prior work is [CAS Monograph 16](https://www.casact.org/publications-research/publications/flagship-publications/cas-monographs/monograph-no-16) (Chalk, Deacon, Guillen & Martinelli; on the Exam 8 syllabus from October 2026), §9.3, pp. 154–158. It sets a rating variable to one value for every policy, predicts, sets it to another, predicts again, and shows the ratio of the summed predictions equals the GLM relativity, because the GLM has no interactions and only one thing changed (Tables 9.7–9.9). It then says in words that had the variable interacted with another, each policy's ratio would differ and the ratio of totals would give the change on average across the policies used; names the procedure partial dependence; notes that the ratio of means weights each policy by its predicted frequency (Fig. 9.5); and in §9.4 observes that its permutation-based interaction score also fires when two features each interact with a common third. It does not draw the consequence that the average depends on the book, does not say how to recover the relativity when the variable interacts, and computes no two-way partial dependence. The nearest mathematical prior work is [Lindholm & Palmquist (2024)](https://ideas.repec.org/a/cup/anacsi/v18y2024i3p675-691_7.html), whose Eq. (8) is the log-link model with pairwise interactions and whose Eq. (9) writes the one-way partial dependence as $\exp\{f_j(x_j)\}$ times a factor $\nu$ that integrates every other term against the data distribution and depends on $x_j$ only through the interactions; Eq. (10) notes proportionality to $\exp\{f_j\}$ when all interactions vanish, and Eq. (11) that the two-way partial dependence does not identify $\exp\{f_{jk}\}$. They state the condition as "all interactions zero" rather than "no interaction involving this variable," never remark that $\nu$ changes with the data distribution, and resolve the identification by redefining the main effects so that partial dependence equals them (p. 679), which moves the mix-dependence into the coefficients rather than out of them; their two-way ratio divides by one-way partial dependences and yields $\exp\{f_{jk}\}/(\nu_1 \nu_2)$, not $\exp\{f_{jk}\}$. They set the level aside deliberately, since their partial dependences only construct covariate partitions. Their $\nu$ lumps together the terms that cancel in a ratio ($Q'$) and the terms that do not ($Q''$); splitting it is the step that yields the per-variable condition, the population dependence, and the recovery by holding partners at base. The maidrr tariff-extraction recipe of [Henckaerts, Antonio & Côté (2022)](https://arxiv.org/abs/2007.06894) uses one-way partial dependences for main effects and two-way minus one-way for interactions, on the response scale, without a statement of when this recovers coefficients. [Henckaerts, Côté, Antonio & Verbelen (2021)](https://arxiv.org/abs/1904.10890), [Lorentzen & Mayer (2020)](https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3595944) and the [SOA interpretability report (2021)](https://www.soa.org/globalassets/assets/files/resources/research-report/2021/interpretable-machine-learning.pdf) give the qualitative warning that averaging in a partial dependence can hide interactions. No actuarial source found says that partial-dependence relativities for interacting variables move with the book mix. The [CAS GLM monograph](https://www.casact.org/monograph/cas-monograph-no-5) reports coefficient relativities relative to a base level and does not use partial dependence.

**Machine-learning interpretability.** The mechanism is established in functional-ANOVA vocabulary. [Friedman (2001)](https://projecteuclid.org/euclid.aos/1013203451), [Apley & Zhu (2020)](https://arxiv.org/abs/1612.08468) and [Zhao & Hastie (2021)](https://www.statslab.cam.ac.uk/~qz280/publication/pdp/paper.pdf) state that a partial dependence recovers a component exactly when the function splits additively across the chosen set, which is the no-partway-overlap condition in another language. [Herbinger, Bischl & Casalicchio (2022)](https://arxiv.org/abs/2202.07254) work the model $\beta_1 x_1 + \beta_2 x_2 + \beta_{12} x_1 x_2$ and show the one-way partial dependence equals $\beta_1$ only because the partner has mean zero. [Lengerich, Tan, Chang, Hooker & Caruana (2020)](https://arxiv.org/abs/1911.04974) show that the split between main effects and interactions in a GAM is not identified without a data distribution and that effects change sign across distributions; [Hiabu, Meyer & Wright (2023)](https://arxiv.org/abs/2208.06151) make "partial dependence equals the main effect" an explicit choice of identification rather than a fact. [Hooker (2007)](https://www.tandfonline.com/doi/abs/10.1198/106186007X237892) is the source for the population dependence of averaged decompositions, and [Friedman & Popescu (2008)](https://arxiv.org/abs/0811.1679) build the H-statistic from $\mathrm{PD}_{AB} - \mathrm{PD}_A - \mathrm{PD}_B$, the additive form of the double ratio.

**Anchored decompositions and econometrics.** Holding the other variables at a reference point instead of averaging over them is the anchored (cut-HDMR) decomposition of numerical analysis: [Kuo, Sloan, Wasilkowski & Woźniakowski (2010)](https://www.ams.org/journals/mcom/2010-79-270/S0025-5718-09-02319-9) give the general Möbius formula and the vanishing property behind the disjoint-terms result, [Rahman (2014)](https://arxiv.org/abs/1310.6769) states that the anchored components need no probability measure while the averaged ones do, and [Mase, Owen & Seiler (2019)](https://arxiv.org/abs/1911.00467) and [Gao & Zhao (2024)](https://arxiv.org/abs/2411.01625) carry the same construction into Shapley explanations, naming the alternating sum as Möbius inversion. In econometrics the same distinction is the average marginal effect versus the marginal effect at representative values, and [Ai & Norton (2003)](<https://doi.org/10.1016/S0165-1765(03)00032-6>) is the standard reference that the interaction effect in a nonlinear model is not the interaction coefficient. None of these connects the anchored decomposition to treatment-contrast GLM coefficients or to rating tables.

**What this guide adds.** Monograph 16 stops at "the GLM has coefficients, the black box has a portfolio average," and Lindholm & Palmquist supply the algebra for why. This guide answers what both leave open, stated for models built from named terms: a one-way marginal relativity equals the main-effect coefficient, the partial relativity, if and only if the variable is in no interaction; the per-term recipe is exact if and only if the interaction terms are pairwise disjoint; when terms overlap, holding the partners at base, which is the treatment-contrast definition, returns the coefficient on any book; a marginal relativity that moves between refits is the sign that too few variables were held, not that the model is unstable; and an interaction coefficient survives averaging exactly when the averaged-over variables leave no full-order contrast, with averaging over a shared partner able to manufacture an interaction the model does not have. Each step is a corollary of results above. We are not aware of the combination, or of its consequence for which relativities to put in a rate filing, in the pricing literature.

## Appendix A: Objects and notation

*The symbols used in Appendix B. Not needed for the main body.*

One rule runs through every definition below: a row index $i$ always refers to a specific data set. A model has no rows; a prediction gets its row index from the data set the model was applied to.

**Variables, sets of variables, and terms.** Let $V$ be the set of rating variables; a variable is an atom, not a set. A subset $t \subseteq V$ is a set of variables, and $\mathcal{P}(V)$ is the collection of all such subsets. The model carries a term for some of them; the collection of subsets that have terms is $M \subseteq \mathcal{P}(V)$. For each $t \in M$ the term is $g_t$, a function of the coordinates of $x$ in $t$ only, and its coefficient table is $\beta_t = \ln g_t$. So $t$ is a set and $g_t$ is a function; "the term $t$" is shorthand for $g_t$. $|t| = 1$ is a main effect, $|t| = 2$ a two-way interaction, and the intercept is the term on the empty set, $t = \emptyset$. Capital $T$ names the one term whose coefficient is wanted. $S$ names a set of variables being fixed, which may be larger than any single term. A collection of terms is a subset of $M$; Appendix B uses $Q = M \cap \mathcal{P}(T)$, the terms the model has on subsets of $T$, together with $Q'$ (the terms disjoint from $T$) and $Q''$ (the rest). A term $t$ can stand in three relations to a set of variables $S$: inside $S$ ($t \subseteq S$), disjoint from $S$ ($t \cap S = \emptyset$), or overlapping $S$ partway (some of $t$'s variables in $S$, some not). With $V = \{\text{age}, \text{sex}, \text{breed}, \text{weight}, \text{deductible}\}$ and $M = \{\{\text{age}\}, \{\text{sex}\}, \{\text{breed}\}, \{\text{weight}\}, \{\text{deductible}\}, \{\text{age}, \text{weight}\}, \{\text{breed}, \text{weight}\}\}$: the term $\{\text{age}, \text{weight}\}$ overlaps the set $\{\text{age}\}$ partway; no term overlaps $\{\text{age}, \text{weight}, \text{breed}\}$ partway; no interaction term touches $\{\text{sex}\}$ or $\{\text{deductible}\}$.

&#91;embedded content: interaction graph · 5 variables, 2 interaction terms\]

Each shaded set is overlapped partway by no term: the lines inside it are the interaction terms, and no line crosses its edge. A marginal relativity over one shaded set, or over several of them together, is population-free (Appendix B). The set $\{\text{age}, \text{weight}\}$ is not shaded because the term $\{\text{breed}, \text{weight}\}$ overlaps it partway.

**Data-generating process and observed data.** Assume a data-generating process with two separate parts: a loss relationship, $\mu(x) = E[y \mid x]$, the expected loss for a risk with characteristics $x$; and a mix, $P(x)$, the joint distribution of characteristics across the risks that happen to be written, correlations between characteristics included. Together they make the joint distribution $P(x, y) = P(y \mid x) \cdot P(x)$. Exposure is not the mix but the weight it is measured with: the mix in a data set is the exposure-weighted frequency of each cell. The two parts are controlled by different things, which is why they can come apart: loss given characteristics is a property of the risk, while which characteristics show up is a property of who buys and what underwriting accepts. A data set $D$ is one draw from it, with rows $(x_i, y_i, w_i)$: the variable values, the observed loss (claims), and the exposure (earned exposure). The model is fit on $D$, and we take it to represent the loss relationship, on average and within confidence intervals. Its estimate of $\mu(x)$ is $\hat\mu(x)$, a log-link model with one term per subset in $M$:

$$
\ln \hat\mu(x) = \beta_0 + \sum_{t \in M} \beta_t(x_t)
$$

The fitted value for row $i$ is $\hat y_i = \hat\mu(x_i)$. The collection $\{\beta_T : T \in M\}$ is a ragged set of tables whose shape is set by $T$: a vector for a factor main effect, a matrix for a factor×factor interaction, a curve for a smooth, a set of curves for a factor×smooth. $|\beta_T|$ is the number of levels in the term $T$. For a GAM the usable object is each curve's value on a grid, not its basis coefficients.

**Cells and partial coordinates.** A cell $x$ is a full vector of values, one per variable in $V$; $x_S$ is its values on the variables in $S$. The base cell is $x^0$. A partial coordinate $z_S$ is a chosen set of values for the variables in $S$, the row of a relativity table you are asking about, such as age 10. It is never taken from the data.

**Counterfactual evaluation.** The vector $(z_S, x_{i,\bar S})$ reads: "the variables in $S$ are fixed to the values in $z$, and the variables in $\bar S$ keep the values from row $i$ of the data set." $\hat\mu(z_S, x_{i,\bar S})$ is the model evaluated at that vector. The same vector can be written as an operation on row $i$, $(x_i;\, x_S \leftarrow z_S)$, "row $i$ with its $S$-coordinates overwritten by $z$", which is what the code does: copy the data set, overwrite the columns in $S$ with $z$, predict. Formulas use the two-block form because it shows which values are fixed and which are moving; the overwrite form is the reminder that only part of $x$ changed. It is not $\hat y_i$: it is a grid indexed by $i$ and by $z$.

**Other draws, and the reference population.** Imagine other data sets $D'$, $D''$, $D'''$ from the same loss relationship but with their own mixes, the same $P(y \mid x)$ and a different $P(x)$: next year's book, a different region, the book after an underwriting change. Fitting the same model on each would give the same coefficients, on average and within confidence intervals, because the coefficients describe the loss relationship and the loss relationship has not changed. The question this guide answers is whether marginal relativities computed on $D'$, $D''$, $D'''$ would also be the same. They need not be, and Appendix B says exactly when they are. To ask the question we need a name for the mix side of a data set on its own: a reference population $P$ is the variable values and exposure weights of some data set, real or imagined, with no response column, because a partial dependence never looks at $y$. The training data $D$ is one possible $P$, and the usual default; the in-force book, a forecast book, a synthetic grid, or a single cell are others. The expectation of any function $g$ over $P$ is its exposure-weighted mean:

$$
E_P[g] = \frac{\sum_{i \in P} w_i\, g(x_i)}{\sum_{i \in P} w_i}
$$

**Operators.** Three operators make every quantity in the guide a one-line expression that reads as code.

- $\mathbb{F}_S(z)\, D$ keeps the rows of $D$ with $x_S = z$ (filter). In code: `filter()`.
- $\mathbb{T}_S(z)\, D$ overwrites $x_S$ with $z$ in every row of $D$ and leaves exposure and every other column untouched (set). In code: `mutate()`.
- $\boldsymbol{\Sigma}_w\, f\, D$ is the exposure-weighted mean of $f$ over the rows of $D$, $\sum_i w_i f(x_i) / \sum_i w_i$ (average). In code: `weighted.mean()`. $E_P[g]$ in the formulas below is this operator applied to $P$, $\boldsymbol{\Sigma}_w\, g\, P$, written as an expectation when the data set is fixed.

Expressions are read right to left, like function composition: $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, \mathbb{F}_k(w)\, D$ keeps the rows with $x_k = w$, sets $x_S$ to $z$, scores with $\hat\mu$, and averages. A single cell is a one-row data set, so $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, \{x^0\} = \hat\mu(z_S; x^0_{\bar S})$ with nothing left to average. Filter and set on different variables commute; a second set on the same variable overwrites the first; a filter after a set on the same variable keeps everything or nothing. The three operations of "Three operations, three words" are $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{F}_S(z)\, P$ (conditional), $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, P$ (marginal), and $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, \{x^0\}$ (partial); each relativity is the ratio of its operation at $z$ to the same operation at $z^0$.

**Partial dependence: the marginal operation.** Friedman's partial dependence of the model over $S$, at $z$, against $P$, is the expected model output when the variables in $S$ are set to $z$ in every row and everything else is drawn from $P$; in operator form, $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, P$:

$$
\mathrm{PD}_S(z; P) = E_P\big[\hat\mu(z_S, x_{V\setminus S})\big] = \frac{\sum_{i \in P} w_i\, \hat\mu(z_S, x_{i,V\setminus S})}{\sum_{i \in P} w_i}
$$

The row index is summed out; PD is a function of $z$ alone. $S$ says which variables, $z$ their values, and $P$ where the rest come from. In code: overwrite the columns in $S$ of a copy of $P$ with $z$, predict, take the exposure-weighted mean; once per grid value $z$.

Setting the variables in $S$ to $z$ is not the same as selecting the rows that already have those values. The two operations differ by one word, and that difference is the whole distinction between a conditional (one-way) relativity and a marginal one, and holding instead of averaging is the third column:

|  | Filter (conditional) | Set and average (marginal) | Set and hold (partial) |
| --- | --- | --- | --- |
| Operator form | $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{F}_S(z)\, P$ | $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, P$ | $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_S(z)\, \{x^0\}$ |
| Expression | $E_P[\hat\mu(x) \mid x_S = z]$ | $E_P[\hat\mu(z_S; x_{\bar S})]$ | $\hat\mu(z_S; x^0_{\bar S})$ |
| Reads as | the model, averaged over the rows that already have $x_S = z$ | the model with $x_S$ set to $z$ in every row, averaged over all rows | the model at the base cell with $x_S$ set to $z$ |
| Rows averaged | only those with $x_S = z$; a different set at each $z$ | all of $P$; the same set at each $z$ | one row; nothing averaged |
| What it is | the numerator of the conditional (one-way) relativity | the partial dependence $\mathrm{PD}_S(z; P)$, the numerator of the marginal relativity | the numerator of the partial relativity: the coefficient table |

**Marginal relativity.** A marginal relativity is a partial dependence divided by its value at the base cell; the bar marks the averaging:

$$
\bar r_S(z; P) = \frac{\mathrm{PD}_S(z; P)}{\mathrm{PD}_S(x^0_S; P)}
$$

When $P$ cancels (Appendix B says when), the marginal relativity no longer depends on any population and equals the partial relativity, written $r_S(z)$ without the bar.

**Partial relativity.** A partial relativity is the model's own table for one term $t$, expressed relative to the base cell. It is the set-and-hold operation, $\boldsymbol{\Sigma}_w\, \hat\mu\, \mathbb{T}_t(z)\, \{x^0\}$ divided by $\hat\mu(x^0)$, and on the log scale it is the coefficient difference:

$$
r_t(z) = \exp\big(\beta_t(z_t) - \beta_t(x^0_t)\big)
$$

The table in "Where the familiar relativities land" shows this is the special case in which $P$ is a single cell, the base cell.

## Appendix B: The separability lemma, with proof

*The proof of point 2. Not needed for the main body.*

Start from a coefficient. Pick a term $T \in M$, the set of variables whose coefficient table $\beta_T$ you want, and ask what operation on data returns it.

**The model as a product of terms.** Under a log link,

$$
\hat\mu(x) = \prod_{t \in M} g_t(x_t), \qquad g_t = e^{\beta_t}, \qquad g_\emptyset = e^{\beta_0}
$$

Each term $g_t$ depends only on the coordinates of $x$ in its own set $t$. A ratio of a term to its value at base is a difference of coefficients on the log scale, $\ln[g_t(z_t) / g_t(z^0_t)] = \beta_t(z_t) - \beta_t(z^0_t)$, and under treatment contrasts $\beta_t(z^0_t) = 0$, so the ratio is $e^{\beta_t(z_t)}$ itself. Every ratio of averages below is to be read that way: as a statement about coefficient differences.

**Fix the variables in $T$.** Write $(z_T;\, x_{\bar T})$ for the vector in which the variables in $T$ are fixed at the values $z$ and the rest, $\bar T = V \setminus T$, keep their own values from the row.

**Partition the terms relative to $T$.** Let $Q = M \cap \mathcal{P}(T)$: the terms the model has on subsets of $T$, which means $T$ itself, the lower-order terms on its variables, and $\emptyset$ (the intercept). Every other $t \in M$ is either disjoint from $T$ or overlaps it partway, so $M$ splits into three families:

$$
\begin{aligned}
Q &= M \cap \mathcal{P}(T) &&\text{inside } T\\
Q' &= \{\,t \in M : t \cap T = \emptyset,\; t \neq \emptyset\,\} &&\text{disjoint from } T\\
Q'' &= M \setminus (Q \cup Q') = \{\,t \in M : t \cap T \neq \emptyset,\; t \not\subseteq T\,\} &&\text{overlapping } T \text{ partway, supersets of } T \text{ included}
\end{aligned}
$$

With $T = \{A, B, C\}$, $Q$ is whichever of $\emptyset$, $A$, $B$, $C$, $AB$, $AC$, $BC$ and $ABC$ the model actually has. With $T = \{\text{age}\}$ in the Appendix A example: $\emptyset$ and $\{\text{age}\}$ are in $Q$; $\{\text{sex}\}$, $\{\text{breed}\}$, $\{\text{weight}\}$, $\{\text{deductible}\}$ and $\{\text{breed}, \text{weight}\}$ are in $Q'$; $\{\text{age}, \text{weight}\}$ is in $Q''$.

**Evaluate each family at the fixed vector.** A term in $Q$ sees only fixed values. A term in $Q'$ sees only the row's own values, on its own variables $x_t$. A term in $Q''$ sees fixed values on $t \cap T$ and the row's values on $t \setminus T$:

$$
\hat\mu(z_T;\, x_{\bar T}) = \underbrace{\prod_{t \in Q} g_t(z_t)}_{G_Q(z)}\;\cdot\;\underbrace{\prod_{t \in Q'} g_t(x_t)}_{G_{Q'}(x)}\;\cdot\;\underbrace{\prod_{t \in Q''} g_t(z_{t \cap T};\, x_{t \setminus T})}_{G_{Q''}(z,\, x)}
$$

**Average over data and take a ratio.** For any data set $P$ with exposure weights, and base values $z^0$ for the variables in $T$,

$$
\frac{E_P\big[\hat\mu(z_T;\, x_{\bar T})\big]}{E_P\big[\hat\mu(z^0_T;\, x_{\bar T})\big]} = \prod_{t \in Q}\frac{g_t(z_t)}{g_t(z^0_t)}\;\cdot\;\frac{E_P\big[G_{Q'}(x)\, G_{Q''}(z, x)\big]}{E_P\big[G_{Q'}(x)\, G_{Q''}(z^0, x)\big]}
$$

**Claim.** The ratio is the same for every data set $P$ if and only if $Q''$ is empty: no term overlaps $T$ partway.

**If.** With $Q''$ empty, $G_{Q''} \equiv 1$, and the second factor is $E_P[G_{Q'}] / E_P[G_{Q'}] = 1$. The ratio is the product of the terms in $Q$ relative to base: the joint table for the variables in $T$. On the log scale it is $\sum_{t \in Q} [\beta_t(z_t) - \beta_t(z^0_t)]$, the sum of the coefficient differences of every term inside $T$. $P$ has cancelled, and every term in $Q'$ with it. This holds for every $P$: the training data, a different book, a synthetic grid, or a single row, which is why the recipe in the main body can hold everything at the base cell and use no data at all. The mix never enters. It enters only when $Q''$ is not empty, where the second factor is a weighted average over $P$'s rows and the weights are the mix; there the training data has no special status and is simply the mix that happens to be at hand.

**Isolating $g_T$ from the joint table.** Write $R_T(z_T)$ for the ratio above: the joint table for $T$'s variables relative to base, which is itself a marginal relativity over $T$. It contains $g_T$ and the terms on proper subsets of $T$, so getting $g_T$ out means dividing those out. For the orders that occur in a rating model:

Main effect, $T = \{A\}$. There is nothing to divide out; the marginal relativity is the term, and its log is the coefficient difference:

$$
\begin{aligned}
\frac{g_A(z_A)}{g_A(z^0_A)} &= R_A(z_A) = \frac{\sum_i w_i\,\hat\mu(z_A;\,x_{i,\bar A})}{\sum_i w_i\,\hat\mu(z^0_A;\,x_{i,\bar A})}\\[6pt]
\beta_A(z_A) - \beta_A(z^0_A) &= \ln R_A(z_A)
\end{aligned}
$$

Two-way, $T = \{A, B\}$. Three marginal relativities over $\{A, B\}$: the one at $(z_A, z_B)$, divided by the ones at $(z_A, z^0_B)$ and $(z^0_A, z_B)$:

$$
\begin{aligned}
\frac{g_{AB}(z_A, z_B)}{g_{AB}(z^0_A, z^0_B)} &= \frac{R_{AB}(z_A, z_B)}{R_{AB}(z_A, z^0_B)\; R_{AB}(z^0_A, z_B)}\\[6pt]
\beta_{AB}(z_A, z_B) - \beta_{AB}(z_A, z^0_B) - \beta_{AB}(z^0_A, z_B) + \beta_{AB}(z^0_A, z^0_B) &= \ln R_{AB}(z_A, z_B) - \ln R_{AB}(z_A, z^0_B) - \ln R_{AB}(z^0_A, z_B)
\end{aligned}
$$

Under treatment contrasts the two in the denominator are the $A$ and $B$ partial relativities, the main effects, so the interaction factor is the two-way table divided by the two one-way tables, which is what an interaction table in a rating plan is.

In general. For each subset $u \subseteq T$ let $z^{(u)}$ be the point with the variables in $u$ at $z$ and the rest of $T$ at base. The alternating product over the subsets of $T$ returns the term alone:

$$
\begin{aligned}
\frac{g_T(z_T)}{g_T(z^0_T)} &= \prod_{u \subseteq T} R_T\big(z^{(u)}\big)^{(-1)^{|T \setminus u|}}\\[6pt]
\beta_T(z_T) - \beta_T(z^0_T) &= \sum_{u \subseteq T} (-1)^{|T \setminus u|}\, \ln R_T\big(z^{(u)}\big) \qquad \text{(treatment contrasts)}
\end{aligned}
$$

A term $t \subsetneq T$ depends on $z^{(u)}$ only through $u \cap t$; holding that fixed, the alternating sign summed over the free choice of $u \cap (T \setminus t)$ is zero whenever $T \setminus t$ is nonempty, so every $t \subsetneq T$ cancels identically. This step needs no gauge. What remains is $g_T$'s own alternating ratio: under treatment contrasts $g_T$ is 1 whenever any of its coordinates sits at base, so every factor with $u \neq T$ is 1 and the product is $g_T(z_T)$ outright; in another gauge it is the part of $g_T$ that no re-gauging can move.

**The alternating contrast is a mixed finite difference.** On the log scale, $\sum_{u \subseteq T} (-1)^{|T \setminus u|} \ln R_T(z^{(u)})$ is the $|T|$-th order mixed difference of $\ln \hat\mu$ across the corners of $T$: the finite version of the mixed partial derivative $\partial^{|T|} \ln \hat\mu / \partial x_{t_1} \cdots \partial x_{t_{|T|}}$. For $|T| = 2$ the double ratio is the discrete $\partial^2 \ln \hat\mu / \partial x_A\, \partial x_B$. An interaction on the log scale is a nonzero mixed partial, and the interaction table is that derivative integrated over the cell. This is the one place calculus adds something here: it names the alternating product with a derivative every reader knows.

**Only if.** Suppose $Q''$ is not empty, and take $P$ to be a single row with moving values $u$. The second factor becomes $G_{Q''}(z, u) / G_{Q''}(z^0, u)$. If this were the same for every $u$, then on the log scale the partway terms would satisfy

$$
\sum_{t \in Q''} \beta_t(z_{t\cap T};\, u_{t\setminus T}) = c(z) + d(u)
$$

a function of the fixed values alone plus a function of the moving values alone. A term that overlaps $T$ partway and splits that way carries no content that actually crosses the boundary of $T$: it could be rewritten as terms on smaller sets, some inside $T$ and some disjoint from it. So the only-if rests on one assumption: each interaction term in $M$ depends jointly on all of its variables and is not a sum of terms on smaller sets. That is what a fixed gauge (the Gauge section) enforces, and it is an assumption about how the terms are written, not about the model.

**When $Q''$ is not empty: pin its outside variables at base.** The $Q''$ factor is the only part of the decomposition that mixes $z$ and $x$, and the fix is to stop those coordinates from moving. Let

$$
C = \bigcup_{t \in Q''} (t \setminus T)
$$

the variables the partway terms reach outside $T$, and hold them at base: replace $x_C$ by $z^0_C$. The decomposition becomes

$$
\hat\mu(z_T;\, z^0_C;\, x_{\overline{T\cup C}}) = \underbrace{\prod_{t \in Q} g_t(z_t)\cdot \prod_{t \in Q''} g_t(z_{t\cap T};\, z^0_{t\setminus T})}_{\text{depends on } z \text{ only}}\;\cdot\;\underbrace{\prod_{t \in Q'} g_t(z^0_{t\cap C};\, x_{t\setminus C})}_{\text{depends on } x \text{ only}}
$$

Every $Q''$ term is now a function of $z$ alone, because all of its outside-$T$ variables are in $C$. Every $Q'$ term is disjoint from $T$, so fixing some of its coordinates leaves it $z$-free. The decomposition is separable for arbitrary $T$, in one step. Average over any $P$ and take the ratio to base; the $Q'$ product cancels:

$$
\frac{E_P\big[\hat\mu(z_T;\, z^0_C;\, x_{\overline{T\cup C}})\big]}{E_P\big[\hat\mu(z^0_T;\, z^0_C;\, x_{\overline{T\cup C}})\big]} = \prod_{t \in Q}\frac{g_t(z_t)}{g_t(z^0_t)}\;\cdot\;\prod_{t \in Q''}\frac{g_t(z_{t\cap T};\, z^0_{t\setminus T})}{g_t(z^0_{t\cap T};\, z^0_{t\setminus T})} = R_T(z_T)
$$

$P$ is gone, and under treatment contrasts the $Q''$ product is 1, because every factor in it has its $t \setminus T$ coordinates at base. What remains is $R_T(z_T)$, the joint table for $T$'s variables, the same object as in the $Q'' = \emptyset$ case, and the alternating product over the subsets of $T$ isolates $g_T(z_T) / g_T(z^0_T)$ as above. The $Q'' = \emptyset$ case is this with $C$ empty.

Example: terms $A$, $B$, $AB$, $C$, $BC$, $D$ and $\beta_A$ wanted. $T = \{A\}$, $Q'' = \{AB\}$, $C = \{B\}$, so $B$ is held at $b_0$, $A$ is varied, and $C$ and $D$ keep their row values:

$$
e^{\beta_A(a_1)} = \frac{\sum_i w_i\,\hat\mu(a_1, b_0;\, x_{i,\{C,D\}})}{\sum_i w_i\,\hat\mu(a_0, b_0;\, x_{i,\{C,D\}})}
$$

The $BC$ and $D$ terms are in $Q'$ and cancel; $AB$ is in $Q''$, sits at $b_0$, and equals 1.

**Which coefficients survive averaging.** The lemma asks when the whole table $\mathrm{PD}_T(\cdot\,; P)$ is free of $P$. Recovering a single interaction coefficient needs less. Write

$$
\ln \mathrm{PD}_T(z; P) = \sum_{t \in Q} \beta_t(z_t) + h_P(z), \qquad h_P(z) = \ln E_P\big[G_{Q'}(x)\, G_{Q''}(z, x)\big]
$$

and let $\Delta_T$ be the alternating contrast over the base-anchored corners of $T$. Under treatment contrasts $\Delta_T$ kills every $\beta_t$ with $t \subsetneq T$ and returns $\beta_T(z_T)$, so

$$
\Delta_T \ln \mathrm{PD}_T(z; P) = \beta_T(z_T) + \Delta_T h_P(z)
$$

The coefficient is recovered exactly when $\Delta_T h_P = 0$, which requires only that $h_P$ have no full-$T$ interaction, not that it be constant. For $|T| = 1$ the two conditions coincide, $\Delta_T h_P = h_P(z) - h_P(z^0)$, so a main effect is recovered by averaging only when $Q''$ is empty, as the lemma says. For an interaction they differ. A structural sufficient condition, holding for every $P$: the terms in $Q''$ do not between them touch every variable of $T$. Then $h_P$ depends on $z$ only through a proper subset of $T$'s coordinates and $\Delta_T h_P = 0$.

Example where it holds: terms $A$, $B$, $AB$, $C$, $BC$ and $T = \{A, B\}$. $Q'' = \{BC\}$ touches only $B$, so $h_P(a, b) = \ln E_P[e^{\beta_C(c) + \beta_{BC}(b, c)}]$ is a function of $b$ alone, and the double ratio of $\mathrm{PD}_{AB}$ returns $\beta_{AB}$ on any mix even though the two-way table itself, with its main effects, does not. Example where it fails: binary $A$, $B$, $C$ with $\ln \hat\mu = ac + bc$, no $AB$ term, and $P(C = 1) = \tfrac{1}{2}$. Then $\mathrm{PD}_{AB}(a, b) = \tfrac{1}{2}(1 + e^{a+b})$ and the double ratio is $2(1 + e^2)/(1 + e)^2 \approx 1.21$, an apparent $\beta_{AB} \approx 0.19$ from a model that has none. Averaging over a partner that $A$ and $B$ share manufactures a log-scale interaction between them. This is also how a two-way partial-dependence plot, or an H-statistic, can report an $A \times B$ interaction that is really $A \times C$ and $B \times C$; the pinned two-way table, with $C$ held at base, shows none.

What a different mix does: nothing, once the $Q''$ terms' outside variables are pinned. $Q''$ then contributes no $x$-dependence, the mix never enters, and the fitted data, a future book, and a single row return the same tables. The mix enters only when a $Q''$ term's outside variable is left moving: the main-effect tables then depend on $P$ on every mix, the fitted data included, while a pure interaction coefficient may or may not survive the alternating contrast according to the condition above. For a model in which everything interacts, such as a gradient-boosted model, $Q''$ for any $T$ reaches every other variable: the population-free one-way object is the profile through the base cell, and every marginal relativity depends on the mix. It is the same rule.

**When the interaction terms are pairwise disjoint.** Let $T_1$ and $T_2$ be any two distinct interaction terms in $M$ ($|t| > 1$). They are pairwise disjoint, $T_1 \cap T_2 = \emptyset$ for every such pair, if and only if $Q''$ is empty for every interaction term $T$. Then fixing an interaction term's own variables and averaging over everything else returns its joint table on any data, and the alternating ratio isolates $g_T$. The step is one line: a term overlaps $T$ partway exactly when it shares a variable with $T$ without lying inside it; the lower-order terms on $T$'s variables are in $Q$, so only another interaction term can be in $Q''$. For a main effect $T = \{j\}$, $Q''$ contains every interaction that contains $j$, so fixing $j$ alone returns $g_j$ only if $j$ is in no interaction. In a model with $A$, $B$ and $AB$, fixing $A$ alone and averaging does not return $g_A$; fixing $A$ and $B$ together returns $g_A$, $g_B$ and $g_{AB}$. With $A \times B$, $C \times D$ and $E \times F \times G$ the condition holds. Add $A \times D$ and it fails: fixing $A$ and $B$ alone leaves $D$ moving inside $A \times D$; fix $\{A, B, C, D\}$ and every coefficient on those variables is recovered. Nested terms ($E \times F$ beside $E \times F \times G$) count as overlapping, and fixing $E$ and $F$ alone leaves $G$ moving.

**Five models, classified.** For each model: the smallest sets whose marginal relativity is population-free, and the sets whose marginal relativity depends on the mix, with the term that overlaps them partway.

| Model terms | Interaction terms | Smallest sets whose PD is population-free | Sets whose PD depends on the mix, and the term that overlaps them partway | Interactions pairwise disjoint? |
| --- | --- | --- | --- | --- |
| $A$, $B$, $AB$, $CDE$ | $AB$, $CDE$ | $\{A,B\}$; $\{C,D,E\}$ | $\{A\}$, $\{B\}$: $AB$ | Yes |
| $A$, $B$, $AB$, $CD$, $CDE$ | $AB$, $CD$, $CDE$ | $\{A,B\}$; $\{C,D,E\}$ | $\{C,D\}$: $CDE$ (nested); $\{A\}$, $\{B\}$: $AB$ | No: $CD \subset CDE$ |
| $A$, $B$, $AB$, $CD$, $BCE$ | $AB$, $CD$, $BCE$ | $\{A,B,C,D,E\}$ | every smaller set: $AB$ and $BCE$ share $B$, $CD$ and $BCE$ share $C$, so the terms chain together | No |
| $A$, $B$, $AB$, $CD$, $ABC$ | $AB$, $CD$, $ABC$ | $\{A,B,C,D\}$ | $\{A,B\}$: $ABC$; $\{C,D\}$: $ABC$, through $C$; $\{A,B,C\}$: $CD$, through $C$ | No |
| $A$, $B$, $AB$, $CD$, $ABCD$ | $AB$, $CD$, $ABCD$ | $\{A,B,C,D\}$ | every smaller set: $ABCD$ | No |

In the first two models, fixing $A$ and $B$ together, or $C$, $D$ and $E$ together, and averaging over the rest returns the coefficient tables; fixing $A$ alone does not, and in the second model fixing $C$ and $D$ alone does not. In the last three, nothing short of fixing all the variables the interactions touch returns coefficients by averaging; every coefficient is still obtained by pinning, as in "Reading any coefficient off the model." In all five the rating-table delivery is the same: one table per term. To check a fixed set $S$ by hand: list every term as inside $S$, disjoint from $S$, or overlapping $S$ partway; averaging over the rest returns coefficients when the third list is empty, and a mix-dependent blend otherwise.

## Manuscript checklist

*What the manuscript needs beyond this guide. Ticked items are done in the guide and need only transferring.*

- [ ] Structure: Introduction (the four points and the vocabulary clash) · Objects, operators, catalogue · Term-based models and the decomposition · Interactions · Discussion; proofs and code in an appendix.
- [ ] A real-data example with a mix shift and reproducible code. freMTPL2 is the convention (Lorentzen & Mayer, Henckaerts et al., Lindholm & Palmquist all use it), which also allows direct comparison with their partial-dependence plots.
- [ ] The additive and general-link section: identity link with sums and differences in place of products and ratios; the decomposition lives on the link scale, so average the linear predictor for coefficient recovery under any link; on the response scale it is exact only for the log and identity links (Ai & Norton for logit).
- [x] The vocabulary concordance table: conditional / marginal / partial against Friedman, Apley & Zhu, econometrics, and pricing shop talk ("Three operations, three words").
- [ ] Check the Apley & Zhu "M-plot" usage against their paper before the table goes in the manuscript.
- [x] The vocabulary pass across this guide: marginal relativity $\bar r_S(z; P)$ for set-and-average, partial relativity $r_t(z)$ for set-and-hold, conditional for one-way.
- [ ] The same vocabulary pass across the two companion notes, which use "partial relativity" for the marginal operation and "base-risk relativity" for the partial one.
- [x] The operator notation $\mathbb{F}$, $\mathbb{T}$, $\boldsymbol{\Sigma}_w$ defined (Appendix A) and used in the concordance and comparison tables. Still open: $E_P[\cdot]$ remains as shorthand for $\boldsymbol{\Sigma}_w\, {\cdot}\, P$ in the Appendix B formulas; decide whether to replace it.
- [ ] The full catalogue table from the operator note (ICE, stratified, restricted, ALE step, observed one-ways) with operator form, sum form, and "what question it answers."
- [x] A definition of "coefficient" for GAM smooths and penalized terms ("The rating table is the model").
- [x] The misspecification caveat as a short section, separating the lemma, which holds for any fitted $\hat\mu$, from refit stability, which needs correct specification.
- [x] A full read of Lindholm & Palmquist §2.1 with equations cited: Eq. (8)–(11) and p. 679.
- [x] CAS Monograph 16 §9.3–9.4 read and cited as the nearest practical prior work.
- [x] The "which coefficients survive averaging" result ($\Delta_T h_P = 0$), with the $AB + BC$ example and the $ac + bc$ counterexample (Appendix B). Optional: characterize the $P$-dependent sufficient conditions.
- [x] The alternating product as the finite-difference mixed partial derivative of $\ln \hat\mu$ (Appendix B). For the manuscript, cut the line integral, elasticity, ALE, and derivative-ICE material from the calculus note.
- [x] The spurious-interaction caveat for interaction detection (two-way PDP, H-statistic, Monograph 16's permutation score) when two variables share a partner ("When marginal relativities are the right tool").
- [x] When the marginal relativity is the right object: average effect over a named book; models without terms ("When marginal relativities are the right tool").
- [x] The contribution stated plainly, "we are not aware of," in the Summary and in "Where this sits in the literature."
- [ ] Cut from this paper: credibility and shrinkage (kept in the guide's Estimation section as a standalone note for colleagues), posterior intervals (one sentence), the dropped-variable projection for pricing, ALE beyond a mention.
- [ ] Venue: *Variance* or *Annals of Actuarial Science*; both take methodological tutorials with a result in them.
