d# The Guide's Framework in Operator Notation (Draft)

Exploratory companion to [relativities_operators.md](relativities_operators.md). The goal is to connect the guide's conceptual framework to the operators:

$$
\text{Pick a variable }j
\;\longrightarrow\;
\text{vary }x_j
\;\longrightarrow\;
\text{what do I do with everything else?}
$$

plus the three questions (what am I varying, what do I do with everything else, prediction or ratio).

The result is that each of the guide's three questions corresponds to one **slot** in a single expression. The guide's "different in kind" remark about the one-way is then visible as a one-letter change in that expression.

---

## 0. Symbols

This note follows the guide's naming wherever the two notes clash.

| Guide | Operator note | Meaning |
|---|---|---|
| $\hat\mu(\mathbf x)$ | $\hat u(x)$ | Fitted rate per pet-year |
| $ee_i$ | $e_i$ | Earned exposure (written $e$ in subscripts) |
| $y_i$ | $\ell_i$ | Observed aggregate loss |
| $\mathbf x^b$, $z^b$ | | Baseline pet; reference value of $x_j$ |
| $S_j(z)$ | $F_j(z)\,D$ | Pets that actually have $x_j = z$ |
| $\hat\mu(z, x_{i,-j})$ | $\hat\mu(T_j(z)\,x_i)$, or $\hat\mu(x_i \,;\, x_j \leftarrow z)$ | Pet $i$ with $x_j$ assigned $z$ |
| $M_j(z)$ | "one-way" $r_j(z)$, up to scale | Model-based one-way average |
| $PD_j(z)$ | "PDP" $p_j(z)$, up to scale | Partial dependence |
| base-risk $r_j(z)$ | (none) | Baseline pet with $x_j$ changed |

**Warning:** $r_j$ means the *base-risk* relativity in the guide but the *one-way* relativity in the operator note. This note uses the guide's meaning.

The operators are the same as in the operator note:

- $F_j(z)$ keeps rows that **have** $x_j = z$.
- $T_j(z)$ **assigns** $x_j \leftarrow z$ on every row; exposure and losses ride along unchanged.
- $\langle f \rangle_e\, D = \Sigma_e(f)\,D \,/\, \Sigma_e(1)\,D$ is the exposure-weighted average.

A single pet is a one-row dataset, written $\{\mathbf x^b\}$ or $\{i\}$. On a one-row dataset the weight cancels, so $\langle \hat\mu\rangle_e\{i\} = \hat\mu(\mathbf x_i)$.

---

## 1. Three Questions, Three Slots

Every model-based quantity in the guide fits one template:

$$
\boxed{\;
A(z) \;=\; \langle \hat\mu \rangle_e \;\; \underbrace{O_j(z)}_{\text{Q1: how is } x_j \text{ varied?}} \;\; \underbrace{D_0}_{\text{Q2: everything else}}
\qquad\qquad
\underbrace{A(z) \;\text{ or }\; \frac{A(z)}{A(z^b)}}_{\text{Q3: prediction or ratio?}}
\;}
$$

**Q1. What am I varying, and how?** This is the operator $O$.

| Choice | Operator |
|---|---|
| One variable, by assignment | $T_j(z)$ |
| One variable, by selection | $F_j(z)$ |
| The whole pet | $T_{\mathbf x} := T_1(x_1)\cdots T_p(x_p)$, every coordinate assigned |

**Q2. What do I do with everything else?** This is the starting dataset $D_0$. The other variables take whatever values the rows of $D_0$ have.

| Choice | $D_0$ |
|---|---|
| Hold at the baseline pet | $\{\mathbf x^b\}$ |
| Hold at one real pet | $\{i\}$ |
| Every real pet, then average | $D$ (the portfolio) |
| Every real pet in a subgroup, then average | $F_k(w)\,D$ |

**Q3. Prediction or ratio?** Either keep $A(z)$, which is in dollars per pet-year, or divide by $A(z^b)$ to get a relativity. Normalizing to the portfolio average instead is in §5.

The guide says Q2 "matters most, and is the one most often left unstated". In this template, Q2 can't be left unstated, because it is the dataset written on the right of every expression.

---

## 2. The Whole System, Rewritten

This is the guide's summary table (@tbl-system) with operator and function forms added.

| Quantity | Guide | Operator form | Function form |
|---|---|---|---|
| Overall relativity | $R(\mathbf x)$ | $\dfrac{\hat\mu(T_{\mathbf x}\,\mathbf x^b)}{\hat\mu(\mathbf x^b)}$ | $\dfrac{\hat\mu(\mathbf x^b \,;\, \text{all} \leftarrow \mathbf x)}{\hat\mu(\mathbf x^b)}$ |
| Base-risk relativity | $r_j(z)$ | $\dfrac{\langle\hat\mu\rangle_e\, T_j(z)\,\{\mathbf x^b\}}{\langle\hat\mu\rangle_e\, T_j(z^b)\,\{\mathbf x^b\}}$ | $\dfrac{\hat\mu(\mathbf x^b \,;\, x_j \leftarrow z)}{\hat\mu(\mathbf x^b)}$ |
| ICE | $ICE_{ij}(z)$ | $\langle\hat\mu\rangle_e\, T_j(z)\,\{i\}$ | $\hat\mu(\mathbf x_i \,;\, x_j \leftarrow z)$ |
| ICE relativity | $r_{ij}(z)$ | $\dfrac{\langle\hat\mu\rangle_e\, T_j(z)\,\{i\}}{\langle\hat\mu\rangle_e\, T_j(z^b)\,\{i\}}$ | $\dfrac{\hat\mu(\mathbf x_i \,;\, x_j \leftarrow z)}{\hat\mu(\mathbf x_i \,;\, x_j \leftarrow z^b)}$ |
| Partial dependence | $PD_j(z)$ | $\langle\hat\mu\rangle_e\, T_j(z)\, D$ | $\langle \hat\mu(\mathbf x \,;\, x_j \leftarrow z)\rangle_e\, D$ |
| Partial relativity | $\bar r_j(z)$ | $\dfrac{\langle\hat\mu\rangle_e\, T_j(z)\, D}{\langle\hat\mu\rangle_e\, T_j(z^b)\, D}$ | $\dfrac{\langle \hat\mu(\mathbf x \,;\, x_j \leftarrow z)\rangle_e\, D}{\langle \hat\mu(\mathbf x \,;\, x_j \leftarrow z^b)\rangle_e\, D}$ |
| Model one-way average | $M_j(z)$ | $\langle\hat\mu\rangle_e\, F_j(z)\, D$ | $\langle \hat\mu(\mathbf x \mid x_j = z)\rangle_e\, D$ |
| Observed one-way average | $\bar y_j(z)$ | $\dfrac{\Sigma(y)\, F_j(z)\,D}{\Sigma(e)\, F_j(z)\,D}$ | |
| One-way relativity | $m_j(z)$ | $\dfrac{\langle\hat\mu\rangle_e\, F_j(z)\, D}{\langle\hat\mu\rangle_e\, F_j(z^b)\, D}$ | $\dfrac{\langle \hat\mu(\mathbf x \mid x_j = z)\rangle_e\, D}{\langle \hat\mu(\mathbf x \mid x_j = z^b)\rangle_e\, D}$ |

### What the table shows

**Base-risk, ICE and PD are one expression.** All three are $\langle\hat\mu\rangle_e\, T_j(z)\, D_0$. Only the dataset differs: $\{\mathbf x^b\}$, $\{i\}$ or $D$. The guide notes that "the base-risk relativity is the ICE relativity of the baseline pet". The operator form takes that one step further: it is also the partial relativity of a portfolio containing one pet. Going down the guide's list "hold at baseline → hold at one real pet → every real pet, then average" changes only $D_0$.

**The one-way changes one letter.** It is $F_j$ in place of $T_j$. The guide says the one-way "is different in kind from the others. The first five keep the pets fixed and change a value. The one-way relativity changes *which pets are being compared*." In operator form, that difference is the letter.

**Overall vs. base-risk is Q1.** The overall relativity assigns every coordinate on the baseline pet, while the base-risk relativity assigns one. "The whole pet or one rating variable?" becomes "$T_{\mathbf x}$ or $T_j$?"

---

## 3. What Differs Between Numerator and Denominator

The guide's @tbl-structure asks what differs between numerator and denominator. In operator form:

| Relativity | Numerator | Denominator | Same dataset? |
|---|---|---|---|
| Base-risk | $T_j(z)\{\mathbf x^b\}$ | $T_j(z^b)\{\mathbf x^b\}$ | yes, $\{\mathbf x^b\}$ |
| ICE | $T_j(z)\{i\}$ | $T_j(z^b)\{i\}$ | yes, $\{i\}$ |
| Partial | $T_j(z)\,D$ | $T_j(z^b)\,D$ | yes, $D$ |
| One-way | $F_j(z)\,D$ | $F_j(z^b)\,D$ | **no** |

For every $T$-based relativity, the numerator and denominator start from the same dataset and differ only in the assigned value. That is the guide's "keep the pets the same, change the value of $x_j$". For the one-way, the datasets themselves differ: "keep the value the same, change which pets are compared".

### The algebra shows it too

$T$ keeps every row and its exposure, so the exposure totals in a partial relativity cancel:

$$
\bar r_j(z)
= \frac{\Sigma_e(\hat\mu)\,T_j(z)D \,/\, \Sigma_e(1)\,T_j(z)D}{\Sigma_e(\hat\mu)\,T_j(z^b)D \,/\, \Sigma_e(1)\,T_j(z^b)D}
= \frac{\Sigma_e(\hat\mu)\, T_j(z)\, D}{\Sigma_e(\hat\mu)\, T_j(z^b)\, D},
$$

because $\Sigma_e(1)\,T_j(z)D = \Sigma_e(1)\,D$ for every $z$. The result is the guide's "total form", a ratio of the book's total expected loss under two values. In the example it is $2736 / 1530 = 1.79$.

$F$ changes which rows are present, so in the one-way the exposures don't cancel:

$$
m_j(z)
= \frac{\Sigma_e(\hat\mu)\, F_j(z)\, D}{\Sigma_e(\hat\mu)\, F_j(z^b)\, D}
\;\times\;
\frac{\Sigma(e)\, F_j(z^b)\, D}{\Sigma(e)\, F_j(z)\, D}.
$$

The leftover exposure ratio is the algebraic symptom of comparing different pets.

---

## 4. The Weighted Vote and the Three Averages

Define the ICE relativity as a function of a record:

$$
\rho_{j}(z) := \frac{\hat\mu \circ T_j(z)}{\hat\mu \circ T_j(z^b)},
\qquad\text{so}\qquad
\rho_{j}(z)(\mathbf x_i) = r_{ij}(z).
$$

Then $\hat\mu\circ T_j(z) = (\hat\mu\circ T_j(z^b))\cdot\rho_j(z)$, and substituting this into the total form gives the guide's weighted vote (@eq-weighted-vote) in one line:

$$
\bar r_j(z)
= \frac{\Sigma_e\big(\hat\mu\circ T_j(z^b)\cdot \rho_j(z)\big)\, D}{\Sigma_e\big(\hat\mu\circ T_j(z^b)\big)\, D}
= \langle \rho_j(z) \rangle_{\omega}\, D,
\qquad
\omega = e \cdot \big(\hat\mu \circ T_j(z^b)\big).
$$

The weight subscript expresses the guide's "exposure times predicted cost at the reference value" directly. The guide's three averages (@tbl-averaging) then differ only in **the weight and the scale**:

| Method | Operator form | Example |
|---|---|---:|
| Ratio of averages (partial relativity) | $\langle \rho_j(z)\rangle_{e\cdot(\hat\mu\circ T_j(z^b))}\, D$ | 1.79 |
| Arithmetic average of ICE relativities | $\langle \rho_j(z)\rangle_{e}\, D$ | 1.74 |
| Geometric average of ICE relativities | $\exp \langle \log\rho_j(z)\rangle_{e}\, D$ | 1.72 |

---

## 5. The "Who × What" Grid

This is the most useful connection. Separate the two things a one-way changes at the same time:

- **who:** which pets, chosen by their *actual* value $w$, i.e. $F_j(w)$;
- **what:** which value they are *assigned*, i.e. $T_j(z)$.

Define

$$
G_j(z, w) = \langle \hat\mu \rangle_e\; T_j(z)\; F_j(w)\; D
= \big\langle \hat\mu(\mathbf x \,;\, x_j \leftarrow z \mid x_j = w) \big\rangle_e\, D .
$$

In words: take the pets that actually have $w$, assign them $z$, and average. This is the operator note's $T_j(z)\,F_j(B)$ building block (§5.4 there).

### The running example

For age, with $w$ the pets' actual age (rows) and $z$ the assigned age (columns). Pets 1 and 4 are age 2, with exposure 2.0, so $\pi(2) = 4/7$. Pets 2 and 3 are age 7, with exposure 1.5, so $\pi(7) = 3/7$.

| Pets that actually are... | assigned $z = 2$ | assigned $z = 7$ | Row ratio: partial relativity within the group |
|---|---:|---:|---:|
| age 2 (pets 1, 4) | **397.50** | 678.00 | 1.71 |
| age 7 (pets 2, 3) | 490.00 | **920.00** | 1.88 |
| Mix-weighted ($= PD_{\text{age}}$) | 437.14 | 781.71 | 1.79 |
| Column ratio: mix effect | 1.23 | 1.36 | |

The diagonal (bold) is the one-way: $920.00 / 397.50 = 2.31$.

### Every quantity in the guide is a reading of this grid

- **The diagonal is the one-way.** $T_j(z)\,F_j(z) = F_j(z)$, so $G_j(z,z) = M_j(z)$. Therefore $m_j(z) = G_j(z,z)/G_j(z^b,z^b)$, which is $2.31$.
- **A row ratio is a partial relativity on a subgroup.** $G_j(z,w)/G_j(z^b,w)$ is the partial relativity computed on the portfolio $F_j(w)D$: 1.71 for the age-2 pets and 1.88 for the age-7 pets.
- **The mix-weighted column is partial dependence.** Partition the portfolio by actual value and apply the tower property (operator note §5.7):

  $$
  PD_j(z) = \sum_w \pi_j(w)\, G_j(z, w).
  $$

  Here $\frac47(678) + \frac37(920) = 781.71$. The partial relativity, 1.79, is a weighted vote of the row ratios, just as it is a weighted vote of the pets.
- **A column ratio is a mix effect.** $G_j(z,w)/G_j(z,w')$ holds the assigned value fixed and changes who is compared. At age 2, the age-7 pets are a 23% more expensive mix than the age-2 pets.

### The one-way decomposition is a trip around the square

The guide's Kitagawa split (@sec-calc-rate-mix) is the two ways around the $2\times 2$ square from $(z^b, z^b)$ to $(z, z)$:

$$
m_j(z)
= \underbrace{\frac{G_j(z,z)}{G_j(z^b,z)}}_{\text{within: age-7 pets, } 7 \text{ vs } 2}
\times
\underbrace{\frac{G_j(z^b,z)}{G_j(z^b,z^b)}}_{\text{mix, at age 2}}
= 1.88 \times 1.23
$$

$$
m_j(z)
= \underbrace{\frac{G_j(z,z)}{G_j(z,z^b)}}_{\text{mix, at age 7}}
\times
\underbrace{\frac{G_j(z,z^b)}{G_j(z^b,z^b)}}_{\text{within: age-2 pets, } 7 \text{ vs } 2}
= 1.36 \times 1.71
$$

Both products equal 2.31. The "within" factor is a partial relativity computed on one group, so a one-way is a **partial relativity times a mix effect**, and the split depends on which corner you pass through. This is the finite version of the path dependence in the calculus chapter.

### The two forces

The guide's two forces (@sec-interactions-revisited) become two properties of the grid.

- **Correlation makes the rows differ.** Each row is a different set of pets. If $x_j$ were independent of $x_{-j}$, every row would hold the same mix of other variables (exactly in the population, approximately in a sample). The rows would then be identical, so the diagonal would equal the column average, $M_j = PD_j$, and the one-way would equal the partial relativity, even with interactions.
- **Interaction makes the row ratios differ.** If $x_j$ interacts with nothing, then $\hat\mu = g_j(x_j)\,h(x_{-j})$ and $G_j(z,w) = g_j(z)\,\langle h\rangle_e F_j(w)D$. Every row then has the same ratio, $g_j(z)/g_j(z^b)$. The grid becomes an outer product, and the one-way is exactly

  $$
  m_j(z) = \underbrace{\frac{g_j(z)}{g_j(z^b)}}_{\text{the GLM factor}} \times \underbrace{\frac{\langle h\rangle_e F_j(z)D}{\langle h\rangle_e F_j(z^b)D}}_{\text{mix effect}} .
  $$

  That is the guide's double counting, written as a formula.

### The two portfolio-average references

The guide (@sec-reference) gives two portfolio-average references for the partial relativity. They are $c_j = 584.82$ (the off-balance) and $\bar\mu = 621.43$, and the guide notes they differ. The grid shows why:

$$
\bar\mu = \sum_w \pi_j(w)\, G_j(w, w)
\qquad\text{(the diagonal, mix-weighted)}
$$

$$
c_j = \sum_z \pi_j(z)\, PD_j(z) = \sum_{z}\sum_{w} \pi_j(z)\,\pi_j(w)\, G_j(z, w)
\qquad\text{(the whole grid, independent weights)}
$$

- $\bar\mu$ averages over pets at their own values.
- $c_j$ averages over a "shuffled" book, in which each pet's value of $x_j$ is redrawn independently of everything else about it. This is the operator note's §5.7 result. In the example, $\frac47(397.50) + \frac37(920.00) = 621.43$, but $\frac47(437.14) + \frac37(781.71) = 584.82$.
- The gap between them is correlation again. Without it, the rows are identical and the two coincide.

### ALE lives next to the diagonal

The guide's counterfactuals section (@sec-counterfactuals) mentions ALE but doesn't cover it. The grid shows what ALE does:

- **Diagonal cells** are real pets at their real values.
- **Far off-diagonal cells** are where the implausible counterfactuals live, such as old-breed pets assigned extreme ages.
- **ALE** uses only the cells next to the diagonal. Each local step is a within factor between adjacent levels, $G_j(z_k, z_k)/G_j(z_{k-1}, z_k)$: the pets that actually are $z_k$, moved one step. These steps are then accumulated along the diagonal.
- **PD** averages entire columns, including the far corners.
- **The one-way** stays on the diagonal and never moves anyone.

So the three methods differ in how far they stray from the diagonal: one-way not at all, ALE one step, PD all the way.

---

## 6. Overall Relativity and the Interaction Factor

The overall relativity assigns every coordinate on the baseline pet, while the base-risk relativities assign one coordinate at a time:

$$
R(\mathbf x) = \frac{\hat\mu(T_1(x_1)\cdots T_p(x_p)\,\mathbf x^b)}{\hat\mu(\mathbf x^b)},
\qquad
r_j(x_j) = \frac{\hat\mu(T_j(x_j)\,\mathbf x^b)}{\hat\mu(\mathbf x^b)},
\qquad
I(\mathbf x) = \frac{R(\mathbf x)}{\prod_j r_j(x_j)} .
$$

Sets on different variables commute (operator note §5.2), so $R(\mathbf x)$ doesn't depend on the order in which the $T$s are applied. The *credit* does. Applying the $T$s one at a time and recording the ratio at each step gives the guide's @tbl-calc-orders. Species first credits age with $2.00$, while age first credits it with $1.40$.

**The operators commute; the attribution doesn't.** Shapley values average the credit over all orders of applying the $T$s.

---

## 7. Other Guide Topics, Briefly

| Guide topic | Operator form |
|---|---|
| Choosing the portfolio (@sec-portfolio) | Choosing $D$, e.g. $F_{\text{state}}(\text{CA})\,D$ for a state filing |
| Partial relativities within subgroups | $\langle\hat\mu\rangle_e\, T_j(z)\, F_k(w)\, D$, the stratified PD |
| Vary nested variables together | Hierarchical set, $T_{\text{species}}(h(b))\,T_{\text{breed}}(b)$ |
| Restrict to valid combinations | $F_{\mathcal A}$ (operator note §7) |
| Two-way PD (@sec-beyond) | $\langle\hat\mu\rangle_e\, T_j(z)\,T_k(w)\, D$ |
| "PD is a question about the model, not real pets" | $\langle y/e\rangle_e\, T_j(z)\, D$ is flat in $z$: observed losses don't respond to $T$ |
| One-way as a model check (A/E) | $\dfrac{\Sigma(y)\, F_j(z)D}{\Sigma_e(\hat\mu)\, F_j(z)D}$, actual over expected on the same rows |

---

## 8. Code

This uses the helpers from the operator note (`F_j`, `T_j`, `avg`). `mu_hat(D)` returns the rate per pet-year for each row.

```r
grid_j <- expand_grid(z = age_levels, w = age_levels) |>
  mutate(G = map2_dbl(z, w, \(z, w) D |> F_j(age, w) |> T_j(age, z) |> avg(mu_hat)))

mix <- tibble(w = age_levels) |>
  mutate(pi = map_dbl(w, \(w) tot(F_j(D, age, w)) / tot(D)))

one_way <- grid_j |> filter(z == w)                                  # diagonal = M_j(z)
pd      <- grid_j |> left_join(mix, by = "w") |>
  summarise(PD = sum(pi * G), .by = z)                               # mix-weighted columns

base_risk <- map_dbl(age_levels, \(z) x_b |> T_j(age, z) |> mu_hat()) / mu_hat(x_b)
```

Every quantity in §2 is either a single pipeline or a reading of `grid_j`.

---

## 9. Open Questions

- **Is the grid worth putting in the guide?** It explains the one-way vs. partial distinction, the Kitagawa split, the two references, and ALE with one table, and it needs no calculus.
- **Continuous $x_j$.** The rows become bins $F_j(B_k)$, while the columns stay grid points $T_j(z)$. The grid is no longer square, so "the diagonal" means the cell where $z$ falls inside $B_k$.
- **Symbol for the grid.** $G_j(z,w)$ is a placeholder. The function form $\langle \hat\mu(\mathbf x \,;\, x_j \leftarrow z \mid x_j = w)\rangle_e D$ may be clear enough to use without a name.
