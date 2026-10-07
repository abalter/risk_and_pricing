# Pet Insurance Pricing Modeling and Analysis

Using historical claims, we can build statistical models to help answer actuarial and business questions about a group of policies. Some questions we might want to answer include:

1. Which segments of the book present the highest risk?
2. Which segments of the book are underpriced or overpriced?
3. Can we anticipate high-risk policies at sale time so they can be routed for detailed consideration?

Statistical models can help answer these questions. The certainty of their answers depends on the amount and quality of the data used to fit or train the models, as well as choices made during the modeling process.

In this document, we present an account of the decisions we have made and the methods we have implemented to answer these and other questions. We attempt to maintain a technically accessible style overall while also providing optional deep dives so that the document contains a rigorous account of the analysis.

# Terminology and Notation

Actuarial, statistical, and machine-learning terminology overlap but are not always aligned. In this document, we establish a consistent vocabulary, generally preferring statistical terminology for modeling concepts and standard actuarial terminology for insurance and pricing concepts.

This document contains two appendices: 

Appendix A: Symbols and Notations
Appendix B: Glossary

Despite being relegated to appendices, these sections are the most important in the document. They introduces the terminology and notation used throughout the discussion of the models and analyses. The actuarial and pricing terminology is especially important because familiar words such as *premium*, *loss*, *rate*, *expected*, and *actual* can have different meanings in different contexts.

Most readers will probably benefit from reviewing them before proceeding. However most readers may wish to plunge ahead and use them only for reference.

# Feature Engineering, Feature Selection, and Model Selection
The internet is filled with information about these topics and I have no interest in reinventing that wheel. That said, I do want to cover some topics that apply specifically to pricing models. Namely:

- Choice of target
- Choice of model structure
- Inclusion/exclusion of plan and sales varaibles
- Data quality and imputation
- High-cardinality variables
- Cross-Coverage Consistency
- Model Selection

## Choice of Target
A pricing model is usually a _loss_ model. The idea is to use historical data to be able to predict* or estimate* the expected* loss* from writing a future policy*. One way to understand prospective losses is through the _risks_ incurred in different segments* of the book*. In a pure sense, the exogenous data generating process* (DGP) is the incidence of claims. Therefore, risks are more purely represented through eligible loss* because those represent the frequency and severity of claims. The endogenous DGP for loss is the incidence of payments. From an accounting point of view, risk occurs through paid loss* which represents the frequency and severity of payments.

## Choice of Model Structure
A highly technical decision the modeler will make is whether to model loss as the target and earned exposure as an offset*, or whether to model loss rate = loss / earned exposure as the target. In the second case, it is also essential to use earned exposure as weights* in the model. This decision does not affect the model performance. But whichever the modeler chooses does determine how to properly peform analysis calculations after modeling.

## Inclusion / Exclusion of Plan and Sales Variables
Plan variables refers to coinsurance*, deductible*, and limit*. Sales variables refers to whether the policy was sold over the phone, through the web, how the customer paid, etc. Plan variables do not change the pure risk of a policy--that depends only on the pet. But they may change or reflect how the pet owner _uses_ the policy and makes claims. Likewise, sales variables may give behavioral insight into the pet owner.

Both sides

Omitted variable bias

## Data Quality and Imputation
For statistical modeling we want data to be as clean as possible because clean data contains the most information. Values that are missing, incorrect, or inconsistent decrease the signal-to-noise ratio. Here are some examples form our data:

### Neutered
Business partners told us that the neutered variable is not collected consistently, and also not updated consistently when it changes (i.e. an animal gets neutered while covered). Therefore we are not using it.

### Mixed Breed Status
There is a `mixed` variable in the data set that records whether an animal is mixed breed or purebred. The `breed` variable also sometimes implies mixed status. For example, "Mixed (Toy 0-10 Lbs.)" is one breed category and "Bernese Mix" is another. However, animals with breeds that specifically indicated being mixed breed did not uniformly end up with `mixed` = "yes". Because mixed status is an important predictive variable we imputed* correct mixed status whenever possible.

### High-Cardinality Variables
High-cardinality categorical variables are ones that have a large number of levels*. When levels are represented in roughly equal numbers, they are said to be "balanced". Both high cardinality and unbalanced levels create problems for statistical models, especially when some levels have very low counts. 

Simple method

Higherarchical clustering.

"Mixed (Toy 0-10 Lbs.)" --> Misc-Mixed-Toy-Canine

### Cross-Coverage Consistency
Our data contains a separate row for each coverage the pet is insured under. For the same pet, all personal or demographic variables should align: age, sex, species, breed, mixed, breedsize, US State. We cross-checked these and found them to be all correct.

## Model Selection
Model selection is a fraught process. In principle, there is no principled way to do it. In practice, it still must be done.

Model selection means choosing which variables and in which forms to include in the statistical model. By trying many different combinations and forms you can arrive at a model that performs better than the others in terms of the metrics you are using. However, the more different models you try, the greater the chance that you have "overfit" by finding a model, by chance, that just happens to fit the data you have perfectly, but would not fit well to data it has not seen.

Cross-validation is one way to try to control for overfitting. It helps but is not perfect. Bootstrap "optimism" correction is another. No method is perfect, which is why, in principal, all model selection algorithms are suspect. In practice, modelers use a combination of algorithms, experience, and subject matter expertise to arrive at models they believe are best for the particular task.

# Loss Modeling
To study loss at the policy level it can be convenient to aggregate claims at the term level. This means, for each policy $i$, you create the following term-grain variables:

n_i: number of claims
ee_i: earned exposure (usually months/12)
\pi_i: total amount paid on all claims
u_i: total eligible amount of all claims
t_i: total premium collected

The data set might have multiple indices:
policy_id: Associated with the insured pet owner
pet_id: Associated with an individual pet

The policy might be ?

Coverage

Taken together, we have a data set of rows that each contain

$$(e_i, ee_i, \pi_i, e_i, t_i, c_i, d_i, l_i, x_{1,i}, x_{2, i}, x_{3, i}, ...)$$

where $x_{j}$ are pet data such as age, sex, species, etc.

Because of the way claims arise, insurance loss is most naturally modeled on a log scale. The practical outcome of loss modeling is a statistical model that allows us to

Everything that is part of a statistical model is an estimate.

If we have data (y_i, x_i), and fit a statistical model y_i = f(x_i), then we remind ourselves that the model only gives estimates with the "hat" symbol. Consequently y = f(x) represents a hypothetical relationship between actual values x_i and y_i. But for the model, we write \hat y_i = \hat f(x_i). In other words, we imagine that the true y_i is some true function f of the x_i. But we can only estimate that function. So we take real values x_i and put them into our estimate function \hat f() and arrive at \hat y_i which are estimates of the real y_i.

Another subtlety about statistical models is that the estimates are not actual substitutes for the real thing. This is because most statistical models estimate _expected_ values. So \hat y_i = \hat f(x_i) is really shorthand for E[y_i] = \hat f(x). But here the expectation E[] isn't over the data $i$. It's an ensemble average, meaning that it reflects the average outcome of an infinite number of multiverse experiments.

$$
log(E[u]) = f(x, ...)
$$

Where $u$ is the loss (eligible or paid), x are the pet variables, and ... are any other covariates the model requires (such as plan variables).


Because we can choose two potential targets for our loss model, u or \pi, we introduce a general notation \mu_\pi for paid loss and \mu_u for eligible loss. That way we can simply write \mu for loss and specify which only when necessary.

# Eligible and Paid Loss
Both eligible loss and paid loss reflect the accumulation of claims on a policy. We said that eligible loss is more "pure" because it arises from an exogenous DGP, i.e. the random arrival of claims. The paid loss is endogenous because it potentially reflects business decisions regarding how and if to cover the claimed amounts. In most cases, however, the relationship will be mechanical. The amount paid on each claim will reflect the allowed amount for that claim, any coinsurance, the deductible status, and whether a limit has been reached. 

Becuase deductible status and limit status adjust with each claim payout, it's not strictly possible to calculate paid loss from eligible loss once aggregated on a term basis. However, it is possible to consider a "mechanical" relationship based on a benefit formula. The most common version would be something like

$$
\pi_i = g(u_i, c_i, d_i, l_i) = 
$$

In theory, one could do the same for (model) estimated values

$$
\hat \pi_i = g(\hat u_i, c_i, d_i, l_i) = 
$$

However, $g$ is a nonlinear function, and there is a subtle mathematical rule about averages and nonlinear functions that says that doing this won't work out the way we want it to. Actuaries have developed methods to compensate for this rule, but they are fairly complex.

Therefore, when studying risk it makes sense to choose eligible loss $u \equiv \mu_u$ as the target, but for pricing or accounting concerns (such as pricing) it's best to choose paid loss $\pi \equiv \mu_\pi$ as the modeling target.

It is often traditional in statistical literature to represent the target of a model by $\mu$. The symbol $\mu$ is also generally used to represent an average or mean. There is an important reason for this choice of symbol. It is to remind us that the output of a model is not a full standin for the actual target variable. Instead, it represents a kind of _average_ and must respect the limitations of statisticial averages. Jensen's inequality. Nonlinear functions.

# Comparing Risk

## Relativities and base levels

A relativity is a ratio of rates against a chosen base risk. The base changes how relativities look and how well they are estimated, not what anyone pays.

### Base rate and overall relativity

Pick a base risk $x^b$, one reference value for each rating variable.

$$
B = \hat\mu(x^b), \qquad
R(x) = \frac{\hat\mu(x)}{\hat\mu(x^b)} = \exp\big[\hat f(x) - \hat f(x^b)\big], \qquad
\hat\mu(x) = B \cdot R(x)
$$

This holds for any $f$, interactions included. Changing the base moves $B$ and $R(x)$ in opposite directions, so their product, the price, is unchanged.

## Relativities
Overall relativities R(x): argument is full risk vector
One-way relativities r_j(x_j): Index is risk varaible, argument is risk variable value. All other variables have been integrated over.
Partial relativities r_j(x_j): Index is risk varaible, argument is risk variable value. All other variables have been integrated over.

## Mental map

$$
\boxed{
\text{Pick }j
\;\longrightarrow\;
\text{vary }x_j
\;\longrightarrow\;
\text{what do I do with }x_{-j}?
}
$$

| Quantity | What happens to $x_j$? | What happens to $x_{-j}$? | Mental model |
| --- | --- | --- | --- |
| **Overall relativity** | Entire risk vector $\mathbf{x}$ | Not applicable | Compare the **entire risk vector** $\mathbf{x}$ with base risk $\mathbf{x}^b$ |
| **One-way relativity** | Vary $x_j$ | Fix at **one base risk** $x_{-j}^b$ | Relativity as a function of $x_j$ for the chosen base risk |
| **ICE** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$ | Prediction as a function of $x_j$ for each individual risk |
| **Partial dependence (PD)** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$, then average over $i$ | Average prediction as a function of $x_j$ across the portfolio |
| **Partial relativity** | Vary $x_j$ | Same as PD: repeat over $x_{i,-j}$ and average over $i$ | Partial-dependence curve normalized relative to a reference value of $x_j$ |
``


- **Base risk** $\rightarrow$ one-way relativity
- **One observed risk at a time** $\rightarrow$ ICE
- **All observed risks, then average** $\rightarrow$ partial dependence
- **All observed risks, average, then normalize** $\rightarrow$ partial relativity
- **Don't isolate $j$ at all** $\rightarrow$ overall relativity

Separately, after deciding what to do with $x_{-j}$, ask whether the result should be expressed as an **absolute prediction** or normalized into a **relativity**.

Progression:
One-way: start with the baseline pet.
ICE: start with one actual pet.
PD: do the ICE calculation for all the pets and average.
Overall: different question entirely, compare this whole pet/risk to the baseline.

| Quantity | Question it answers |
| --- | --- |
| **Overall relativity** | What is the predicted risk of this pet relative to the baseline? |
| **One-way relativity** | How would the predicted baseline risk vary if I change this one variable? |
| **ICE** | Take a given pet. How would its predicted risk vary if I change this one variable? |
| **Partial dependence (PD)** | Across the portfolio, how would the average predicted risk vary if I change this one variable? |
| **Partial relativity** | Across the portfolio, how would the average predicted risk change relative to a reference value if I change this one variable? |


Yes to the first question, with a wording nuance.

For **ICE**, for each $i$, you fix $x_{-j}$ at **that observation's values** and vary $x_j$.

For **PD**, you do exactly the same thing for **every observation**, then average the resulting predictions at each $x_j$.

So I'd revise the two rows to make their relationship more obvious:

| Quantity | What happens to $x_j$? | What happens to $x_{-j}$? | Mental model |
| --- | --- | --- | --- |
| **ICE** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$ | Prediction as a function of $x_j$ for each individual risk |
| **Partial dependence / partial curve** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$, then average over $i$ | Average prediction as a function of $x_j$ across the portfolio |

## Be careful with the word "effect"

I would **not** write:

> Effect of $x_j$ averaged across the portfolio

unless you've specifically defined an effect as a difference or ratio.

PD is fundamentally

$$
PD_j(z)
=
\frac{1}{N}\sum_i \hat\mu(z,x_{i,-j}),
$$

or your exposure-weighted version. That's an **average prediction**, not yet an effect.

If you compare two points on that curve,

$$
PD_j(z_1)-PD_j(z_0),
$$

then you have an average effect on the additive scale. Or, for your relativity setting,

$$
\frac{PD_j(z_1)}{PD_j(z_0)}
$$

gives you a relativity.

So I actually like **"prediction as a function of $x_j$"** better than "effect of $x_j$" in your table. It keeps **ICE/PD** separate from the subsequent question of how you're going to turn those predictions into **relativities**.

---

For observation $i$, the ICE curve is

$$
ICE_{ij}(z)
=
\hat\mu(z,x_{i,-j}).
$$

---

The last two are especially closely related:

$$
PD_j(z)
=
\operatorname{Avg}_i
\left[
\hat\mu(z,x_{i,-j})
\right]
$$

is the **partial prediction**, while

$$
r_j^{\text{partial}}(z)
=
\frac{PD_j(z)}{PD_j(z^b)}
$$

turns that curve into a **relativity**.

So, in your mental map:

$$
\boxed{\text{Partial relativity = normalized partial dependence}}
$$

at least under the particular definition of partial relativity we've been developing here.

## Partial Relaivities

# Theoretical Premium

# Ways of Assessing Pricing
Loss Elimination Ratio
Pricing adequacy
Actual vs. Expected
Empirical vs. Mechanical
Actual vs. Technical





# Symbols and Notation

## Conventions

1. No hat means observed data. A hat means a model estimate.
2. $P_i$ is always data: the premium actually charged. It is never computed from a model.
3. $T_i$ is always computed. It is never data, so it carries no hat.
4. $E[\cdot]$ is the true, unknown expectation. Its estimate carries a hat. Model output is called "estimated"; "expected" is reserved for $E[\cdot]$.
5. A subscript $i$ means a total for policy $i$ over its term. Per-unit-exposure rates are functions of the rating variables and carry no index.
6. The Tweedie power is written $\xi$, so lowercase $p$ never appears.

## Data (per policy $i$, over its term)

| Symbol | Name | Meaning |
| --- | --- | --- |
| $x_i$ | rating variables | age, species, breed, sex, state, product |
| $d_i,\ c_i,\ l_i$ | cost-sharing terms | deductible, copay, annual limit |
| $ee_i$ | earned exposure | policy-years in force during the period |
| $u_i$ | eligible loss (ground-up loss) | covered vet costs over the term, before cost-sharing |
| $\pi_i$ | paid loss (empirical paid) | what the insurer actually paid, on-leveled |
| $\pi_i^{\text{mech}}$ | mechanical paid | paid computed from the *actual* eligible loss with the benefit formula, $g(u_i;\, d_i, c_i, l_i)$ |
| $P_i$ | premium (the "A" in AvT) | earned on-level premium charged, over the same exposure $ee_i$ |

The benefit formula, applied to the term total:

$$
g(u;\, d, c, l) = \min\big((1-c)\max(u-d,\,0),\ l\big)
$$

## Model estimates

| Symbol | Name | Meaning |
| --- | --- | --- |
| $f(x)$ | log pure premium | the fitted function of the rating variables; $f = \log \mu$ |
| $\hat\mu_u(x)$ | ground-up pure premium | estimated eligible loss per unit exposure (eligible model) |
| $\hat\mu_\pi(x, d, c, l)$ | paid (net) pure premium | estimated paid loss per unit exposure (paid model) |
| $\hat u_i = ee_i\,\hat\mu_u(x_i)$ | estimated eligible loss | for policy $i$ |
| $\hat\pi_i = ee_i\,\hat\mu_\pi(x_i, d_i, c_i, l_i)$ | estimated paid loss | for policy $i$ |
| $\xi$ | Tweedie power | estimated by mgcv's `tw()` family; $1 < \xi < 2$ |

## Pricing quantities

| Symbol | Name | Meaning |
| --- | --- | --- |
| $F$ | fixed expense | dollars per unit exposure, independent of premium size |
| $V$ | variable expense ratio | fraction of premium (commissions, premium taxes, payment processing) |
| $Q$ | profit and contingency ratio | target margin, as a fraction of premium |
| $k = 1/(1 - V - Q)$ | loading factor | applies when $F \approx 0$ |
| LAE | loss adjustment expense | the cost of handling claims; loaded onto losses or folded into $F$ and $V$ |
| $T_i$ | technical premium | the premium that would exactly cover estimated paid, expenses and profit |

$$
T_i = \frac{\hat\pi_i + F\,ee_i}{1 - V - Q}
$$

Correctly priced means $P_i = T_i$.

## Ratios over a group of policies $S$

| Ratio | Formula | Answers |
| --- | --- | --- |
| S   |     | Segment or group of policies. For example: female short haired cats in Colorado. }
| AvT | $\sum_{i \in S} P_i \,/\, \sum_{i \in S} T_i$ | Is the price adequate for the estimated cost? Below 1 means underpriced. |
| Relative AvT | $\text{AvT}(S) \,/\, \text{AvT}(\text{book})$ | Is group $S$ priced worse than the book average? |
| Loss ratio (LR) | $\sum_{i \in S} \pi_i \,/\, \sum_{i \in S} P_i$ | How did actual claims compare with premium? Target is $1 - V - Q$ when $F = 0$. |
| A/E | $\sum_{i \in S} \pi_i \,/\, \sum_{i \in S} \hat\pi_i$ | Did the model predict claims correctly? No premium involved. |
| Mechanical check | $\sum \pi_i \,/\, \sum \pi_i^{\text{mech}}$ | How well does the benefit formula reproduce actual payments? About 4% off book-wide. |


# Glossary

## Data Concepts and Terminology

**Observation:** A single unit represented in a dataset, usually corresponding to one row. What an observation represents depends on the grain of the data.

**Grain:** What one row of a dataset represents. Examples include one claim, one policy-month, or one policy-term.

**Aggregation Basis:** A dimension over which observations are grouped or summarized. Examples include calendar month, policy term, state, and species.

**Variable:** A recorded characteristic or quantity that may take different values across observations.

**Numeric Variable:** A variable whose values are numbers with meaningful numeric relationships. Examples include age, weight, loss amount, and claim count.

**Continuous Variable:** A numeric variable that can, in principle, take any value within an interval. Examples include weight and age. A continuous quantity may nevertheless be recorded or rounded to discrete values.

**Discrete Variable:** A numeric variable that takes distinct, separated values, often integers. Counts such as number of claims are discrete variables.

**Categorical Variable:** A variable whose values represent groups or categories rather than numerical quantities. Categories may be *nominal*, with no inherent ordering, such as species or state, or *ordinal*, with a meaningful ordering.

**Cardinality:** The number of distinct values or levels a categorical variable can take. For example, a variable representing the 50 U.S. states has a cardinality of 50 if all states are represented and no additional category is used.

**Coding:** The way a variable's values are represented in a dataset. For example, Yes/No and Female/Male might each be coded as 1/0. The numeric codes are labels and do not necessarily imply numerical relationships, so it would not follow that Yes is greater than No.

**Rate:** A quantity expressed relative to another quantity, often through division. For example, speed is distance per unit of time. In insurance, the denominator might be exposure, premium, or claim count, so the denominator should always be stated or made clear by context.

## Statistical and Machine-Learning Concepts and Terminology

**Mean or Average:** The sum of a set of numeric values divided by the number of values. The arithmetic mean is one measure of the center of a distribution.

**Variance:** A measure of how much a numeric variable varies around its mean. Larger variance indicates greater dispersion.

**Covariance:** A measure of how two numeric variables vary together. Positive covariance indicates that they tend to increase together, while negative covariance indicates that one tends to increase as the other decreases.

**Model:** A mathematical or computational representation of relationships among variables. A statistical model may describe a response variable as a function of predictors and a probability distribution.

**Response Variable / Outcome / Target:** The variable a model is intended to explain or predict. This document generally uses *response variable* for statistical models and may use *target* when discussing machine-learning workflows.

**Covariate:** A variable included in a statistical analysis to help explain variation in the response. Depending on context, it may or may not be a variable of primary interest.

**Predictor:** A variable used by a model to explain or predict the response variable.

**Feature:** A model input. A feature may be an original variable or a value derived through feature engineering. In this document, *predictor* is generally preferred when discussing statistical models.

**Parameter:** An unknown quantity that characterizes a population, probability distribution, or model. Model fitting uses data to estimate parameters.

**Coefficient:** A model parameter that determines how a predictor contributes to the model. Its interpretation depends on the model form, link function, variable coding, and the presence of interactions.

**Estimate:** A value calculated from data and used to approximate an unknown parameter or quantity. *Estimate* may refer to either the procedure or its resulting value, depending on context.

**Estimated:** Describes a quantity whose value has been inferred from data rather than directly observed.

**Fitted Value:** A model's estimated value of the response for an observation used during model fitting. Depending on the model, this may represent an estimated conditional mean or another distributional quantity.

**Prediction / Predicted Value:** A value produced by a fitted model for a specified set of predictor values. A prediction may be produced for training data, held-out data, or new data.

**Residual:** The difference between an observed response and its fitted or predicted value, defined according to the type of model and residual being used.

**Expectation / Expected Value:** The probability-weighted average of a random variable under a specified probability distribution. A conditional expectation is the expected value given specified information or predictor values.

**Conditional / Conditioned On:** Restricted to, or evaluated given, particular information. For example, \(E[Y \mid X=x]\) is the expected value of \(Y\) conditional on \(X=x\).

**Interaction:** A model term representing a relationship in which the effect of one predictor depends on the value of another predictor. An interaction is defined relative to the model's scale and structure.

**Confounder:** A variable associated with both a predictor of interest and the response that can distort a causal interpretation if it is not appropriately addressed. Confounding is primarily a causal concept, not merely a correlation among predictors.

**Feature Engineering:** The creation or transformation of variables for use as model inputs. Examples include combining categories, constructing ratios, applying transformations, or deriving variables from dates.

**Feature Selection:** The process of choosing which candidate predictors or engineered features are available for inclusion in a model.

**Model Selection:** The process of choosing among candidate model specifications, which may differ in predictors, interactions, functional forms, distributions, algorithms, or tuning parameters.

**Regression Model:** A model that describes the distribution or expected value of a response as a function of predictors. Regression is not limited to continuous responses or straight-line relationships.

**Tree Model:** A model that recursively divides observations into groups using decision rules based on predictor values. The resulting predictions are determined by the terminal groups, or leaves.

**Training Data:** Data used to fit a model and estimate its parameters.

**Validation Data:** Data not used directly to fit a candidate model and instead used to compare models, select tuning parameters, or make other modeling decisions.

**Held-Out / Test Data:** Data withheld from model development and used to evaluate performance on observations not used to fit or select the model.

**Model Performance:** A model's measured ability to accomplish a specified task. Relevant aspects may include predictive accuracy, calibration, discrimination, stability, and performance across business segments.

**Calibration:** Agreement between predicted values and corresponding observed outcomes. For a model of expected loss, a well-calibrated group of predictions has average observed loss close to average predicted loss, subject to sampling variation.

**Discrimination:** A model's ability to assign meaningfully different predictions to observations with different outcomes or levels of risk. A model can discriminate well without being well calibrated.

**Overfitting:** Fitting patterns specific to the training data that do not generalize reliably to new observations.

**Generalization:** The extent to which a fitted model performs on observations not used to develop it.

**Cross-Validation:** A resampling procedure in which models are repeatedly trained and evaluated using different partitions of the available data.

**Temporal Validation:** Model evaluation that preserves time ordering, generally training on earlier observations and evaluating on later observations.

**Exposure:** A measure of the extent to which an observational unit is subject to the possibility of an event or loss. In insurance models, exposure commonly represents time at risk.

**Offset:** A model term whose coefficient is fixed rather than estimated. In a log-link model for aggregate loss or claim count, the logarithm of exposure is commonly used as an offset so that the remaining model terms describe a rate per unit of exposure.

## General Insurance Concepts

**Insured:** The person or entity protected by an insurance policy. In pet insurance, the policyholder is typically the pet owner, while the covered pet is the subject of the insured risk.

**Insurer:** The company that issues the policy and assumes the covered risk in exchange for premium.

**Claim:** A request by the insured for the insurer to reimburse or cover an expense under the terms of the policy.

**Loss:** A monetary measure associated with claims. The precise meaning depends on context and should therefore be qualified when necessary, for example *eligible loss*, *paid loss*, or *incurred loss*.

**Premium:** The amount charged by the insurer for providing coverage. Premium may be quoted, written, billed, collected, or earned, and the applicable meaning should be stated when it is not clear from context.

**Deductible:** The amount of otherwise eligible loss that is the responsibility of the insured before reimbursement is calculated. Deductibles may be defined per claim, per condition, per term, or on another basis according to the policy.

**Coinsurance / Reimbursement Percentage:** The percentage of eligible loss paid by the insurer after application of the deductible, subject to policy terms and limits. In pet insurance, the insurer-paid share is commonly described as the reimbursement percentage.

**Copayment:** A fixed dollar amount paid by the insured toward a covered expense. This is distinct from percentage-based coinsurance.

**Limit:** The maximum amount the insurer will pay for covered losses over a specified scope, such as per claim, per condition, annually, or over the lifetime of the policy.

**Exclusion:** A condition, service, cause of loss, or circumstance for which the policy does not provide coverage.

**Benefit:** A general term for coverage or payment provided to the insured under the policy.

**Policy:** The contract between the insured and insurer that defines the coverage, exclusions, benefit provisions, premium, and other terms under which claims will be settled.

**Policy Term:** The period during which a particular instance of the insurance contract is in effect, commonly one year.

**Book / Book of Business:** A collection of policies written by an insurer, often referring to a particular product, market, or portfolio. Historical data about those policies constitute experience from the book.

## Actuarial and Pricing Terminology

The terms in this section are organized into observed quantities, modeled quantities, and pricing quantities. This distinction separates what occurred in the historical data from what a model estimates and from what is ultimately used to set or evaluate prices.

### General Actuarial Quantities

**Earned Exposure:** A measure of the amount of time or other exposure over which a policy was in effect and subject to loss. When exposure is measured in policy-years, twelve fully exposed months generally correspond to one unit of earned exposure. A partial term contributes a corresponding fraction, subject to the organization's exposure convention.

**Claim Count:** The number of claims satisfying a stated definition during a specified period. The definition should make clear how reopened, duplicate, or multi-line claims are counted when those issues are relevant.

**Claim Frequency:** Claim count per unit of exposure, either observed or expected. If \(N\) is claim count and \(e\) is exposure, observed frequency is \(N/e\).

**Claim Severity:** Loss per claim, either observed or expected. If \(L\) is loss and \(N\) is claim count, observed severity is \(L/N\) when \(N>0\).

**Pure Premium / Loss Cost per Unit of Exposure:** Loss per unit of exposure, either observed or expected. If \(L\) is loss and \(e\) is exposure, pure premium is \(L/e\). Despite its name, pure premium is a measure of loss cost rather than the premium charged to the customer. Consistent definitions of loss and exposure must be used when comparing pure premiums.

Conceptually,

\[
\text{Pure Premium} = \text{Claim Frequency} \times \text{Claim Severity}.
\]

**Loss Rate:** Loss per unit of exposure. In this document, *loss rate* and *pure premium* may refer to the same mathematical quantity, although one term may be preferred in a particular business context. The loss definition must be stated, such as eligible-loss rate or paid-loss rate.

**Loss Ratio:** Loss divided by premium. The definitions and evaluation periods for both loss and premium must be stated. A loss ratio measures loss relative to the amount charged or earned, whereas a loss rate measures loss relative to exposure.

**Rate Relativity:** A multiplicative factor representing the expected cost for a segment relative to a specified reference level. A relativity of 1.20 indicates an expected cost 20% above the reference on the modeled scale.

**Credibility:** The degree of statistical reliance placed on a body of observed experience. Less stable experience may be combined with broader or external information rather than used by itself.

### Observed Quantities

**Observed / Actual / Empirical:** Describes a quantity calculated from events recorded in the historical data rather than produced by a model. These words are sometimes used interchangeably, but *observed* is preferred when referring specifically to values represented in the modeling dataset.

**Eligible Loss:** The amount of a submitted expense that satisfies the coverage definition before applying some or all policyholder cost-sharing provisions. The precise calculation depends on the product and data definition, so the document should state whether deductibles, reimbursement percentages, exclusions, and limits have already been applied.

**Paid Loss:** The amount paid by the insurer for covered claims after application of the relevant policy provisions, such as deductibles, reimbursement percentages, exclusions, and limits. Paid loss may be aggregated by claim, month, policy term, or another basis.

**Incurred Loss:** A measure of loss associated with events that have occurred, commonly including paid amounts plus estimates for amounts not yet paid. The exact components depend on the organization's reserving and accounting definitions.

**Observed Pure Premium / Observed Loss Rate:** Observed loss divided by earned exposure. The loss basis must be identified, for example observed eligible-loss rate or observed paid-loss rate.

**Observed Loss Ratio:** Observed loss divided by the corresponding premium. The result depends on whether loss is eligible, paid, incurred, or otherwise adjusted and whether premium is written or earned.

**Actual Premium:** The premium actually charged or recorded for a policy, as distinct from a modeled or indicated premium. The relevant basis, such as written, billed, or earned, should be specified.

**Written Premium:** Premium associated with policies written during a period, without allocating it according to the portion of coverage that has elapsed.

**Earned Premium:** The portion of premium corresponding to the coverage that has elapsed during the measurement period.

### Modeled Quantities

**Predicted / Estimated:** Describes a value produced by a fitted statistical model. A model prediction is an estimate of a specified quantity, such as expected eligible loss, expected paid loss, or expected claim frequency.

**Expected:** Describes the statistical expectation of a quantity, usually conditional on available predictors. Expected does not mean certain, and an individual observed outcome may differ substantially from its expected value. In this document, expected will always mean estimated or predicted by a model.

**Mechanical:** Describes a value obtained deterministically by applying known policy rules or formulas to other quantities. For example, paid loss may be mechanically calculated from an eligible-loss amount under a simplified benefit formula. A mechanically calculated value is not necessarily observed and is not necessarily a statistical prediction.

**Expected Claim Frequency:** The model-estimated average number of claims per unit of exposure for policies with specified predictor values.

**Expected Claim Severity:** The model-estimated average loss per claim for claims or policies with specified predictor values, under the severity definition used by the model.

**Expected Eligible Loss:** The model-estimated conditional mean of eligible loss for a policy or unit of exposure, according to the model's loss and exposure definitions.

**Expected Paid Loss:** The model-estimated conditional mean of paid loss for a policy or unit of exposure. This may be modeled directly or derived from a model of eligible loss together with policy benefit provisions. Those approaches do not necessarily produce identical results.

**Expected Pure Premium / Expected Loss Rate:** Expected loss per unit of exposure for policies with specified predictor values. The loss basis must be identified.

### Pricing Quantities

**Technical:** Describes a pricing quantity intended to represent indicated cost or premium based on expected costs and specified pricing assumptions, rather than necessarily the amount actually charged.

**Technical Loss:** The expected loss amount used for pricing after applying the selected loss definition, model, adjustments, and pricing assumptions. A technical loss is a constructed pricing quantity and should not be confused with observed loss.

**Technical Premium:** The premium indicated by the pricing framework after allowing for expected losses and any specified expenses, commissions, contingencies, profit provisions, or other pricing components. It may differ from the actual premium because of business decisions, regulatory constraints, transition rules, or differences between the technical and production rating plans.

**Indicated Premium:** The premium supported by a specified actuarial or pricing analysis. In this document, *indicated premium* may be used as a broader term, while *technical premium* refers to the model-based implementation of that indication.

**Indicated Rate:** A rate supported by a specified actuarial or pricing analysis for a unit of exposure or coverage. The term should identify the exposure unit and the cost components included.

**Permissible Loss Ratio:** The proportion of premium available to cover losses and any loss-related expenses included in the definition after allowing for other expenses, profit, contingencies, and applicable pricing provisions. Its calculation depends on the organization's accounting and pricing framework.

**Underpriced:** Describes a policy or segment for which the actual premium is below the relevant technical or indicated premium under a specified pricing framework. A high observed loss ratio alone does not establish underpricing because observed results are subject to random variation and may reflect differences in exposure, mix, or time period.

**Overpriced:** Describes a policy or segment for which the actual premium is above the relevant technical or indicated premium under a specified pricing framework. This is a comparison to a defined pricing benchmark, not a statement that every policy in the segment will produce favorable experience.

## Terms easily confused

- **Loss cost** is a synonym for pure premium: an expected amount per unit exposure. It never names a single policy's realized loss.
- **Aggregate loss** is a realized total over a period, such as $u_i$ or $\pi_i$. Pure premium is its expectation per unit exposure.
- **Mechanical indication** is a different use of "mechanical": the rate change a ratemaking formula produces before actuarial judgment.
