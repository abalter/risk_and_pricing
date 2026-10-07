# Pet Insurance Pricing Modeling and Analysis
Using historical claims we can build statistical models to help answer questions that address actuarial and business questions about a group of policies. Some questions we might want answers to:

1. Which segments of the book present the highest risk?
2. Which segments of the book are underpriced or overpriced?
3. Can we anticipate high-risk policies at sale time so they can be routed for detailed consideration?

Statistical models can provide answers to these questions, and the certainty of these answers will depend on the amount and quality of data that we use to fit or train the models as well as choices about the modeling process.

In the following document we will present an account of the decisions we have made and the methods we have implemented to answer these and other questions. We will attempt to maintain a "technical-light" style overall, but also provide optional deep-dives to make sure that a fully rigorous account is still contained in the document.

# Terminology and Notation
The terminology and notation used in actuarial work is not entirely self-consistent and is also not completely aligned with statistical terminology. Because statistical terminology is both more rigorous and self-consistent, and more general, we will defer to and prioritize statistical terminology.

This section is probably the most important one in the entire document. In it, I will present terminology and notation that will be use throughout to discuss the models and analysis. Of this terminology and notation, the most important will be those that describe the actuarial because it is with these that we are most likely to run into misunderstanding.

## Data Concepts and Terminology
**Grain:** What one row of a dataset represents. Examples: one claim, one policy-month, or one policy-term.
**Aggregation Basis:** The dimension over which observations are grouped or summarized. Examples: calendar month, policy term, state, or species.
**Numeric Variable:** Has values that are numbers and have numeric relationships. Examples: quantity or count.
**Continuous Variable:** A numeric variable that can, in principle, take any value within an interval. Examples include weight and age. A continuous quantity may nevertheless be recorded or rounded to discrete values.
**Discrete Variable:** A numeric variable that takes distinct, separated values, often integers. Counts such as number of claims are discrete variables.
**Categorical Variable:** A variable whose values represent groups or categories rather than numerical quantities. Categories may be nominal, with no inherent ordering, such as species or state, or ordinal, with a meaningful ordering.
**Cardinality:** How many different values a categorical variable can have. Cardinality of US State is 50. Cardinality of primary colors is 3.
**Coding:** How a variable's value are recorded in the data set. Particularly for categorical variables. Yes/No and Female/Male can both be coded as 1/0. But numerical relationships are not applied. So it is not true that Yes > No.
**Rate:** A quantity that measures how one variable changes relative to another such as speed = distance / time. 

## Statistical and Machine Learning Concepts and Terminology
Mean or Average
Variance
Covariance
Model
Covariate
Predictor
Predicted
Estimate
Estimated
Target
Coefficient
Interaction
Model Selection
Feature Selection
Feature Engineering
Regression Model
Tree Model
Confounder
Expectation
Exposure
Offset
Rate
Conditioned


## General Insurance concepts
**Claim:** Request the insured makes to the insurer to cover an expense incurred by the insured.
**Loss:** A monetary measure associated with claims. The precise meaning depends on context and should therefore be qualified when necessary, for example eligible loss, paid loss, or incurred loss.
**Premium:** Per-term amount paid by the insured to the insurer.
**Deductible:** The amount of otherwise eligible loss that is the responsibility of the insured before reimbursement is calculated. Deductibles may be defined per claim, per condition, per term, or on another basis according to the policy.
**Coinsurance / Reimbursement Percentage:** The percentage of an eligible loss paid by the insurer after application of the deductible, subject to policy terms and limits.
**Limit:** The maximum amount the insurer will pay for covered losses over a specified scope, such as per claim, per condition, annually, or over the lifetime of the policy.
**Benefit:** General term for what the insured receives from the insurer. 
**Policy:** The contract between the insured and insurer that defines how claims will be settled and what benefits the insured recieves.
**Policy Term:** The period during which a particular instance of the insurance contract is in effect, commonly one year.
**Book / Book of Business:** A collection of policies written by an insurer, often referring to a particular product, market, or portfolio. Historical data about those policies constitute experience from the book.

## Actuarial terminology
**Pure Premium:** Expected or observed loss per unit of exposure. For example, if loss is aggregated at the policy-term level and earned exposure is measured in policy-years, pure premium is loss divided by earned exposure. Despite its name, pure premium is a measure of loss cost, not the premium charged to the customer.
**Eligible Loss or Loss Cost:** The dollar amount an insured can ask for to settle a claim. Often the month, year, or term aggregate.
**Paid Loss or Loss Cost:** The dollar amount the insurer actually paid to settle a claim. Often the month, year, or term aggregate. The amount actually paid by the insurer for covered claims after application of the policy's deductible, reimbursement percentage, limits, exclusions, and other benefit provisions.
**Earned Exposure:** Every month a policy is in effect exposes the insurer to loss. Earned exposure is a measure of how much time a policy was in effect. For term-grain data, earned exposure is usually [number of months]/12. 
**Observed / Actual / Empirical:** What occurred in the historical data.
**Expected:** The statistical expectation of a quantity, usually conditional on available predictors.
**Predicted / Estimated:** A value produced by a fitted statistical model.
**Mechanical:** A value obtained deterministically by applying policy rules or formulas to other quantities.
**Technical:** A pricing quantity intended to represent the indicated cost or premium based on expected costs and specified pricing assumptions, rather than necessarily the amount actually charged.

