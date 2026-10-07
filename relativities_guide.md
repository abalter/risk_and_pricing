# Comparing Risks with a Fitted Model

## Relativities, ICE, and Partial Dependence as One System

*Draft, October 6, 2026*

A fitted model answers one question directly: what is the expected loss for a pet with these characteristics? Most of the questions we actually ask are comparisons. How much more does a dog cost than a cat? What does age do to risk? How much of a pet's expected loss comes from its breed? Relativities are how we answer these questions.

This guide is about **risk**: comparisons of expected loss, which is driven by the process that generates claims. Pricing layers business considerations on top of risk, such as expenses, profit, competition, and regulation. Pricing relativities are special cases of the general relativities described here, and a separate guide covers them.

The guide is written as a spiral:

- **Part I** gives the whole idea in plain language. You can stop there and still have the main point.
- **Part II** builds each quantity carefully, with one small worked example that runs through every section.
- **Part III** covers practical choices, computation, and limitations.

Interactions are the theme throughout. Modern risk models almost always contain them, and they are the reason "what does age do to risk?" has more than one honest answer.

---

# Part I. The Big Picture

## 1. Two familiar relativities, and why they are no longer enough

Most of us learned two ways to get relativities.

**One-way relativities from the data.** Group the policies by the levels of one rating variable. For each level, divide total loss by total exposure to get the observed pure premium. Then divide each level's pure premium by the base level's. No model is involved.

This is simple and transparent, but it credits a variable with everything that travels with it. If older pets in the book tend to be dogs, and dogs cost more, the one-way age relativities absorb part of the dog effect. Multiplying one-way relativities across variables then counts the same risk more than once.

**Coefficients from a GLM.** Fit a multiplicative (log-link) GLM with all the rating variables at once, and read off $e^{\hat\beta}$ for each level. Because the variables are fit together, each coefficient is adjusted for the others, which solves the double-counting problem. The rate table is then a base rate times a product of these factors.

A GLM with main effects only has one more property, and that property is what made its coefficients so easy to use: **the effect of each variable is the same for every pet.** Moving a pet from age 2 to age 7 multiplies its expected loss by the same factor whether it is a cat in Washington or a dog in California. So $e^{\hat\beta}$ simply *is* the age-7 relativity. It doesn't matter which pet you ask about, which pet you take as the base, or what the book looks like.

**That property disappears once a model has interactions.** Computing power, machine learning, and statistical science have moved on. GAMs with smooth interaction surfaces, gradient-boosted trees, and GLMs with many interaction terms are now routine. They fit risk better because real risk has interactions: dogs may age differently from cats. In such a model there is no single coefficient to read off. The effect of age on a cat differs from its effect on a dog, and "the age relativity" splits into several distinct quantities, each answering a different question.

Explainable machine learning developed tools for exactly this situation, notably partial dependence and individual conditional expectation (ICE). The actuarial literature has mostly not caught up. In the classic main-effects GLM, all of these quantities collapse to the same number, so there was never a need to tell them apart; the only distinction that mattered was one-way versus multivariate. That is why the terminology for these ideas isn't settled in insurance, and why the same ideas keep being rebuilt from scratch.

This guide organizes the modern relativities into one system. Both familiar relativities have a place in it. The GLM coefficient is the special case that all the model-based relativities reduce to when there are no interactions. The one-way relativity becomes a check on the model rather than a measure of a variable's effect.

## 2. A model is a function you can ask questions

Treat the fitted model as a function. Give it a pet's rating characteristics and it returns the expected loss per unit of exposure, that is, per pet-year:

$$
\hat\mu(\text{Dog, age 7, Oregon}) = \$810.
$$

Every model-based quantity in this guide is built the same way: call this function on carefully chosen inputs, then possibly average the outputs, divide one output by another, or both. The quantities differ only in **which inputs you feed in** and **what you do with the outputs**.

## 3. Three questions

Whenever someone reports "the age relativity" or "the effect of species," three questions pin down what was actually computed.

1. **What am I varying?** The whole pet, or one rating variable?
2. **What am I doing with everything else?** If I vary one variable, what values do the other variables take?
3. **Am I keeping the prediction, or turning it into a ratio?** A prediction is in dollars per pet-year. A ratio of predictions is a relativity.

The second question matters most, and it is the one most often left unstated.

## 4. The family at a glance

Take age as the variable of interest, and take a **baseline pet**: Cat, age 2, Washington.

| Quantity | Recipe in plain words | Question it answers |
| --- | --- | --- |
| **Overall relativity** | Predict for this pet. Divide by the prediction for the baseline pet. | How expensive is this pet compared with the baseline pet? |
| **Base-risk relativity** | Take the baseline pet. Change its age to 7. Divide by the baseline pet's prediction. | How would the baseline pet's predicted risk change if only its age changed? |
| **ICE** | Take one real pet from the portfolio. Predict for it at age 1, 2, 3, … while leaving everything else about it unchanged. | How would *this* pet's predicted risk change if only its age changed? |
| **Partial dependence** | Do the ICE calculation for every pet in the portfolio. At each age, average the predictions. | Across the portfolio, how would average predicted risk change if every pet had this age? |
| **Partial relativity** | Divide the partial dependence at age 7 by its value at a reference age. | Across the portfolio, by what factor would average predicted risk change if age moved from the reference to 7? |
| **One-way relativity** | Divide the losses of the pets that *are* age 7 by their exposure. Divide that by the same calculation for the pets that *are* age 2. | How do pets that actually are 7 compare with pets that actually are 2? |

The same family, organized by the answer to question 2:

$$
\text{Pick a variable }j
\;\longrightarrow\;
\text{vary }x_j
\;\longrightarrow\;
\text{what do I do with everything else?}
$$

- **Don't single out a variable at all** → overall relativity
- **Hold everything else at the baseline pet** → base-risk relativity
- **Hold everything else at one real pet** → ICE
- **Do that for every real pet, then average** → partial dependence
- **…then divide by a reference value** → partial relativity
- **Let everything else be whatever it is for the pets that actually have that value** → one-way relativity

The last item is different in kind from the others. The first five keep the pets fixed and change a value. The one-way relativity changes *which pets are being compared*. Section 14 explains why that matters.

Here is where the two familiar relativities from Section 1 fit:

- The **one-way relativity** is the last row.
- The **GLM coefficient** $e^{\hat\beta}$ is the common value of the base-risk relativity, every ICE relativity, and the partial relativity when the model has no interactions involving the variable (Section 15). With interactions, these quantities come apart.

**A note on names.** In this guide, "one-way" always means the traditional calculation from the data, which is its standard meaning in ratemaking (it is also called univariate analysis). The model-based calculation that changes one variable on a baseline pet is the **base-risk relativity**. Names in this area are not settled, so when a colleague says "the one-way relativity" or "the age relativity," ask which calculation they mean.

---

# Part II. Building the Framework

## 5. Notation

**Rating variables.** $\mathbf{x} = (x_1, x_2, \ldots, x_p)$ is a complete vector of rating variables, the whole pet. Bold means the whole vector.

**Focal variable.** $j$ is the variable of interest, such as age. $x_j$ is its value, and $x_{-j}$ means *all of the other variables*. We write

$$
\hat\mu(\mathbf{x}) = \hat\mu(x_j, x_{-j}).
$$

This notation does not reorder the variables. It just says "variable $j$ takes this value, and the others take those values."

**Assigned value.** $z$ is a value we *assign* to the focal variable, such as age 7. It is distinct from $x_j$, the value a pet actually has.

**Base risk.** $\mathbf{x}^b = (x^b_1, \ldots, x^b_p)$ is the baseline pet, with one reference value for every variable. $z^b = x^b_j$ is the reference value of the focal variable.

**Portfolio.** Rows $i = 1, \ldots, N$ are the policy terms we average over (Section 20 discusses how to choose them). For row $i$:

- $\mathbf{x}_i$ is the pet's full vector of rating variables,
- $x_{ij}$ is its value of variable $j$,
- $x_{i,-j}$ is its values of all other variables,
- $ee_i$ is its earned exposure, and
- $y_i$ is its observed aggregate loss over the term.

**Model.** $\hat\mu(\mathbf{x})$ is the fitted expected loss per unit exposure (pure premium) for a pet with characteristics $\mathbf{x}$. The target can be eligible loss or paid loss ($\hat\mu_u$ or $\hat\mu_\pi$ in the pricing notation). Everything here applies to either, so the subscript is dropped. For a log-link model, $\hat\mu(\mathbf{x}) = \exp[\hat f(\mathbf{x})]$.

**Rates, not totals.** Throughout this guide, $\hat\mu$ is a **rate**, per pet-year, and exposure enters the formulas only through the weights $ee_i$. The formulas therefore hold whether the model was fit with aggregate loss as the response and an exposure offset, or with the loss rate as the response and exposure weights. The two fits return different things from `predict()`, though: an offset model returns policy totals $ee_i\,\hat\mu$, which already include exposure. Section 23 shows how to convert, and gives the formulas in both forms.

Two symbols are easy to confuse:

$$
\boxed{i = \text{which pet (portfolio row)}}
\qquad
\boxed{z = \text{which value of the focal variable}}
$$

For example, if $j$ is age, then $i$ might be policy term 18347 and $z$ might be age 7.

Every quantity below, except the observed one-way average, is computed from the fitted model. To keep the notation light, those quantities carry no hats.

## 6. The running example

To keep the arithmetic visible, we write the model down directly instead of fitting it. It has three rating variables: species, age, and state.

$$
\hat\mu(\text{species}, \text{age}, \text{state})
= 300 \times S(\text{species}) \times A(\text{age} \mid \text{species}) \times G(\text{state})
$$

| Species | $S$ |
| --- | ---: |
| Cat | 1.0 |
| Dog | 1.5 |

| Age | $A$ for a cat | $A$ for a dog |
| ---: | ---: | ---: |
| 2 | 1.0 | 1.0 |
| 7 | 1.4 | 2.0 |

| State | $G$ |
| --- | ---: |
| WA | 1.0 |
| OR | 0.9 |
| CA | 1.3 |

The age factor depends on species: in this model, a dog's expected cost rises faster with age than a cat's. That dependence is an **interaction** between age and species. State does not interact with anything. The numbers are illustrative, not real.

The portfolio has four pets:

| Pet $i$ | Species | Age | State | $ee_i$ | $\hat\mu(\mathbf{x}_i)$ |
| ---: | --- | ---: | --- | ---: | ---: |
| 1 | Dog | 2 | OR | 1.0 | 405 |
| 2 | Cat | 7 | WA | 0.5 | 420 |
| 3 | Dog | 7 | CA | 1.0 | 1170 |
| 4 | Cat | 2 | CA | 1.0 | 390 |

The baseline pet is **Cat, age 2, WA**, with $\hat\mu = 300$.

## 7. Overall relativity

Define the base rate as the prediction for the baseline pet:

$$
B = \hat\mu(\mathbf{x}^b).
$$

The **overall relativity** of any risk $\mathbf{x}$ is

$$
R(\mathbf{x}) = \frac{\hat\mu(\mathbf{x})}{\hat\mu(\mathbf{x}^b)},
\qquad\text{so}\qquad
\hat\mu(\mathbf{x}) = B\,R(\mathbf{x}).
$$

For a log-link model, $R(\mathbf{x}) = \exp[\hat f(\mathbf{x}) - \hat f(\mathbf{x}^b)]$.

> **Plain language:** How expensive is this pet compared with the baseline pet?

In the example, for pet 3:

$$
R(\text{Dog, 7, CA}) = \frac{\hat\mu(\text{Dog, 7, CA})}{\hat\mu(\text{Cat, 2, WA})} = \frac{1170}{300} = 3.90.
$$

| Pet | 1 | 2 | 3 | 4 |
| --- | ---: | ---: | ---: | ---: |
| $R(\mathbf{x}_i)$ | 1.35 | 1.40 | 3.90 | 1.30 |

Every characteristic in the numerator can differ from the baseline. The overall relativity makes no attempt to separate age from species from state. It compares **one whole pet with another whole pet**.

For the same reason, interactions cause no difficulty here. The model is evaluated at two complete points, and whatever interactions it contains are included in both predictions.

The base sets only the units. Changing the base pet moves $B$ and every $R(\mathbf{x})$ in opposite directions, so their product, the predicted rate, does not change.

## 8. Base-risk relativity

Now we want to isolate one variable $j$. The **base-risk relativity** changes only $x_j$ and holds every other variable at the baseline pet's values:

$$
r_j(z) = \frac{\hat\mu(z,\, x^b_{-j})}{\hat\mu(z^b,\, x^b_{-j})} = \frac{\hat\mu(z,\, x^b_{-j})}{\hat\mu(\mathbf{x}^b)}.
$$

> **Plain language:** How would the baseline pet's predicted risk change if only this one variable changed?

To get the base-risk relativity for age 7, start from the baseline pet (Cat, 2, WA), change only its age, and compare:

$$
r_{\text{age}}(7) = \frac{\hat\mu(\text{Cat, 7, WA})}{\hat\mu(\text{Cat, 2, WA})} = \frac{420}{300} = 1.40.
$$

The same procedure gives $r_{\text{species}}(\text{Dog}) = 450/300 = 1.50$, $r_{\text{state}}(\text{OR}) = 0.90$, and $r_{\text{state}}(\text{CA}) = 1.30$.

Base-risk relativities are what a multiplicative rate table lists. In a log-link GLM whose baseline pet sits at the reference levels, they are the exponentiated coefficients $e^{\hat\beta}$. If the model has no interactions, multiplying them reproduces every overall relativity exactly:

$$
R(\mathbf{x}) = \prod_j r_j(x_j) \qquad \text{(no interactions)}.
$$

## 9. What interactions do to base-risk relativities

An interaction between age and species means that **the effect of age depends on species**. In the example, moving from age 2 to age 7 multiplies a cat's expected cost by 1.4 and a dog's by 2.0.

Interactions are always mutual. If the effect of age depends on species, then the effect of species depends on age: a dog costs 1.5 times as much as a cat at age 2, but $900/420 = 2.14$ times as much at age 7.

Interactions have three consequences for base-risk relativities.

**First, the base-risk relativity depends on the baseline pet.** With a cat as the baseline, $r_{\text{age}}(7) = 1.40$. With a dog as the baseline, it is $\hat\mu(\text{Dog, 7, WA}) / \hat\mu(\text{Dog, 2, WA}) = 900/450 = 2.00$. Neither number is wrong. Each is the age relativity *for its baseline pet*. The reported "age relativity" therefore depends on a choice about species that has nothing to do with age.

**Second, multiplying base-risk relativities no longer reproduces predictions.** For pet 3:

$$
r_{\text{species}}(\text{Dog}) \times r_{\text{age}}(7) \times r_{\text{state}}(\text{CA}) = 1.5 \times 1.4 \times 1.3 = 2.73,
\qquad\text{but}\qquad
R(\mathbf{x}_3) = 3.90.
$$

We can always write

$$
R(\mathbf{x}) = \Big[\prod_j r_j(x_j)\Big]\, I(\mathbf{x}),
$$

where $I(\mathbf{x})$ is the part of the overall relativity that the base-risk relativities cannot reconstruct. For pet 3, $I = 3.90 / 2.73 = 1.43$. That is exactly the dog's extra aging compared with the cat baseline, $2.0 / 1.4$. For pet 1 (Dog, 2, OR), $I = 1$: the dog is still at the base age, so the interaction never comes into play. An interaction contributes only when both of its partners move away from the base. In a rate table, $I(\mathbf{x})$ appears as a two-way table, such as species by age.

**Third, "the age relativity" stops being a single number.** Age has a relativity in each context, meaning for each combination of the other variables. The rest of Part II is about which contexts to use and how to summarize across them.

### A note on scale

"No interaction" here means the model factors multiplicatively, which is the same as being additive on the log scale. A model that is additive on the log scale has interactions on the dollar scale automatically: a 40% increase is more dollars for an expensive pet than for a cheap one. Relativities are multiplicative, so the multiplicative scale is the relevant one. In this guide, "interaction" always means an interaction on that scale.

## 10. ICE: one real pet at a time

The base-risk relativity evaluates the focal variable in the context of a hypothetical baseline pet. The obvious alternative is to use real pets instead.

For portfolio row $i$, the **individual conditional expectation (ICE)** curve is

$$
ICE_{ij}(z) = \hat\mu(z,\, x_{i,-j}).
$$

Pet $i$ keeps all of its other characteristics, and only the focal variable is set to $z$. Normalizing at the reference value gives the pet's **ICE relativity**:

$$
r_{ij}(z) = \frac{\hat\mu(z,\, x_{i,-j})}{\hat\mu(z^b,\, x_{i,-j})}.
$$

> **Plain language:** Take this particular pet. How would its predicted risk change if only this one variable changed?

For age in the example:

| Pet | Others held at | $ICE_{i,\text{age}}(2)$ | $ICE_{i,\text{age}}(7)$ | $r_{i,\text{age}}(7)$ |
| ---: | --- | ---: | ---: | ---: |
| 1 | Dog, OR | 405 | 810 | 2.00 |
| 2 | Cat, WA | 300 | 420 | 1.40 |
| 3 | Dog, CA | 585 | 1170 | 2.00 |
| 4 | Cat, CA | 390 | 546 | 1.40 |

Every pet gets its own curve. Three features of this table are worth noticing.

- **The predictions differ by state, but the relativities do not.** Pets 1 and 3 are both dogs with different states, and both have ICE relativity 2.00. State does not interact with age, so it scales a pet's curve up or down without changing its shape.
- **The relativities differ by species.** Species interacts with age, so the dogs' curves rise more steeply than the cats'.
- **The base-risk relativity is the ICE relativity of the baseline pet.** The calculation is identical; only the starting pet differs:

$$
\text{base-risk: } \hat\mu(z,\, x^b_{-j})
\qquad\text{vs.}\qquad
\text{ICE: } \hat\mu(z,\, x_{i,-j}).
$$

That makes ICE a direct picture of interactions. If the focal variable interacts with nothing, every pet's ICE relativity curve is the same curve. When it does interact, the curves fan out, and the way they spread shows which pets the variable affects differently.

## 11. Partial dependence: average over the portfolio

ICE gives one curve per pet. **Partial dependence** summarizes them by averaging the predictions across the portfolio at each value $z$. Our predictions are per unit exposure, so we weight by earned exposure:

$$
PD_j(z) = \frac{\sum_{i=1}^N ee_i\,\hat\mu(z,\, x_{i,-j})}{\sum_{i=1}^N ee_i} = \frac{\sum_i ee_i\, ICE_{ij}(z)}{\sum_i ee_i}.
$$

The exposure-weighted average is the average over **pet-years** in the portfolio, not over policy rows. Setting every $ee_i = 1$ gives the unweighted version found in most machine-learning software.

> **Plain language:** Across the portfolio, how would the average predicted risk change if every pet were assigned this value?

To compute $PD_{\text{age}}(7)$, build a counterfactual copy of the portfolio in which every pet is age 7 and nothing else changes:

| Pet | Species | Age | State | $ee_i$ | $\hat\mu(7,\, x_{i,-\text{age}})$ |
| ---: | --- | ---: | --- | ---: | ---: |
| 1 | Dog | **7** | OR | 1.0 | 810 |
| 2 | Cat | **7** | WA | 0.5 | 420 |
| 3 | Dog | **7** | CA | 1.0 | 1170 |
| 4 | Cat | **7** | CA | 1.0 | 546 |

$$
PD_{\text{age}}(7) = \frac{810 + 0.5(420) + 1170 + 546}{3.5} = \frac{2736}{3.5} = 781.71.
$$

Doing the same with every pet set to age 2 gives

$$
PD_{\text{age}}(2) = \frac{405 + 0.5(300) + 585 + 390}{3.5} = \frac{1530}{3.5} = 437.14.
$$

Several points are easy to get wrong.

**This is a question about the model, not about real pets.** Nobody claims these pets are age 7. The question is: *what would the model predict if this portfolio were age 7, with everything else about it unchanged?*

**The pets and the exposure weights are the same at every $z$.** The $ee_i$ are the original exposures of the original rows. They are not recomputed for each age, and they are not "the exposure of age-7 pets." The portfolio is held fixed on purpose, so that the only thing changing between $PD(2)$ and $PD(7)$ is the age the model sees.

**Categorical and continuous variables work the same way.** For species, set every row to Dog, predict, and average; then do the same for Cat. For age, choose a grid of values $z_1, \ldots, z_K$ and do the same at each one. In short:

$$
\boxed{\text{a grid over } x_j; \quad \text{an empirical average over the portfolio's } x_{-j}}
$$

For a categorical variable, the levels are the natural grid.

**PD is a prediction, not an effect.** $PD_j(z)$ is in dollars per pet-year. It becomes an effect or a relativity only when you compare two of its values (Section 16).

## 12. Partial relativity

To express partial dependence as a relativity, divide by its value at a reference value $z^b$:

$$
\bar r_j(z) = \frac{PD_j(z)}{PD_j(z^b)}
= \frac{\sum_i ee_i\,\hat\mu(z,\, x_{i,-j})}{\sum_i ee_i\,\hat\mu(z^b,\, x_{i,-j})}.
$$

The bar is a reminder that this relativity has been averaged over the portfolio. Section 13 shows that it is, in fact, a weighted average of the pets' ICE relativities.

> **Plain language:** For this same portfolio, by what factor would average predicted risk change if this one variable moved from its reference value to $z$?

In the example:

$$
\bar r_{\text{age}}(7) = \frac{781.71}{437.14} = \frac{2736}{1530} = 1.79.
$$

Compare the structure of the three relativities:

| Relativity | Numerator vs. denominator | Plain language |
| --- | --- | --- |
| Overall $R(\mathbf{x})$ | $\mathbf{x}$ vs. $\mathbf{x}^b$: every variable can differ | This whole pet vs. the whole baseline pet |
| Base-risk $r_j(z)$ | $(z, x^b_{-j})$ vs. $(z^b, x^b_{-j})$: only $x_j$ differs | Change one variable, for the baseline pet |
| Partial $\bar r_j(z)$ | $\{(z, x_{i,-j})\}_{i}$ vs. $\{(z^b, x_{i,-j})\}_{i}$: only $x_j$ differs | Change one variable, for the same whole portfolio |

Base-risk and partial relativities have the same structure. In both, only $x_j$ differs between numerator and denominator. The difference is the context:

$$
\begin{aligned}
\text{Base-risk:}\quad & X_j = z, \quad X_{-j} = x^b_{-j} && \text{(one context: the baseline pet)} \\
\text{Partial:}\quad & X_j = z, \quad X_{-j} \sim \text{portfolio} && \text{(every context, weighted as in the book)}
\end{aligned}
$$

The partial relativity no longer depends on an arbitrary choice of a whole baseline pet. It still needs a reference value for the focal variable itself, and Section 19 shows how to avoid even that.

## 13. Partial relativity as a weighted vote of the pets

The partial relativity has a second reading that connects it directly to ICE. Multiply and divide each term by $\hat\mu(z^b, x_{i,-j})$:

$$
\bar r_j(z)
= \frac{\sum_i ee_i\,\hat\mu(z^b, x_{i,-j}) \cdot r_{ij}(z)}{\sum_k ee_k\,\hat\mu(z^b, x_{k,-j})}
= \sum_i \omega_i\, r_{ij}(z),
\qquad
\omega_i = \frac{ee_i\,\hat\mu(z^b, x_{i,-j})}{\sum_k ee_k\,\hat\mu(z^b, x_{k,-j})}.
$$

**The partial relativity is a weighted average of the pets' ICE relativities.** Each pet's weight is its exposure times its predicted cost at the reference value, which is its share of expected dollars.

In the example, the weights at the reference age 2 are $405, 150, 585, 390$ out of $1530$. The dogs (pets 1 and 3) hold 65% of the weight and the cats hold 35%:

$$
\bar r_{\text{age}}(7) = 0.65 \times 2.00 + 0.35 \times 1.40 = 1.79.
$$

This reading explains three things.

- **Where the number lands.** The partial relativity always lies between the smallest and largest ICE relativity. Here it falls between the cats' 1.40 and the dogs' 2.00, nearer the dogs because dogs carry more exposure and cost more per pet-year.
- **What it summarizes.** It is the relativity of *expected dollars*: how much the book's total expected loss would change. That is why it is the natural summary for risk, and it carries straight through to pricing.
- **Why it differs from a plain average of ICE relativities.** Weighting by exposure alone gives dogs 57% and cats 43%, which yields 1.74 instead of 1.79. The two answer slightly different questions. Section 22 compares them.

## 14. One-way relativity: the comparison we used to make

Now compare all of this with the traditional calculation from Section 1. Let $S_j(z) = \{i : x_{ij} = z\}$ be the pets that *actually have* value $z$. For a continuous variable, use a bin around $z$.

The observed **one-way average** is the actual pure premium for that group, and the **one-way relativity** compares two such groups:

$$
\bar y_j(z) = \frac{\sum_{i \in S_j(z)} y_i}{\sum_{i \in S_j(z)} ee_i},
\qquad
m_j(z) = \frac{\bar y_j(z)}{\bar y_j(z^b)}.
$$

To see what the one-way relativity measures, replace each pet's actual loss with the model's prediction for it. That gives the model-based one-way average for the same group:

$$
M_j(z) = \frac{\sum_{i \in S_j(z)} ee_i\,\hat\mu(\mathbf{x}_i)}{\sum_{i \in S_j(z)} ee_i}.
$$

If the model is right, $\bar y_j(z)$ scatters around $M_j(z)$, so $M_j(z) / M_j(z^b)$ is the one-way relativity with the noise removed. The example has no actual losses, so it uses $M_j$. We write $m_j$ for the ratio either way.

> **Plain language:** How do the pets that actually have this value compare with the pets that actually have the reference value?

In the example, the age-2 pets are pets 1 and 4, and the age-7 pets are pets 2 and 3:

$$
M_{\text{age}}(2) = \frac{405 + 390}{2.0} = 397.50,
\qquad
M_{\text{age}}(7) = \frac{0.5(420) + 1170}{1.5} = 920.00,
\qquad
m_{\text{age}}(7) = 2.31.
$$

The one-way relativity is **larger than every pet's ICE relativity**. No pet in this model has its cost multiplied by more than 2.00 when it ages from 2 to 7, yet the one-way comparison shows 2.31. The reason is that the age-7 group is a different set of pets: two-thirds of its exposure is dogs, and two-thirds is in California, while the age-2 group is half dogs and includes a cheap Oregon pet. The one-way relativity mixes these species and state differences into the age comparison.

The key contrast:

$$
\begin{aligned}
\text{Partial dependence:}\quad & \text{keep the pets the same, change the value of } x_j. \\
\text{One-way average:}\quad & \text{keep the value the same, change which pets are compared.}
\end{aligned}
$$

$PD_{\text{age}}(2)$ uses all four pets set to age 2. $M_{\text{age}}(2)$ uses only pets 1 and 4.

The one-way calculation remains valuable as a **model check**. Plotting $\bar y_j(z)$ and $M_j(z)$ by level is the familiar actual-versus-fitted chart, and their ratio $\bar y_j(z) / M_j(z)$ is the A/E for the group $S_j(z)$. A large gap means the model is missing something about pets at that level. What the chart does not show is the effect of the variable itself.

## 15. Interactions, revisited

With every quantity defined, here are all the answers to "what is the age-7 relativity?" for the example:

| Quantity | Age 7 vs. age 2 |
| --- | ---: |
| Base-risk, cat baseline | 1.40 |
| Base-risk, dog baseline | 2.00 |
| ICE, each cat | 1.40 |
| ICE, each dog | 2.00 |
| Partial relativity | 1.79 |
| One-way relativity (from the data) | 2.31 |

Two different forces produce this spread.

**Interactions** make the effect of $x_j$ depend on the other variables. They separate the model-based quantities from one another: base-risk relativities from different baselines, ICE relativities of different pets, and partial relativities over different portfolios.

**Correlation**, meaning which other characteristics tend to come with $x_j$ in the book, separates the one-way relativity from all the others. Base-risk, ICE, and partial relativities never change which pets are compared, so correlation does not enter them. (Part III notes one indirect way it does matter.)

### The special case: no interactions

Suppose $x_j$ interacts with nothing, so the model factors as $\hat\mu(z, x_{-j}) = g_j(z)\,h(x_{-j})$. Then every model-based relativity is the same number:

$$
r_j(z) = r_{ij}(z) = \bar r_j(z) = \frac{g_j(z)}{g_j(z^b)}
\quad\text{for every baseline pet, every pet } i\text{, and every portfolio.}
$$

In a main-effects GLM, this common value is $e^{\hat\beta}$. That is why the classic literature never needed to tell these quantities apart.

The one-way relativity can still differ. Change the example so that dogs age like cats (factor 1.4 for both). Then the base-risk, ICE, and partial relativities all equal 1.40, but the one-way relativity is $686.00 / 397.50 = 1.73$. That gap is pure correlation. It is the double counting described in Section 1, and the reason multivariate models replaced one-way analysis.

### What a single summary costs

Under interactions, the partial relativity is a weighted average over contexts (Section 13), so it depends on the portfolio's mix. If the book shifted toward dogs, the partial age relativity would move toward 2.00. That is not a flaw. It is what summarizing a non-constant effect with one number has to mean. But it does mean a partial relativity is a summary of **a particular portfolio**, and it should be reported that way.

When interactions are important, report more than the headline number:

- the **partial relativity**, as the portfolio-level summary;
- the **spread of ICE relativities**, or partial relativities computed within subgroups (for example, separately for dogs and cats), to show how much the effect varies; and
- for a rate table, the **interaction tables** themselves, because neither base-risk nor partial relativities multiply back to predictions.

## 16. Predictions, relativities, and "effects"

Two separate decisions go into every quantity in this guide:

1. **How do I construct the prediction?** At the baseline pet, at one real pet, or averaged over the portfolio.
2. **How do I compare predictions?** Not at all (keep the prediction), by a difference, or by a ratio.

$ICE_{ij}(z)$ and $PD_j(z)$ are predictions, in dollars per pet-year. Neither is an "effect" until it is compared with something:

$$
PD_j(z_1) - PD_j(z_0) \quad \text{(an additive effect, in dollars)},
\qquad
\frac{PD_j(z_1)}{PD_j(z_0)} \quad \text{(a relativity)}.
$$

So avoid describing a PD curve as "the effect of $x_j$ averaged across the portfolio." It is the *average prediction* as a function of $x_j$. Keeping the two decisions separate prevents several similar-looking objects from being confused with one another.

## 17. The whole system on one page

| Quantity | Symbol | Formula | What happens to $x_j$ | What happens to $x_{-j}$ | Output |
| --- | --- | --- | --- | --- | --- |
| Overall relativity | $R(\mathbf{x})$ | $\hat\mu(\mathbf{x}) / \hat\mu(\mathbf{x}^b)$ | Not singled out | Not singled out: the whole pet changes | Ratio |
| Base-risk relativity | $r_j(z)$ | $\hat\mu(z, x^b_{-j}) / \hat\mu(\mathbf{x}^b)$ | Set to $z$ | Held at the baseline pet | Ratio |
| ICE | $ICE_{ij}(z)$ | $\hat\mu(z, x_{i,-j})$ | Set to $z$ | Held at real pet $i$ | Prediction |
| ICE relativity | $r_{ij}(z)$ | $ICE_{ij}(z) / ICE_{ij}(z^b)$ | Set to $z$ | Held at real pet $i$ | Ratio |
| Partial dependence | $PD_j(z)$ | $\sum_i ee_i\, ICE_{ij}(z) / \sum_i ee_i$ | Set to $z$ for every pet | Each pet keeps its own; then average | Prediction |
| Partial relativity | $\bar r_j(z)$ | $PD_j(z) / PD_j(z^b)$ | Set to $z$ for every pet | Each pet keeps its own; then average | Ratio |
| One-way average | $\bar y_j(z)$, $M_j(z)$ | Average over pets with $x_{ij} = z$ | Not assigned: select pets that have $z$ | Whatever those pets have | Actual or prediction |
| One-way relativity | $m_j(z)$ | $\bar y_j(z) / \bar y_j(z^b)$ | Not assigned | Whatever those pets have | Ratio |

The model-based quantities form two parallel paths:

$$
\text{ICE predictions}
\;\xrightarrow{\text{average over pets}}\;
\text{partial dependence}
\;\xrightarrow{\text{normalize}}\;
\text{partial relativity}
$$

$$
\text{prediction at } (z, x^b_{-j})
\;\xrightarrow{\text{normalize}}\;
\text{base-risk relativity}
$$

In words: **a base-risk relativity evaluates a variable in one context. A partial relativity averages it over the portfolio's contexts.** ICE is the machinery underneath both, and without interactions both reduce to the GLM coefficient. The overall relativity answers a different question, comparing whole pets. The one-way relativity is the odd one out: it compares different groups of pets rather than changing a value for the same pets.

---

# Part III. Practice and Limitations

## 18. Which quantity for which job

| Job | Use | Why |
| --- | --- | --- |
| Compare a specific pet with the base or the book | $\hat\mu(\mathbf{x})$ or $R(\mathbf{x})$ | Exact for any model, interactions included |
| Express the model as multiplicative tables | Base-risk relativities plus interaction tables | The interaction tables carry $I(\mathbf{x})$; base-risk relativities alone don't reproduce predictions |
| Explain what the model says about a variable across the book | Partial relativity | Removes the arbitrary baseline pet; weights contexts by expected dollars |
| Show how much a variable's effect varies | ICE relativities, or partial relativities within subgroups | Makes interactions visible |
| Check the model against the data | One-way: $\bar y_j(z)$ vs. $M_j(z)$ | Actual vs. fitted by level is A/E for each level |
| Compare relativities with the current manual | Whatever the manual uses, usually base-risk relativities at the manual's base | Like-for-like comparison |

Partial relativities are for explanation and comparison. They are not rating factors. Multiplying partial relativities across variables does not reproduce predictions, any more than multiplying base-risk relativities does when there are interactions.

## 19. Choosing the base and reference values

**Overall relativity.** The base sets only the units; predictions are unchanged by it (Section 7). The default is the **portfolio average**,

$$
\bar\mu = \frac{\sum_i ee_i\,\hat\mu(\mathbf{x}_i)}{\sum_i ee_i},
\qquad
R(\mathbf{x}) = \frac{\hat\mu(\mathbf{x})}{\bar\mu},
$$

so that $R(\mathbf{x})$ reads as "this pet relative to the average pet-year in the book." In the example, $\bar\mu = 2175 / 3.5 = 621.43$.

**Partial relativity.** The default is again the portfolio average. Normalize the PD curve by its exposure-weighted average over the values the pets actually have:

$$
c_j = \frac{\sum_i ee_i\, PD_j(x_{ij})}{\sum_i ee_i},
\qquad
\bar r_j(z) = \frac{PD_j(z)}{c_j}.
$$

The exposure-weighted average of $\bar r_j$ over the book is then 1. This is the same calculation as the familiar off-balance factor: the exposure-weighted average relativity, divided out so the book averages 1. In the example, $c_{\text{age}} = 584.82$, so $\bar r_{\text{age}}(2) = 0.75$ and $\bar r_{\text{age}}(7) = 1.34$. Their ratio is still 1.79; only the reference changed. A related choice is to divide by $\bar\mu$ instead, which reads as "if every pet had value $z$, how would the book's average compare with what it is now?" In the example, that is $781.71 / 621.43 = 1.26$ for age 7.

**Base-risk relativity.** A complete baseline pet is unavoidable here; that is the weakness partial relativities remove.

**Natural bases.** Some variables have a meaningful reference level of their own: a standard deductible, annual limit, or copay, or the most common coverage level or plan. When a level like that exists, especially one the current rate manual already uses, use it. Whatever the choice, avoid thinly populated levels as references, because every relativity inherits the reference level's noise.

## 20. Choosing the portfolio

**Book versus portfolio.** *Book of business* is the insurance term for the policies a company has written, usually within a line or program: "the pet book," "the renewal book." *Portfolio* is the more general term from finance and risk theory: any collection of risks considered together. In conversation they are mostly interchangeable. In this guide, *portfolio* means specifically **the set of rows we average over**, which need not be the whole book.

Choosing it is a real decision. Reasonable choices include:

- the experience-period data the model was fit on;
- the current in-force book;
- recent new business, if the mix is shifting; or
- a single state, for a state filing.

Without interactions, the choice does not matter: every portfolio gives the same partial relativity (Section 15). With interactions, it does matter, because the partial relativity is a weighted vote of the pets and different portfolios have different voters. Choose the portfolio whose mix matches the question, and state which one you used.

## 21. Impossible and implausible counterfactuals

Partial dependence and ICE assign a value to every pet regardless of whether that combination makes sense. The model will return a number either way.

**Impossible combinations.** Breed is nested within species. Computing $PD_{\text{species}}(\text{Cat})$ by setting species to Cat on a row whose breed is Labrador asks the model about a Labrador cat. Whatever the model returns is meaningless. Options:

- **Vary nested variables together.** Treat species and breed as one focal variable, so that assigning a breed also assigns its species.
- **Restrict the portfolio.** Compute partial relativities for age separately within dogs and within cats. This also displays the interaction directly.

**Implausible combinations.** Age 15 for a giant breed that rarely lives that long, or a plan option that isn't sold at some enrollment ages, is possible but rare. The model is extrapolating into regions with little or no data, and its predictions there deserve little trust.

This is where correlation re-enters, indirectly (Section 15). When $x_j$ is strongly correlated with other variables, assigning it to every pet creates many such combinations. Practical safeguards:

- Restrict the grid to values with real exposure behind them, and show an exposure histogram under every PD or ICE plot.
- Check exposure for the combinations of $z$ with the focal variable's main interaction partners.
- For continuous variables with strong correlations, consider **accumulated local effects (ALE)** (Apley and Zhu, 2020). ALE avoids unrealistic combinations by making only small changes within local neighborhoods of the data. It is not covered here.

## 22. Three ways to average relativities

When ICE relativities differ across pets, there are at least three reasonable ways to combine them into one number:

| Method | Formula | Weights on $r_{ij}$ | Example |
| --- | --- | --- | ---: |
| Ratio of averages (partial relativity) | $\dfrac{\sum_i ee_i\,\hat\mu(z, x_{i,-j})}{\sum_i ee_i\,\hat\mu(z^b, x_{i,-j})}$ | exposure × predicted cost at $z^b$ | 1.79 |
| Arithmetic average of ICE relativities | $\dfrac{\sum_i ee_i\, r_{ij}(z)}{\sum_i ee_i}$ | exposure | 1.74 |
| Geometric average of ICE relativities | $\exp\!\left[\dfrac{\sum_i ee_i \log r_{ij}(z)}{\sum_i ee_i}\right]$ | exposure, on the log scale | 1.72 |

The geometric average is what you get by computing partial dependence on the **link (log) scale** and exponentiating the difference. Some software does this by default for GLMs and GAMs, so check which scale your tool averages predictions on.

The geometric average is never larger than the arithmetic one. The ratio of averages can fall on either side of them, depending on whether expensive pets have larger or smaller relativities. Without interactions with $x_j$, all three are equal.

This guide uses the ratio of averages because it answers a dollar question: by what factor would the **total expected loss of the same book** change? That is the quantity that adds up across the book, and the one that eventually flows through to premium. The other two answer "how does the typical pet's relativity change," with each pet-year counted equally regardless of its cost.

## 23. Offset or weights: which form the formulas assume

Every formula in this guide is written in terms of the **rate** $\hat\mu(\mathbf{x})$, the expected loss per pet-year, with exposure appearing only as the weight $ee_i$. A Tweedie GAM can be fit to produce that rate in two ways, and `predict()` returns different things for each.

| | Offset model | Rate model |
| --- | --- | --- |
| Response | aggregate loss $y_i$ | loss rate $y_i / ee_i$ |
| How exposure enters | `offset(log(ee))` in the formula | `weights = ee` |
| What the model says | $E[y_i] = ee_i\,\mu(\mathbf{x}_i)$ | $E[y_i / ee_i] = \mu(\mathbf{x}_i)$ |
| `predict(type = "response")` returns | the policy total $ee_i\,\hat\mu(\mathbf{x}_i)$, using the `ee` column of `newdata` | the rate $\hat\mu(\mathbf{x}_i)$; weights play no part in prediction |
| To get the rate $\hat\mu$ | set `ee = 1` in `newdata` | use the prediction as is |
| To get a policy total | use the prediction as is | multiply by $ee_i$ |

Both approaches estimate the same function $\mu(\mathbf{x})$. They are not quite the same fit, because they imply different variances for partial-year policies. The pricing notation document works through this and shows that adding `weights = ee^(xi - 1)` to the offset model makes the two fits identical. Nothing in this guide depends on which approach you choose. What matters is knowing whether a prediction already includes exposure.

### The same formulas in total form

With an offset model, it is often convenient to work directly with predicted policy totals. Write

$$
\hat y_i = ee_i\,\hat\mu(\mathbf{x}_i),
\qquad
\hat y_i(z) = ee_i\,\hat\mu(z,\, x_{i,-j})
$$

for the expected aggregate loss of row $i$: as it is, and with the focal variable set to $z$. Each row keeps its own exposure. This is exactly what an offset model's `predict()` returns on the data or on a counterfactual copy of it. The exposure-weighted formulas then simplify, because the weight $ee_i$ is already inside each prediction:

| Quantity | Rate form (as written in this guide) | Total form |
| --- | --- | --- |
| Partial dependence $PD_j(z)$ | $\dfrac{\sum_i ee_i\,\hat\mu(z, x_{i,-j})}{\sum_i ee_i}$ | $\dfrac{\sum_i \hat y_i(z)}{\sum_i ee_i}$ |
| Partial relativity $\bar r_j(z)$ | $\dfrac{\sum_i ee_i\,\hat\mu(z, x_{i,-j})}{\sum_i ee_i\,\hat\mu(z^b, x_{i,-j})}$ | $\dfrac{\sum_i \hat y_i(z)}{\sum_i \hat y_i(z^b)}$ |
| ICE relativity $r_{ij}(z)$ | $\dfrac{\hat\mu(z, x_{i,-j})}{\hat\mu(z^b, x_{i,-j})}$ | $\dfrac{\hat y_i(z)}{\hat y_i(z^b)}$, since exposure cancels |
| Model-based one-way average $M_j(z)$ | $\dfrac{\sum_{i \in S_j(z)} ee_i\,\hat\mu(\mathbf{x}_i)}{\sum_{i \in S_j(z)} ee_i}$ | $\dfrac{\sum_{i \in S_j(z)} \hat y_i}{\sum_{i \in S_j(z)} ee_i}$ |
| Observed one-way average $\bar y_j(z)$ | $\dfrac{\sum_{i \in S_j(z)} ee_i\,(y_i / ee_i)}{\sum_{i \in S_j(z)} ee_i}$ | $\dfrac{\sum_{i \in S_j(z)} y_i}{\sum_{i \in S_j(z)} ee_i}$ |

The total form of the partial relativity says in symbols what Section 13 said in words: it is the ratio of the book's total expected loss under two values of the focal variable.

Quantities built on a single hypothetical pet, such as the overall and base-risk relativities, have no row exposure to keep. Compute them from rates, which for an offset model means predicting with `ee = 1`.

### Mistakes to avoid

- **Counting exposure twice (offset model).** Weighting offset-model predictions by $ee_i$ computes $\sum_i ee_i^2\,\hat\mu_i / \sum_i ee_i$. That averages policy totals instead of rates, and long policies get too much say. Either predict with `ee = 1` and then weight by $ee_i$, or keep each row's own exposure in the prediction and don't weight again.
- **Leaving exposure out (rate model).** A plain average of rate-model predictions counts every policy row equally, so a six-month policy counts as much as a full year. Weight by $ee_i$.
- **Treating a ratio of totals as a relativity.** A six-month policy's expected total is half of a full-year policy's with the same rate, so a ratio of two policies' totals mixes exposure into the comparison. Relativities always compare rates.

A quick way to see what a fitted model returns: predict one row twice, once with `ee = 1` and once with `ee = 0.5`. If the prediction halves, `predict()` returns policy totals, as an offset model does. If it doesn't change, it returns rates. That is the case for a rate model, and also for an offset supplied through the `offset =` argument, which `predict()` ignores.

## 24. Computing them

The recipe is the same for every model-based quantity:

1. Copy the portfolio.
2. Set the focal variable to $z$ on every row (for base-risk, on the baseline pet only).
3. Predict the **rate per unit exposure** on the response scale. For an offset model, set `ee = 1` in the copy before predicting; a rate model's prediction is already the rate (Section 23).
4. Weight by the **original** exposures and average.
5. Repeat for each $z$ on the grid, then normalize if you want relativities.

A minimal version in R:

```r
# Exposure-weighted partial dependence of `model` on `var`, over values `grid`.
# Works for an offset model or a rate model (Section 23): an offset model needs
# ee = 1 to return the rate, and a rate model ignores ee when predicting.
partial_dependence <- function(model, data, var, grid) {
  sapply(grid, function(z) {
    cf <- data
    cf[[var]][] <- z     # assign z to every row; keeps factor levels for categoricals
    cf$ee <- 1           # predict the rate per pet-year, not the policy total
    mu <- predict(model, newdata = cf, type = "response")
    sum(data$ee * mu) / sum(data$ee)
  })
}

ages <- 0:15
pd   <- partial_dependence(m, dat, "age", ages)
rbar <- pd / pd[ages == 2]                                          # reference age 2
rbar_book <- pd / weighted.mean(pd[match(dat$age, ages)], dat$ee)   # portfolio-average reference
```

Practical notes:

- **Cost.** PD needs $N \times K$ predictions for $N$ rows and $K$ grid values. That is cheap for GLMs and GAMs. For very large portfolios, an exposure-weighted random subsample of rows gives nearly the same curve.
- **Grids.** For continuous variables, use natural units (each year of age) or quantiles of the observed values, and trim the tails where exposure is thin.
- **ICE plots.** Plot ICE relativities $r_{ij}(z)$ on a log scale for a few hundred sampled pets, colored by a suspected interaction partner. A fan of curves that separates by color shows the interaction.
- **Packages.** In R, `marginaleffects` (average predictions over counterfactual grids, with weights), `pdp`, `iml`, and `DALEX` all compute PD and ICE. Check how each handles exposure weights, offsets, and the prediction scale (Section 22) before relying on its defaults.

## 25. Beyond one variable

Everything above generalizes from one focal variable $j$ to a set of variables, such as species and age together. Replace $x_j$ by the pair, assign both values to every pet, and average:

$$
PD_{\text{species, age}}(s, a) = \frac{\sum_i ee_i\,\hat\mu(s, a, x_{i,-\{\text{species, age}\}})}{\sum_i ee_i}.
$$

The result is a two-way table, which is the natural way to display an interaction across the portfolio. Comparing a two-way PD with the product of the two single-variable partial relativities measures how strong the interaction is; this is the idea behind Friedman's H-statistic.

---

# Appendix A. Notation

| Symbol | Meaning |
| --- | --- |
| $\mathbf{x} = (x_1, \ldots, x_p)$ | full vector of rating variables (a whole pet) |
| $j$ | focal rating variable |
| $x_j$, $x_{-j}$ | value of the focal variable; values of all other variables |
| $z$ | a value assigned to the focal variable |
| $\mathbf{x}^b$, $z^b$ | baseline pet; reference value of the focal variable |
| $i = 1, \ldots, N$ | portfolio row (policy term) |
| $\mathbf{x}_i$, $x_{ij}$, $x_{i,-j}$ | row $i$'s full vector; its focal value; its other values |
| $ee_i$ | earned exposure of row $i$ |
| $y_i$ | observed aggregate loss of row $i$ |
| $\hat y_i$, $\hat y_i(z)$ | expected aggregate loss of row $i$, $ee_i\,\hat\mu$: as it is, and with $x_j$ set to $z$ (Section 23) |
| $\hat\mu(\mathbf{x})$ | fitted expected loss per unit exposure; $\hat\mu = e^{\hat f}$ for a log link |
| $B = \hat\mu(\mathbf{x}^b)$ | base rate |
| $\bar\mu$ | exposure-weighted average prediction over the portfolio |
| $R(\mathbf{x})$ | overall relativity |
| $r_j(z)$ | base-risk relativity |
| $I(\mathbf{x})$ | interaction factor: $R(\mathbf{x}) / \prod_j r_j(x_j)$ |
| $ICE_{ij}(z)$, $r_{ij}(z)$ | ICE prediction and ICE relativity for row $i$ |
| $PD_j(z)$ | exposure-weighted partial dependence |
| $\bar r_j(z)$ | partial relativity |
| $\omega_i$ | weight of row $i$ in the partial relativity (Section 13) |
| $c_j$ | portfolio-average reference for partial relativities (Section 19) |
| $S_j(z)$ | rows whose actual value of $x_j$ is $z$ |
| $\bar y_j(z)$, $M_j(z)$, $m_j(z)$ | observed one-way average; model-based one-way average; one-way relativity |

# Appendix B. Standard Names and References

| This guide | Names you will see elsewhere |
| --- | --- |
| Overall relativity $R(\mathbf{x})$ | relativity; total relativity; product of rating factors |
| Base-risk relativity $r_j(z)$ | GLM relativity; rating factor; $e^{\hat\beta}$ in a GLM (with interactions, a main-effect coefficient is the relativity at the base levels of its interaction partners) |
| ICE $ICE_{ij}(z)$ | individual conditional expectation curve (Goldstein et al.) |
| ICE relativity $r_{ij}(z)$ | the multiplicative version of a *centered* ICE (c-ICE) curve |
| Partial dependence $PD_j(z)$ | partial dependence (Friedman); average counterfactual predictions (`marginaleffects`) |
| Partial relativity $\bar r_j(z)$ | no standard name; normalized partial dependence |
| One-way $\bar y_j$, $M_j$, $m_j$ | one-way or univariate analysis (ratemaking); M-plot (Apley and Zhu); the actual and fitted lines of an actual-vs-fitted chart |

The machine-learning literature usually writes the focal set as $S$ and its complement as $C$. Partial dependence there is $\hat f_S(x_S) = \frac{1}{n}\sum_i \hat f(x_S, x_C^{(i)})$, and ICE curves are $\hat f_S^{(i)}$. This guide writes $\hat\mu$ explicitly because what we average is expected dollars, not an abstract score. There is no standard symbol for a partial relativity.

**A caution about "marginal."** The word is used in opposite senses. Apley and Zhu's "marginal plot" (M-plot) is the *conditional* average used in one-way analysis. Econometric "marginal effects" are derivatives or differences of predictions. In probability, a "marginal" distribution is what partial dependence averages over. This guide avoids the word.

**References**

- Apley, D. W., and Zhu, J. (2020). Visualizing the effects of predictor variables in black box supervised learning models. *Journal of the Royal Statistical Society, Series B*, 82(4), 1059–1086.
- Arel-Bundock, V. *marginaleffects* (R and Python package) and documentation.
- Friedman, J. H. (2001). Greedy function approximation: A gradient boosting machine. *Annals of Statistics*, 29(5), 1189–1232.
- Goldburd, M., Khare, A., Tevet, D., and Guller, D. *Generalized Linear Models for Insurance Rating*. CAS Monograph No. 5.
- Goldstein, A., Kapelner, A., Bleich, J., and Pitkin, E. (2015). Peeking inside the black box: Visualizing statistical learning with plots of individual conditional expectation. *Journal of Computational and Graphical Statistics*, 24(1), 44–65.
- Molnar, C. *Interpretable Machine Learning*. Online book, chapters on PD, ICE, and ALE.
- Werner, G., and Modlin, C. *Basic Ratemaking*. Casualty Actuarial Society, chapters on traditional (univariate) and multivariate classification ratemaking.
