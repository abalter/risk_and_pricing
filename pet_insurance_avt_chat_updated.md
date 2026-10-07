# Prompt

> Given a data set for pet insurance aggregated at the term level with policies indexed by i. The data contains various data about the pets, $x_i$, as well as eligible loss $u_i$, paid loss $p_i$, earned exposure $ee_i$, coinsurance $c_i$, deductible $d_i$, limit $l_i$, and onleveld premium $t_i$.
>
> Q1: To calculate "Actual vs. Technical", AvT, should we model eligible loss or paid loss?
>
> Q2: After modeling, how do we calculate AvT?

# Response

There is an important distinction here: **AvT is a comparison of the premium actually charged with the premium your technical pricing model says should have been charged.** So the modeling target should correspond to the insurer's expected cost under the coverage actually provided. CAS ratemaking treats premium as the amount needed to cover expected losses plus expenses and profit, with rating variables and coverage provisions reflected in that expected cost.

## Q1. Eligible loss or paid loss?

For the AvT you are describing, I would model **paid loss**, not eligible loss.

Let

$$
p_i = \text{paid loss}
$$

and suppose the contract maps eligible loss $u_i$ to paid loss through coinsurance, deductible, limits, and any other benefit provisions:

$$
p_i = g(u_i;c_i,d_i,l_i,\ldots).
$$

What you ultimately need for technical pricing is the insurer's expected cost:

$$
E[p_i\mid x_i,c_i,d_i,l_i,\ldots].
$$

That's the quantity the premium must fund. In particular, two otherwise identical pets with different deductibles or coinsurance parameters present different expected costs to the insurer and therefore should generally have different technical premiums.

So, schematically, I would fit something like

$$
p_i \sim f(x_i,c_i,d_i,l_i,\ldots)
$$

while properly accounting for earned exposure $ee_i$.

### Why not eligible loss?

A model of

$$
E[u_i\mid x_i]
$$

is a model for the **underlying loss propensity of the pet before the insurance contract transforms that loss into insurer cost**. That's potentially very useful. For example, it can give you coverage-independent risk relativities.

But by itself it isn't the technical cost of the policy.

You *could* build the pricing model in two stages:

$$
\widehat{E[u_i\mid x_i]}
\quad\longrightarrow\quad
\widehat{E[p_i\mid x_i,c_i,d_i,l_i]}
$$

using an actuarial loss-cost transformation. That's conceptually attractive if you want to separate **underlying pet risk** from **coverage choice**. But if your immediate objective is technical premium and AvT, modeling paid loss directly is the more direct approach.

## Q2. How do we calculate AvT?

Suppose your final model produces predicted paid loss

$$
\hat p_i = \widehat{E[p_i\mid x_i,c_i,d_i,l_i,\ldots]}.
$$

That is the **technical expected loss**, but it is **not yet technical premium**.

You need to convert expected loss into the indicated premium required to support that expected loss, including whatever expense/profit structure belongs in your pricing system.

For example, in a simple loss-ratio framework with permissible/target loss ratio $LR^*$,

$$
T_i = \frac{\hat p_i}{LR^*},
$$

where $T_i$ is the **technical premium**.

If instead you have fixed expenses plus variable expense/profit provisions, the transformation should reflect those explicitly.

You then have:

- $t_i$: actual on-leveled premium
- $T_i$: modeled technical premium

and therefore

$$
\boxed{\mathrm{AvT}_i = \frac{t_i}{T_i}}
$$

if you use the convention **Actual / Technical**.

Thus:

$$
\mathrm{AvT}_i > 1
$$

means the policy is priced **above technical**, while

$$
\mathrm{AvT}_i < 1
$$

means it is priced **below technical**.

## Portfolio-level AvT

This part is important. I would **not average the individual AvT ratios**.

For a portfolio or segment $S$, calculate

$$
\boxed{
\mathrm{AvT}_S
=
\frac{\sum_{i\in S}t_i}
     {\sum_{i\in S}T_i}
}
$$

rather than

$$
\frac{1}{n}\sum_i\frac{t_i}{T_i}.
$$

The ratio-of-sums measures aggregate actual premium relative to aggregate technical premium, which is the economically relevant portfolio quantity.

For example:

$$
\frac{\$10.5\text{M actual premium}}
     {\$10.0\text{M technical premium}}
=1.05.
$$

So the book is **5% above technical**.

## One subtlety with your $ee_i$

Because your records are **term-level observations with earned exposure**, make sure $T_i$ and $t_i$ are on the **same exposure basis**.

If your model estimates an annualized loss cost,

$$
\widehat{LC}_i
=
\widehat{E[p_i/ee_i\mid \cdots]},
$$

then term expected loss is

$$
\hat p_i = ee_i\widehat{LC}_i,
$$

and technical term premium needs to be calculated on that same earned basis.

If $t_i$ is already **on-leveled earned premium for the observed term exposure**, then the final comparison is simply

$$
\boxed{
\mathrm{AvT}
=
\frac{\sum_i t_i}
     {\sum_i T_i}
}.
$$

### The overall chain

I would think about your variables as:

$$
\boxed{
(x_i,c_i,d_i,l_i,\ldots)
\rightarrow
E[p_i]
\rightarrow
\text{technical premium }T_i
\rightarrow
\frac{\text{actual on-leveled premium }t_i}{T_i}
}
$$

So the short answers are:

1. **Model paid loss** for this purpose, with coverage terms incorporated appropriately.
2. Convert predicted paid loss into **technical premium** using your pricing expense/profit structure.
3. Calculate **AvT = actual on-leveled premium / technical premium**, using the ratio of sums when reporting AvT for a segment or portfolio.

# Prompt

> How do we determine the permissible loss ratio?

# Response

The **permissible loss ratio (PLR) is not estimated from the loss model**. It comes from the company's expense structure and target underwriting return.

In the simplest formulation,

$$
\boxed{\mathrm{PLR}=1-V-Q}
$$

where

- $V$ = expenses that vary with premium, as a fraction of premium
- $Q$ = underwriting profit and contingency provision, as a fraction of premium.

This follows the standard ratemaking decomposition: the rate must provide for claims, claim-settlement expenses, operational/administrative expenses, and the cost of capital.

### Example

Suppose the company determines that:

- commissions: 8%
- premium taxes: 2%
- other variable expenses: 5%
- target underwriting profit/contingency: 5%

Then

$$
V=.08+.02+.05=.15
$$

and

$$
\mathrm{PLR}=1-.15-.05=.80.
$$

So 80 cents of each premium dollar is available for losses and any expenses that you have chosen to include with losses.

If your modeled expected loss for policy $i$ is $800, then

$$
T_i=\frac{800}{0.80}=\$1,000.
$$

If actual on-leveled premium was $900,

$$
AvT_i=\frac{900}{1000}=0.90.
$$

So that policy was priced at **90% of technical**.

## But there is an important complication for your application

Not all expenses should necessarily be handled through the PLR.

Suppose there is a **fixed per-policy expense** $F$, while $V$ represents expenses proportional to premium. Then technical premium is

$$
\boxed{
T_i =
\frac{\hat p_i + F_i}
     {1-V-Q}
}
$$

rather than simply

$$
\frac{\hat p_i}{\mathrm{PLR}}.
$$

This distinction matters for pet insurance because administrative/acquisition expenses need not scale proportionally with expected loss.

### So where do *your* numbers come from?

For an internal pet-insurance AvT study, I would ask Finance/Pricing for the company's **technical pricing assumptions**, specifically:

1. variable expense provision,
2. fixed expense provision,
3. claim-adjustment expenses, and whether those are already included in your loss definition,
4. target profit/contingency or return provision.

**Don't infer the PLR from the observed historical loss ratio.** A historical loss ratio tells you what happened under historical prices and losses. The permissible loss ratio is an **assumption defining the premium level considered adequate** given the expense and return requirements.

And this exposes something I oversimplified in my previous answer: **you cannot turn your predicted paid losses into technical premium just by choosing a generic target loss ratio.** You need your company's expense and return assumptions.

So in your project, if nobody has supplied those assumptions yet, **you do not yet have enough information to calculate a genuine AvT from the loss model.**

# Prompt

> Suppose I can't get F, V, Q from the business end. Could I estimate them for different segments from the actual $p_i$ and $t_i$?

# Response

Yes, but with an important limitation: **from $p_i$ and $t_i$ alone you can estimate the historical relationship between losses and premium, but you cannot separately identify $F$, $V$, and $Q$.**

The standard ratemaking equation distinguishes loss, fixed expenses, variable expenses, and profit:

$$
T_i = \frac{E[p_i] + F_i}{1-V_i-Q_i}.
$$

### What you *can* estimate

For a segment $s$, you can calculate the empirical loss ratio

$$
LR_s =
\frac{\sum_{i\in s}p_i}
     {\sum_{i\in s}t_i}.
$$

If losses are sufficiently mature and appropriately adjusted, this estimates the segment's **historical loss cost relative to actual premium**.

But it does **not** estimate the permissible loss ratio.

For example, suppose a segment has

$$
LR_s=0.72.
$$

There are infinitely many economic structures consistent with that observed result:

$$
F=0,\quad V+Q=0.28
$$

is one possibility, but so is

$$
F>0,\quad V+Q<0.28.
$$

More fundamentally, the fact that the company *experienced* a 72% loss ratio doesn't tell you that the company *intended* to price to a 72% loss ratio. The latter is what you need for technical premium.

## However, there is something useful you can do

Given your objective, I think I would change the analysis slightly.

You already have a model of expected paid loss:

$$
\hat p_i = E[p_i\mid x_i,c_i,d_i,l_i,\ldots].
$$

Instead of claiming to estimate an absolute technical premium, define a **loss-cost technical index**:

$$
R_i=\frac{\hat p_i}{ee_i}
$$

or simply $\hat p_i$ if working with earned term totals.

Then compare **relative technical adequacy** across policies:

$$
A_i = \frac{t_i}{\hat p_i}.
$$

This is essentially premium per dollar of expected loss. It is *not* AvT in the strict sense, because $\hat p_i$ hasn't been loaded for expenses and profit.

But notice something useful. If $F$ is negligible and $V+Q$ is approximately constant across policies,

$$
T_i=\frac{\hat p_i}{1-V-Q},
$$

so

$$
AvT_i
=
\frac{t_i}{T_i}
=
(1-V-Q)\frac{t_i}{\hat p_i}.
$$

Therefore **$t_i/\hat p_i$ has exactly the same relative ordering as true AvT**. The missing PLR is merely an unknown common multiplicative constant.

That means you can answer questions such as:

> Which policies or segments appear relatively underpriced compared with their modeled risk?

without knowing the company's target PLR.

### And you can normalize it

For example, define portfolio-average adequacy as 1:

$$
\boxed{
AvT_i^*
=
\frac{t_i/\hat p_i}
     {\sum_jt_j/\sum_j\hat p_j}
}
$$

Then:

- $AvT_i^*=1$: priced at the portfolio-average relationship between premium and modeled loss
- $AvT_i^*<1$: relatively underpriced
- $AvT_i^*>1$: relatively overpriced

For segments, I would use ratio-of-sums:

$$
\boxed{
AvT_s^*
=
\frac{
\displaystyle\frac{\sum_{i\in s}t_i}
{\sum_{i\in s}\hat p_i}
}{
\displaystyle\frac{\sum_i t_i}
{\sum_i\hat p_i}
}
}
$$

This is identifiable from the data you have.

I would call it something like **relative AvT**, **relative technical adequacy**, or **premium-to-technical-loss-cost index**, rather than absolute AvT.

One caveat matters: if fixed expenses $F_i$ differ materially across policies or segments, or the expense structure varies systematically by segment, that normalization no longer removes the unknown expense loading.

So given that the business hasn't provided $F,V,Q$, **I would use the normalized relative measure rather than estimate a PLR from $p_i/t_i$**. It gives you a defensible answer to relative underpricing without pretending that the observed loss ratio is the company's target loss ratio.

# Prompt

> What if, instead of modeling $\hat p_i$, I estiamte $\hat p_i$ from $\hat u_i$, $c_i$, $d_i$, $l_i$?

# Response

Yes. In fact, that decomposition can be preferable if your goal is to separate **pet risk** from **benefit design**.

If the eligible-loss model estimates

$$
\hat u_i = E[U_i\mid x_i],
$$

then you would ideally calculate

$$
\boxed{
\hat p_i
=
E\!\left[g(U_i;c_i,d_i,l_i)\mid x_i\right]
}
$$

where $g(\cdot)$ is the policy's payment function.

### One important correction

Generally,

$$
E[g(U)] \ne g(E[U]).
$$

So you usually **cannot** take the predicted mean eligible loss $\hat u_i$ and simply apply deductible, coinsurance, and limit:

$$
g(\hat u_i;c_i,d_i,l_i).
$$

For example, with a simple deductible,

$$
P=c\min\{(U-d)_+,l\}.
$$

Then what you need is

$$
E[P\mid x]
=
c\,E\left[\min\{(U-d)_+,l\}\mid x\right],
$$

not

$$
c\min\{(E[U\mid x]-d)_+,l\}.
$$

Thus your eligible-loss model needs to give you enough information about the **conditional distribution of eligible loss**, rather than only its conditional mean.

## Conceptually, though, I like this architecture

You would have:

$$
x_i
\longrightarrow
\text{eligible-loss distribution}
\longrightarrow
\text{coverage transformation }(c_i,d_i,l_i)
\longrightarrow
\hat p_i.
$$

This cleanly separates two things:

**Underlying risk**

$$
U_i\mid x_i
$$

from

**insurance contract**

$$
U_i \rightarrow P_i.
$$

Then your relative technical measure from our previous discussion becomes

$$
\frac{t_i}{\hat p_i},
$$

or normalized to the whole portfolio,

$$
\boxed{
AvT_i^*
=
\frac{t_i/\hat p_i}
{\sum_jt_j/\sum_j\hat p_j}
}
$$

subject to the same caveat about unknown expense structures.

And this has a particularly attractive interpretation for the **rules engine** you've been working on: a pet isn't classified as high risk merely because its owner selected rich coverage. The eligible-loss model estimates the pet's underlying expected claims risk, while the second step translates that risk through the actual coverage into expected insurer cost.

So **yes, I think this is a potentially cleaner framework than directly modeling paid loss**, provided your eligible-loss modeling approach allows you to correctly calculate the expected payment under $c_i,d_i,l_i$. The key question becomes whether your `eligible loss` data and benefit rules give you enough information to estimate that payment expectation.

# Prompt

> Right. I understand the Jensen's inequality issue. How do I determine if using $p = g(u)$ will be adequate for my purposes?

# Response

Yes. Since you observe **both** eligible loss $u_i$ and actual paid loss $p_i$, you can test directly whether the plug-in approximation

$$
\tilde p_i = g(u_i;c_i,d_i,l_i)
$$

is adequate for the *AvT purpose*. You do not need to decide this theoretically.

### The test I would use

Calculate $g(u_i)$ from the observed eligible loss for every term, then compare **aggregated observed paid loss** with **aggregated reconstructed paid loss**:

$$
R_s =
\frac{\sum_{i\in s} p_i}
     {\sum_{i\in s} g(u_i;c_i,d_i,l_i)}
$$

for the portfolio overall and, especially, across the dimensions that matter for your AvT analysis.

If $g(u)$ is an exact description of the benefit calculation and $u_i$ has sufficient granularity, you'd expect $R_s\approx1$.

But I think there's an even more important issue in your particular setup.

### Term-level aggregation may be the real problem

Suppose a term has two eligible claims of $500 each and a $250 **per-claim** deductible.

Actual reimbursement before coinsurance would be

$$
(500-250)+(500-250)=500.
$$

But your term-level eligible loss is

$$
u_i=1000,
$$

so applying the deductible once gives

$$
(1000-250)=750.
$$

That's not Jensen's inequality. It's a **loss-granularity problem**. Likewise, annual versus per-incident deductibles, annual limits, per-incident limits, reimbursement percentages, exclusions, etc. can make

$$
p_i \ne g(u_i,c_i,d_i,l_i)
$$

when $u_i$ is aggregated at a level above that at which the benefit provisions operate.

### What would convince me it is adequate?

Not that individual values are close.

For your use case, I'd want

$$
\frac{\sum p_i}{\sum g(u_i)}\approx1
$$

**within the segments over which AvT will be interpreted**, especially:

- deductible level,
- coinsurance level,
- limit level,
- predicted-risk bands,
- other major rating segments.

That directly tests whether the approximation introduces **systematic pricing-relevant bias**.

For example, this would concern me:

| Deductible | $\sum p/\sum g(u)$ |
|---|---:|
| $100 | 0.99 |
| $250 | 0.94 |
| $500 | 0.84 |

Even if the portfolio-wide ratio were 0.97, $g(u)$ would be unsuitable for comparing AvT across deductible levels because it systematically misstates the coverage relativity.

Conversely, if those ratios are all close to 1 with no material pattern, I would be comfortable treating

$$
\boxed{\hat p_i \approx g(\hat u_i;c_i,d_i,l_i)}
$$

as a **pragmatic approximation for relative AvT**, despite knowing mathematically that

$$
g(E[U\mid X])\ne E[g(U)\mid X].
$$

The empirical question isn't whether the equality is exact. We already know it generally isn't. The relevant question is whether the resulting error is large or systematically associated with the dimensions on which you're trying to detect underpricing.

**I would do this validation on observed $u_i,p_i$ first, before involving $\hat u_i$ at all.** That isolates whether your proposed coverage transformation is adequate from whether your eligible-loss model is adequate.

# Prompt

> Please do the following for me:
>
> 1. Format this entire chat in markdown
> 2. Each prompt should be preceded by `# Prompt`
> 3. The prompt should be quoted `>...`
> 4. Each response should be preceded by `# Response`
> 4. All math should be latex math with `$...$` or `$$...$$`. No unicode inline math.
> 5. The entire document should be a markdown file I can download.


# Response

The exposure bookkeeping depends on which of the two Tweedie formulations is used. Both approaches target the same conditional mean relationship,

$$
E[U_i \mid x_i, ee_i] = ee_i r_i,
$$

where:

- $U_i$ is term-level eligible loss,
- $ee_i$ is earned exposure, and
- $r_i$ is expected eligible loss per unit exposure.

They do **not**, in general, specify the same Tweedie likelihood or exposure-dependent variance. Therefore, they should be treated as two distinct modeling approaches even though their fitted predictions can be placed on the same rate and term-dollar scales.

## Approach 1: Model term-level eligible loss with an exposure offset

Fit the term-level eligible loss directly:

$$
U_i \sim \operatorname{Tweedie}(\mu_i, \phi, p),
$$

with

$$
\log(\mu_i) = \log(ee_i) + f(x_i).
$$

Equivalently,

$$
\mu_i = ee_i \exp\{f(x_i)\}.
$$

The processing chain is:

$$
\boxed{
U_i
\xrightarrow[\operatorname{offset}(\log ee_i)]{\text{model}}
\hat u_i
\xrightarrow{g(\cdot;c_i,d_i,l_i)}
\hat p_i
}
$$

### Prediction scale

With the observed offset supplied, a response-scale prediction is a **term-level eligible-loss amount**:

$$
\boxed{\hat u_i = ee_i \hat r_i.}
$$

Therefore, apply the coverage transformation directly to that term-level amount:

$$
\boxed{
\hat p_i = g(\hat u_i;c_i,d_i,l_i).
}
$$

Do **not** multiply $\hat u_i$ by exposure again.

If a downstream calculation needs the annualized eligible-loss rate, remove the exposure effect exactly once:

$$
\boxed{
\hat r_i = \frac{\hat u_i}{ee_i}.
}
$$

Alternatively, obtain the model prediction at $ee_i=1$, provided the prediction implementation supplies the offset consistently.

## Approach 2: Model eligible-loss rate with exposure weights

Define the observed eligible-loss rate:

$$
y_i = \frac{u_i}{ee_i}.
$$

Fit

$$
\frac{U_i}{ee_i}
\sim
\operatorname{Tweedie}(r_i,\phi,p),
\qquad
w_i=ee_i.
$$

The processing chain is:

$$
\boxed{
\frac{u_i}{ee_i}
\xrightarrow[\text{weights}=ee_i]{\text{model}}
\hat r_i
\xrightarrow{\times ee_i}
\hat u_i
\xrightarrow{g(\cdot;c_i,d_i,l_i)}
\hat p_i
}
$$

### Prediction scale

The response-scale prediction is an **eligible-loss rate per unit exposure**:

$$
\boxed{
\hat r_i
=
\widehat{E\!\left[U_i/ee_i \mid x_i\right]}.
}
$$

The fitting weight affects estimation. It does not convert a predicted rate into term-level dollars. Un-normalize exactly once:

$$
\boxed{
\hat u_i = ee_i \hat r_i.
}
$$

Then apply the coverage transformation:

$$
\boxed{
\hat p_i = g(ee_i\hat r_i;c_i,d_i,l_i).
}
$$

Do **not** use $g(\hat r_i;c_i,d_i,l_i)$, because dollar-valued deductibles and limits must be applied to a term-level eligible-loss amount, not to an annualized rate.

## Common downstream calculations

After either approach has produced term-level expected paid loss $\hat p_i$, do not multiply by exposure again. Both $\hat p_i$ and on-leveled earned premium $t_i$ are term-level dollar amounts.

### Relative technical adequacy

Without expense and profit provisions, the policy-level premium-to-expected-loss measure is

$$
\boxed{
A_i = \frac{t_i}{\hat p_i}.
}
$$

For a segment $s$, use the ratio of sums:

$$
\boxed{
A_s
=
\frac{\sum_{i\in s} t_i}
     {\sum_{i\in s} \hat p_i}.
}
$$

Do not average the individual ratios $t_i/\hat p_i$.

If a portfolio-normalized relative adequacy index is required, define

$$
\boxed{
A_s^*
=
\frac{
\displaystyle \frac{\sum_{i\in s}t_i}{\sum_{i\in s}\hat p_i}
}{
\displaystyle \frac{\sum_i t_i}{\sum_i\hat p_i}
}.
}
$$

This is a relative premium-to-technical-loss-cost index, not absolute AvT unless the required expense and profit provisions have been supplied.

### Absolute AvT

If technical premium is

$$
T_i = \frac{\hat p_i + F_i}{1-V_i-Q_i},
$$

then

$$
\boxed{
\operatorname{AvT}_i = \frac{t_i}{T_i}.
}
$$

For segment $s$:

$$
\boxed{
\operatorname{AvT}_s
=
\frac{\sum_{i\in s}t_i}
     {\sum_{i\in s}T_i}.
}
$$

## Validation of the coverage transformation

The observed-data validation of $g$ requires no exposure adjustment under either modeling formulation:

$$
\boxed{
R_s
=
\frac{\sum_{i\in s}p_i}
     {\sum_{i\in s}g(u_i;c_i,d_i,l_i)}.
}
$$

Both the numerator and denominator are already term-level dollar amounts. This validation should be performed overall and within the coverage and rating segments for which adequacy will be interpreted.

## Important limitation of the plug-in transformation

The convenient approximation

$$
\hat p_i \approx g(\hat u_i;c_i,d_i,l_i)
$$

is not generally equal to

$$
E[g(U_i;c_i,d_i,l_i)\mid x_i].
$$

The empirical validation above determines whether the approximation is adequate for the intended segment-level analysis. It does not establish equality of the two expectations.

## Corrected replacement for the earlier annualized-loss-cost passage

The earlier passage should be replaced with the following formulation.

### Offset formulation

$$
\boxed{
\hat u_i
=
\widehat{E[U_i\mid x_i,ee_i]},
\qquad
\hat r_i=\frac{\hat u_i}{ee_i},
\qquad
\hat p_i=g(\hat u_i;c_i,d_i,l_i).
}
$$

### Exposure-weighted rate formulation

$$
\boxed{
\hat r_i
=
\widehat{E[U_i/ee_i\mid x_i]},
\qquad
\hat u_i=ee_i\hat r_i,
\qquad
\hat p_i=g(\hat u_i;c_i,d_i,l_i).
}
$$

Thus, the two approaches differ in what the model predicts directly:

- The **offset model** directly predicts term-level eligible loss $\hat u_i$ for the supplied exposure.
- The **weighted-rate model** directly predicts annualized eligible-loss rate $\hat r_i$.

Once each prediction is converted to term-level eligible loss, the coverage transformation and all subsequent adequacy calculations are the same.
