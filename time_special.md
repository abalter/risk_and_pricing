# Prompt
> Harrell, Efron and others have claimed and partially shown that bootstrap optimism testing can replace k-fold CV in most cases where the DGP is static. Has there been work done to extend this idea to temporal CV?
> 
> One question I have is whether time is actually a special variable or just another continuous variable. Consider model that includes price or age. Typically, one is not concerned about doing CV _along_ one of those varaibles, even though the DGP may be a function of them. We just hope we have enough data to capture the evolution of the DGP along those variables as encoded in their coefficient and the coefficients of interaction terms containing them.
> 
> We know time _is_ special in terms of causality. But is it actually special as a continuos variable in a linear model in the way it affects CV?

# Response
Yes. But I think there are two distinct issues that are easy to conflate:

- **Dependence:** observations close in time may not be independent.
- **Distributional change:** $P(Y, X \mid t)$ itself may change with calendar time.

There is a substantial literature extending bootstrap ideas to address (1). There is much less sense in which bootstrap optimism correction can replace temporal validation when the thing you want to measure is (2).

And this distinction gets directly at your question about whether time is really special.

## 1. In a stationary world, time is surprisingly not that special

Suppose the true model is

$$Y_i = f(X_i,t_i) + \epsilon_i$$

and $f$ is stable. For example,

$$E[Y_i\mid X_i,t_i] = \beta_0+\beta_1X_i+\beta_2t_i+\beta_3X_it_i.$$

There is nothing intrinsically different here between $t$ and age or price. If you have adequately sampled the support of $t$, correctly modeled its functional form and interactions, and the conditional distribution is stable, then calendar time is just another predictor.

That is more than a thought experiment. Christoph Bergmeir, Rob J. Hyndman, and Bonsoo Koo show that ordinary $K$-fold CV can actually be valid for autoregressive time-series prediction under conditions including uncorrelated model errors. Their point is explicitly that temporal ordering alone does not automatically invalidate ordinary CV.

That result pushes in exactly the direction you are thinking.

So I would revise the common rule

> "If there is time, you must use temporal CV."

to something much more precise:

> If the prediction problem involves distributional change over calendar time, validation must reproduce that change.

Temporal ordering by itself is not sufficient to establish that.

## 2. What makes time different from age or price?

Here is the crucial distinction.

Suppose price has an effect:

$$Y = f(\text{price})+\epsilon.$$

Training observations at price \$50 and test observations at price \$60 can still be draws from the same joint DGP. Price varies, but the relationship generating observations hasn't changed.

Now suppose calendar time has an effect:

$$Y=f(t)+\epsilon.$$

Again, this need not create a special validation problem. If the function is stable, you can estimate $f(t)$.

The problem occurs when the function itself depends on time:

$$Y_t = f_t(X_t)+\epsilon_t.$$

Now

$$P_t(Y\mid X) \neq P_{t+h}(Y\mid X).$$

That cannot generally be handled merely by putting a linear time term into the model.

For example, in insurance:

$$E[L\mid X,t] = \exp\left( \beta_0+ \beta_X X+ \beta_t t \right)$$

might adequately represent ordinary inflationary drift.

But suppose the age effect itself changes:

$$\beta_{\mathrm{age}}=\beta_{\mathrm{age}}(t).$$

Or underwriting changes. Or claims handling changes. Or the geographic mix changes. Or veterinary costs undergo a structural shift.

Then the thing evolving isn't merely the value of a predictor.

The mapping

$$X\rightarrow Y$$

is evolving.

That's the important sense in which calendar time can be special.

## 3. And this explains exactly what the ordinary optimism bootstrap estimates

Harrell-style optimism correction conceptually estimates

$$\operatorname{Optimism} = E\left[ L(\hat f_D,D^\mathrm{new}) - L(\hat f_D,D) \right],$$

where $D$ and $D^{\mathrm{new}}$ are draws from approximately the same population.

The bootstrap estimates how much performance you lose when moving from the sample upon which the model was developed to another sample from the same underlying distribution. Ewout W Steyerberg and Frank E Harrell Jr explicitly characterize bootstrapping as an internal-validation method and emphasize that all model-development steps must be repeated inside the bootstrap.

That's why bootstrap optimism can substitute for random CV in the setting Harrell is usually talking about.

But temporal CV can target a different quantity:

$$E\left[ L(\hat f_{D_{\leq t}},D_{t+h}) \right].$$

Now the training distribution is $P_{\leq t}$, while the target is $P_{t+h}$.

If

$$P_{t+h}=P_{\leq t},$$

the distinction largely collapses.

If

$$P_{t+h}\neq P_{\leq t},$$

it does not.

No ordinary bootstrap of the historical observations can manufacture information about an unknown future distribution.

That's the fundamental limitation.

## 4. But there absolutely has been work on bootstrapping temporal data

This literature is quite old and extensive.

Hans R. Künsch's 1989 paper is foundational. He showed that ordinary IID bootstrap resampling fails under serial dependence and developed the block bootstrap for general stationary sequences. Instead of resampling individual observations, it resamples contiguous blocks, preserving local dependence. Importantly, his theoretical setting is explicitly stationary processes with short-range dependence.

That spawned moving-block, stationary, circular-block, sieve, and related bootstraps. For example, Peter Bühlmann's sieve bootstrap approximates a stationary linear process by increasingly rich autoregressive models and resamples innovations; the paper explicitly contrasts this with Künsch's block bootstrap.

More recent work continues this line. Yiren Wang and Dimitris N. Politis develop a model-free bootstrap for a general class of stationary time series and establish validity even for one-step-ahead bootstrap prediction intervals.

So bootstrap theory has successfully attacked:

$$\text{IID} \quad\longrightarrow\quad \text{stationary dependent data}.$$

But notice the word that keeps appearing: **stationary**.

That is important.

Most of this work solves the dependence problem, not arbitrary future distribution shift.

## 5. This suggests a better taxonomy than "time-series vs non-time-series"

For your insurance problem, I'd distinguish three situations.

**A. Stable conditional DGP**

$$P(Y\mid X,t)=P(Y\mid X)$$

apart from measured covariates.

There is no special temporal validation requirement. Random resampling/bootstrap is reasonable.

**B. Stable temporal structure**

$$P(Y\mid X,t)=f(X,t;\theta)$$

where $f$ is stable and calendar-time effects can be learned.

Examples could include a smooth inflation trend or stable seasonality.

Here your intuition is quite plausible: time behaves much like another continuous covariate.

The main complication may be serial dependence. Block/sieve bootstrap or appropriate CV can deal with that. Bergmeir, Hyndman, and Koo's result is particularly relevant because it demonstrates formally that even ordinary $K$-fold CV need not be invalid merely because the observations form a time series.

**C. Evolving DGP**

$$P_t(Y\mid X)\neq P_{t+h}(Y\mid X).$$

Now calendar time isn't merely a predictor.

It is an index identifying which distribution generated the observation.

That's qualitatively different.

And expanding-window temporal CV becomes useful because it asks the operational question:

> "If I had fitted this model then, how well would it have worked next?"

An IID bootstrap does not ask that question.

## 6. I think this also changes how we should think about your insurance CV disagreement

We've previously been framing your choice between random CV and temporal CV rather starkly.

I think that's slightly too crude.

The real question for your pet-insurance pricing model is:

What source of generalization error are we trying to estimate?

If you want to estimate finite-sample overfitting under an approximately stable DGP, Harrell-style bootstrap optimism correction is arguably the more efficient tool because you don't unnecessarily discard training observations. That is exactly the motivation behind bootstrap internal validation.

If you want to estimate degradation when deploying a model into a later insurance environment, temporal validation is estimating something bootstrap optimism is not.

And you may reasonably care about both.

Conceptually:

$$\boxed{ \text{Observed future error} \approx \text{estimation/overfit error} + \text{temporal transport error} }$$

I would not interpret that equation as a literal additive decomposition without additional assumptions. But conceptually it is very useful.

Bootstrap optimism primarily probes the first component.

Temporal backtesting probes both.

## 7. There's an interesting implication for expanding-window validation

Suppose your model explicitly contains:

- calendar time,
- inflation indices,
- age,
- geography,
- product changes,
- seasonality,
- relevant interactions,

and these adequately explain the evolution of loss.

Then temporal CV and random/bootstrap validation should start converging toward similar conclusions.

If they don't, that is potentially scientifically interesting.

For example:

$$\text{bootstrap deviance} \ll \text{future-window deviance}$$

could indicate that the model is not merely overfitting. It may be failing to transport through time.

That turns the disagreement between temporal CV and bootstrap validation into a diagnostic rather than forcing us to choose one as "correct."

So: is time special?

My answer would be: **not mathematically just because it is time.**

If calendar time enters a stable DGP through an estimable function, then your analogy to age or price is essentially correct. Treating calendar time as automatically requiring ordered CV is too strong. The theoretical results of Bergmeir et al. are useful evidence for precisely this point.

Time becomes special for validation when it indexes changes in the DGP that cannot be learned simply as a stable $t$-effect from the training sample.

That gives, I think, a much sharper principle:

$$\boxed{ \text{Temporal CV is not required because time is ordered.} }$$

$$\boxed{ \text{Temporal CV is required when future deployment entails temporal transport.} }$$

And that distinction is especially relevant to insurance pricing. Your question isn't fundamentally "Is this a time series?" It is:

> Is next year's insurance portfolio effectively another sample from the same conditional DGP, or are we asking the fitted model to transport to a different DGP?

That is the assumption I'd want the model-selection strategy to expose and test.

## Primary references

1. Hans R. Künsch (1989). *The Jackknife and the Bootstrap for General Stationary Observations*. Annals of Statistics, 17(3), 1217–1241. See the abstract and §1 for the extension from IID bootstrap to stationary dependent sequences.
2. Christoph Bergmeir, Rob J. Hyndman & Bonsoo Koo (2018). *A Note on the Validity of Cross-Validation for Evaluating Autoregressive Time Series Prediction*. Computational Statistics & Data Analysis, 120, 70–83. See the abstract and theoretical development concerning conditions under which ordinary $K$-fold CV remains valid.
3. Yiren Wang & Dimitris N. Politis (2022). *Model-free bootstrap for a general class of stationary time series*. Bernoulli, 28(2), 744–770. See §1 and the results on bootstrap prediction.
4. Ewout W. Steyerberg & Frank E. Harrell Jr (2016). *Prediction models need appropriate internal, internal-external, and external validation*. Journal of Clinical Epidemiology, 69, 245–247. See the discussion of bootstrap internal validation and repeating the full modeling procedure within resamples.



Considering the idea in the document "That turns the disagreement between temporal CV and bootstrap validation into a diagnostic rather than forcing us to choose one as "correct."", How do I apply this to the pet pricing modeling? In other words, what are some _diagnostics_ that help me determine whether the proess is stable enough to use a stable CV method or if I actually need temporal CV?



Updated todo list

Searched codebase for "temporal cross validation fold design term year expanding window bootstrap optimism stability", no results

Read

Searched for regex `temporal.{0,20}(CV|cross.?valid|fold)|expanding.window|term_year|fold2|k.?fold` (`**/notes/**`), 84 results

Read memory

Read , lines 420 to 600

Searched for regex `bootstrap|optimism|Gini|calibration MSE|cal_mse|PSI|population stability|coefficient stability|drift` (`**/notes/pipeline_reference.qmd`), 35 results

Read , lines 270 to 400

Read , lines 720 to 780

Read , lines 1190 to 1235

Good news: your pipeline already has most of the plumbing needed for this — you just haven't pointed it at _this_ question yet. Here's how I'd operationalize "disagreement as diagnostic" for your model.

## 1. Make the gap itself a tracked number

You already compute, per expanding-window fold, `gini`/`oe`/`cal_mse` (`pipeline_reference.qmd:399`), and you already have `bootstrap_gini_paired()` / `FS_N_BOOT=200` for IID-style resampling comparisons. Compute one more thing on the **final selected formula**: an IID (order-ignoring) bootstrap Gini/calibration on the pooled data, using the same paired-bootstrap machinery. Then define

$$\text{transport gap} = \text{IID bootstrap Gini} - \text{freshest-fold OOT Gini}$$

(and the same for `cal_mse`). Track this gap, not just the fold Gini in isolation. A small, stable gap across the fold sequence is direct evidence you're in the doc's "case A/B" (stable DGP or stable temporal structure); a large or _growing_ gap concentrated in the freshest folds is "case C" (evolving DGP) — and tells you temporal CV isn't optional, it's the whole point.

## 2. You've already generated one gold-standard example — use it as a template

Your Stage-2 "full-fold-sequence stability check" (`project_documentation_technical.qmd:470-497`) is _exactly_ the diagnostic-not-gate idea from the doc. The `deductible_group` finding (ordered-contrast coefficients collapsing −57 → −0.14 as the window expanded, one fold's `cal_mse` blowing up to 8.20) is a textbook "mapping X→Y is evolving" case, not just noise. Generalize that same coefficient-trajectory check to your term_year_num-adjacent terms specifically:

- Plot the `age` smooth's EDF/curvature, `term_year_num`'s linear slope, and the breed/state random-effect variance components across the fold sequence.
- **Converging/settling as the window grows** → consistent with an estimable, stable `f(X,t)`.
- **Monotonic drift or non-convergence** → real structural change, same signature as the deductible_group case.

## 3. Turn candidate time-interactions into an explicit test, not just a Gini gate

You already candidate-test `term_year_num × coverage` (smooth) and `term_year_num × breed/state_code` (linear) via sequential selection. Right now acceptance is "does it improve the max-info fold's Gini/calibration." Add the placebo contrast: does the same interaction _also_ improve an IID/random-split Gini by a similar amount?

- Improves both similarly → it's capturing a real but time-_invariant_ relationship (e.g., breed just has a different baseline risk), not evidence of drift.
- Improves the OOT fold meaningfully more than the IID comparison → that breed/coverage's _effect_ is genuinely non-stationary — direct evidence for case C, localized to that segment.

## 4. Placebo/permuted-time test (new, cheap to add)

Randomly permute the calendar-time index across terms (break true order, preserve everything else), rerun `create_train_test_windows()` on the fake timeline, and compare the resulting Gini/O-E trajectory to both (a) the real-time trajectory and (b) the IID bootstrap. If real-time performs distinctly worse than permuted-time — which should look like the IID bootstrap plus pure sample-size effects — that isolates "calendar order is doing real work" from "smaller early folds are just noisier." This is the most direct causal test of Bergmeir et al.'s condition (temporal ordering alone doesn't invalidate CV _unless_ errors are actually correlated with/dependent on time).

## 5. Frozen-model drift check (separates "can we refit fast enough" from "is it drifting at all")

Fit once on your earliest usable window, freeze the coefficients, and score every subsequent calendar month **without refitting** — plot O/E (or `cal_mse`) against calendar time. A flat line near 1.0 says the DGP is stable enough that periodic refits (rather than a fundamentally different validation strategy) are all you need. A systematic trend, or a level shift at a known date, both diagnoses drift _and_ dates it — useful for tying to known events you've already flagged elsewhere (wellness benefit redesign, vet-cost inflation, underwriting changes).

## 6. Don't conflate this with the separate "dependence" issue

The doc's issue (1) — serial dependence — is orthogonal to drift and matters specifically for your `pricing.R` parametric coefficient bootstrap (`mvrnorm` over `fixef`/`vcov`), which currently assumes IID-adequate variance. A quick Ljung-Box test (or just an ACF plot) on monthly mean residuals tells you whether that bootstrap is understating rating-factor uncertainty even if the _mean_ structure (Gini/calibration) looks perfectly stable. If there's meaningful autocorrelation, that argues for a block-style correction on the uncertainty step specifically — independent of whatever you conclude about drift.

## Decision rule to close the loop

- Gap (1) small and stable, coefficient trajectories (2) converge, time-interactions (3) don't beat their IID counterpart, placebo (4) ≈ real-time → you're in case A/B: lean on the existing bootstrap/paired-Gini machinery day-to-day, keep expanding-window CV as a periodic audit rather than the primary gate.
- Any of (2)–(5) show real, direction-consistent drift → keep the max-info-fold expanding-window gate as primary (as you already do), and use the frozen-model check (5) to set a refresh cadence rather than just a one-time accept/reject.

Created 3 todos
