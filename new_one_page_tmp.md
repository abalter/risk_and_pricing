# Proposal

Complete a technical guide and journal article that describe important
considerations for reporting rating factors derived from relativity
calculations and introduce new theoretical constraints on when it is
appropriate to do so.

# Why This Work Matters

Insurance practitioners frequently use the term *relativity* to describe
the effect of a rating variable on premium. This paper demonstrates that
several quantities commonly called relativities are mathematically
distinct and coincide only under special conditions. The core
theoretical insight is that while a model coefficient is an intrinsic
property of a fitted model a marginal or partial-dependence-style
relativity depends on both the fitted model and the reference portfolio.

The journal article will introduce and explore the new theoretical
constraints and consist of mathematical proofs and numerical
simulations. The guide will clarify different types of relativities, how
to calculate them, and how to properly use them, and will contain code
and demonstrations.

# Contribution to practice:

- Many different quantities are referred to as "the relativities" by
  actuaries.
- Some are the ones that can equate to model coefficients, and some are
  not.
- Relativities only equate to coefficients when:
  - interactions have a specific structure
  - or you limit analysis to the historical portfolio and not try to
    forecast.
- Explicit guidance for rating-table extraction from GLMs/GAMs.

# Contributions to theory:

- Unifying ideas from interpretable ML, functional ANOVA, anchored
  decompositions, and actuarial relativities into one coherent
  framework.
- A necessary-and-sufficient condition for when a PDP-based relativity
  equals a model coefficient.
- A formal characterization of how overlapping interaction structures
  create portfolio dependence.

# Time Required

I propose working on this project for **15hrs/week for three weeks**.
Given that I already have a solid draft, I believe this will be
sufficient time to complete.
