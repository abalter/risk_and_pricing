# Calculus and Insurance Relativities

The central connection is:

> **A relativity is a finite multiplicative change. A derivative is the corresponding instantaneous change.**

Suppose

\[
f(\mathbf{x}) > 0
\]

is the predicted risk, loss cost, frequency, severity, or pure premium for a risk vector

\[
\mathbf{x}=(x_1,\ldots,x_p).
\]

For multiplicative comparisons, the natural calculus quantity is usually not simply

\[
\frac{\partial f(\mathbf{x})}{\partial x_j},
\]

but the derivative of the log prediction:

\[
\frac{\partial \log f(\mathbf{x})}{\partial x_j}
=
\frac{1}{f(\mathbf{x})}
\frac{\partial f(\mathbf{x})}{\partial x_j}.
\]

This is the local rate of **proportional change** in predicted risk.

---

## 1. From derivatives to relativities

Hold all variables except \(x_j\) fixed and define

\[
g(t)=f(t,\mathbf{x}_{-j}).
\]

The relativity between \(x_j=a\) and \(x_j=b\), conditional on the other predictor values, is

\[
R_j(a,b\mid\mathbf{x}_{-j})
=
\frac{g(a)}{g(b)}.
\]

Taking logarithms gives

\[
\log R_j(a,b\mid\mathbf{x}_{-j})
=
\log g(a)-\log g(b).
\]

By the fundamental theorem of calculus,

\[
\boxed{
\log R_j(a,b\mid\mathbf{x}_{-j})
=
\int_b^a
\frac{\partial \log f(t,\mathbf{x}_{-j})}{\partial t}
\,dt
}
\]

and therefore

\[
\boxed{
R_j(a,b\mid\mathbf{x}_{-j})
=
\exp\left\{
\int_b^a
\frac{\partial \log f(t,\mathbf{x}_{-j})}{\partial t}
\,dt
\right\}.
}
\]

Thus, a relativity is the **accumulated local proportional change** between two predictor values.

### Local approximation

For a small change \(\Delta x_j\),

\[
R_j(x_j+\Delta x_j,x_j\mid\mathbf{x}_{-j})
\approx
\exp\left\{
\frac{\partial\log f(\mathbf{x})}{\partial x_j}
\Delta x_j
\right\}.
\]

When the change is very small,

\[
R_j-1
\approx
\frac{\partial\log f(\mathbf{x})}{\partial x_j}
\Delta x_j.
\]

This is the multiplicative analogue of the ordinary linear approximation

\[
\Delta f
\approx
\frac{\partial f}{\partial x_j}\Delta x_j.
\]

---

## 2. Overall relativity and multivariable calculus

Let \(\mathbf{x}^b\) be a baseline risk vector. The overall relativity of \(\mathbf{x}\) relative to \(\mathbf{x}^b\) is

\[
R(\mathbf{x};\mathbf{x}^b)
=
\frac{f(\mathbf{x})}{f(\mathbf{x}^b)}.
\]

Let

\[
\boldsymbol{\gamma}(s),\qquad 0\leq s\leq1,
\]

be any smooth path from \(\mathbf{x}^b\) to \(\mathbf{x}\):

\[
\boldsymbol{\gamma}(0)=\mathbf{x}^b,
\qquad
\boldsymbol{\gamma}(1)=\mathbf{x}.
\]

Then

\[
\boxed{
\log R(\mathbf{x};\mathbf{x}^b)
=
\int_0^1
\nabla\log f\{\boldsymbol{\gamma}(s)\}^{\mathsf T}
\boldsymbol{\gamma}'(s)
\,ds.
}
\]

This provides the following interpretation:

- \(\nabla\log f(\mathbf{x})\) is the vector of **local log-relativity gradients**.
- Each component describes the local proportional sensitivity to one predictor.
- The overall log-relativity is the accumulated gradient along a path from the baseline risk to the target risk.
- Exponentiating converts the accumulated log change into a multiplicative relativity.

Because \(\nabla\log f\) is the gradient of a scalar function, the total line integral is path-independent under the usual differentiability conditions.

However, an attempt to divide the total change into separate variable contributions can be path-dependent when the model contains interactions. A decomposition must therefore specify an ordering, path, or averaging convention.

---

## 3. Baseline-fixed relativity as a slice through the prediction surface

Suppose that only \(x_j\) is varied while all other predictors remain at their baseline values \(\mathbf{x}_{-j}^b\).

The corresponding relativity is

\[
R_j^{\mathrm{base}}(a,b)
=
\frac{
f(a,\mathbf{x}_{-j}^b)
}{
f(b,\mathbf{x}_{-j}^b)
}.
\]

Its calculus representation is

\[
\boxed{
\log R_j^{\mathrm{base}}(a,b)
=
\int_b^a
\frac{\partial\log f(t,\mathbf{x}_{-j}^b)}
     {\partial t}
\,dt.
}
\]

This relativity follows one particular slice through the fitted prediction surface.

It answers:

> How would the predicted risk of the baseline profile change if only \(x_j\) changed?

If the model contains interactions, changing the baseline values of the other predictors can change this relativity.

---

## 4. ICE relativity as an integrated individual derivative

For observation \(i\), define its Individual Conditional Expectation function for \(x_j\) as

\[
g_{ij}(t)
=
f(t,\mathbf{x}_{i,-j}).
\]

This varies \(x_j\) while holding the remaining predictors at the values observed for risk \(i\).

The ICE relativity between \(a\) and \(b\) is

\[
R_{ij}^{\mathrm{ICE}}(a,b)
=
\frac{
f(a,\mathbf{x}_{i,-j})
}{
f(b,\mathbf{x}_{i,-j})
}.
\]

Its calculus representation is

\[
\boxed{
\log R_{ij}^{\mathrm{ICE}}(a,b)
=
\int_b^a
\frac{\partial\log f(t,\mathbf{x}_{i,-j})}
     {\partial t}
\,dt.
}
\]

Therefore:

- An **ICE curve** follows the prediction for one individual risk as \(x_j\) varies.
- A **derivative ICE curve** follows the local slope for that individual risk.
- An **ICE relativity** accumulates that individual-specific log-slope over an interval.

Goldstein et al. define ICE curves by varying the predictor of interest separately for each observation while holding that observation's other predictors fixed. They also introduce derivative ICE plots, which display derivatives of the individual ICE functions and can reveal heterogeneity associated with interactions [Goldstein et al. (2015), Sections 3 and 4].

### Interaction interpretation

Consider the local log-slope

\[
\frac{\partial\log f(t,\mathbf{x}_{-j})}{\partial t}.
\]

If this quantity varies substantially with \(\mathbf{x}_{-j}\), then the effect of \(x_j\) depends on the rest of the risk profile.

Consequently, the ICE curves for different observations can have different slopes or shapes. This heterogeneity is one of the principal features ICE plots were designed to expose [Goldstein et al. (2015), Sections 3.2 and 4].

---

## 5. Partial relativity as calculus after averaging

Define the partial-dependence risk function

\[
m_j(t)
=
E_W\left[
f(t,\mathbf{X}_{-j})
\right],
\]

where \(E_W\) denotes the selected portfolio averaging distribution. For example, it could be an exposure-weighted empirical average:

\[
m_j(t)
=
\frac{
\sum_{i=1}^n w_i f(t,\mathbf{x}_{i,-j})
}{
\sum_{i=1}^n w_i
}.
\]

The partial relativity between \(a\) and \(b\) is

\[
R_j^{\mathrm{PD}}(a,b)
=
\frac{m_j(a)}{m_j(b)}.
\]

Friedman's partial-dependence construction fixes the focal predictor values and averages the fitted function over the joint distribution of the remaining predictors [Friedman (2001), Section 8.1, equations 44–45].

The calculus representation is

\[
\boxed{
\log R_j^{\mathrm{PD}}(a,b)
=
\int_b^a
\frac{m_j'(t)}{m_j(t)}
\,dt.
}
\]

If differentiation and averaging can be interchanged, then

\[
m_j'(t)
=
E_W\left[
\frac{\partial f(t,\mathbf{X}_{-j})}{\partial t}
\right].
\]

Therefore,

\[
\frac{d}{dt}\log m_j(t)
=
\frac{
E_W\left[
\partial f(t,\mathbf{X}_{-j})/\partial t
\right]
}{
E_W\left[
f(t,\mathbf{X}_{-j})
\right]
}.
\]

Because

\[
\frac{\partial f}{\partial t}
=
f\frac{\partial\log f}{\partial t},
\]

this can also be written as

\[
\boxed{
\frac{d}{dt}\log m_j(t)
=
\frac{
E_W\left[
f(t,\mathbf{X}_{-j})
\frac{\partial\log f(t,\mathbf{X}_{-j})}{\partial t}
\right]
}{
E_W\left[
f(t,\mathbf{X}_{-j})
\right]
}.
}
\]

This has an important implication:

> The derivative of the log partial-dependence curve is generally not the ordinary average of the individual log-derivatives.

Instead, it is a **prediction-weighted average** of individual log-derivatives. Risks with larger predicted outcomes receive more weight in the proportional slope of the portfolio-average prediction.

This is another manifestation of the distinction between

\[
\log E[f]
\]

and

\[
E[\log f].
\]

They are different mathematical objects.

---

## 6. ICE and partial relativity are related by averaging

The partial-dependence function is an average of ICE functions:

\[
m_j(t)
=
E_W[g_{ij}(t)].
\]

In empirical form,

\[
m_j(t)
=
\frac{
\sum_{i=1}^n w_i g_{ij}(t)
}{
\sum_{i=1}^n w_i
}.
\]

Thus:

> **ICE shows the collection of individual prediction curves; partial dependence averages those curves.**

Goldstein et al. describe ICE as a disaggregation of the partial-dependence function into observation-specific curves [Goldstein et al. (2015), Sections 1 and 3].

However, the partial relativity is generally not the arithmetic mean of the ICE relativities:

\[
\frac{m_j(a)}{m_j(b)}
\neq
E_W\left[
\frac{g_{ij}(a)}{g_{ij}(b)}
\right].
\]

The left side is a **ratio of averages**, whereas the right side is an **average of ratios**.

These coincide only under special conditions.

---

## 7. One-way relativity

Suppose a one-way risk function uses the actual portfolio members observed at each value or level of \(x_j\):

\[
q_j(t)
=
E_W\left[
f(\mathbf{X})
\mid X_j=t
\right].
\]

The associated one-way relativity is

\[
R_j^{\mathrm{1way}}(a,b)
=
\frac{q_j(a)}{q_j(b)}.
\]

For a continuous predictor, its formal local proportional slope is

\[
\frac{d}{dt}\log q_j(t).
\]

The one-way function can be written as

\[
q_j(t)
=
\int
f(t,\mathbf{z})\,
dP_W(\mathbf{z}\mid X_j=t).
\]

As \(t\) changes, two things can change:

1. The value of the focal predictor inside \(f(t,\mathbf{z})\).
2. The conditional distribution of the remaining predictors,
   \[
   P_W(\mathbf{X}_{-j}\mid X_j=t).
   \]

The derivative of the one-way function therefore generally combines:

- a **model-response component**, caused by changing \(x_j\);
- a **portfolio-composition component**, caused by changes in the associated distribution of the other risk characteristics.

By contrast, partial dependence uses a fixed averaging distribution:

\[
m_j(t)
=
\int
f(t,\mathbf{z})\,dP_W(\mathbf{z}).
\]

The distinction is:

> **Partial-relativity derivative:** Change the focal predictor while holding the averaging portfolio fixed.

> **One-way-relativity derivative:** Move through the observed portfolio, allowing both the focal predictor and the associated risk mix to change.

This is closely related to the distinction drawn by Apley and Zhu between partial-dependence functions and conditional or marginal plots. They show that conditional averaging can confound the focal predictor's modeled effect with the effects of associated predictors [Apley and Zhu (2020), Sections 2.1–2.3].

---

## 8. Interactions correspond to mixed partial derivatives

For two continuous predictors \(x_j\) and \(x_k\), consider

\[
\frac{\partial^2\log f(\mathbf{x})}
     {\partial x_j\,\partial x_k}.
\]

This measures how the local log-relativity gradient for \(x_j\) changes as \(x_k\) changes.

- If the mixed partial is zero everywhere, the local proportional effect of \(x_j\) does not depend on \(x_k\).
- If it is nonzero, the slope for \(x_j\) varies with \(x_k\), indicating an interaction on the log-risk scale.

For an additive log model,

\[
\log f(\mathbf{x})
=
\beta_0+\sum_{j=1}^p h_j(x_j),
\]

all cross-partials are zero:

\[
\frac{\partial^2\log f(\mathbf{x})}
     {\partial x_j\,\partial x_k}
=
0,
\qquad j\neq k.
\]

The prediction model is then multiplicative:

\[
f(\mathbf{x})
=
e^{\beta_0}
\prod_{j=1}^p e^{h_j(x_j)}.
\]

In this special case, each variable has an independent relativity:

\[
R_j(a,b)
=
\exp\{h_j(a)-h_j(b)\}.
\]

That relativity does not depend on the values of the other predictors.

This is the calculus explanation for why a multiplicative rating model without interactions produces stable factor relativities.

### With interactions

Suppose instead that

\[
\log f(x_j,x_k)
=
h_j(x_j)+h_k(x_k)+h_{jk}(x_j,x_k).
\]

Then

\[
\frac{\partial\log f}{\partial x_j}
=
h_j'(x_j)
+
\frac{\partial h_{jk}(x_j,x_k)}{\partial x_j}.
\]

The local effect of \(x_j\) now depends on \(x_k\). Accordingly:

- the relativity for \(x_j\) is not a single universal number;
- ICE relativities can differ across risks;
- baseline-fixed relativities depend on the selected baseline;
- partial relativities average over this interaction-dependent heterogeneity.

---

## 9. Elasticity as relativity per percentage change

For a positive continuous predictor \(x_j\), define the elasticity

\[
\frac{\partial\log f}{\partial\log x_j}
=
x_j\frac{\partial\log f}{\partial x_j}.
\]

This answers:

> Approximately what percentage change in predicted risk accompanies a 1% change in \(x_j\)?

For a finite change from \(b\) to \(a\),

\[
\log R_j(a,b)
=
\int_{\log b}^{\log a}
\frac{\partial\log f}
     {\partial\log x_j}
\,d\log x_j.
\]

Thus, elasticity is the infinitesimal analogue of a relativity measured against a **proportional change in the predictor**, rather than a one-unit change.

If the elasticity is constant and equal to \(\eta\), then

\[
\log R_j(a,b)
=
\eta\log\left(\frac{a}{b}\right),
\]

so

\[
R_j(a,b)
=
\left(\frac{a}{b}\right)^\eta.
\]

---

## 10. Categorical relativities are finite differences

For a categorical predictor, an ordinary derivative does not exist. The appropriate analogue is a finite difference or finite contrast.

For levels \(A\) and \(B\), the additive contrast is

\[
\Delta f
=
f(x_j=B,\mathbf{x}_{-j})
-
f(x_j=A,\mathbf{x}_{-j}).
\]

The multiplicative contrast is

\[
R
=
\frac{
f(x_j=B,\mathbf{x}_{-j})
}{
f(x_j=A,\mathbf{x}_{-j})
}.
\]

On the log scale,

\[
\Delta\log f
=
\log f(x_j=B,\mathbf{x}_{-j})
-
\log f(x_j=A,\mathbf{x}_{-j})
=
\log R.
\]

Thus, a categorical log-relativity is the discrete counterpart of an integrated log-derivative.

This gives a unified interpretation:

- For a continuous predictor, a relativity is an **accumulated derivative**.
- For a categorical predictor, a relativity is a **finite difference on the log-prediction scale**.
- In both cases, the relativity is a contrast between two modeled risk states.

---

## 11. Connection to accumulated local effects

Accumulated Local Effects, or ALE, provide another direct connection between calculus and model interpretation.

For a continuous predictor, a first-order ALE function is constructed by averaging local derivatives conditionally over the observed distribution and then integrating those averages:

\[
\operatorname{ALE}_j(t)
=
\int_{t_0}^{t}
E\left[
\left.
\frac{\partial f(z,\mathbf{X}_{-j})}{\partial z}
\right|
X_j=z
\right]
\,dz
-
C.
\]

Here, \(C\) is a centering constant.

Apley and Zhu introduced ALE to estimate predictor effects through accumulated local derivatives while avoiding some of the extrapolation created by partial dependence when predictors are strongly dependent [Apley and Zhu (2020), Sections 2.3 and 2.4].

This produces a useful conceptual progression:

- **Derivative:** local change at one point and one risk profile.
- **ICE:** local or finite change along one individual's prediction curve.
- **Partial dependence:** average predictions first, then compare or differentiate.
- **ALE:** average local derivatives conditionally, then accumulate them.
- **Relativity:** exponentiate an accumulated change on the log-risk scale.

An analogous log-risk ALE construction would accumulate conditional averages of

\[
\frac{\partial\log f}{\partial x_j}
\]

rather than derivatives of \(f\) itself.

---

## 12. Summary

| Concept | Underlying quantity | Calculus analogue | Plain-language question |
|---|---|---|---|
| **Overall relativity** | \(f(\mathbf{x})/f(\mathbf{x}^b)\) | Line integral of \(\nabla\log f\) | How much riskier is this complete risk vector than the baseline? |
| **Baseline-fixed relativity** | \(f(a,\mathbf{x}_{-j}^b)/f(b,\mathbf{x}_{-j}^b)\) | Integral of a log-partial derivative along the baseline profile | How would baseline risk change if only \(x_j\) changed? |
| **ICE relativity** | \(f(a,\mathbf{x}_{i,-j})/f(b,\mathbf{x}_{i,-j})\) | Integral of an individual-specific log-derivative | How would this particular risk's prediction change? |
| **Partial relativity** | \(m_j(a)/m_j(b)\) | Integral of the log-derivative of an averaged prediction curve | How would average predicted risk change if everyone were assigned this value? |
| **One-way relativity** | \(q_j(a)/q_j(b)\) | Combines model response and portfolio-composition change | How does predicted risk differ across the groups actually found at these values? |
| **Interaction** | Dependence of one variable's relativity on other variables | Mixed partial derivative of \(\log f\) | Does the effect of \(x_j\) change depending on \(x_k\)? |
| **Elasticity** | Proportional outcome change per proportional predictor change | \(\partial\log f/\partial\log x_j\) | What percentage risk change accompanies a 1% predictor change? |
| **Categorical relativity** | Ratio between predictions for two levels | Finite difference in \(\log f\) | How does predicted risk change when moving between two categories? |
| **ALE** | Accumulated conditionally averaged local effects | Integral of conditional expected derivatives | What local effect accumulates over the observed predictor distribution? |

---

## 13. Unifying framework

The different relativities differ primarily in **which curve is constructed before taking the ratio**:

\[
\text{Relativity}
=
\frac{
\text{curve value at }a
}{
\text{curve value at }b
}.
\]

- **Overall relativity** compares two points on the full prediction surface.
- **Baseline-fixed relativity** uses a slice through the selected baseline profile.
- **ICE relativity** uses an individual slice through the prediction surface.
- **Partial relativity** first averages individual prediction curves over a fixed portfolio.
- **One-way relativity** averages over the portfolio actually associated with each focal value.

Calculus describes the local geometry of each of these curves:

\[
\boxed{
\text{log-relativity}
=
\text{accumulated local log-slope}.
}
\]

This is the common framework connecting derivatives, ICE, partial dependence, interactions, elasticities, and actuarial relativities.

---

## References

Apley, D. W., and Zhu, J. (2020). “Visualizing the Effects of Predictor Variables in Black Box Supervised Learning Models.” *Journal of the Royal Statistical Society: Series B*, 82(4), 1059–1086.  
https://doi.org/10.1111/rssb.12377

- Sections 2.1–2.3 distinguish partial dependence, conditional averaging, and their behavior under predictor dependence.
- Sections 2.3–2.4 define accumulated local effects using conditionally averaged local derivatives.
- The appendices provide the corresponding formal functional definitions and decompositions.

Friedman, J. H. (2001). “Greedy Function Approximation: A Gradient Boosting Machine.” *The Annals of Statistics*, 29(5), 1189–1232.  
https://doi.org/10.1214/aos/1013203451

- Section 8 introduces interpretation methods for fitted prediction functions.
- Section 8.1, particularly equations 44–45, defines partial dependence by averaging over the complementary predictor distribution.
- Section 8.2 discusses interaction effects in fitted functions.

Goldstein, A., Kapelner, A., Bleich, J., and Pitkin, E. (2015). “Peeking Inside the Black Box: Visualizing Statistical Learning With Plots of Individual Conditional Expectation.” *Journal of Computational and Graphical Statistics*, 24(1), 44–65.  
https://doi.org/10.1080/10618600.2014.907095

- Section 3 defines ICE curves as observation-specific versions of partial-dependence curves.
- Section 3.2 introduces derivative ICE plots.
- Section 4 demonstrates how heterogeneous ICE curves and derivatives reveal interaction structure.