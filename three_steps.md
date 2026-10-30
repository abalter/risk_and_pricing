The pure interaction is the discrete equivalent of a cross-partial derivative in calculus ($\frac{\partial^2 y}{\partial x_1 \partial x_2}$). It answers a very specific question: **"How much does the marginal effect of $x_1$ change when I change $x_2$?"**

To derive it conceptually, you do not start by subtracting everything from the total joint effect. You start by calculating the marginal effect of $x_1$ twice under two different conditions, and taking the difference between them.

Here is the step-by-step derivation and exactly how it connects to the dataset-level Partial Dependence calculations we were doing earlier.

### The Mathematical Derivation (Difference of Marginal Effects)

Let your model be $\hat{y} = f_0 + f_1(x_1) + f_2(x_2) + f_{12}(x_1, x_2)$.

**Step 1: Calculate the marginal effect of $x_1$ when $x_2$ is shifted to $v_2$.**
You mutate $x_1$ from base to $v_1$, while locking $x_2$ at $v_2$.


$$M_{v_2} = \hat{y}(v_1, v_2) - \hat{y}(b_1, v_2)$$


If we substitute the functions, $f_0$ and $f_2(v_2)$ cancel out:


$$M_{v_2} = [f_1(v_1) - f_1(b_1)] + [f_{12}(v_1, v_2) - f_{12}(b_1, v_2)]$$

**Step 2: Calculate the marginal effect of $x_1$ when $x_2$ is at its base $b_2$.**
You mutate $x_1$ from base to $v_1$, while locking $x_2$ at $b_2$.


$$M_{b_2} = \hat{y}(v_1, b_2) - \hat{y}(b_1, b_2)$$


Substitute the functions, and $f_0$ and $f_2(b_2)$ cancel out:


$$M_{b_2} = [f_1(v_1) - f_1(b_1)] + [f_{12}(v_1, b_2) - f_{12}(b_1, b_2)]$$

**Step 3: Deriving the Pure Interaction**
The pure interaction is exactly the difference between these two marginal effects: $M_{v_2} - M_{b_2}$.

$$\text{Pure Interaction} = \Big( [f_1(v_1) - f_1(b_1)] + [f_{12}(v_1, v_2) - f_{12}(b_1, v_2)] \Big) - \Big( [f_1(v_1) - f_1(b_1)] + [f_{12}(v_1, b_2) - f_{12}(b_1, b_2)] \Big)$$

Because the main effect of $x_1$ is identical in both brackets, $[f_1(v_1) - f_1(b_1)]$ perfectly annihilates itself. You are left with the exact four-term expression you noted earlier:

$$\text{Pure Interaction} = f_{12}(v_1, v_2) - f_{12}(b_1, v_2) - f_{12}(v_1, b_2) + f_{12}(b_1, b_2)$$

### How This Relates to the Prior Calculations

In the earlier examples, we calculated **1-Way Partial Relativities** by applying a mutate-and-average logic over a dataset of $N$ rows.

When you run a 1-Way Partial Dependence calculation on $x_1$, you are essentially executing **Step 1** ($M_{x_{2k}}$) for every single row in the dataset, allowing $x_{2k}$ to be whatever it naturally is for that row.

$$\text{Row } k \text{ Marginal Effect} = [f_1(v_1) - f_1(b_1)] + [f_{12}(v_1, x_{2k}) - f_{12}(b_1, x_{2k})]$$

You then average those row-level marginal effects across the entire portfolio:

$$\text{1-Way Partial Relativity} = [f_1(v_1) - f_1(b_1)] + \frac{1}{N} \sum_{k=1}^N \Big( f_{12}(v_1, x_{2k}) - f_{12}(b_1, x_{2k}) \Big)$$

**The Key Connection:**
The 1-Way Partial Relativity calculation deliberately stops before Step 3. It *keeps* the main effect of $x_1$, and it collapses the interaction term into a dataset-weighted scalar (averaging the interaction penalty across the portfolio's actual mix of $x_2$).

The Pure Interaction calculation executes Step 3 to mathematically destroy the main effect of $x_1$. Because the main effects are removed, the result is completely isolated from the baseline trends of the individual variables. You no longer need to average anything across the dataset—the pure interaction surface is universally true for the model regardless of the portfolio mix.

I skipped the algebraic expansion in that step, which made the cancellation hard to follow. Let's write out the full model equation for both parts of that subtraction so you can see exactly what cancels out.

Your base model is:


$$\hat{y}(x_1, x_2) = f_0 + f_1(x_1) + f_2(x_2) + f_{12}(x_1, x_2)$$

In Step 1, we are calculating the marginal effect of changing $x_1$ from $b_1$ to $v_1$, while $x_2$ is locked at $v_2$. The equation is:


$$M_{v_2} = \hat{y}(v_1, v_2) - \hat{y}(b_1, v_2)$$

Here are the exact functions being substituted for those two $\hat{y}$ terms:

**First term: Evaluate the model at $(v_1, v_2)$**


$$\hat{y}(v_1, v_2) = \mathbf{f_0} + f_1(v_1) + \mathbf{f_2(v_2)} + f_{12}(v_1, v_2)$$

**Second term: Evaluate the model at $(b_1, v_2)$**


$$\hat{y}(b_1, v_2) = \mathbf{f_0} + f_1(b_1) + \mathbf{f_2(v_2)} + f_{12}(b_1, v_2)$$

Now, substitute those full expressions back into the subtraction $M_{v_2}$:

$$M_{v_2} = \Big( \mathbf{f_0} + f_1(v_1) + \mathbf{f_2(v_2)} + f_{12}(v_1, v_2) \Big) - \Big( \mathbf{f_0} + f_1(b_1) + \mathbf{f_2(v_2)} + f_{12}(b_1, v_2) \Big)$$

If you distribute the negative sign to the second bracket, you get:

$$M_{v_2} = \mathbf{f_0} - \mathbf{f_0} + f_1(v_1) - f_1(b_1) + \mathbf{f_2(v_2)} - \mathbf{f_2(v_2)} + f_{12}(v_1, v_2) - f_{12}(b_1, v_2)$$

Notice the bold terms:

* $f_0 - f_0 = 0$ (The global intercept cancels out).
* $f_2(v_2) - f_2(v_2) = 0$ (Because $x_2$ was locked at $v_2$ for both predictions, the main effect of $x_2$ is identical on both sides and completely annihilates itself).

Once those cancel, you are left exactly with the remaining pieces:

$$M_{v_2} = [f_1(v_1) - f_1(b_1)] + [f_{12}(v_1, v_2) - f_{12}(b_1, v_2)]$$

This proves that when you calculate a marginal effect for $x_1$, the main effect of $x_2$ completely disappears, leaving only the main effect of $x_1$ and the interaction penalty.

