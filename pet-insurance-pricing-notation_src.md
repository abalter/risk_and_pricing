# Pet Insurance Pricing: Notation and Concepts

*As of October 5, 2026*

## Glossary

Every symbol below means one thing throughout this document. If anything later conflicts with this section, this section wins.

### Conventions

1. No hat means observed data. A hat means a model estimate.
2. $P_i$ is always data: the premium actually charged. It is never computed from a model.
3. $T_i$ is always computed. It is never data, so it carries no hat.
4. $E[\cdot]$ is the true, unknown expectation. Its estimate carries a hat. Model output is called "estimated"; "expected" is reserved for $E[\cdot]$.
5. A subscript $i$ means a total for policy $i$ over its term. Per-unit-exposure rates are functions of the rating variables and carry no index.
6. The Tweedie power is written $\xi$, so lowercase $p$ never appears.

### Data (per policy $i$, over its term)

| Symbol | Name | Meaning |
| --- | --- | --- |
| $x_i$ | rating variables | age, species, breed, sex, state, product |
| $d_i,\ c_i,\ l_i$ | cost-sharing terms | deductible, copay, annual limit |
| $ee_i$ | earned exposure | policy-years in force during the period |
| $u_i$ | eligible loss (ground-up loss) | covered vet costs over the term, before cost-sharing |
| $\pi_i$ | paid loss (empirical paid) | what the insurer actually paid, on-leveled |
| $\pi_i^{\text{mech}}$ | mechanical paid | paid computed from the *actual* eligible loss with the benefit formula, $g(u_i;\, d_i, c_i, l_i)$ |
| $P_i$ | premium (the "A" in AvT) | earned on-level premium charged, over the same exposure $ee_i$ |

The benefit formula, applied to the term total:

$$
g(u;\, d, c, l) = \min\big((1-c)\max(u-d,\,0),\ l\big)
$$

### Model estimates

| Symbol | Name | Meaning |
| --- | --- | --- |
| $f(x)$ | log pure premium | the fitted function of the rating variables; $f = \log \mu$ |
| $\hat\mu_u(x)$ | ground-up pure premium | estimated eligible loss per unit exposure (eligible model) |
| $\hat\mu_\pi(x, d, c, l)$ | paid (net) pure premium | estimated paid loss per unit exposure (paid model) |
| $\hat u_i = ee_i\,\hat\mu_u(x_i)$ | estimated eligible loss | for policy $i$ |
| $\hat\pi_i = ee_i\,\hat\mu_\pi(x_i, d_i, c_i, l_i)$ | estimated paid loss | for policy $i$ |
| $\xi$ | Tweedie power | estimated by mgcv's `tw()` family; $1 < \xi < 2$ |

### Pricing quantities

| Symbol | Name | Meaning |
| --- | --- | --- |
| $F$ | fixed expense | dollars per unit exposure, independent of premium size |
| $V$ | variable expense ratio | fraction of premium (commissions, premium taxes, payment processing) |
| $Q$ | profit and contingency ratio | target margin, as a fraction of premium |
| $k = 1/(1 - V - Q)$ | loading factor | applies when $F \approx 0$ |
| LAE | loss adjustment expense | the cost of handling claims; loaded onto losses or folded into $F$ and $V$ |
| $T_i$ | technical premium | the premium that would exactly cover estimated paid, expenses and profit |

$$
T_i = \frac{\hat\pi_i + F\,ee_i}{1 - V - Q}
$$

Correctly priced means $P_i = T_i$.

### Ratios over a group of policies $S$

| Ratio | Formula | Answers |
| --- | --- | --- |
| AvT | $\sum_S P_i \,/\, \sum_S T_i$ | Is the price adequate for the estimated cost? Below 1 means underpriced. |
| Relative AvT | $\text{AvT}(S) \,/\, \text{AvT}(\text{book})$ | Is group $S$ priced worse than the book average? |
| Loss ratio (LR) | $\sum_S \pi_i \,/\, \sum_S P_i$ | How did actual claims compare with premium? Target is $1 - V - Q$ when $F = 0$. |
| A/E | $\sum_S \pi_i \,/\, \sum_S \hat\pi_i$ | Did the model predict claims correctly? No premium involved. |
| Mechanical check | $\sum \pi_i \,/\, \sum \pi_i^{\text{mech}}$ | How well does the benefit formula reproduce actual payments? About 4% off book-wide. |

### Terms easily confused

- **Loss cost** is a synonym for pure premium: an expected amount per unit exposure. It never names a single policy's realized loss.
- **Aggregate loss** is a realized total over a period, such as $u_i$ or $\pi_i$. Pure premium is its expectation per unit exposure.
- **Mechanical indication** is a different use of "mechanical": the rate change a ratemaking formula produces before actuarial judgment.

## The model

The Tweedie GAM estimates a rate, $\mu(x)$, and exposure multiplies that rate to give a policy's estimated total.

### The chain

Shown for eligible loss; the paid model has the same structure with $\pi_i$ as the response.

$$
\begin{aligned}
f(x) &= \log \mu(x) && \text{log loss per unit exposure} \\
\mu(x) &= e^{f(x)} && \text{loss per unit exposure (the rate)} \\
E[u_i] &= ee_i\,\mu(x_i) = \exp\big[\log ee_i + f(x_i)\big] && \text{expected loss for policy } i
\end{aligned}
$$

Exposure sits outside $f$, as a multiplier. If $ee_i$ were an argument of $f$, the model could learn a rate that depends on how long a policy was in force, and that would leak into prices. Putting `offset(log(ee))` in the formula does exactly this. Use the formula offset, not the `offset=` argument, because `predict()` ignores the argument.

### What $\mu$ is

$\mu(x)$ is the expected loss for one unit of exposure, one pet-year, for a pet with characteristics $x$. Suppose a 3-year-old Lab has $\hat\mu(x) = \$400$. A full-year policy ($ee = 1$) has estimated loss \$400. A six-month policy ($ee = 0.5$) has \$200. The risk is the same; only the time on the books differs.

The physics analogy is a Poisson process: expected count = rate × time. The policy total is the accumulated quantity, $ee_i$ is the time window, and $\mu(x)$ is the rate. A premium is quoted per year of coverage, which is why pricing is built on $\mu$.

### Why $\mu$ has no row index

For a policy in the data, $\hat u_i / ee_i = \hat\mu(x_i)$ exactly. But exposure belongs to a policy, not to a risk profile: two pets with the same $x$ can have different $ee_i$. So $ee_i$ and $\hat u_i$ carry the policy index, while $\hat\mu(x)$ is a function of the rating variables alone. It can be evaluated for any $x$, including combinations no policy has, which is what a rate table needs.

The observed ratio $u_i / ee_i$ is different again. It is one policy's realized rate: mostly zeros, with occasional large spikes. $\hat\mu(x_i)$ estimates its mean.

### What mgcv returns

- `predict(m, type = "link")` gives $\log ee_i + \hat f(x_i)$, with the offset included.
- `predict(m, type = "response")` and `fitted(m)` give the policy total, $ee_i\,\hat\mu(x_i)$.
- To get the rate $\hat\mu(x)$, predict on `newdata` with `ee = 1`.

### Aggregate loss and pure premium

$u_i$ and $\pi_i$ are **aggregate losses**: realized totals over a term, the sum of all claims. **Pure premium** is the expected aggregate loss per unit exposure, and it factors as frequency × severity:

$$
\mu = \frac{E[S]}{ee} = \underbrace{\frac{E[N]}{ee}}_{\text{frequency}} \times \underbrace{E[X]}_{\text{severity}}
$$

Here $S$ is aggregate loss, $N$ the number of claims, and $X$ a claim's size. A Tweedie with $1 < \xi < 2$ is exactly a compound Poisson–gamma distribution, the collective risk model. That is why it can model aggregate loss in one step. The alternative is a frequency–severity model, which fits $N$ and $X$ separately and multiplies them. The product is valid only if claim size is independent of claim count, given $x$ (see "Applying functions to predictions" below).

### A note on weighting

The offset-only model implies $\operatorname{Var}(u_i) = \phi\,(ee_i\,\mu_i)^\xi$. Modeling the rate $u_i / ee_i$ with weights $ee_i$ implies $\phi\, ee_i\, \mu_i^\xi$ instead. The fits then weight policies by $ee_i^{\,2-\xi}$ versus $ee_i$, which only matters when many policies are partial-year. Adding `weights = ee^(xi - 1)` makes the two identical. A quick look at the distribution of `ee` shows whether this matters.

## Eligible vs paid

Pricing needs estimated paid loss, $\hat\pi_i$, and the simplest way to get it is to model paid loss directly.

### Applying functions to predictions

A regression estimate is a summary over everything the model cannot see. Two pets with identical $x$ have different losses (one has no claims, the other needs surgery), but any function of $x$ must give both the same number. Fitting with Tweedie deviance or squared error makes that number the mean of the outcomes at that $x$.

So a function applied to a prediction is applied to a mean. That gives the right answer only if the function commutes with averaging:

| Operation on predictions | Safe? |
| --- | --- |
| sums, scaling by constants (e.g., $T_i = k\,\hat\pi_i$) | always |
| products of two predictions (e.g., frequency × severity) | only if the two quantities are independent, given $x$ |
| nonlinear functions ($g$, squaring, $\exp$) | not in general |

**The squares example.** A regression predicts the side length $L$ of squares from their color, texture and material. Holding color = red, averaging the predicted $L$ over the other variables and then squaring underestimates the average area of red squares, because

$$
\overline{L^2} = \bar L^{\,2} + \operatorname{Var}(L).
$$

The mapping to pet insurance:

| Squares | Pet insurance |
| --- | --- |
| side length $L$ | eligible loss $u$ |
| area $L^2$ | paid $g(u)$ |
| color (held fixed) | rating variables $x$ |
| other variables (averaged over) | everything that makes pets with identical $x$ differ |

With pets it is worse: the "other variables" (genetics, owner behavior, luck) are mostly unobserved, so $\hat u_i$ is necessarily already averaged over them. And $g$ is convex at the deductible and concave at the limit, so the error can go either way and differs by cell.

The same failure appears elsewhere: exponentiating a prediction of $\log y$ underestimates $E[y]$ (retransformation bias). A log-*link* GLM avoids this because it models $\log E[y]$, not $E[\log y]$.

### Why $g(\hat u_i)$ is not $\hat\pi_i$

$\pi_i^{\text{mech}} = g(u_i;\, d_i, c_i, l_i)$ applies $g$ to a realized value. It is exact. But $g(\hat u_i;\, d_i, c_i, l_i)$ applies $g$ to a mean:

$$
E\big[g(u_i)\big] \neq g\big(E[u_i]\big)
$$

The same point needs no expectations, only sums. Take 100 pets with identical $x$, a \$250 deductible, 10% copay and \$3,000 limit:

| Pets | actual $u_i$ | predicted $\hat u_i$ | $g(u_i)$ | $g(\hat u_i)$ |
| --- | --- | --- | --- | --- |
| 70 | \$0 | \$400 | \$0 | \$135 |
| 25 | \$600 | \$400 | \$315 | \$135 |
| 5 | \$5,000 | \$400 | \$3,000 | \$135 |
| **Sum over 100** | **\$40,000** | **\$40,000** | **\$22,875** | **\$13,500** |

The predictions reproduce the eligible total exactly, but $g$ does not respect sums. Applying $g$ to each *actual* loss gives what was paid; applying it to each *prediction* gives 41% less. The pets with \$5,000 surgeries don't exist individually in the predictions: they've been folded into everyone's \$400.

Equivalently: two worlds can share $\hat\mu_u(x) = \$400$, one where every pet costs exactly \$400 (average paid \$135) and one with the spread above (average paid \$228.75). No function of $\hat\mu_u(x)$ alone can be right in both.

Getting $\hat\pi_i$ from the eligible model is still possible, because the fitted Tweedie gives the whole distribution of $u_i$. But it means averaging $g$ over that distribution policy by policy, and the answer depends on the Tweedie's implied tail and mass at zero.

### Modeling paid directly

Fit the same gam with two changes: the response is paid loss $\pi_i$, and the cost-sharing terms $d_i, c_i, l_i$ are added as factors. Same family, link and offset.

$$
\hat\pi_i = ee_i\,\exp\big[\hat f(x_i,\, d_i,\, c_i,\, l_i)\big]
$$

This works because reality applied $g$ to each pet's actual loss, producing $\pi_i$, before the model averages. Afterward the only operation is $T_i = k\,\hat\pi_i$, which is linear. Its estimates reproduce total paid, which is what premium must cover.

- **It gains** selection effects. If people who pick low deductibles have riskier pets, the deductible effect includes that.
- **It gives up** pricing cost-sharing combinations that don't exist in the data.

In physics terms: eligible loss is the true spectrum and the benefit formula is a nonlinear detector response. The eligible model fits the true spectrum and must fold it through the detector, which needs the full distribution. The paid model fits the measured spectrum directly.

### Which model for what

| Purpose | Model |
| --- | --- |
| AvT by cell | paid |
| Underwriting routing on underpricing | paid |
| A routing rule on underlying health, regardless of plan | eligible |
| Describing underlying risk by breed, age, state | eligible |
| Redesigning deductibles or limits | eligible |

Modeling eligible loss first was a defensible choice: it is the more direct data-generating process. Keep both models. A direct test of the eligible route on your data is $\sum_S \pi_i \,/\, \sum_S g(\hat u_i;\, d_i, c_i, l_i)$ by deductible level; it should be near 1 if the route worked.

## Relativities and base levels

A relativity is a ratio of rates against a chosen base risk. The base changes how relativities look and how well they are estimated, not what anyone pays.

### Base rate and overall relativity

Pick a base risk $x^b$, one reference value for each rating variable.

$$
B = \hat\mu(x^b), \qquad
R(x) = \frac{\hat\mu(x)}{\hat\mu(x^b)} = \exp\big[\hat f(x) - \hat f(x^b)\big], \qquad
\hat\mu(x) = B \cdot R(x)
$$

This holds for any $f$, interactions included. Changing the base moves $B$ and $R(x)$ in opposite directions, so their product, the price, is unchanged.

### One-way relativities and interactions

The one-way relativity for variable $j$ moves only $x_j$ and holds every other variable at its base:

$$
r_j(x_j) = \frac{\hat\mu(x_j,\, x_{-j}^b)}{\hat\mu(x^b)}, \qquad
R(x) = \Big[\prod_j r_j(x_j)\Big]\, I(x)
$$

If $f$ is purely additive, the interaction factor $I(x) = 1$ and the product of one-way relativities is exact. With interactions, two things follow:

- A one-way curve describes $x_j$ **at the base of its interacting partners**. If age interacts with breed, the age curve is the age curve for the base breed.
- In a rate table, an interaction becomes a two-way table of relativities.

In mgcv, a formula with `s(x1) + s(x2) + ti(x1, x2)` maps directly: the main-effect smooths give the one-way factors and the `ti()` term gives the cross effect. A `te(x1, x2)` term mixes both, so the factors are computed numerically from the ratios above.

### Choosing a base

1. **Match the current rate manual.** Indicated and current relativities are then directly comparable. This usually outweighs everything else.
2. **Highest exposure.** Every relativity is a ratio against the base, so a thin base inflates every standard error.
3. **Typical risk.** A level a non-actuary recognizes as "the standard policy." Usually the same as highest exposure.
4. **Representative of interactions.** Bases where interacting variables cover most of the book, so one-way curves describe most policies.

| Variable | Natural base |
| --- | --- |
| Species | dog, if it carries the most exposure |
| Breed | a base within each species: mixed breed (dog), domestic shorthair (cat) |
| Age | a reference age where exposure is dense, often near typical enrollment age; avoid the tails |
| Sex | the larger group, or the manual's base |
| State | the largest-exposure state, or the manual's base; fixed within a single-state filing |
| Coverage | the most-sold product, or the manual's base |

### Normalizing instead of choosing

Scale each one-way relativity so its exposure-weighted average over the book is 1:

$$
c_j = \frac{\sum_i ee_i\, r_j(x_{ji})}{\sum_i ee_i}, \qquad
r'_j(x_j) = \frac{r_j(x_j)}{c_j}, \qquad
B' = B \prod_j c_j
$$

Compute $r_j$ with any provisional base, then normalize. The provisional base level for variable $j$ appears as the same constant in $r_j$ and in every term of $c_j$, so it cancels. With interactions, the base values of $j$'s interacting partners remain. $B'$ absorbs the constants, so prices are unchanged, and $B'$ is no longer the rate of a specific risk.

## Technical premium

$T_i$ is the premium that would exactly cover estimated paid loss, expenses and profit. $P_i$ is what the premium is; $T_i$ is what it should be.

Every premium dollar goes to claims, fixed expense, variable expense or profit. Setting the premium equal to that sum and solving:

$$
T_i = \hat\pi_i + F\,ee_i + V\,T_i + Q\,T_i
\quad\Longrightarrow\quad
T_i = \frac{\hat\pi_i + F\,ee_i}{1 - V - Q}
$$

For example, with $\hat\pi_i = \$400$, $F = \$30$ per pet-year, a full-year policy, $V = 15\%$ and $Q = 5\%$: $T_i = 430 / 0.80 = \$537.50$.

The loadings $F$, $V$ and $Q$ come from finance or pricing actuaries, not from the claims data. Only $\hat\pi_i$ comes from the model. The section on avoiding unknown loadings below covers what to do without them.

## AvT, loss ratio and A/E

Each ratio compares two of three quantities: premium charged, actual paid and estimated paid. AvT is the one that works for small cells and at quote time.

| Ratio | Compares | Uses actual claims? | Uses the model? |
| --- | --- | --- | --- |
| AvT | premium $P_i$ vs technical premium $T_i$ | no | yes |
| Loss ratio | actual paid $\pi_i$ vs premium $P_i$ | yes | no |
| A/E | actual paid $\pi_i$ vs estimated paid $\hat\pi_i$ | yes | yes, no premium involved |

### Premium and paid loss

$P_i$ is money in: known, set in advance by the rate table. $\pi_i$ is money out: random, known only after the term. For one policy their ratio means little, because most pets have $\pi_i = 0$ and a few have $\pi_i$ many times their premium. Over a group, $\sum \pi_i / \sum P_i$ is the loss ratio. $P_i$ must be earned premium over the same exposure that produced $\pi_i$.

### Why AvT rather than loss ratio

Both account for expenses. A loss ratio is judged against the permissible loss ratio $1 - V - Q$, the share of premium meant to fund claims. With $F = 0$ the two are the same comparison:

$$
\text{AvT} = \frac{\sum P_i}{\sum T_i} = \frac{1 - V - Q}{\sum \hat\pi_i \big/ \sum P_i}
$$

AvT is below 1 exactly when the estimated claims-to-premium ratio is above $1 - V - Q$. The difference is which claims number goes in: actual $\pi_i$ or estimated $\hat\pi_i$. Actual claims are noisy in small groups and don't exist at quote time.

### Worked example: 20 French bulldogs in Colorado

Each pays \$600, so \$12,000 in premium. With $V + Q = 0.20$ and $F = 0$, the claims budget is $0.80 \times \$12{,}000 = \$9{,}600$.

| Source of claims | Claims | Claims / premium | Reads as |
| --- | --- | --- | --- |
| Year 1, actual: two minor claims | \$3,000 | 0.25 | badly overpriced |
| Year 2, actual: one airway surgery | \$22,000 | 1.83 | disastrous |
| Model, every year | \$10,800 | 0.90 | AvT = 0.80 / 0.90 = 0.89, about 11% underpriced |

The actual loss ratio swings with luck because 20 dogs is too few. The model borrows strength from all French bulldogs, all 4-year-olds and all of Colorado, so its answer is stable.

### How the three ratios connect

With $F = 0$ and $k = 1/(1 - V - Q)$:

$$
\underbrace{\frac{\sum P_i}{\sum k\,\hat\pi_i}}_{\text{AvT}}
=
\underbrace{\frac{\sum P_i}{\sum k\,\pi_i}}_{(1-V-Q)/\text{LR}}
\times
\underbrace{\frac{\sum \pi_i}{\sum \hat\pi_i}}_{\text{A/E}}
$$

Price adequacy judged by the model equals price adequacy judged by actual claims, times how actual claims compared with the model. If pricing were clairvoyant, with $P_i = k\,\pi_i$, the first factor on the right would be 1 and AvT would equal A/E.

A/E checks the model because it contains no premium: it compares only the model with reality. A/E near 1 over large groups is what justifies trusting AvT in thin cells.

## Avoiding unknown loadings

If fixed expense is small, the loadings multiply every cell by the same constant, so relative AvT ranks cells without knowing $V$ or $Q$.

### Why the loadings cancel

With $F \approx 0$, $T_i = k\,\hat\pi_i$ for every policy, so $(1 - V - Q)$ appears as the same factor in every cell's AvT:

$$
\text{AvT}(S) = (1 - V - Q)\,\frac{\sum_{i\in S} P_i}{\sum_{i\in S} \hat\pi_i}
$$

Dividing by the book's AvT removes it:

$$
\text{AvT}_{\text{rel}}(S) = \frac{\sum_{i\in S} P_i \big/ \sum_{i\in S} \hat\pi_i}{\sum_{\text{book}} P_i \big/ \sum_{\text{book}} \hat\pi_i}
$$

A value of 0.85 means cell $S$ is priced 15% worse than the book average, relative to its estimated cost.

### Where actual losses come in

1. **Calibrate the model's level.** Scale $\hat\pi_i$ so that $\sum \hat\pi_i = \sum \pi_i$ over the book. The model decides how estimated cost is distributed across cells; actual experience decides the total.
2. **Book-level adequacy.** The actual book loss ratio, $\sum \pi_i / \sum P_i$, is a number the business already tracks against its own target, even if $V$ and $Q$ are never shared.

Actual losses aren't used cell by cell because small cells are mostly noise, as the French bulldog example shows.

### What this gives up

- **Fixed expense.** If $F$ is material, cheap policies need proportionally more premium, so ignoring $F$ makes low-premium cells look better than they are. Recomputing with a plausible range of $F$ shows whether the ranking of the worst cells changes.
- **Absolute statements.** "Cell $S$ is 15% worse than average" is supported; "cell $S$ loses money" needs the loadings.

## The deliverables

Both deliverables are AvT, grouped differently: by cell for underpricing, by applicant for routing.

### Underpriced cells

A cell is one combination of rating variables, such as a 4-year-old neutered female French bulldog in Colorado. Rank cells by relative AvT, then look for patterns at coarser levels: breed, age band, state and their combinations. $T_i$ comes from the model rather than the cell's own claims, which is what makes cell-level adequacy feasible.

### Underwriting routing at new business

Routing decides what happens to an application before binding: request medical records, refer to custom underwriting, and similar actions. Rules may use only what is known at quote time: rating variables, chosen deductible, copay and limit, and application answers.

Route on low $P_i / T_i$, not on high $T_i$. An expensive pet priced accordingly is not a problem; a pet priced below its estimated cost is. A shallow decision tree fit to policy-level AvT is one way to turn this into interpretable rules.

### Open questions

- [ ] Confirm that "actual" in AvT means premium charged, not losses paid
- [ ] Get values of $F$, $V$ and $Q$, or confirm that relative AvT is acceptable, and whether $F \approx 0$ is safe
- [ ] Settle base levels, and revisit how the base choice affects one-way relativities
- [ ] Check mechanical vs empirical paid by deductible and limit level
- [ ] Run $\sum_S \pi_i / \sum_S g(\hat u_i)$ by deductible level to see the eligible route's error directly
- [ ] Check the distribution of `ee` for partial-year policies
- [ ] Ask whether "high-risk" in routing means high cost or underpriced
