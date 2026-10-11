# Relativities as Expectations, Filters, and Interventions

## Basic Definitions

Let:

- $x \in \mathcal X$ denote an arbitrary point in model space.
- $\hat u(x)$ denote the modeled loss rate (or pure premium).
- $e_i$ denote the exposure associated with observation $i$.
- $x_i$ denote the covariate vector for observation $i$.

The portfolio average risk is

$$
R_b
=
\frac{\sum_i e_i \hat u(x_i)}
     {\sum_i e_i}.
$$

This is an exposure-weighted average over the actual portfolio.

Equivalently,

$$
R_b = E_E[\hat u(X)],
$$

where $E_E$ denotes expectation under the portfolio exposure distribution.

---

## Overall Relativity

Define the overall model relativity as

$$
r(x)
=
\frac{\hat u(x)}
     {R_b}.
$$

This normalization implies

$$
E_E[r(X)] = 1.
$$

The function $r(x)$ is the fundamental object. Everything else is a projection, slice, or transformation of this function.

---

## Distribution of Relativities

For each observation,

$$
r_i
=
r(x_i)
=
\frac{\hat u(x_i)}
     {R_b}.
$$

A useful summary is the exposure-weighted distribution of $r_i$.

Formally,

$$
P(r(X) \le t)
=
\frac{
\sum_i e_i I(r_i \le t)
}{
\sum_i e_i
}.
$$

Interpretation:

> Draw a random unit of exposure from the portfolio. What relativity does it belong to?

This summarizes the degree of segmentation in the model.

---

# Notation Challenges

We identified three distinct concepts that are often conflated:

1. A point in model space.
2. An observed portfolio record.
3. A modified ("counterfactual") record.

Using the same notation for all three creates confusion.

---

## Portfolio Observations

Use

$$
x_i=(x_{i1},\dots,x_{ip})
$$

for the $i$-th observation.

Use

$$
x_{ij}
$$

for the value of variable $j$ in observation $i$.

---

# Two Fundamental Operations

We introduced explicit operators.

## Filtering

Define

$$
F_j(z)
$$

as:

> Keep only records whose $j$-th variable equals $z$.

Applied to a portfolio $D$,

$$
F_j(z)(D)
=
\{x_i \in D : x_{ij}=z\}.
$$

This corresponds to what statisticians would call conditioning.

---

## Setting (Intervention)

Define

$$
T_j(z,x)
$$

as:

> Replace the $j$-th variable of $x$ with $z$.

Formally,

$$
T_j(z,x)_k
=
\begin{cases}
z, & k=j \\
x_k, & k\neq j.
\end{cases}
$$

Unlike filtering, this modifies data rather than selecting data.

---

# One-Way Relativities

A one-way relativity is an exposure-weighted conditional expectation.

For variable $j$,

$$
r_j(z)
=
E_E[r(X)\mid X_j=z].
$$

In discrete form,

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

Interpretation:

> Average overall relativity among policies that actually have $x_j=z$.

Using the filter notation,

$$
r_j(z)
=
\operatorname{Avg}_E
\Big(
r(x),
x \in F_j(z)(D)
\Big).
$$

The filter notation closely mirrors how the quantity is computed in code.

---

# Two-Way Relativities

A heatmap of variables $j$ and $k$ is not a collection of one-way relativities.

Instead,

$$
r_{jk}(z,w)
=
E_E[r(X)\mid X_j=z,\;X_k=w].
$$

This is a two-way relativity surface.

A heatmap visualizes this function.

---

# PDP-Style Relativities

The PDP-style quantity uses intervention instead of filtering.

Define

$$
p_j(z)
=
E_E[r(T_j(z,X))].
$$

Interpretation:

> Force every policy to have $X_j=z$, score the model, then average.

This differs fundamentally from

$$
r_j(z)
=
E_E[r(X)\mid X_j=z].
$$

The first asks:

> What happens if everyone has value $z$?

The second asks:

> What is the risk among policies that already have value $z$?

---

# ICE Curves

For observation $i$,

$$
p_{ij}(z)
=
r(T_j(z,x_i)).
$$

Interpretation:

> Hold all other variables fixed for observation $i$, vary variable $j$, and evaluate the model.

This is an Individual Conditional Expectation (ICE) curve.

---

# Relationship Among the Main Objects

The hierarchy becomes:

### Overall Relativity

$$
r(x)
=
\frac{\hat u(x)}
     {R_b}.
$$

### One-Way Relativity

$$
r_j(z)
=
E_E[r(X)\mid X_j=z].
$$

### Two-Way Relativity

$$
r_{jk}(z,w)
=
E_E[r(X)\mid X_j=z,\;X_k=w].
$$

### PDP

$$
p_j(z)
=
E_E[r(T_j(z,X))].
$$

### ICE

$$
p_{ij}(z)
=
r(T_j(z,x_i)).
$$

Viewed this way:

- The overall relativity $r(x)$ is the fundamental object.
- One-way and two-way relativities are conditional expectations (filtering).
- PDPs are interventional expectations (setting).
- ICE curves are individual interventional evaluations.

---

# Why Explicit Filter and Set Operators Help

Traditional notation hides the distinction between:

- Restricting the population.
- Modifying the population.

The operators make the distinction explicit.

Filtering:

$$
F_j(z)
$$

means

> Keep records where $x_j=z$.

Setting:

$$
T_j(z)
$$

means

> Force records to have $x_j=z$.

These are fundamentally different operations and often produce different answers.

---

# Order of Operations

Having explicit operators also lets us reason about compositions.

### Filter Then Set

$$
T_k(w)\,F_j(z)(D)
$$

means:

1. Keep records with $x_j=z$.
2. Change variable $k$ to $w$.

Interpretation:

> Among policies having $x_j=z$, what would happen if $x_k$ were changed to $w$?

---

### Set Then Filter

$$
F_j(z)\,T_k(w)(D)
$$

means:

1. Change variable $k$ to $w$.
2. Keep records with $x_j=z$.

If $j\neq k$, these often commute.

If $j=k$, they generally do not.

For example,

$$
F_j(z)\,T_j(w)
$$

and

$$
T_j(w)\,F_j(z)
$$

represent completely different operations.

---

# Key Insight

The entire framework can be organized around three primitive ideas:

1. **Evaluate**

   $$
   r(x)
   $$

2. **Filter**

   $$
   F_j(z)
   $$

3. **Set**

   $$
   T_j(z)
   $$

From these three operations, one can define:

- exposure-weighted portfolio risk,
- one-way relativities,
- two-way relativities,
- PDPs,
- ICE curves,
- higher-dimensional relativity surfaces,

all as different summaries or transformations of the same underlying relativity function $r(x)$.