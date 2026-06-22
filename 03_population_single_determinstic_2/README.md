# Harvard Applied Math/Engineering Science 115

## Population (single species, deterministic, Part 2)

>For ODE integrations, `ode45` is used in MATLAB, and `scipy.integrate.solve_ivp` in Python [uses RK45 by default](https://docs.scipy.org/doc/scipy/reference/generated/scipy.integrate.solve_ivp.html). See [`ode_examples.ipynb`](https://github.com/zhimingkuang/Harvard-AM-115/blob/main/03_population_single_2/solve_ivp_insectoutbreak_class.ipynb) for example.

`climate_temperature_tendency.ipynb`, `climate_temperature_tendency.m`

This example provides a helper function to compute the temperature tendency of the planet.

`solve_ivp_insectoutbreak_class.ipynb`, `ode45_insectoutbreak_class.m`

This example calculates the insect outbreak with the predation term.

`solve_ivp_insectoutbreak_hysteresis.ipynb`, `ode45_insectoutbreak_hysteresis.m`

This example calculates the insect outbreak with the predation term and time-varying growth rate per capita.

`plot_insectoutbreak_fixed_points.ipynb`, `plot_insectoutbreak_fixed_points.m`

This example examines nondimensionalization and fixed point analysis.