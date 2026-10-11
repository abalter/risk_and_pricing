# An Operator Notation for Relativities (Draft)

Exploratory note. The aim is a small notation in which

- one-way, two-way, partial-dependence (PDP), ICE, and related quantities are written with the same few symbols, and
- each expression reads directly as a computation (filter rows, overwrite a column, score, take a weighted mean).

The notation is self-contained here and is not yet aligned with the guide.

---

## 1. Objects

Keeping the types of object separate is what makes the notation work.

| Kind | Symbol | What it is | In code |
|---|---|---|---|
| Record | $i$ | Covariates $x_i = (x_{i1},\dots,x_{ip})$ plus **attached columns**: exposure $e_i$, and optionally claim count $n_i$ and observed loss $\ell_i$ | a row |
| Dataset | $D$ | A finite collection of records | a tibble |
| Function | $f$ | A number for each record. Either a **model function** of the covariates only ($\hat u(x)$, $r(x)$), or built from attached columns ($y_i = \ell_i/e_i$) | `predict()` or a column |
| Weight | $\omega$ | A nonnegative attached column used for averaging: $e$ (the usual case), $n$, ... | a column |

The split between covariates and attached columns matters:

- $F$ acts on whole rows, so it removes covariates and attached columns together.
- $T$ rewrites covariates only. Attached columns ride along unchanged.
- Model functions are re-evaluated on rewritten covariates. Attached columns are not.

Conventions:

- $x$ (no subscript) is an arbitrary point in feature space $\mathcal X$; the model $\hat u$ is defined on all of $\mathcal X$.
- $x_i$ is the $i$-th record; $x_{ij}$ is the value of variable $j$ on record $i$.
- $X_j$ is used only inside predicates, e.g. "$X_j = z$" means "variable $j$ equals $z$".
- $z, w$ are values (levels) of a single variable.
- A single record can be treated as a one-record dataset $\{i\}$.

---

## 2. The Four Primitives

Two operators map datasets to datasets (filter, set), one maps a dataset to a number (aggregate), and evaluation is plain function application.

### 2.1 Evaluate

$$
f(x)
$$

Apply a function to a record. No averaging. In code: `predict(model, newdata = row, type = "response")`.

### 2.2 Filter: $F$ (dataset $\to$ smaller dataset)

For a set of levels $B$,

$$
F_j(B)\,D = \{\, i \in D : x_{ij} \in B \,\},
\qquad F_j(z) := F_j(\{z\}).
$$

More generally, $F[\phi]\,D$ keeps records satisfying any predicate $\phi$.

Filtered rows take their attached columns with them. So after $F$, every later sum or average runs over the **filtered exposure**, in both numerator and denominator. To make that explicit, filtering is the same as zeroing the weights of the dropped rows (§5.5):

$$
\Sigma_\omega(y)\, F[\phi]\,D = \Sigma_\omega(\mathbf 1_\phi\, y)\, D .
$$

For continuous variables, an exact-value filter $F_j(z)$ has almost no exposure, so one-ways use bins: $F_j(B_k)$.

In code: `filter(D, j %in% B)`.

### 2.3 Set: $T$ (dataset $\to$ same-size, modified dataset)

$$
T_j(z)\,D = \{\, (T_j(z)\,x_i,\; e_i,\; n_i,\; \ell_i) : i \in D \,\},
\qquad
\big(T_j(z)\,x\big)_k =
\begin{cases}
z & k = j\\
x_k & k \neq j.
\end{cases}
$$

Every record has variable $j$ overwritten with $z$. Nothing else changes: the other covariates stay the same, and so do the attached columns $e_i$, $n_i$ and $\ell_i$. $T$ keeps every row, so the weights don't change.

Unlike $F$, $T$ has no trouble with continuous variables. $T_j(z)$ works at any grid point $z$, so no binning is needed.

In code: `mutate(D, j = z)`.

### 2.4 Aggregate: $\Sigma_\omega(\cdot)$ and $\langle\cdot\rangle_\omega$ (dataset $\to$ number)

The **weighted total** of $y$ over a dataset:

$$
\Sigma_\omega(y)\, D = \sum_{i \in D} \omega_i\, y_i ,
\qquad
\Sigma(y)\, D := \Sigma_1(y)\, D = \sum_{i \in D} y_i .
$$

So $\Sigma_\omega(1)\,D$ is the total weight, e.g. $\Sigma_e(1)\,D = \Sigma(e)\,D$ is total exposure.

The **weighted average** of $f$ is the ratio of two totals over the *same* rows:

$$
\langle f \rangle_\omega\, D
= \frac{\Sigma_\omega(f)\, D}{\Sigma_\omega(1)\, D}
= \frac{\sum_{i \in D} \omega_i\, f_i}{\sum_{i \in D} \omega_i}.
$$

The subscript names the weight, and the dataset sits to the right like any other operand. The weight is always written, even when it is $e$. The average is undefined if the total weight is zero.

In code: `tot(D, w)` and `avg(D, f, w)` (§9).

### Reading an expression

Everything is a chain of operators applied to $D$, read right to left like function composition:

$$
\langle r \rangle_e\, T_k(w)\, F_j(z)\, D
$$

reads as: start with $D$, keep $X_j = z$, set $X_k = w$, score with $r$, and take the exposure-weighted mean over the rows that remain. With R's pipe, the code follows the same steps, left to right: `D |> F_j(j, z) |> T_j(k, w) |> avg(r, exposure)`.

### 2.5 Function Form

The operators describe what happens to the *data*. An equivalent notation describes what happens to the *argument* of the function:

| | Conditioning (filter) | Setting (intervene) |
|---|---|---|
| Function form | $f(x \mid x_j = z)$ | $f(x \,;\, x_j \leftarrow z)$ |
| Reads as | $f$ at $x$, **given that** $x_j = z$ | $f$ at $x$, **with** $x_j$ assigned $z$ |
| Operator form | $\langle f\rangle_\omega\, F_j(z)\, D$ | $\langle f\rangle_\omega\, T_j(z)\, D$ |

The two forms are connected by the identities in §5.5:

$$
\langle f(x \mid x_j = z) \rangle_\omega\, D = \langle f \rangle_\omega\, F_j(z)\, D,
\qquad
\langle f(x \,;\, x_j \leftarrow z) \rangle_\omega\, D = \langle f \rangle_\omega\, T_j(z)\, D .
$$

The function form is easier to read; the operator form is closer to the code.

Two cues separate the cases, so each is readable even if the other is missed:

- **Separator:**
  - $\mid$ is "given that". It applies only to records where the statement is true.
  - $;$ adds information about the same argument. It avoids $:$, which in set-builder notation $\{x : \dots\}$ means "such that" and would read as a filter.
- **Relation:**
  - $=$ is a test.
  - $\leftarrow$ is an assignment, and it assigns to the variable $x_j$, not to the index $j$.

**Combining, and the ordering rule.** Assignments and conditions can appear together, as in $f(x \,;\, x_j \leftarrow z \mid x_k = w)$. The rule is:

> **Conditions refer to the original record, before any assignment.**

In operator form, every $F$ is applied first (rightmost) and every $T$ after. For different variables the order doesn't matter anyway (§5.3). For the same variable, the rule is what makes the expression unambiguous. Filtering after setting the same variable is trivial (§5.4), so the rule loses nothing.

| Quantity | Function form | Operator form |
|---|---|---|
| One-way | $\langle r(x \mid x_j = z)\rangle_e\, D$ | $\langle r\rangle_e\, F_j(z)\, D$ |
| PDP | $\langle r(x \,;\, x_j \leftarrow z)\rangle_e\, D$ | $\langle r\rangle_e\, T_j(z)\, D$ |
| ICE | $r(x_i \,;\, x_j \leftarrow z)$ | $r\big(T_j(z)\, x_i\big)$ |
| Two-way | $\langle r(x \mid x_j = z, x_k = w)\rangle_e\, D$ | $\langle r\rangle_e\, F_j(z) F_k(w)\, D$ |
| Two-way PDP | $\langle r(x \,;\, x_j \leftarrow z, x_k \leftarrow w)\rangle_e\, D$ | $\langle r\rangle_e\, T_j(z) T_k(w)\, D$ |
| Stratified PDP | $\langle r(x \,;\, x_j \leftarrow z \mid x_k = w)\rangle_e\, D$ | $\langle r\rangle_e\, T_j(z) F_k(w)\, D$ |
| ALE step (§6.2) | $\langle r(x \,;\, x_j \leftarrow z_{k-1} \mid x_j = z_k)\rangle_e\, D$ | $\langle r\rangle_e\, T_j(z_{k-1}) F_j(z_k)\, D$ |

The function form reaches its limit with the restricted PDP (§7.2). There, the admissibility condition applies to the *modified* record, which breaks the ordering rule, so that case is written in operator form only.

---

## 3. The Base Objects

Fix a reference portfolio $D$.

**Portfolio average modeled risk**

$$
R_b = \langle \hat u \rangle_e\, D .
$$

**Relativity surface**

$$
r(x) = \frac{\hat u(x)}{R_b},
\qquad\text{so}\qquad
\langle r \rangle_e\, D = 1 .
$$

Note that $r$ depends on $D$ through $R_b$. If the reference portfolio changes, all relativities are rescaled by a single constant, but their shapes don't change.

**Distribution of relativities.** The exposure-weighted CDF is itself just an average:

$$
G(t) = \langle \mathbf 1\{r \le t\} \rangle_e\, D .
$$

**Exposure mix of variable $j$.** This is the marginal distribution of $X_j$:

$$
\pi_j(z) = \frac{\Sigma_e(1)\, F_j(z)\,D}{\Sigma_e(1)\, D} .
$$

The same construction with another weight gives other mixes, e.g. a claim-count mix $\Sigma_n(1)\, F_j(z)D \,/\, \Sigma_n(1)\, D$.

---

## 4. The Catalogue

The core payoff: the one-way and the PDP differ by **one letter**.

| Quantity | Operator form | Question it answers |
|---|---|---|
| One-way (conditional) | $r_j(z) = \langle r \rangle_e\, F_j(z)\,D$ | Average relativity of policies that *have* $X_j = z$ |
| PDP (partial / marginal) | $p_j(z) = \langle r \rangle_e\, T_j(z)\,D$ | Average relativity if *every* policy had $X_j = z$ |
| ICE | $p_{ij}(z) = r\big(T_j(z)\,x_i\big)$ | Relativity of policy $i$ if its $X_j$ were $z$ |
| Two-way (conditional) | $r_{jk}(z,w) = \langle r \rangle_e\, F_j(z)F_k(w)\,D$ | Heatmap of actual cells |
| Two-way PDP | $p_{jk}(z,w) = \langle r \rangle_e\, T_j(z)T_k(w)\,D$ | Heatmap if everyone were in cell $(z,w)$ |
| Stratified PDP | $\langle r \rangle_e\, T_j(z)\,F_k(w)\,D$ | PDP for $j$ computed within segment $X_k = w$ |
| Restricted PDP | $\langle r \rangle_e\, F_{\mathcal A}\,T_j(z)\,D$ | PDP using only admissible counterfactuals (§7) |
| Observed loss rate (one-way) | $\langle y \rangle_e\, F_j(z)\,D = \dfrac{\Sigma(\ell)\, F_j(z)D}{\Sigma(e)\, F_j(z)D}$ | Actual pure premium in level $z$ |
| Observed frequency (one-way) | $\langle \nu \rangle_e\, F_j(z)\,D = \dfrac{\Sigma(n)\, F_j(z)D}{\Sigma(e)\, F_j(z)D}$ | Actual claim frequency, $\nu_i = n_i/e_i$ |
| Observed severity (one-way) | $\langle s \rangle_n\, F_j(z)\,D = \dfrac{\Sigma(\ell)\, F_j(z)D}{\Sigma(n)\, F_j(z)D}$ | Actual severity, $s_i = \ell_i/n_i$, **claim-weighted** |
| ALE-style local effect | see §6 | Effect of moving $X_j$ between adjacent levels, among policies near those levels |

The weight subscript earns its place in the observed rows. Frequency and pure premium are exposure-weighted, while severity is claim-weighted. In each case the weighted average reduces to a ratio of totals, which is how these quantities are normally computed.

The usual probability notation is a translation of these:

$$
\langle r \rangle_e\, F_j(z)D = E_e[\,r(X)\mid X_j = z\,],
\qquad
\langle r \rangle_e\, T_j(z)D = E_e[\,r(X_{-j}, z)\,] = E_e\big[\,r(X)\mid \mathrm{do}(X_j = z)\,\big].
$$

**Observed data under $T$.** Because $T$ leaves attached columns alone and $y_i = \ell_i/e_i$ is built only from attached columns,

$$
\langle y \rangle_e\, T_j(z)\,D = \langle y \rangle_e\, D \qquad\text{for every } z .
$$

The "PDP of raw experience" is a flat line. That is the right answer, not a defect: observed outcomes can't respond to a counterfactual change in covariates. Only a model function can. Filtering gives different answers on data and on the model, but setting only gives a non-trivial answer on the model. This is the precise sense in which the model adds something over a one-way of raw experience.

---

## 5. Algebra

These rules let you simplify or compare expressions without going back to sums.

### 5.1 Filters

$$
F_j(A)\,F_j(B) = F_j(A \cap B),
\qquad
F_j(A)\,F_k(B) = F_k(B)\,F_j(A).
$$

### 5.2 Sets

$$
T_j(z)\,T_j(w) = T_j(z) \quad\text{(last write wins)},
\qquad
T_j(z)\,T_k(w) = T_k(w)\,T_j(z) \quad (j \ne k).
$$

### 5.3 Filter and Set on Different Variables Commute

$$
F_k(B)\,T_j(z) = T_j(z)\,F_k(B) \qquad (j \neq k).
$$

So the stratified PDP is unambiguous.

### 5.4 Filter and Set on the Same Variable Don't Commute

$$
F_j(B)\,T_j(z)\,D =
\begin{cases}
T_j(z)\,D & z \in B\\
\varnothing & z \notin B
\end{cases}
$$

This is uninteresting: setting first and then filtering on the same variable either keeps everything or nothing.

$$
T_j(z)\,F_j(B)\,D
$$

This one is interesting. It reads: among policies that actually have $X_j \in B$, what if $X_j$ were $z$? This is the building block of ALE (§6). Also note $T_j(z)\,F_j(z) = F_j(z)$.

### 5.5 Pushing Operators Into the Function or the Weight

**Set moves into the function.** Averaging over a set dataset is the same as averaging a composed function over the original:

$$
\langle f \rangle_\omega\, T\,D = \langle f \circ T \rangle_\omega\, D .
$$

This relies on $T$ leaving the weights alone (§2.3). For an attached-column function like $y$, $y \circ T = y$, which is the flat-PDP result in §4.

**Filter moves into the weight.** Averaging over a filtered dataset is averaging with the dropped rows' weights set to zero:

$$
\langle f \rangle_\omega\, F[\phi]\,D = \langle f \rangle_{\omega \mathbf 1_\phi}\, D
= \frac{\Sigma_\omega(\mathbf 1_\phi f)\, D}{\Sigma_\omega(\mathbf 1_\phi)\, D}.
$$

This is the fully explicit form of "the average is over the filtered exposure". These two identities connect the operator form to the sum and integral forms in the earlier drafts, so there's no need to carry all three forms for every quantity.

### 5.6 Linearity

$$
\langle a f + b g \rangle_\omega\, D = a\langle f\rangle_\omega\, D + b\langle g\rangle_\omega\, D .
$$

### 5.7 Tower Property (Re-assembling a Filtered Average)

$$
\langle f \rangle_\omega\, D = \sum_z \pi_j(z)\, \langle f \rangle_\omega\, F_j(z)\,D,
\qquad \pi_j(z) = \frac{\Sigma_\omega(1)\, F_j(z)D}{\Sigma_\omega(1)\, D}.
$$

The mix $\pi_j$ must use the same weight as the average. For example, severity one-ways re-assemble under the claim-count mix, not the exposure mix.

**In words:** cut the book into pieces by the level of $X_j$ and average $f$ within each piece. If you then average those piece-level averages, weighting each by its exposure share, you get back the average over the whole book. This is the identity behind "the total is the mix-weighted average of the segments."

**Why it holds.** The filters $F_j(z)$, taken over all levels $z$, *partition* $D$: every record lands in exactly one piece. Splitting the sum by level and multiplying and dividing by each piece's exposure gives:

$$
\langle f \rangle_\omega\, D
= \frac{\sum_z \Sigma_\omega(f)\, F_j(z)D}{\Sigma_\omega(1)\, D}
= \sum_z \underbrace{\frac{\Sigma_\omega(1)\, F_j(z)D}{\Sigma_\omega(1)\, D}}_{\pi_j(z)}
\;\underbrace{\frac{\Sigma_\omega(f)\, F_j(z)D}{\Sigma_\omega(1)\, F_j(z)D}}_{\langle f\rangle_\omega\, F_j(z)D} .
$$

**Small example.** Suppose level A has 60% of exposure with an average relativity of 0.8, and level B has 40% with an average of 1.3. Then $0.6 \times 0.8 + 0.4 \times 1.3 = 1.00$, which is the portfolio average.

**Name.** In probability notation this is the law of iterated expectations, $E[f] = E\big[E[f \mid X_j]\big]$. The inner expectation is the filtered average and the outer one is the mix-weighted sum.

**Generalizations.** Any partition works, not just the levels of one variable:

- bins $F_j(B_k)$ of a continuous variable;
- two-way cells $F_j(z)F_k(w)$, weighted by their joint exposure share;
- any set of disjoint predicates that together cover the book.

**Consequence for one-ways.** One-way relativities always average back to 1 under the exposure mix,

$$
\sum_z \pi_j(z)\, r_j(z) = \langle r \rangle_e\, D = 1 .
$$

So a set of one-ways is automatically balanced to the portfolio. If a one-way table doesn't reconcile this way, the exposure or the base $R_b$ is inconsistent.

**Why PDPs don't satisfy it.** The datasets $T_j(z)D$ are not pieces of $D$. Each one is the *whole* book with $X_j$ overwritten, so they don't partition anything, and the argument above doesn't apply. What the mix-weighted sum of PDP values actually computes is

$$
\sum_z \pi_j(z)\, p_j(z) = \sum_z \pi_j(z)\, \langle r \rangle_e\, T_j(z)D,
$$

which is the average relativity of a "shuffled" book. In that book, each policy's $X_j$ is redrawn at random from the mix $\pi_j$, independently of the rest of its profile. This equals 1 only when that shuffling doesn't change the average, i.e. when $X_j$ is independent of the other variables, or the model is additive in $X_j$ on the response scale. For a multiplicative model, the sum is $\langle g_j\rangle_e D\,\langle g_{-j}\rangle_e D \,/\, \langle g_j g_{-j}\rangle_e D$ (see §6.1), so it equals 1 only when $g_j$ and $g_{-j}$ are uncorrelated under the exposure mix.

How far this sum is from 1 is therefore a quick, checkable measure of how much $X_j$ is entangled with the rest of the book.

---

## 6. Worked Uses of the Algebra

### 6.1 Why the One-Way Differs From the GLM Factor

Take a multiplicative model $\hat u(x) = \prod_k g_k(x_k)$, and write $g_{-j}(x) = \prod_{k \ne j} g_k(x_k)$. Then

$$
p_j(z) = \langle r \rangle_e\, T_j(z)D
= \frac{g_j(z)\,\langle g_{-j} \rangle_e\, D}{R_b}
\;\propto\; g_j(z),
$$

$$
r_j(z) = \langle r \rangle_e\, F_j(z)D
= \frac{g_j(z)\,\langle g_{-j} \rangle_e\, F_j(z)D}{R_b}.
$$

So for a multiplicative model:

- the **PDP recovers the fitted factor** up to a constant;
- the **one-way** is the fitted factor times $\langle g_{-j}\rangle_e\, F_j(z)D$, which is the average of the *other* factors among policies at level $z$.

The ratio

$$
\frac{r_j(z)}{p_j(z)} = \frac{\langle g_{-j} \rangle_e\, F_j(z)D}{\langle g_{-j} \rangle_e\, D}
$$

is exactly the "distributional bias" or mix effect: how the rest of the risk profile differs at level $z$ compared with the whole book. The two-line derivation is a good test of whether the notation is pulling its weight.

### 6.2 ALE-Style Local Effects (Ordered Variable)

Suppose variable $j$ has ordered levels $z_1 < \dots < z_K$. The local effect of stepping from $z_{k-1}$ to $z_k$, measured only on policies that actually sit at $z_k$, is:

$$
\delta_j(k) =
\langle r \rangle_e\, T_j(z_k)\,F_j(z_k)\,D
-
\langle r \rangle_e\, T_j(z_{k-1})\,F_j(z_k)\,D
=
\big\langle\, r\circ T_j(z_k) - r \circ T_j(z_{k-1}) \,\big\rangle_e\, F_j(z_k)\,D.
$$

Accumulate to get the curve: $a_j(z_k) = \sum_{m \le k} \delta_j(m)$. On a multiplicative scale, use $\log r$ in place of $r$.

ALE combines all three dataset-level ideas: filter (to stay on realistic data), set (to make the counterfactual move), and difference-then-average.

### 6.3 Marginal Effects for One Policy

The ICE difference is

$$
\Delta_{ij}(z \to z') = r\big(T_j(z')\,x_i\big) - r\big(T_j(z)\,x_i\big),
$$

and its portfolio average is $\langle r\circ T_j(z') - r \circ T_j(z)\rangle_e\, D = p_j(z') - p_j(z)$, by linearity.

---

## 7. Admissible Counterfactuals

$F$ can only remove rows, so it can never produce a profile that wasn't already in the data. $T$ can. It may create rows the model shouldn't be asked about. Describe the acceptable rows as a set $\mathcal A \subseteq \mathcal X$ of **admissible profiles**, and write

$$
F_{\mathcal A} := F[\,x \in \mathcal A\,]
$$

for the filter that keeps only admissible rows. Assume the data itself is admissible, $F_{\mathcal A} D = D$.

### 7.1 Three Kinds of Restriction

$\mathcal A$ is the intersection of three sets, one per kind of violation:

$$
\mathcal A = \mathcal A_{\text{vocab}} \cap \mathcal A_{\text{joint}} \cap \mathcal A_{\text{hier}} .
$$

**(i) Model vocabulary.** For example, a breed the model has never seen. Let $\mathcal Z_j$ be the levels (or range) of variable $j$ the model was fitted on. Then

$$
\mathcal A_{\text{vocab}} = \mathcal Z_1 \times \cdots \times \mathcal Z_p .
$$

This can be checked one variable at a time. Outside it, the model either errors or silently falls back, e.g. to a base or "other" level. That fallback is a modeling choice and should be explicit: a map $m_j$ from raw values into $\mathcal Z_j$, applied before evaluation.

**(ii) Joint plausibility.** For example, a 100-year-old cat, or a pregnant male dog. Each value is individually in vocabulary, but the combination is impossible or implausible. Write it as a set of constraints across variables:

$$
\mathcal A_{\text{joint}} = \{\, x : c_1(x), \dots, c_M(x) \text{ all hold} \,\},
$$

e.g. $c_1(x) = [\,x_{\text{age}} \le a_{\max}(x_{\text{species}})\,]$ and $c_2(x) = \neg[\,x_{\text{sex}} = \text{M} \wedge x_{\text{pregnant}}\,]$.

This is where the curse of dimensionality bites. As $p$ grows, most of the product space $\mathcal A_{\text{vocab}}$ is empty of data, so $T$ easily lands somewhere the model has never seen anything nearby. Hard constraints like those above define $\mathcal A_{\text{joint}}$. A softer version is a profile that is plausible but has no nearby exposure (an 18-year-old Great Dane); see §11.

**(iii) Hierarchy.** For example, a cat with breed = Labrador Retriever. If breed is nested within species through a map $h(\text{breed}) = \text{species}$,

$$
\mathcal A_{\text{hier}} = \{\, x : x_{\text{species}} = h(x_{\text{breed}}) \,\}.
$$

### 7.2 Restricting by Filtering

The **restricted PDP** sets, then drops inadmissible rows:

$$
\tilde p_j(z) = \langle r \rangle_e\, F_{\mathcal A}\, T_j(z)\, D .
$$

An equivalent reading is "keep only the policies for which the move is admissible, then set those":

$$
F_{\mathcal A}\, T_j(z)\, D = T_j(z)\, F[\,T_j(z)\,x \in \mathcal A\,]\, D .
$$

The cost is that the retained population now depends on $z$. So $\tilde p_j$ is partly a conditional quantity again: comparing $\tilde p_j(z)$ across $z$ mixes the effect of $z$ with changes in who was retained. Always report the **retained share** alongside it:

$$
\rho_j(z) = \frac{\Sigma_e(1)\, F_{\mathcal A}\, T_j(z)\, D}{\Sigma_e(1)\, D}.
$$

If $\rho_j \equiv 1$, nothing was dropped and $\tilde p_j = p_j$. A small $\rho_j(z)$ means the PDP value at $z$ rests on little exposure.

The same idea applies to the other quantities:

- **ICE:** the curve for policy $i$ is simply defined only on $\{z : T_j(z)\,x_i \in \mathcal A\}$.
- **ALE:** local moves $T_j(z_{k-1})\,F_j(z_k)$ mostly stay inside $\mathcal A$, which is the reason ALE exists. $F_{\mathcal A}$ can still be applied as a safeguard.

### 7.3 Hierarchies: Set the Whole Branch

Hierarchy violations can be *avoided* rather than filtered, because the child level determines the parent. Define a hierarchical set that moves both:

$$
T^{h}_{\text{breed}}(b) = T_{\text{species}}\big(h(b)\big)\; T_{\text{breed}}(b).
$$

The two sets act on different variables, so they commute (§5.2), and the result always lies in $\mathcal A_{\text{hier}}$.

The reverse doesn't work: setting species doesn't determine breed. A PDP over species needs a rule for what happens to breed, for example:

- move to a species-level "unknown breed" level, or
- redraw breed from its within-species mix.

That is a choice, not something the notation decides (§11).

---

## 8. Re-basing

Displayed relativities are often re-based. Re-basing is a final scalar step applied to a curve, not a new operator. For any curve $s(z)$ (one-way, PDP, etc.):

- **To a base level:** $s(z)/s(z_0)$.
- **To the exposure mix:** $s(z) / \sum_w \pi_j(w)\,s(w)$.

By §5.7, a one-way is already mix-balanced. A PDP is not.

---

## 9. Translation to Code

Assume `D` is a tibble with feature columns and attached columns `exposure`, `claims`, `loss`. A function `f(D)` returns one number per row, e.g. `r <- \(D) predict(model, newdata = D, type = "response") / R_b`.

The helpers are named `F_j` / `T_j` rather than `F` / `T` because `F` and `T` are aliases for `FALSE` and `TRUE` in base R.

```r
library(tidyverse)

F_j <- function(D, var, levels) {                # filter
  filter(D, {{ var }} %in% levels)
}

T_j <- function(D, var, z) {                     # set; attached columns untouched
  # keep factor levels so predict() still recognizes the column
  mutate(D, {{ var }} := if (is.factor({{ var }})) factor(z, levels = levels({{ var }})) else z)
}

tot <- function(D, y = exposure) {               # Sigma(y) D
  sum(pull(D, {{ y }}))
}

avg <- function(D, f, w = exposure) {            # <f>_w D
  weighted.mean(f(D), pull(D, {{ w }}))
}

F_adm <- function(D) filter(D, admissible(D))    # F_A; admissible() returns a logical per row

age_levels <- levels(D$age)

curves <- tibble(z = age_levels) |>
  mutate(
    mix          = map_dbl(z, \(z) tot(F_j(D, age, z)) / tot(D)),
    one_way      = map_dbl(z, \(z) D |> F_j(age, z) |> avg(r)),
    pdp          = map_dbl(z, \(z) D |> T_j(age, z) |> avg(r)),
    strat_pdp    = map_dbl(z, \(z) D |> F_j(region, w) |> T_j(age, z) |> avg(r)),
    restr_pdp    = map_dbl(z, \(z) D |> T_j(age, z) |> F_adm() |> avg(r)),
    retained     = map_dbl(z, \(z) tot(F_adm(T_j(D, age, z))) / tot(D)),
    ice_i        = map_dbl(z, \(z) D |> slice(i) |> T_j(age, z) |> r()),
    obs_pp       = map_dbl(z, \(z) { Dz <- F_j(D, age, z); tot(Dz, loss) / tot(Dz, exposure) }),
    obs_freq     = map_dbl(z, \(z) { Dz <- F_j(D, age, z); tot(Dz, claims) / tot(Dz, exposure) }),
    obs_sev      = map_dbl(z, \(z) { Dz <- F_j(D, age, z); tot(Dz, loss) / tot(Dz, claims) })
  )

T_breed <- function(D, b) D |> T_j(breed, b) |> T_j(species, species_of[[b]])   # T^h (§7.3)
```

Each pipeline is the corresponding entry from §4 or §7. The math is written right to left (like function composition) and the pipe left to right, so the operators appear in reverse order, but both describe the same sequence of steps.

The observed quantities are computed as ratios of totals, $\Sigma(\ell) / \Sigma(e)$ and so on, rather than as `avg()` of a per-row ratio. This is the same quantity (§4), and it avoids `0/0` on rows with no claims.

With this setup, the §5.7 identities become one-line checks: `sum(curves$mix * curves$one_way)` should be 1, while `sum(curves$mix * curves$pdp)` generally won't be.

---

## 10. Changes From the Earlier Drafts

- **Types made explicit.** In the earlier drafts, $F_j(z)$ acted on datasets but $T_j(z,x)$ acted on points, and later $T_j(z)$ was applied to datasets without being defined there. Here both $F$ and $T$ are dataset $\to$ dataset, and $T$ on a point is the one-record special case.
- **$E_E$ / $A_E$ / measure $E$ replaced by $\Sigma_\omega(\cdot)$ and $\langle\cdot\rangle_\omega$.** The earlier drafts used $E$ for both the exposure measure and the expectation. Now the weight is an explicit subscript and the dataset is an operand on the right. That makes the filtered exposure visible, puts $F$ vs. $T$ side by side, and handles claim-weighted severity with no extra machinery.
- **"Project" / $M_{-j}$ / $P_j$ dropped as a primitive.** Conditioning is "filter, then average". Marginalizing is "set, then average": the PDP integrates over the marginal distribution of $X_{-j}$. Both are composites, so a fifth primitive isn't needed. This also resolves the naming question raised in the drafts: one-way = *conditional*, PDP = *marginal / interventional*.
- **Commutation claims made exact.** Filter/set on different variables *always* commute (§5.3), not just "may coincide". The same-variable case is spelled out (§5.4).
- **Observed vs. modeled stated precisely.** Attached columns ride along under $T$, so raw experience has a flat PDP (§4).
- **Function form added (§2.5).** $f(x \mid x_j = z)$ for conditioning and $f(x \,;\, x_j \leftarrow z)$ for setting, with an explicit ordering rule.
- **Math delimiters.** The drafts mix `\( \)` and `$ $`. This note uses `$` only.

---

## 11. Open Questions

- **Soft support.** $\mathcal A$ in §7 holds hard constraints. Should there also be a data-driven notion of "has nearby exposure", and how would it be written? For example, $F[\,\Sigma_e(1)\, F_{N(x)} D > c\,]$ for some neighbourhood $N(x)$.
- **Setting a parent in a hierarchy.** What should happen to breed under $T_{\text{species}}(s)$ (§7.3)?
- **Restricted PDP vs. ALE.** Both deal with inadmissible counterfactuals. Is one preferred, or are they reported together?
- **Symbol choice.** $T$ (transform) versus $S$ (set) versus $\mathrm{do}_j(z)$ for the operator form. Pearl's $\mathrm{do}$ intervenes on the data-generating process, so its effects can propagate to other variables. $T$ only overwrites a model input, which argues against borrowing $\mathrm{do}$.
