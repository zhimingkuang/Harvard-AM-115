# Harvard Applied Math/Engineering Science 115

## Numerics

>For ODE integrations, `ode45` is used in MATLAB, and `scipy.integrate.solve_ivp` in Python [uses RK45 by default](https://docs.scipy.org/doc/scipy/reference/generated/scipy.integrate.solve_ivp.html). To output smoother results, _i.e._ more times to store solutions) in `solve_ivp`, increase `t_eval` intervals (check [`ode_examples.ipynb`](https://github.com/zhimingkuang/Harvard-AM-115/blob/main/02_numerics/ode_examples.ipynb) for example).
>
>We also include a custom Python implementation of `ode45`. Check the second half of `balancing_stick.ipynb`, `flame.ipynb`, `ode_examples.ipynb`, `ode_function.ipynb`, `single_pendulum.ipynb` for details.

`balancing_stick.ipynb`, `balancing_stick.m`

This example calculates the numerical solution to the balancing stick problem (modelled as a single pendulum).

`euler_method.ipynb`, `euler_method.m`

This example compares the exact and forward Euler solutions of the IVP.

`euler_stability.ipynb`, `euler_stability.m`

This example compares the stability of exact, forward Euler (explicit) and backward Euler (implicit) solutions.

`flame.ipynb`, `flame.m`

This example examines the effects of timestep in a stiff problem through different integration schemes.

`ode_examples.ipynb`, `ode_examples.m`

This example introduces how to define and solve ODEs.

`ode_function.ipynb`, `ode_function.m`

This example shows how to define, solve, and plot an ODE with a main function.

`single_pendulum.ipynb`, `single_pendulum.m`

This example examines the effects of numerical errors via a single pendulum ODE.