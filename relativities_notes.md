Yes. You are reading the two definitions correctly.

1. Overall relativity

For an arbitrary risk vector

x=(x1,x2,…,xp),x=(x_1,x_2,\ldots,x_p),

the overall relativity is

R(x)=μ^(x1,x2,…,xp)μ^(x1b,x2b,…,xpb).R(x)=\frac{\hat\mu(x_1,x_2,\ldots,x_p)} {\hat\mu(x_1^b,x_2^b,\ldots,x_p^b)}.

So all variables in the numerator can differ from their base values simultaneously.

It answers:

How expensive is this entire risk relative to the base risk?

For example,

R(Dog, age 7, Oregon)=μ^(Dog, age 7, Oregon)μ^(Cat, age 2, Washington).R(\text{Dog, age 7, Oregon}) = \frac{\hat\mu(\text{Dog, age 7, Oregon})} {\hat\mu(\text{Cat, age 2, Washington})}.

Interactions present no special problem here. You're simply evaluating the complete fitted model at two points.

2. One-way relativity

For variable jj,

rj(xj)=μ^(xj,x−jb)μ^(xjb,x−jb).r_j(x_j) = \frac{\hat\mu(x_j,x_{-j}^b)} {\hat\mu(x_j^b,x_{-j}^b)}.

Since

(xjb,x−jb)=xb,(x_j^b,x_{-j}^b)=x^b,

that's exactly your expression

rj(xj)=μ^(xj,x−jb)μ^(xb).r_j(x_j) = \frac{\hat\mu(x_j,x_{-j}^b)} {\hat\mu(x^b)}.

So here only xjx_j changes. Everything else remains at its base value.

It answers a different question:

Starting from the base risk, what happens if I change only this rating variable?

For example,

rage(7)=μ^(Cat, age 7, Washington)μ^(Cat, age 2, Washington).r_{\text{age}}(7) = \frac{\hat\mu(\text{Cat, age 7, Washington})} {\hat\mu(\text{Cat, age 2, Washington})}.
Where interactions become important

Suppose the model contains an age × species interaction.

Then

rage(7)r_{\text{age}}(7)

is specifically the age-7 effect when species is held at its base value.

It does not generally tell you what changing age from 2 to 7 does for a dog.

That's why

R(x)≠∏jrj(xj)R(x) \neq \prod_j r_j(x_j)

in general.

Instead,

R(x)=[∏jrj(xj)]I(x),R(x) = \left[\prod_j r_j(x_j)\right]I(x),

where I(x)I(x) captures precisely the part of the full-model prediction that cannot be reconstructed by changing each variable individually from the common base.

So the distinction you noticed is fundamental:

R(x):all variables may move together\boxed{ R(x):\quad \text{all variables may move together} }

versus

rj(xj):change one variable, hold everything else at base\boxed{ r_j(x_j):\quad \text{change one variable, hold everything else at base} }

And this is exactly why choosing a particular base risk starts to feel awkward once you have interactions: the reported "age relativity," for example, is conditional on whatever species, geography, etc. you happened to choose as the base.


Almost. But I would phrase it differently, because xjx_j itself doesn't determine which components of x−jx_{-j} should match it.

The move from a one-way relativity to a partial relativity is essentially:

Instead of evaluating the effect of xjx_j at one fixed configuration x−jbx_{-j}^b, evaluate it across the relevant values of x−jx_{-j}, then average over those values.

So instead of

rj(xj)=μ^(xj,x−jb)μ^(xjb,x−jb),r_j(x_j) = \frac{\hat\mu(x_j,x_{-j}^b)} {\hat\mu(x_j^b,x_{-j}^b)},

you are heading toward something like

EX−j[μ^(xj,X−j)]EX−j[μ^(xjb,X−j)].\frac{ E_{X_{-j}}\left[\hat\mu(x_j,X_{-j})\right] }{ E_{X_{-j}}\left[\hat\mu(x_j^b,X_{-j})\right] }.

The important difference is:

One-way relativity: choose one x−jbx_{-j}^b and hold it fixed.
Partial relativity: let X−jX_{-j} vary over the portfolio while fixing Xj=xjX_j=x_j.

That becomes especially important with interactions. Suppose age interacts with species. For the partial relativity for age =7=7, you would evaluate

μ^(7,xi,−age)\hat\mu(7,x_{i,-\text{age}})

for each portfolio observation ii. Thus some evaluations are age-7 dogs, some are age-7 cats, etc., according to the portfolio distribution of the other variables.

You then aggregate those predictions.

So I think the idea you are reaching for is correct, but rather than "setting some part of x−jbx_{-j}^b to match xjx_j", I'd say:

replace the fixed x−jb with the portfolio distribution of X−j.\boxed{\text{replace the fixed }x_{-j}^b\text{ with the portfolio distribution of }X_{-j}.}

That's the conceptual bridge from the base-conditioned one-way relativity to a portfolio-averaged partial relativity.


Not quite. The one-way line is the one that needs correcting.

Overall relativity R(x)R(x): argument is the full risk vector xx.

One-way relativity rj(xj)r_j(x_j): index is risk variable jj; argument is its value xjx_j. All other variables are held at their base values x−jbx_{-j}^b, not integrated over.

rj(xj)=μ^(xj,x−jb)μ^(xjb,x−jb)r_j(x_j) = \frac{\hat\mu(x_j,x_{-j}^b)} {\hat\mu(x_j^b,x_{-j}^b)}

Partial relativity rjpartial(xj)r_j^{\mathrm{partial}}(x_j): index is risk variable jj; argument is its value xjx_j. The other variables are integrated/averaged over a specified distribution, such as the empirical portfolio distribution.

For example,

rjpartial(xj)=EX−j[μ^(xj,X−j)]EX−j[μ^(xjb,X−j)].r_j^{\mathrm{partial}}(x_j) = \frac{ E_{X_{-j}}\left[\hat\mu(x_j,X_{-j})\right] }{ E_{X_{-j}}\left[\hat\mu(x_j^b,X_{-j})\right] }.

So the key contrast is simply:

one-way: hold x−j fixedvs.partial: average over X−j\boxed{\text{one-way: hold }x_{-j}\text{ fixed}} \qquad\text{vs.}\qquad \boxed{\text{partial: average over }X_{-j}}

This is also why partial relativities are attractive for your interacting model: they don't make the reported effect of xjx_j conditional on one arbitrarily chosen combination x−jbx_{-j}^b.



Not necessarily. There are two different computational ideas hiding under "averaging over."

If your target is the portfolio-averaged partial relativity, then in practice you usually average over the observed rows, not an artificial grid:

μˉj(z)=1n∑i=1nμ^(z,xi,−j).\bar\mu_j(z) = \frac{1}{n}\sum_{i=1}^n \hat\mu(z,x_{i,-j}).

For each observed risk ii, you replace xijx_{ij} with the putative value zz, while leaving that risk's other covariates unchanged.

So if j=j= age and z=7z=7:

Take every policy in the portfolio.
Set its age to 7.
Leave breed, species, geography, etc. at that policy's observed values.
Predict.
Average those predictions.

You repeat that calculation over a grid of putative values of zz to obtain the function

z↦μˉj(z).z\mapsto\bar\mu_j(z).

So the grid is over the focal variable xjx_j. The "integration" over X−jX_{-j} is performed empirically using the observed portfolio:

EX−j ⁣[μ^(z,X−j)]≈1n∑iμ^(z,xi,−j).E_{X_{-j}}\!\left[\hat\mu(z,X_{-j})\right] \approx \frac1n\sum_i\hat\mu(z,x_{i,-j}).

That's a useful distinction:

Grid over xjx_j; empirical average over X−jX_{-j}.

And this is very close to what packages such as marginaleffects call average predictions.


Yes on the categorical calculation, with one important issue: for your insurance application, I think you probably do want exposure weighting.

For a value zz of rating variable jj, compute the portfolio-averaged prediction as

μˉj(z)=∑i=1Nwi μ^(z,xi,−j)∑i=1Nwi.\bar\mu_j(z) = \frac{\sum_{i=1}^N w_i\,\hat\mu(z,x_{i,-j})} {\sum_{i=1}^N w_i}.

The marginaleffects documentation makes this distinction explicit: avg_predictions() averages predictions over the empirical distribution and provides wts for a weighted average.

Should wiw_i be earned exposure?

If your μ^i\hat\mu_i is the loss rate/pure premium per unit exposure that you've been modeling, then yes, I would use earned exposure:

wi=eei.w_i=ee_i.

Then your partial relativity describes the effect for a randomly selected unit of exposure in the portfolio, rather than for a randomly selected policy-term row.

That's generally the more natural estimand for the pricing relativities you've been describing.

Categorical variable

Exactly as you said. If species has levels Cat, Dog, Other, then for each level zz:

μˉspecies(z)=∑ieei μ^(z,xi,−species)∑ieei.\bar\mu_{\text{species}}(z) = \frac{ \sum_i ee_i\, \hat\mu(z,x_{i,-\text{species}}) }{ \sum_i ee_i }.

Every original row gets temporarily assigned species = z; everything else stays as observed.

So you get three numbers:

μˉ(Cat),μˉ(Dog),μˉ(Other).\bar\mu(\mathrm{Cat}),\quad \bar\mu(\mathrm{Dog}),\quad \bar\mu(\mathrm{Other}).

You then normalize these appropriately to get relativities.

Continuous variable

Conceptually, exactly the same thing.

Choose a sequence of values

z1,z2,…,zKz_1,z_2,\ldots,z_K

spanning the useful range of the continuous variable.

For each zkz_k, set that variable to zkz_k for every row, predict all NN rows, and calculate

μˉj(zk)=∑ieeiμ^(zk,xi,−j)∑ieei.\bar\mu_j(z_k) = \frac{ \sum_i ee_i\hat\mu(z_k,x_{i,-j}) }{ \sum_i ee_i }.

So if pet_age runs from 0 through 20, you might obtain

pet ageexposure-weighted mean prediction0μˉ(0)1μˉ(1)2μˉ(2)⋮⋮20μˉ(20)\begin{array}{c|c} \text{pet age} & \text{exposure-weighted mean prediction}\\ \hline 0 & \bar\mu(0)\\ 1 & \bar\mu(1)\\ 2 & \bar\mu(2)\\ \vdots & \vdots\\ 20 & \bar\mu(20) \end{array}

If the variable is genuinely continuous, you choose a sufficiently fine grid rather than evaluating every possible real number. The marginaleffects API likewise distinguishes the values at which a focal numeric variable is evaluated from the observations over which predictions are averaged.

So computationally there really isn't much difference between categorical and continuous variables:

For each chosen z:xij←z⟶predict all rows⟶exposure-weighted average\boxed{ \text{For each chosen }z: \quad x_{ij}\leftarrow z \quad\longrightarrow\quad \text{predict all rows} \quad\longrightarrow\quad \text{exposure-weighted average} }

The categorical levels are simply the natural grid for a categorical variable.


No. That is precisely the nice part of this construction. You do not need to define a new eeiee_i when you counterfactually change age.

For a particular value, say age =1=1, you construct

μˉage(1)=∑ieei μ^(age=1,xi,−age)∑ieei.\bar\mu_{\text{age}}(1) = \frac{ \sum_i ee_i\,\hat\mu(\text{age}=1,x_{i,-\text{age}}) }{ \sum_i ee_i }.

The eeiee_i's remain the observed exposures of the original rows.

You're asking:

What would the portfolio's average predicted loss rate be if every unit of our existing exposure were assigned age 1, while retaining the portfolio's distribution of all other characteristics?

So row ii becomes counterfactually age 1, but it retains its original exposure eeiee_i.

Then repeat:

μˉage(2)=∑ieei μ^(2,xi,−age)∑ieei,\bar\mu_{\text{age}}(2) = \frac{ \sum_i ee_i\,\hat\mu(2,x_{i,-\text{age}}) }{ \sum_i ee_i },

and so forth.

There's an important subtlety here

If age is associated with the amount of exposure itself, then what we're doing is deliberately not asking:

What does the actual portfolio of one-year-old pets look like?

That would condition on age and therefore give you a different distribution of X−jX_{-j} and exposures for every age.

Instead, partial relativity is asking the counterfactual/model question:

What does the model predict if I change age, while holding the portfolio constant?\boxed{\text{What does the model predict if I change age, while holding the portfolio constant?}}

Thus the same rows and same exposure weights are used at age 1, age 2, age 3, etc.

That is what makes comparisons such as

μˉage(10)μˉage(2)\frac{\bar\mu_{\text{age}}(10)} {\bar\mu_{\text{age}}(2)}

isolate the modeled age effect, including the way age interacts with the fixed portfolio distribution of the other variables.



Yes, I see the confusion. ii is always an observation or row in your portfolio, not a level of the variable.

Suppose your data look schematically like this:

ii species age state eeiee_i1 Dog 2 OR 1.0
2 Cat 7 WA 0.5
3 Dog 4 CA 0.8
⋮\vdots    

Then i=1,…,Ni=1,\ldots,N indexes those policy-term rows.

Categorical example: species

To calculate the partial prediction for Dog, you counterfactually set every row to Dog:

ii species age state eeiee_i1 Dog 2 OR 1.0
2 Dog 7 WA 0.5
3 Dog 4 CA 0.8

Predict every row, then calculate

μˉspecies(Dog)=∑i=1Neeiμ^(Dog,xi,−species)∑i=1Neei.\bar\mu_{\text{species}}(\text{Dog}) = \frac{ \sum_{i=1}^N ee_i \hat\mu(\text{Dog},x_{i,-\text{species}}) }{ \sum_{i=1}^N ee_i }.

Then do the same thing with every row set to Cat, etc.

So this is not the total exposure of actual dogs. The eeiee_i's are the exposures of the original NN observations.

Continuous example: age

It's exactly the same operation.

For age 1, make a counterfactual dataset:

ii species age state eeiee_i1 Dog 1 OR 1.0
2 Cat 1 WA 0.5
3 Dog 1 CA 0.8

and compute

μˉage(1)=∑i=1Neeiμ^(1,xi,−age)∑i=1Neei.\bar\mu_{\text{age}}(1) = \frac{ \sum_{i=1}^N ee_i \hat\mu(1,x_{i,-\text{age}}) }{ \sum_{i=1}^N ee_i }.

Then set all NN rows to age 2 and repeat:

μˉage(2)=∑i=1Neeiμ^(2,xi,−age)∑i=1Neei.\bar\mu_{\text{age}}(2) = \frac{ \sum_{i=1}^N ee_i \hat\mu(2,x_{i,-\text{age}}) }{ \sum_{i=1}^N ee_i }.

And so on.

So the notation has two different indices/arguments that are easy to conflate:

i=portfolio observation\boxed{ i = \text{portfolio observation} }

while

z=the level/value of the focal rating variable being evaluated\boxed{ z = \text{the level/value of the focal rating variable being evaluated} }

Hence the general expression is

μˉj(z)=∑i=1Neei μ^(z,xi,−j)∑i=1Neei.\bar\mu_j(z) = \frac{\sum_{i=1}^N ee_i\,\hat\mu(z,x_{i,-j})} {\sum_{i=1}^N ee_i}.

That distinction also means your original conception of the categorical calculation, "add up exposure within each observed level," was a different calculation from the partial relativity we're discussing.



Almost. There are two different averaging operations, and I think that is what has been getting tangled.

One-way relativity

For a chosen value zz of variable jj:

rj(z)=μ^(z,x−jb)μ^(xjb,x−jb).r_j(z) = \frac{\hat\mu(z,x_{-j}^b)} {\hat\mu(x_j^b,x_{-j}^b)}.

There is no averaging over portfolio rows here. You construct a single hypothetical risk:

(z,x−jb)(z,x_{-j}^b)

and predict it. All the other variables are fixed at their base values.

Partial relativity

Here you eliminate that arbitrary x−jbx_{-j}^b. For the same zz, you evaluate the model for every portfolio row, keeping that row's other characteristics:

μ^(z,x1,−j),μ^(z,x2,−j),…,μ^(z,xN,−j).\hat\mu(z,x_{1,-j}),\quad \hat\mu(z,x_{2,-j}),\quad\ldots,\quad \hat\mu(z,x_{N,-j}).

Then average those predictions, perhaps exposure-weighted:

μˉj(z)=∑ieeiμ^(z,xi,−j)∑ieei.\bar\mu_j(z) = \frac{\sum_i ee_i\hat\mu(z,x_{i,-j})} {\sum_i ee_i}.

So yes, your last sentence is essentially right:

With partial relativities, I go back and average over the other variables.

More precisely, you're averaging the model predictions over the portfolio's joint empirical distribution of the other variables.

That's the fundamental distinction:

One-way: xj=z,X−j=x−jbPartial: xj=z,X−j∼portfolio\boxed{ \begin{aligned} \text{One-way: }&x_j=z,\qquad X_{-j}=x_{-j}^b\\[3pt] \text{Partial: }&x_j=z,\qquad X_{-j}\sim\text{portfolio} \end{aligned}}

And you do that for every zz you're interested in, whether zz is Dog/Cat or age 1,2,3,…1,2,3,\ldots.



They are closely related, but ICE is observation-specific, whereas your one-way relativity is base-risk-specific.

For variable jj, define the ICE curve for portfolio observation ii as

ICEij(z)=μ^(z,xi,−j).ICE_{ij}(z)=\hat\mu(z,x_{i,-j}).

That means:

Take observation ii, leave all of its other characteristics unchanged, vary xjx_j through values zz, and see what the model predicts.

So each observation gets its own curve.

Your one-way calculation is

μ^(z,x−jb),\hat\mu(z,x_{-j}^b),

which is mathematically the same operation, except instead of starting from an actual observation ii, you start from your chosen base risk xbx^b.

Thus:

one-way prediction curve=ICE-like curve for the base risk\boxed{ \text{one-way prediction curve} = \text{ICE-like curve for the base risk} }

If you convert both to relativities by normalizing at xjbx_j^b, the correspondence is even clearer.

ICE relativity for observation ii
rijICE(z)=μ^(z,xi,−j)μ^(xjb,xi,−j).r_{ij}^{ICE}(z) = \frac{ \hat\mu(z,x_{i,-j}) }{ \hat\mu(x_j^b,x_{i,-j}) }.

This says, "For this particular risk, how much does prediction change when I move xjx_j from the reference value to zz?"

One-way relativity
rj(z)=μ^(z,x−jb)μ^(xjb,x−jb).r_j(z) = \frac{ \hat\mu(z,x_{-j}^b) }{ \hat\mu(x_j^b,x_{-j}^b) }.

That's the same construction evaluated at the single configuration x−jbx_{-j}^b.

This becomes especially informative with interactions.

Suppose age interacts with species. A dog policy ii might have

ri,ageICE(10)=2.1,r_{i,\text{age}}^{ICE}(10)=2.1,

while a cat policy kk might have

rk,ageICE(10)=1.4.r_{k,\text{age}}^{ICE}(10)=1.4.

The ICE curves differ because changing age has a different modeled effect depending on the other characteristics of the risk.

Your conventional one-way age relativity chooses one of those contexts, x−agebx_{-\text{age}}^b, and reports the curve in that context.

And this leads directly to the relationship with what we've been calling the partial effect:

ICE:one curve for each xi,−jOne-way relativity:one curve at chosen x−jbPartial prediction:average the ICE predictions over i\boxed{ \begin{array}{rcl} \text{ICE} &:& \text{one curve for each }x_{i,-j}\\ \\ \text{One-way relativity} &:& \text{one curve at chosen }x_{-j}^b\\ \\ \text{Partial prediction} &:& \text{average the ICE predictions over }i \end{array}}

Specifically,

μˉj(z)=∑ieei ICEij(z)∑ieei.\bar\mu_j(z) = \frac{\sum_i ee_i\,ICE_{ij}(z)} {\sum_i ee_i}.

So ICE is actually the machinery underlying the portfolio-averaged partial curve we were discussing: generate the ICE predictions for every portfolio observation, then average them at each value zz.

One caution: averaging the ICE predictions and then taking ratios is generally not the same as averaging the ICE relativities rijICE(z)r_{ij}^{ICE}(z). That distinction matters for exactly how you choose to define your final "partial relativity."





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


Right. We need to add partial relativity as a separate row, and distinguish it from PD by the normalization step. I would also change “Effect” in the one-way row to “Relativity” for consistency with our earlier distinction.

Here is the updated version as literal Markdown:

| Quantity | What happens to $x_j$? | What happens to $x_{-j}$? | Mental model |
| --- | --- | --- | --- |
| **Overall relativity** | Entire risk vector $\mathbf{x}$ | Not applicable | Compare the **entire risk vector** $\mathbf{x}$ with base risk $\mathbf{x}^b$ |
| **One-way relativity** | Vary $x_j$ | Fix at **one base risk** $x_{-j}^b$ | Relativity as a function of $x_j$ for the chosen base risk |
| **ICE** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$ | Prediction as a function of $x_j$ for each individual risk |
| **Partial dependence (PD)** | Vary $x_j$ | Fix at **one actual observation** $x_{i,-j}$; repeat for each $i$, then average over $i$ | Average prediction as a function of $x_j$ across the portfolio |
| **Partial relativity** | Vary $x_j$ | Same as PD: repeat over $x_{i,-j}$ and average over $i$ | Partial-dependence curve normalized relative to a reference value of $x_j$ |

And I'd update the shorthand to:

- **Base risk** $\rightarrow$ one-way relativity
- **One observed risk at a time** $\rightarrow$ ICE
- **All observed risks, then average** $\rightarrow$ partial dependence
- **All observed risks, average, then normalize** $\rightarrow$ partial relativity
- **Don't isolate $j$ at all** $\rightarrow$ overall relativity

That last list gives you a particularly clean progression:

ICE predictions→average over iPD→normalizepartial relativity.\text{ICE predictions} \quad\xrightarrow{\text{average over }i}\quad \text{PD} \quad\xrightarrow{\text{normalize}}\quad \text{partial relativity}.

And separately:

prediction at (xj,x−jb)→normalizeone-way relativity.\text{prediction at }(x_j,x_{-j}^{b}) \quad\xrightarrow{\text{normalize}}\quad \text{one-way relativity}.

So one-way relativity and partial relativity differ primarily in where you evaluate/average over x−jx_{-j}, while PD and partial relativity differ primarily in whether the resulting prediction curve is normalized.


Exactly. I think you've identified an important structural distinction.

For partial relativity as we've defined it,

rjpartial(z)=PDj(z)PDj(zb)=Avg⁡i[μ^(z,xi,−j)]Avg⁡i[μ^(zb,xi,−j)].r_j^{\mathrm{partial}}(z) = \frac{PD_j(z)}{PD_j(z^b)} = \frac{ \operatorname{Avg}_i[\hat\mu(z,x_{i,-j})] }{ \operatorname{Avg}_i[\hat\mu(z^b,x_{i,-j})] }.

Notice what stays the same between numerator and denominator:

xi,−jis the same portfolio distribution in both.x_{i,-j}\quad\text{is the same portfolio distribution in both.}

Only xjx_j changes.

Compare that with overall relativity:

R(x)=μ^(x)μ^(xb).R(x) = \frac{\hat\mu(x)} {\hat\mu(x^b)}.

Here the numerator and denominator can differ in every variable.

And one-way relativity sits interestingly between them:

rj(z)=μ^(z,x−jb)μ^(zb,x−jb).r_j(z) = \frac{\hat\mu(z,x_{-j}^b)} {\hat\mu(z^b,x_{-j}^b)}.

Again, only xjx_j changes between numerator and denominator, but you're asking about that change in the particular context of the base risk.

So I might sharpen the unified picture to:

Relativities differ in what constitutes the comparison population

Overall relativity

xvs.xb\boxed{x \quad\text{vs.}\quad x^b}

This whole pet versus the whole baseline pet.

One-way relativity

(z,x−jb)vs.(zb,x−jb)\boxed{(z,x_{-j}^b)\quad\text{vs.}\quad(z^b,x_{-j}^b)}

Change only xjx_j, for the baseline pet.

Partial relativity

{(z,xi,−j)}i=1Nvs.{(zb,xi,−j)}i=1N\boxed{ \{(z,x_{i,-j})\}_{i=1}^N \quad\text{vs.}\quad \{(z^b,x_{i,-j})\}_{i=1}^N }

Change only xjx_j, for the same whole portfolio, then compare the average predictions.

That last one is much more isolated, as you put it. The nuisance of selecting a complete base risk xbx^b has mostly disappeared. You need a reference value zbz^b for the variable whose relativity you're reporting, but you don't need reference values for every other variable.

And that gives us yet another nice way of seeing the family:

Overall:whole risk vs. whole base riskOne-way:one variable vs. its base, conditional on base riskPartial:one variable vs. its base, averaged over the portfolio\boxed{ \begin{array}{lll} \text{Overall} &:& \text{whole risk vs. whole base risk}\\[3pt] \text{One-way} &:& \text{one variable vs. its base, conditional on base risk}\\[3pt] \text{Partial} &:& \text{one variable vs. its base, averaged over the portfolio} \end{array} }

I think "conditional on base risk" vs. "averaged over portfolio" captures the one-way/partial distinction particularly cleanly.


---

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
