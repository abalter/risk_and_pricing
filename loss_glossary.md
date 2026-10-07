You're right, and the inconsistency was mine, not just the field's. Actuarial notation does vary, but the specific slip was writing "$P_i = (E[\pi_i]+F)/(1-V-Q)$." That's not a definition of $P_i$. It's a *condition*: what would be true if the policy were priced exactly right, which should have been written as $P_i = T_i$. Here is a fixed notation that I'll stick to.

**Rules that make it consistent**

1. **No hat means observed data.** A hat means a model estimate.
2. **$P_i$ is always data** (the premium charged). It is never computed from a model.
3. **$T_i$ is always computed.** It is never data.
4. **$E[\cdot]$ is the true, unknown expectation.** Its estimate always carries a hat.
5. **Policy totals use the index $i$.** Per-unit-exposure rates are functions of the rating variables, with no index.

**Data (per policy $i$, over its term)**

| Symbol | Meaning |
|---|---|
| $x_i$ | rating variables (age, species, breed, sex, state, product) |
| $d_i, c_i, l_i$ | deductible, copay, annual limit |
| $ee_i$ | earned exposure |
| $u_i$ | eligible loss |
| $\pi_i$ | paid loss, $\approx g(u_i;\, d_i, c_i, l_i)$ |
| $P_i$ | earned on-level premium (charged) |

**Model estimates**

| Symbol | Meaning |
|---|---|
| $\hat\mu_u(x)$ | ground-up pure premium: eligible loss per unit exposure (eligible model) |
| $\hat\mu_\pi(x, d, c, l)$ | paid pure premium: paid loss per unit exposure (paid model) |
| $\hat u_i = ee_i\,\hat\mu_u(x_i)$ | expected eligible loss for policy $i$ |
| $\hat\pi_i = ee_i\,\hat\mu_\pi(x_i, d_i, c_i, l_i)$ | expected paid loss for policy $i$ |

**Pricing quantities**

| Symbol | Meaning |
|---|---|
| $F,\ V,\ Q$ | fixed expense per unit exposure, variable expense ratio, profit ratio |
| $T_i = \dfrac{\hat\pi_i + F\,ee_i}{1 - V - Q}$ | technical premium for policy $i$ |

"Correctly priced" means $P_i = T_i$.

**Ratios over a group of policies $S$**

| Ratio | Formula | Answers |
|---|---|---|
| AvT | $\sum_S P_i \,/\, \sum_S T_i$ | Is the price adequate for the expected cost? |
| Loss ratio | $\sum_S \pi_i \,/\, \sum_S P_i$ | How did the premium compare to actual claims? |
| A/E | $\sum_S \pi_i \,/\, \sum_S \hat\pi_i$ | Did the model predict claims correctly? |

**One more change:** I'll write the Tweedie power as $\xi$ instead of $p$, so no lowercase $p$ appears anywhere. The paid model is then `family = tw()` with estimated $\hat\xi$.

If anything later in our conversation conflicts with this table, the table wins, and you should call it out. Want me to put this into a doc you can keep alongside your project notes?