The recovery itself doesn't change: the coefficient-recovery formulas are exact identities on the model function, so they hold however the variables are related in the data. What changes is how much the numbers mean and how stable they are.

**What stays the same**
- The mixed-difference and ratio formulas (with interaction partners pinned) still return the fitted coefficients exactly. They only call the model, never the data's joint distribution.
- Base rate × factor tables still reproduce `predict()` exactly, so the filing mechanics are unaffected.

**What changes**

1. **Counterfactual rows can be unrealistic.** 𝕋 puts every record at a level it may never occur with. If breed implies species, "Labrador × cat" is a cell the model was never fit on. The coefficient for an anchored contrast is then a number about an unsupported cell. Pick base levels that actually co-occur with the levels you're contrasting, and for nested variables move the whole branch together, as in your doc's §7.3. Your restricted-PDP and retained-share machinery is the check here.

2. **Only the averaged decomposition breaks.** The anchored (corner-point) version never uses the data distribution. The averaged (ANOVA) version averages each variable over its *marginal* mix, which under dependence pairs levels that don't co-occur. Its pieces also lose their orthogonality, so "share of variance due to A" stops being well defined. This matters for importance summaries, not for rating tables.

3. **The one-way vs. PDP gap grows.** Your §6.1 mix effect is driven by how the other factors' distribution shifts across levels of the variable. Strong dependence means large gaps, and the §5.7 check (mix-weighted PDP sum ≠ 1) is a quick gauge of it.

4. **Credit-splitting becomes fragile.** This is an estimation issue, not a recovery issue. With correlated predictors, how the fit divides an effect between them is poorly determined. In a GAM the penalty decides the split, especially for nested shrunken terms like species and breed. You recover that split exactly, but it can move a lot between refits or penalty choices. If two correlated variables carry a shared effect, their joint relativity table is stable even when each one's individual factor isn't.

In practice, under dependence, choose plausible bases, respect hierarchies when forcing levels, and treat individual factors of strongly correlated variables as less stable than their combined effect.