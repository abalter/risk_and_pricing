That's the right simulation for this paper, and it dovetails with the main result rather than sitting beside it. The theorem says a relativity for S is intrinsic to the model only when no term partially overlaps S. A simulation is the only place you can show what happens when the *model* is the thing that's wrong, because in real data you never know the true structure — so the demonstration is: misspecify the model, refit it on different books, and watch quantities that should be constants move.

A design that stays inside your vocabulary:

**Data-generating process.** Poisson frequency, log link, two rating variables with a true interaction: $\log\mu = \beta_0 + f_1(x_1) + f_2(x_2) + \gamma\, g(x_1, x_2)$, with $x_1$ a small ordered factor (age band, say five levels) and $x_2$ three levels. Set $\gamma$ so the interaction is modest but real — the kind a filed GLM would omit. Exposure weights $w$ from a cell table you control.

**The design variable is the book, not the sample.** Generate $K$ books that differ only in the joint exposure distribution over $(x_1, x_2)$ — the same DGP, different mixes. Three or four is enough: balanced, young-skewed, one where $x_1$ and $x_2$ are correlated.

**Two fitted models per book.** $\mathcal{M}_0$, main effects only (misspecified); $\mathcal{M}_1$, with the interaction (correctly specified). GLM is fine; mgcv is optional.

**Three quantities, each computed with your operators.** For $S = \{x_1\}$: the base-anchored table entry (set $x_2$ to base, difference against the base level of $x_1$); the partial relativity (average over the book's $x_2$ distribution); and the truth, from the DGP by the same base-anchored construction.

**Two figures.** Figure 1: the relativity for each level of $x_1$ on the vertical axis, the $K$ books on the horizontal, one panel per fitted model. Under $\mathcal{M}_1$ the base-anchored lines are flat — intrinsic — and the partial-relativity lines move with the book, which is the "drags the book along with the factor" picture. Under $\mathcal{M}_0$ *both* move, because the fitted main effect has absorbed the interaction weighted by the mix, and the construction can only be intrinsic to the model it's handed. That second panel is the sentence the paper needs: base-anchoring makes a table intrinsic to the model, not to the world, and misspecification shows up as mix-dependence under refit. Figure 2 is the pricing consequence: actual-versus-technical by $(x_1, x_2)$ cell under $\mathcal{M}_0$, which is your Nationwide analysis on data where you know the answer.

One optional extension if the half day stretches: add a third variable $x_3$ correlated with $x_1$ and omit it from both models. The $x_1$ relativity absorbs $x_3$'s effect in proportion to the correlation, and a one-line figure of bias against $\rho$ makes the omitted-variable case explicit without a second simulation.

The whole thing is one function that takes a cell table and $\gamma$ and returns the three tables, called in a loop. When you're ready to write it, I can draft the R skeleton in your operator notation so the code and the paper use the same names.


Yes, it matters, and there is an original: the `CASdatasets` R package by Christophe Dutang and Arthur Charpentier, the companion to *Computational Actuarial Science with R*. The insurer is anonymous ("unknown private insurer," policies from roughly 2011–2013), so the package *is* the primary source — everything on Kaggle, OpenML, Hugging Face and inside other R packages is a copy of some version of it.

And the versions differ. The current CASdatasets `freMTPL2freq` has 677,991 rows; the OpenML and Kaggle copies have 678,013. Those copies were taken from an older package version, before Dutang removed duplicate records, and some of them also inherited the `ClaimNb` quirks that the Noll–Salzmann–Wüthrich case study (the standard tutorial on this dataset) spends a page cleaning up. A referee who knows the dataset will know which version you used from the row count.

For the paper: install from the authors' repository, not CRAN (it was never on CRAN because of size):

```r
install.packages("CASdatasets",
  repos = "https://dutangc.perso.math.cnrs.fr/RRepository/",
  type = "source")
data(freMTPL2freq); data(freMTPL2sev)
```

Then cite the dataset by its DOI — the package now has one through Recherche Data Gouv, `10.57745/P0KHAG` — plus the package version in your session info, and apply the Noll et al. conventions (`ClaimNb` capped at 4, `Exposure` capped at 1) with a sentence saying so. That's what makes the example reproducible by an actuary in 2028 rather than by whoever still has the Kaggle CSV.

One practical note: the GitHub pages site is marked under construction, but the CNRS repository and the GitHub repo (github.com/dutangc/CASdatasets) both work; if the source install is slow, the GitHub repo has the data as `.rda` files you can load directly.

Sources: [CASdatasets — freMTPL reference page](https://dutangc.github.io/CASdatasets/reference/freMTPL.html), [CASdatasets package site](https://dutangc.github.io/CASdatasets), [Charpentier, 2024 update on CASdatasets (DOI, hosting)](https://r-bloggers.com/2024/07/some-updates-about-the-insurance-datasets-package-casdataset), [OpenML 41214 copy (678,013 rows)](https://api.openml.org/d/41214), [Poisson frequency vignette on the CNRS repository](https://dutangc.perso.math.cnrs.fr/RRepository/pub/web/vignettes/poisson_vignette.html)