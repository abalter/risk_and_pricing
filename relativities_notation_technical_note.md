# Technical Note: Relativities as Expectations, Filters, Interventions, and Projections

## Purpose

This note develops a unified framework for actuarial relativities based on five primitive operations:

1. Evaluate
2. Filter
3. Set (Intervene)
4. Average
5. Project

The central idea is that the overall relativity surface is the fundamental object. One-way relativities, two-way relativities, PDPs, ICE curves, and related summaries are derived from it through combinations of these operations.

---

## Model Space and Portfolio Space

Let

$$
\mathcal X
$$

be the model feature space.

A risk profile is

$$
x=(x_1,\ldots,x_p) \in \mathcal X.
$$

The fitted model is

$$
\hat u(x),
$$

where \(\hat u(x)\) denotes the modeled loss rate, pure premium, or other modeled risk quantity.

The model exists on all admissible points in \(\mathcal X\), regardless of whether those points appear in the portfolio.

---

## Portfolio Data

Define the portfolio dataset

$$
D = \{(x_i,e_i)\}_{i=1}^n,
$$

where:

- \(x_i\) is the covariate vector for observation \(i\),
- \(e_i\) is the associated exposure.

Notation:

$$
x_i=(x_{i1},\ldots,x_{ip}).
$$

Here:

- \(x\) = arbitrary point in model space,
- \(x_i\) = observed profile \(i\),
- \(x_{ij}\) = value of variable \(j\) for observation \(i\).

---

## Exposure Measure

The portfolio induces an exposure measure

$$
E.
$$

For observed data,

$$
dE(x)=\sum_i e_i\,\delta_{x_i}(x),
$$

where \(\delta_{x_i}\) denotes a point mass at observation \(x_i\).

This allows equivalent discrete and integral representations.

---

## Exposure-Weighted Expectation

Define expectation under the exposure measure:

$$
E_E[f(X)]
=\frac{\int f(x)\,dE(x)}{\int dE(x)}.
$$

In a finite portfolio,

$$
E_E[f(X)]
=\frac{\sum_i e_i f(x_i)}{\sum_i e_i}.
$$

Define the computational average operator

$$
A_E(D,f)
:=E_E[f(X)].
$$

Thus

$$
A_E(D,f)
=\frac{\sum_i e_i f(x_i)}{\sum_i e_i}.
$$

The notation \(E_E\) is convenient for mathematical derivations, while \(A_E\) is convenient for describing calculations.

---

## Portfolio Average Risk

Define the portfolio average risk

$$
R_b
=E_E[\hat u(X)].
$$

Equivalent forms:

$$
R_b
=\frac{\sum_i e_i\hat u(x_i)}{\sum_i e_i}
=\frac{\int \hat u(x)\,dE(x)}{\int dE(x)}.
$$

---

## Overall Relativity

Define the relativity surface

$$
r(x)
=\frac{\hat u(x)}{R_b}.
$$

By construction,

$$
E_E[r(X)] = 1.
$$

The function \(r(x)\) is the fundamental object in this framework.

---

# Primitive Operations

## 1. Evaluate

Evaluation means computing

$$
r(x)
$$

or

$$
\hat u(x)
$$

at a point in model space.

---

## 2. Filter

Define the filtering operator

$$
F_j(z).
$$

Applied to a portfolio:

$$
F_j(z)(D)
=\{(x_i,e_i)\in D:x_{ij}=z\}.
$$

Interpretation:

> Keep observations whose \(j\)-th variable equals \(z\).

Filtering corresponds to conditioning.

---

## 3. Set (Intervene)

Define

$$
T_j(z,x).
$$

This replaces the \(j\)-th coordinate of \(x\) with \(z\).

$$
T_j(z,x)_k=
\begin{cases}
 z & k=j\\
 x_k & k\neq j
\end{cases}
$$

Interpretation:

> Force variable \(j\) to equal \(z\).

Unlike filtering, this changes the records.

---

## 4. Average

The averaging operator is

$$
A_E(D,f).
$$

This computes an exposure-weighted average over the records in \(D\).

---

## 5. Project

Projection reduces dimensionality by averaging over variables not explicitly retained.

For example,

$$
P_j[r](z)
:=E_E[r(X)\mid X_j=z].
$$

The operator \(P_j\) maps a multidimensional function into a one-dimensional function.

Note: this is a conditional-expectation projection, not merely algebraic marginalization.

---

# One-Way Relativities

The one-way relativity for variable \(j\) is

$$
r_j(z)
=E_E[r(X)\mid X_j=z].
$$

Discrete form:

$$
r_j(z)
=\frac{\sum_{i:x_{ij}=z} e_i r(x_i)}{\sum_{i:x_{ij}=z} e_i}.
$$

Integral form:

$$
r_j(z)
=\frac{\int r(x)\mathbf 1(x_j=z)\,dE(x)}{\int \mathbf 1(x_j=z)\,dE(x)}.
$$

Operator form:

$$
r_j(z)
=A_E(F_j(z)(D),r).
$$

Interpretation:

> Average relativity among policies that naturally have value \(z\).

---

# Two-Way Relativities

$$
r_{jk}(z,w)
=E_E[r(X)\mid X_j=z,X_k=w].
$$

Discrete form:

$$
r_{jk}(z,w)
=\frac{\sum_{i:x_{ij}=z,x_{ik}=w} e_i r(x_i)}{\sum_{i:x_{ij}=z,x_{ik}=w} e_i}.
$$

Operator form:

$$
r_{jk}(z,w)
=A_E(F_j(z)F_k(w)(D),r).
$$

These are naturally visualized with heatmaps.

---

# PDP-Style Relativities

A partial dependence quantity uses intervention rather than filtering.

$$
p_j(z)
=E_E[r(T_j(z,X))].
$$

Discrete form:

$$
p_j(z)
=\frac{\sum_i e_i r(T_j(z,x_i))}{\sum_i e_i}.
$$

Integral form:

$$
p_j(z)
=\frac{\int r(T_j(z,x))\,dE(x)}{\int dE(x)}.
$$

Operator form:

$$
p_j(z)
=A_E(D,r\circ T_j(z)).
$$

Interpretation:

> What would the portfolio's average relativity be if every policy had value \(z\)?

---

# ICE Curves

For observation \(i\),

$$
p_{ij}(z)
=r(T_j(z,x_i)).
$$

Interpretation:

> Hold all other characteristics fixed and vary variable \(j\).

No averaging occurs.

---

# Raw Data Versus Modeled Data

The framework applies equally to observed outcomes and modeled outcomes.

## Observed Data

Let

$$
u_i
$$

be an observed loss rate.

Then observed one-way risk is

$$
\frac{\sum_{i:x_{ij}=z} e_i u_i}{\sum_{i:x_{ij}=z} e_i}.
$$

Advantages:

- Directly reflects historical experience.
- Requires no model.

Disadvantages:

- High variance.
- Sparse segments may be unstable.

## Modeled Data

Replace observed loss rates with predictions:

$$
\hat u(x_i).
$$

Then the modeled one-way risk is

$$
\frac{\sum_{i:x_{ij}=z} e_i \hat u(x_i)}{\sum_{i:x_{ij}=z} e_i}.
$$

Advantages:

- More stable.
- Leverages information from all predictors.
- Naturally incorporates interactions and shrinkage present in the model.

Disadvantages:

- Depends on model specification and assumptions.

## Unified View

Observed and modeled summaries differ only in the function being averaged.

Observed:

$$
f(x_i)=u_i.
$$

Modeled:

$$
f(x_i)=\hat u(x_i).
$$

All filter, set, average, and projection operators remain unchanged.

---

# Filter Versus Set

The distinction between filtering and setting is fundamental.

Filtering:

$$
F_j(z)
$$

means:

> Keep records where \(x_j=z\).

Setting:

$$
T_j(z)
$$

means:

> Change records so that \(x_j=z\).

Thus

$$
E_E[r(X)\mid X_j=z]
$$

and

$$
E_E[r(T_j(z,X))]
$$

answer different questions.

---

# Operator Ordering

Filter then set:

$$
T_k(w)F_j(z)(D).
$$

Interpretation:

> Among policies with \(X_j=z\), what would happen if \(X_k\) were set to \(w\)?

Set then filter:

$$
F_j(z)T_k(w)(D).
$$

If \(j\neq k\), these may coincide.

If \(j=k\), they generally do not.

The operators therefore provide an algebra for expressing counterfactual and conditional questions.

---

# Notation Reference

| Symbol | Meaning |
|----------|----------|
| $x$ | Arbitrary point in model space |
| $x_i$ | Observed profile $i$ |
| $x_{ij}$ | Variable $j$ for observation $i$ |
| $\mathcal X$ | Model feature space |
| $e_i$ | Exposure |
| $D$ | Portfolio dataset |
| $u_i$ | Observed loss rate |
| $\hat u(x)$ | Modeled loss rate |
| $R_b$ | Portfolio average modeled risk |
| $r(x)$ | Overall relativity |
| $E_E[\cdot]$ | Exposure-weighted expectation |
| $A_E(D,\cdot)$ | Exposure-weighted averaging operator |
| $F_j(z)$ | Filter where variable $j=z$ |
| $T_j(z,x)$ | Set variable $j$ equal to $z$ |
| $P_j$ | Conditional-expectation projection |

---

# Relativity Calculation Reference

| Quantity | Expectation Form | Operator Form |
|----------|----------|----------|
| Portfolio average risk | $E_E[\hat u(X)]$ | $A_E(D,\hat u)$ |
| Overall relativity | $\hat u(x)/R_b$ | Evaluate $r(x)$ |
| One-way relativity | $E_E[r(X)\mid X_j=z]$ | $A_E(F_j(z)(D),r)$ |
| Two-way relativity | $E_E[r(X)\mid X_j=z,X_k=w]$ | $A_E(F_j(z)F_k(w)(D),r)$ |
| PDP | $E_E[r(T_j(z,X))]$ | $A_E(D,r\circ T_j(z))$ |
| ICE | $r(T_j(z,x_i))$ | Evaluate transformed record |
| Observed one-way risk | $E_E[u(X)\mid X_j=z]$ | $A_E(F_j(z)(D),u)$ |
| Observed two-way risk | $E_E[u(X)\mid X_j=z,X_k=w]$ | $A_E(F_j(z)F_k(w)(D),u)$ |

---

# Core Insight

The relativity surface

$$
r(x)=\frac{\hat u(x)}{R_b}
$$

is the fundamental object.

One-way relativities, two-way relativities, PDPs, ICE curves, and relativity heatmaps are all derived from the same surface through combinations of:

- Evaluate
- Filter
- Set
- Average
- Project

This viewpoint provides a unified mathematical and computational language for understanding actuarial risk segmentation.


I've staged the technical note as a downloadable Markdown file:

technical_note_relativities.md

One correction I'd make in a future revision: I introduced PjP_j as a projection operator. I think that's cleaner than the earlier M−jM_{-j}, but I'd want to spend a bit more time deciding whether "projection" or "conditional expectation operator" is the better term for the framework. Everything else is reasonably internally consistent.

