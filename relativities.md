# Relativities and Risk Comparison

Relativities are a way of expressing model predictions as comparisons.

Although terms such as *overall relativity*, *one-way relativity*, *ICE*, *partial dependence*, and *partial relativity* can initially seem like a collection of unrelated concepts, they can be understood as variations on a common framework.

The key questions are:

1. **What am I varying?**
2. **What am I doing with everything else?**
3. **Am I looking at a prediction, or a ratio of predictions?**

For quantities involving a particular rating variable $j$, a useful mental map is

$$
\boxed{
\text{Pick }j
\;\longrightarrow\;
\text{vary }x_j
\;\longrightarrow\;
\text{what do I do with }x_{-j}?
}
$$

where

- $x_j$ is the rating variable of interest, such as pet age, and
- $x_{-j}$ represents all of the other rating variables, such as species, breed, geography, and so forth.

From this perspective:

- **Base risk** $\rightarrow$ one-way relativity
- **One observed risk at a time** $\rightarrow$ ICE
- **All observed risks, then average** $\rightarrow$ partial dependence
- **All observed risks, average, then normalize** $\rightarrow$ partial relativity
- **Don't isolate $j$ at all** $\rightarrow$ overall relativity

---

## 1. Setup

Let the complete vector of rating variables for a risk be

$$
\mathbf{x}=(x_1,x_2,\ldots,x_p).
$$

Suppose our fitted model predicts

$$
\hat\mu(\mathbf{x}).
$$

For example, $\hat\mu(\mathbf{x})$ might be the predicted pure premium per unit of earned exposure for a pet having characteristics $\mathbf{x}$.

Choose a **base risk**

$$
\mathbf{x}^b=(x_1^b,x_2^b,\ldots,x_p^b),
$$

where one reference value has been chosen for every rating variable.

For example, a base risk might be:

| Variable | Base value |
| --- | --- |
| Species | Cat |
| Age | 2 |
| State | Washington |
| Plan | Standard |

This describes one particular hypothetical pet.

---

# 2. Overall Relativity

Define the base rate

$$
B=\hat\mu(\mathbf{x}^b).
$$

The **overall relativity** for an arbitrary risk $\mathbf{x}$ is

$$
R(\mathbf{x})
=
\frac{\hat\mu(\mathbf{x})}
     {\hat\mu(\mathbf{x}^b)}.
$$

Therefore,

$$
\hat\mu(\mathbf{x})=B\,R(\mathbf{x}).
$$

For a log-link model with predictor $f(\mathbf{x})$,

$$
R(\mathbf{x})
=
\exp\left[
\hat f(\mathbf{x})-\hat f(\mathbf{x}^b)
\right].
$$

### Plain language

> **What is the predicted risk of this pet relative to the baseline pet?**

For example,

$$
R(\text{Dog, age 7, Oregon})
=
\frac{
\hat\mu(\text{Dog, age 7, Oregon})
}{
\hat\mu(\text{Cat, age 2, Washington})
}.
$$

Every characteristic of the pet in the numerator can differ from the base pet.

This calculation does not try to isolate age, species, geography, or any other individual variable. It compares **one complete risk with another complete risk**.

### Interactions

Interactions pose no conceptual problem for overall relativity.

The model is simply evaluated at two complete points in predictor space:

$$
\boxed{
\mathbf{x}
\quad\text{vs.}\quad
\mathbf{x}^b
}
$$

Any interactions are automatically included in both predictions.

---

# 3. One-Way Relativity

Suppose we now want to isolate rating variable $j$.

Write the risk vector as

$$
\mathbf{x}=(x_j,x_{-j}),
$$

where $x_{-j}$ means *all variables other than $j$*.

The one-way relativity is

$$
r_j(z)
=
\frac{
\hat\mu(z,x_{-j}^b)
}{
\hat\mu(x_j^b,x_{-j}^b)
}.
$$

Because

$$
(x_j^b,x_{-j}^b)=\mathbf{x}^b,
$$

we can also write

$$
r_j(z)
=
\frac{
\hat\mu(z,x_{-j}^b)
}{
\hat\mu(\mathbf{x}^b)
}.
$$

### Plain language

> **How would the predicted baseline risk vary if I changed this one variable?**

Suppose age is the variable of interest.

Our baseline pet is

> Cat, age 2, Washington.

To calculate the one-way age relativity at age 7, construct

> Cat, **age 7**, Washington.

Then

$$
r_{\text{age}}(7)
=
\frac{
\hat\mu(\text{Cat, age 7, Washington})
}{
\hat\mu(\text{Cat, age 2, Washington})
}.
$$

Only age changed.

Everything else stayed at the values defining the baseline pet.

Thus:

$$
\boxed{
\text{One-way relativity}
=
\text{one variable vs. its base, conditional on the base risk}
}
$$

---

# 4. Why Interactions Matter for One-Way Relativities

Suppose the model contains an interaction between age and species.

Then

$$
r_{\text{age}}(7)
$$

is specifically the age-7 relativity **for whatever species was chosen for the baseline pet**.

If the baseline species is Cat, it describes the model's age behavior in the context of a cat.

It does not necessarily describe what changing age from 2 to 7 does for a dog.

Consequently, with interactions,

$$
R(\mathbf{x})
\neq
\prod_j r_j(x_j)
$$

in general.

We can write

$$
R(\mathbf{x})
=
\left[
\prod_j r_j(x_j)
\right] I(\mathbf{x}),
$$

where $I(\mathbf{x})$ represents the portion of the overall relativity that cannot be reconstructed by multiplying the individual one-way relativities defined at the common base risk.

This exposes an important limitation of one-way relativities:

> With interactions, the reported relativity for one variable depends on the values selected for the other variables in the base risk.

---

# 5. Individual Conditional Expectation (ICE)

One-way relativity suggests another possibility.

Instead of holding the other variables at the values of a hypothetical **base pet**, what if we hold them at the values of an **actual pet**?

Let $i$ index observations in the portfolio.

For observation $i$, define

$$
ICE_{ij}(z)
=
\hat\mu(z,x_{i,-j}).
$$

### Plain language

> **Take a given pet. How would its predicted risk vary if I changed this one variable?**

Suppose observation $i$ is

> Dog, age 4, Oregon.

For an age ICE curve, we evaluate

$$
\hat\mu(\text{Dog, age 1, Oregon}),
$$

$$
\hat\mu(\text{Dog, age 2, Oregon}),
$$

$$
\hat\mu(\text{Dog, age 3, Oregon}),
$$

and so forth.

Species and state remain those of this particular pet.

Then we repeat the same process for another pet.

Each observation therefore gets its **own curve**.

---

# 6. One-Way Relativity and ICE Are Closely Related

Mathematically, the operation is very similar.

For one-way prediction, we evaluate

$$
\hat\mu(z,x_{-j}^b).
$$

For ICE observation $i$, we evaluate

$$
\hat\mu(z,x_{i,-j}).
$$

The difference is what we use for the other variables.

### One-way

Use the other characteristics of the **base risk**:

$$
x_{-j}^b.
$$

### ICE

Use the other characteristics of **observation $i$**:

$$
x_{i,-j}.
$$

Thus an intuitive description is

$$
\boxed{
\text{One-way prediction curve}
=
\text{ICE-like curve for the base risk}
}
$$

An ICE curve itself contains predictions rather than relativities.

If desired, an observation-specific ICE relativity could be defined as

$$
r_{ij}^{ICE}(z)
=
\frac{
\hat\mu(z,x_{i,-j})
}{
\hat\mu(x_j^b,x_{i,-j})
}.
$$

This asks:

> **For this particular pet, how much does predicted risk change when I move $x_j$ from the reference value to $z$?**

With interactions, ICE curves can differ substantially between observations because the modeled relationship between $x_j$ and risk can depend on $x_{-j}$.

---

# 7. Partial Dependence

ICE gives us a prediction curve for every observed risk.

Partial dependence takes the next step:

> **Average those predictions across the portfolio.**

The unweighted partial dependence function is

$$
PD_j(z)
=
\frac{1}{N}
\sum_{i=1}^N
\hat\mu(z,x_{i,-j}).
$$

Equivalently,

$$
PD_j(z)
=
\operatorname{Avg}_i
\left[
ICE_{ij}(z)
\right].
$$

### Plain language

> **Across the portfolio, how would the average predicted risk vary if I changed this one variable?**

For example, suppose we want the partial dependence of pet age at age 7.

Take every observation in the portfolio.

For each observation:

1. Set age to 7.
2. Leave that observation's species, breed, geography, plan, etc. unchanged.
3. Obtain its prediction.

Then average those predictions.

So we might create the following counterfactual portfolio:

| Observation $i$ | Species | Age | State |
| ---: | --- | ---: | --- |
| 1 | Dog | **7** | OR |
| 2 | Cat | **7** | WA |
| 3 | Dog | **7** | CA |
| $\vdots$ | $\vdots$ | $\vdots$ | $\vdots$ |

No claim is being made that these pets actually have age 7.

We are asking a model question:

> **What would the model predict if I assigned age 7 to the existing portfolio while leaving its other characteristics unchanged?**

---

# 8. Exposure-Weighted Partial Dependence

In insurance applications, observations may represent different amounts of exposure.

If $\hat\mu$ represents predicted loss per unit exposure, we may want the portfolio average to represent a unit of exposure rather than an average policy-term row.

Let $ee_i$ denote the earned exposure associated with observation $i$.

Then define

$$
PD_j^{(ee)}(z)
=
\frac{
\sum_{i=1}^N
ee_i\,
\hat\mu(z,x_{i,-j})
}{
\sum_{i=1}^N ee_i
}.
$$

### What does $i$ mean?

This is worth emphasizing:

$$
\boxed{
i=\text{portfolio observation}
}
$$

It does **not** index levels of the rating variable.

Meanwhile,

$$
\boxed{
z=\text{value of the focal rating variable being evaluated}
}
$$

For example, if $j$ is pet age,

- $i$ might identify policy-term 18347,
- $z$ might equal age 7.

---

# 9. Exposure Does Not Change When We Change the Focal Variable

Suppose we evaluate age 1:

$$
PD_{\text{age}}^{(ee)}(1)
=
\frac{
\sum_i ee_i
\hat\mu(1,x_{i,-\text{age}})
}{
\sum_i ee_i
}.
$$

The $ee_i$ values remain the observed exposures associated with the original rows.

Then evaluate age 2:

$$
PD_{\text{age}}^{(ee)}(2)
=
\frac{
\sum_i ee_i
\hat\mu(2,x_{i,-\text{age}})
}{
\sum_i ee_i
}.
$$

We use the **same observations and same exposure weights** at every age.

We are therefore *not* asking:

> What does the portfolio of actual one-year-old pets look like?

Instead, we are asking:

> **What would the model predict if the existing portfolio were assigned age 1?**

Then:

> **What would the model predict if that same portfolio were assigned age 2?**

The portfolio is deliberately being held constant so that the focal model variable is what changes.

---

# 10. Categorical and Continuous Variables

The computational idea is essentially the same for categorical and continuous variables.

## Categorical variable

Suppose Species has levels

- Cat
- Dog
- Other

For Dog:

1. Set Species = Dog for every portfolio observation.
2. Leave every other rating variable unchanged.
3. Predict every observation.
4. Average the predictions, optionally using exposure weights.

Then repeat for Cat and Other.

This gives

$$
PD_{\text{species}}(\text{Cat}),
\qquad
PD_{\text{species}}(\text{Dog}),
\qquad
PD_{\text{species}}(\text{Other}).
$$

## Continuous variable

Suppose the focal variable is pet age.

Choose values

$$
z_1,z_2,\ldots,z_K.
$$

For each $z_k$:

1. Set age to $z_k$ for every observation.
2. Leave all other characteristics unchanged.
3. Predict every observation.
4. Average the predictions.

This produces

$$
z\mapsto PD_{\text{age}}(z).
$$

The important distinction is:

$$
\boxed{
\text{Grid over }x_j;
\qquad
\text{empirical average over }X_{-j}.
}
$$

For a categorical variable, the categories provide a natural grid.

For a continuous variable, we choose a useful collection of values at which to evaluate the curve.

---

# 11. Partial Relativity

Partial dependence is still expressed in units of the modeled outcome.

To turn it into a relativity, choose a reference value $z^b$ for the focal rating variable and normalize:

$$
r_j^{\text{partial}}(z)
=
\frac{
PD_j(z)
}{
PD_j(z^b)
}.
$$

For an exposure-weighted PD, equivalently,

$$
r_j^{\text{partial}}(z)
=
\frac{
\dfrac{
\sum_i ee_i\hat\mu(z,x_{i,-j})
}{
\sum_i ee_i
}
}{
\dfrac{
\sum_i ee_i\hat\mu(z^b,x_{i,-j})
}{
\sum_i ee_i
}
}.
$$

### Plain language

> **Across the portfolio, how would average predicted risk change relative to a reference value if I changed this one variable?**

For example,

$$
r_{\text{age}}^{\text{partial}}(10)
=
\frac{
PD_{\text{age}}(10)
}{
PD_{\text{age}}(2)
}.
$$

This asks:

> **For the same portfolio, how much greater or smaller would average predicted risk be if age were set to 10 rather than age 2?**

Thus

$$
\boxed{
\text{Partial relativity}
=
\text{normalized partial dependence}
}
$$

under this definition of partial relativity.

---

# 12. Why Partial Relativity Is More Isolated Than Overall Relativity

There is an important structural distinction between these relativities.

## Overall relativity

$$
R(\mathbf{x})
=
\frac{
\hat\mu(\mathbf{x})
}{
\hat\mu(\mathbf{x}^b)
}.
$$

The numerator and denominator can differ in **every rating variable**.

In plain language:

> **This whole pet versus the whole baseline pet.**

## One-way relativity

$$
r_j(z)
=
\frac{
\hat\mu(z,x_{-j}^b)
}{
\hat\mu(z^b,x_{-j}^b)
}.
$$

Only $x_j$ changes.

But the comparison is conditional on one specific choice of all the other variables.

In plain language:

> **Change only this variable, for the baseline pet.**

## Partial relativity

$$
r_j^{\text{partial}}(z)
=
\frac{
\operatorname{Avg}_i[
\hat\mu(z,x_{i,-j})
]
}{
\operatorname{Avg}_i[
\hat\mu(z^b,x_{i,-j})
]
}.
$$

Only $x_j$ changes, and the **same portfolio distribution of $x_{-j}$ appears in both numerator and denominator**.

In plain language:

> **Change only this variable for the same entire portfolio, then compare the average predictions.**

Therefore,

$$
\boxed{
\begin{aligned}
\text{Overall} &: \text{ whole risk vs. whole base risk}\\[3pt]
\text{One-way} &: \text{ one variable vs. its base, conditional on base risk}\\[3pt]
\text{Partial} &: \text{ one variable vs. its base, averaged over the portfolio}
\end{aligned}
}
$$

---

# 13. The Unified Mental Map

The quantities can now be placed in one system.

| Quantity | What happens to $x_j$? | What happens to $x_{-j}$? | Mental model |
| --- | --- | --- | --- |
| **Overall relativity** | Entire risk vector $\mathbf{x}$ | Not applicable | Compare the **entire risk vector** $\mathbf{x}$ with base risk $\mathbf{x}^b$ |
| **One-way relativity** | Vary $x_j$ | Fix at **one base risk** $x_{-j}^b$ | Relativity as a function of $x_j$ for the chosen base risk |
| **ICE** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$ | Prediction as a function of $x_j$ for each individual risk |
| **Partial dependence (PD)** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$, then average over $i$ | Average prediction as a function of $x_j$ across the portfolio |
| **Partial relativity** | Vary $x_j$ | Same as PD: repeat over $x_{i,-j}$ and average over $i$ | Partial-dependence curve normalized relative to a reference value of $x_j$ |

Or, even more compactly:

$$
\boxed{
\text{Pick }j
\longrightarrow
\text{vary }x_j
\longrightarrow
\text{what do I do with }x_{-j}?
}
$$

- **Base risk** $\rightarrow$ one-way relativity
- **One observed risk at a time** $\rightarrow$ ICE
- **All observed risks, then average** $\rightarrow$ partial dependence
- **All observed risks, average, then normalize** $\rightarrow$ partial relativity
- **Don't isolate $j$ at all** $\rightarrow$ overall relativity

---

# 14. The Questions Each Quantity Answers

The same concepts can be expressed almost entirely without mathematical terminology.

| Quantity | Question it answers |
| --- | --- |
| **Overall relativity** | What is the predicted risk of this pet relative to the baseline pet? |
| **One-way relativity** | How would the predicted baseline risk vary if I changed this one variable? |
| **ICE** | Take a given pet. How would its predicted risk vary if I changed this one variable? |
| **Partial dependence (PD)** | Across the portfolio, how would the average predicted risk vary if I changed this one variable? |
| **Partial relativity** | Across the portfolio, how would the average predicted risk change relative to a reference value if I changed this one variable? |

---

# 15. Predictions, Effects, and Relativities Are Not the Same Thing

It is useful to keep these concepts separate.

An ICE value

$$
ICE_{ij}(z)=\hat\mu(z,x_{i,-j})
$$

is a **prediction**.

Likewise,

$$
PD_j(z)
=
\operatorname{Avg}_i
\left[
\hat\mu(z,x_{i,-j})
\right]
$$

is an **average prediction**.

Neither is inherently an "effect."

To compare two values on an additive scale, we could calculate

$$
PD_j(z_1)-PD_j(z_0).
$$

To compare them multiplicatively, we could calculate

$$
\frac{
PD_j(z_1)
}{
PD_j(z_0)
}.
$$

The latter is a relativity.

So there are really two separate decisions:

1. **How do I construct the prediction?**
2. **How do I compare predictions?**

This distinction prevents several similar-looking objects from being conflated.

---

# 16. The Relationship Among ICE, PD, and Partial Relativity

These three quantities form a particularly clean progression.

Start with one observation:

$$
ICE_{ij}(z)
=
\hat\mu(z,x_{i,-j}).
$$

Repeat for all observations and average:

$$
ICE
\quad\xrightarrow{\text{average over }i}\quad
PD.
$$

Normalize the resulting PD curve:

$$
PD
\quad\xrightarrow{\text{normalize}}\quad
\text{partial relativity}.
$$

Therefore,

$$
\boxed{
\text{ICE predictions}
\longrightarrow
\text{average}
\longrightarrow
\text{partial dependence}
\longrightarrow
\text{normalize}
\longrightarrow
\text{partial relativity}
}
$$

There is a parallel path for one-way relativity:

$$
\boxed{
\text{prediction at }(z,x_{-j}^b)
\longrightarrow
\text{normalize}
\longrightarrow
\text{one-way relativity}
}
$$

This reveals that one-way and partial relativities are not fundamentally unrelated quantities.

They differ primarily in what happens to $x_{-j}$:

$$
\boxed{
\begin{aligned}
\text{One-way:}\qquad
& X_j=z,
& X_{-j}=x_{-j}^b
\\[4pt]
\text{Partial:}\qquad
& X_j=z,
& X_{-j}\sim\text{portfolio}
\end{aligned}
}
$$

In words:

> **One-way relativity evaluates the variable in one context. Partial relativity averages it over the portfolio's contexts.**

---

# 17. Interactions Through This Unified View

This framework also makes interactions easier to understand.

If there are no relevant interactions, changing $x_j$ may have essentially the same relative effect regardless of $x_{-j}$.

But with interactions, the prediction

$$
\hat\mu(z,x_{-j})
$$

depends on which $x_{-j}$ we use.

That immediately explains why there are several possible summaries.

We can ask:

### What happens for the baseline pet?

Use

$$
x_{-j}=x_{-j}^b.
$$

This leads to the **one-way** curve.

### What happens for this particular pet?

Use

$$
x_{-j}=x_{i,-j}.
$$

This leads to an **ICE** curve.

### What happens on average across the portfolio?

Evaluate many

$$
x_{i,-j}
$$

and average them.

This leads to **partial dependence** and, after normalization, a **partial relativity**.

Interactions therefore do not require an entirely new conceptual framework.

They make the answer to

> **What happens when I change $x_j$?**

depend on the answer to

> **What am I doing with $x_{-j}$?**

---

# 18. One Final Caution: Average Predictions vs. Average Relativities

Suppose we normalize each ICE curve individually:

$$
r_{ij}^{ICE}(z)
=
\frac{
\hat\mu(z,x_{i,-j})
}{
\hat\mu(z^b,x_{i,-j})
}.
$$

We could then average those individual relativities.

But that is generally **not the same quantity** as first averaging predictions and then taking their ratio:

$$
\operatorname{Avg}_i
\left[
\frac{
\hat\mu(z,x_{i,-j})
}{
\hat\mu(z^b,x_{i,-j})
}
\right]
\neq
\frac{
\operatorname{Avg}_i[\hat\mu(z,x_{i,-j})]
}{
\operatorname{Avg}_i[\hat\mu(z^b,x_{i,-j})]
}.
$$

The partial relativity defined in this guide uses the quantity on the **right**:

1. average predictions for $z$,
2. average predictions for $z^b$,
3. take the ratio.

This definition corresponds naturally to comparing average modeled risk for the same portfolio under two values of the focal rating variable.

---

# 19. Summary

The terminology becomes considerably easier to remember once the quantities are treated as consequences of a common construction rather than as separate definitions.

Start with

$$
\hat\mu(x_j,x_{-j}).
$$

Then ask:

### 1. What am I varying?

Either:

- the entire risk vector $\mathbf{x}$, or
- one focal variable $x_j$.

### 2. What am I doing with everything else?

If varying $x_j$, either:

- hold $x_{-j}$ at the base risk,
- hold $x_{-j}$ at one observed risk, or
- repeat over the observed portfolio and average.

### 3. Am I keeping the prediction or normalizing it?

A prediction remains on the model's outcome scale.

A relativity divides one prediction, or one averaged prediction, by another.

That yields the whole system:

$$
\boxed{
\begin{array}{lll}
\textbf{Overall relativity}
&=&
\text{whole risk vs. whole base risk}
\\[4pt]
\textbf{One-way relativity}
&=&
\text{vary one variable at the base risk, then normalize}
\\[4pt]
\textbf{ICE}
&=&
\text{vary one variable for one observed risk}
\\[4pt]
\textbf{Partial dependence}
&=&
\text{vary one variable for every observed risk, then average}
\\[4pt]
\textbf{Partial relativity}
&=&
\text{partial dependence, then normalize}
\end{array}
}
$$

The central mental model is therefore not five different definitions.

It is:

$$
\boxed{
\text{What am I varying?}
\quad+\quad
\text{What am I doing with everything else?}
\quad+\quad
\text{Prediction or ratio?}
}
$$
