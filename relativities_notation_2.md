# Relativities as Expectations, Filters, Interventions, and Marginalizations

## Overview

Suppose we have a model

$$
\hat u(x)
$$

which predicts loss rate, pure premium, or some other measure of risk for a risk profile

$$
x \in \mathcal X.
$$

A central idea is that the model itself is not the same thing as the portfolio.

The model exists over the entire feature space:

$$
\mathcal X.
$$

The portfolio only occupies a subset of that space and comes with its own exposure distribution.

Most actuarial quantities of interest can be expressed as combinations of four operations:

1. **Evaluate**
2. **Filter**
3. **Set**
4. **Average**

A fifth useful operation is:

5. **Marginalize (Project)**

Many concepts that are often presented separately (one-way relativities, two-way relativities, PDPs, ICE curves, etc.) can be understood as different combinations of these operations.

---

# Data, Model Space, and Portfolio Space

## Model Space

Let

$$
x = (x_1,\dots,x_p)
$$

denote an arbitrary point in feature space.

The model

$$
\hat u(x)
$$

may be evaluated at any admissible point.

No portfolio or observed data is required.

---

## Portfolio Observations

Suppose the portfolio contains observations

$$
x_1,\dots,x_n.
$$

To avoid notation conflicts:

- \(x\) denotes an arbitrary point in model space.
- \(x_i\) denotes observation \(i\).
- \(x_{ij}\) denotes the value of variable \(j\) for observation \(i\).

Thus

$$
x_i
=
(x_{i1},\dots,x_{ip}).
$$

---

# The Portfolio

Define

$$
D
=
\{(x_i,e_i)\}_{i=1}^n
$$

to be the portfolio dataset.

Each observation consists of:

- risk profile \(x_i\)
- exposure \(e_i\)

The symbol \(D\) represents the collection of business being analyzed.

All filtering, averaging, and summarization operations act on \(D\).

---

# Exposure Measure

The exposure values induce a measure on the feature space.

For observed data,

$$
E(x)
=
\sum_i e_i \delta_{x_i}(x)
$$

where \(\delta_{x_i}\) is a point mass at \(x_i\).

This allows us to write quantities using either:

- discrete sums
- continuous integrals

depending on context.

---

# Exposure-Weighted Average

Define the exposure-weighted average operator

$$
A_E(D,f).
$$

For observed data,

$$
A_E(D,f)
=
\frac{
\sum_i e_i f(x_i)
}{
\sum_i e_i
}.
$$

In continuous form,

$$
A_E(f)
=
\frac{
\int f(x)\,dE(x)
}{
\int dE(x)
}.
$$

---

# Expectation Notation

Define

$$
E_E[f(X)]
=
A_E(D,f).
$$

Thus

$$
E_E[f(X)]
=
\frac{
\sum_i e_i f(x_i)
}{
\sum_i e_i
}
=
\frac{
\int f(x)\,dE(x)
}{
\int dE(x)
}.
$$

The notation

$$
E_E
$$

simply means:

> Take an expectation under the portfolio exposure distribution.

---

# Portfolio Average Risk

The portfolio average risk is

$$
R_b
=
E_E[\hat u(X)].
$$

Discrete form:

$$
R_b
=
\frac{
\sum_i e_i \hat u(x_i)
}{
\sum_i e_i
}.
$$

Integral form:

$$
R_b
=
\frac{
\int \hat u(x)\,dE(x)
}{
\int dE(x)
}.
$$

---

# Overall Relativity

Define

$$
r(x)
=
\frac{\hat u(x)}
     {R_b}.
$$

This produces a dimensionless relative risk measure.

By construction,

$$
E_E[r(X)]
=
1.
$$

Discrete form:

$$
\frac{
\sum_i e_i r(x_i)
}{
\sum_i e_i
}
=
1.
$$

Integral form:

$$
\frac{
\int r(x)\,dE(x)
}{
\int dE(x)
}
=
1.
$$

---

# Operation 1: Evaluate

Evaluation means computing

$$
r(x)
$$

or

$$
\hat u(x)
$$

for a given point.

No averaging or filtering occurs.

---

# Operation 2: Filter

Define the filter operator

$$
F_j(z).
$$

Applied to a dataset,

$$
F_j(z)(D)
=
\{
(x_i,e_i)\in D
:
x_{ij}=z
\}.
$$

Interpretation:

> Keep only observations whose \(j\)-th variable equals \(z\).

Filtering corresponds to conditioning.

---

# Operation 3: Set (Intervention)

Define

$$
T_j(z,x).
$$

This modifies a risk profile by replacing variable \(j\) with value \(z\).

Formally,

$$
T_j(z,x)_k
=
\begin{cases}
z & k=j \\
x_k & k\neq j
\end{cases}.
$$

Interpretation:

> Force variable \(j\) to equal \(z\).

Unlike filtering, this changes the data.

---

# Operation 4: Exposure Averaging

Given a dataset and function,

$$
A_E(D,f)
=
\frac{
\sum_i e_i f(x_i)
}{
\sum_i e_i
}.
$$

This is the operational form.

Equivalent expectation notation:

$$
A_E(D,f)
=
E_E[f(X)].
$$

---

# Operation 5: Marginalization

Marginalization collapses dimensions.

For example,

$$
M_{-j}(r)(z)
=
E_E[r(X)\mid X_j=z].
$$

This constructs a lower-dimensional summary of a higher-dimensional risk surface.

---

# One-Way Relativities

A one-way relativity is a filtered exposure-weighted average.

## Probability Form

$$
r_j(z)
=
E_E[r(X)\mid X_j=z].
$$

## Discrete Form

$$
r_j(z)
=
\frac{
\sum_{i:x_{ij}=z}
e_i r(x_i)
}{
\sum_{i:x_{ij}=z}
e_i
}.
$$

## Integral Form

$$
r_j(z)
=
\frac{
\int r(x)\mathbf 1(x_j=z)\,dE(x)
}{
\int \mathbf 1(x_j=z)\,dE(x)
}.
$$

## Operator Form

$$
r_j(z)
=
A_E(F_j(z)(D),r).
$$

Interpretation:

> Average relativity among observations that naturally have value \(z\).

---

# Two-Way Relativities

## Probability Form

$$
r_{jk}(z,w)
=
E_E[r(X)\mid X_j=z,X_k=w].
$$

## Discrete Form

$$
r_{jk}(z,w)
=
\frac{
\sum_{i:x_{ij}=z,x_{ik}=w}
e_i r(x_i)
}{
\sum_{i:x_{ij}=z,x_{ik}=w}
e_i
}.
$$

## Operator Form

$$
r_{jk}(z,w)
=
A_E(
F_j(z)F_k(w)(D),
r
).
$$

These quantities are commonly visualized with heatmaps.

---

# PDP-Style Relativities

A PDP uses intervention rather than filtering.

## Probability Form

$$
p_j(z)
=
E_E[r(T_j(z,X))].
$$

## Discrete Form

$$
p_j(z)
=
\frac{
\sum_i e_i r(T_j(z,x_i))
}{
\sum_i e_i
}.
$$

## Integral Form

$$
p_j(z)
=
\frac{
\int r(T_j(z,x))\,dE(x)
}{
\int dE(x)
}.
$$

## Operator Form

$$
p_j(z)
=
A_E(D,r\circ T_j(z)).
$$

Interpretation:

> What would average risk be if every policy had value \(z\)?

---

# ICE Curves

For observation \(i\),

$$
p_{ij}(z)
=
r(T_j(z,x_i)).
$$

Interpretation:

> Hold all variables fixed except \(j\), vary \(j\), and evaluate the model.

No averaging occurs.

---

# Raw Data Versus Modeled Data

A critical distinction is whether calculations use observed outcomes or modeled predictions.

## Using Raw Data

Suppose observed loss rate is

$$
u_i.
$$

Then one-way observed risk can be calculated as

$$
\frac{
\sum_{i:x_{ij}=z}
e_i u_i
}{
\sum_{i:x_{ij}=z}
e_i
}.
$$

This measures actual historical experience.

Advantages:

- Directly reflects observed outcomes.
- No model assumptions.

Disadvantages:

- High variance.
- Sparse cells can be unstable.

---

## Using Modeled Data

Replace observed loss rate with

$$
\hat u(x_i).
$$

Then

$$
\frac{
\sum_{i:x_{ij}=z}
e_i \hat u(x_i)
}{
\sum_{i:x_{ij}=z}
e_i
}.
$$

This produces modeled relativities.

Advantages:

- Stable.
- Uses 


Yes, it looks like the markdown got truncated during transmission. The sentence:

This produces modeled relativities.

Advantages:

Stable.
Uses

is obviously incomplete.

A downloadable artifact would avoid this class of problem because:

The markdown wouldn't be re-rendered by chat.
Large equations and tables wouldn't be truncated.
You could version it as the notation evolves.

Given how much we've developed here, I actually think we're beyond a chat transcript and into a small technical note. The document could probably be improved further before freezing it:

Clarify the relationship between AEA_E, EEE_E, and M−jM_{-j}.
Better separate raw-data relativities and modeled relativities.
Define the exposure measure EE more carefully.
Add a section on commuting/non-commuting operators FF and TT.
Add examples for:
one-way relativity,
PDP,
ICE,
two-way heatmap.
Tighten the notation around DD, XX, xx, and xix_i.

One thing I would probably change before formalizing the notation is the statement:

M_{-j}(r)(z)
=

E_E[r(X) | X_j = z]

because that isn't really a marginalization operator. It's a conditional expectation operator. Marginalization and conditioning are closely related but distinct. If we're going to build an algebra of operators, I'd want to clean that up first.

My recommendation is to treat the current markdown as a draft and produce a polished v1 document rather than preserving the current state exactly. The ideas are good; the notation is almost there, but I think we can make it substantially more internally consistent before freezing it into a PDF, markdown artifact, or note.


