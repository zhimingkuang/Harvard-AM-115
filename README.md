# Harvard Applied Math/Engineering Science 115
This Git repository contains example codes from the course Applied Math 115 Mathematical Modeling at Harvard.

## Modules

- [Population (single species, deterministic, Part 1)](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/01_population_single_1)
- [Numerics](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/02_numerics)
- [Population (single species, deterministic, Part 2)](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/03_population_single_2)
- [Population (single species, probabilistic)](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/04_population_single_3)
- [Model fitting (brief intro)](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/05_model_fitting)
- [Population (multiple species)](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/06_population_multiple)
- [Models of an epidemic](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/07_epidemic)
- [Monte Carlo](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/08_monte_carlo)
- [Queuing model](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/09_queuing)
- [Markov chain](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/10_markov_chain)
- [Diffusion](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/11_diffusion)
- [Age of the Earth](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/12_earth_age)
- [Traffic](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/13_traffic)
- [Optimization](https://github.com/zhimingkuang/Harvard-AM-115/tree/main/14_optimization)

## Run code

- MATLAB (local machine): navigate to the target folder and run MATLAB scripts
    
- [MATLAB Online](https://matlab.mathworks.com/): first need to create a new project by cloning the repo, then navigate to the target folder and run MATLAB scripts

> Caveat: MATLAB scripts can run interactively online, but have not found a way to update the cloned repo in if new files are added

- Python (local machine): need local Python and Jupyter installation to run notebooks

- Python ([Google Colab](https://colab.research.google.com/notebooks/welcome.ipynb)): click "Open in Colab" badge on the top of each `.ipynb` notebook to run (no need to install anything for Python to run)

> If you are running the notebook on Google Colab, please make a copy of the notebook to your drive:
>
> - click "Copy to Drive"
> - or navigate to "File -> Save a copy in Drive"
> - or navigate to "File -> Download" and save a local copy
>
> Otherwise all your changes will not be saved

## Resources

- [Install Git](https://www.atlassian.com/git/tutorials/install-git)
- [Git cheat sheet](https://education.github.com/git-cheat-sheet-education.pdf) (You will mostly only be using `git pull` to retrieve updated files)
- [Install Jupyter using Anaconda and conda](https://docs.jupyter.org/en/latest/install/notebook-classic.html#installing-jupyter-using-anaconda-and-conda) (The straightforward way, but your libraries are installed in `conda` environment; may encounter path/dependency issues in future)
- [Install Jupyter with pip](https://docs.jupyter.org/en/latest/install/notebook-classic.html#alternative-for-experienced-python-users-installing-jupyter-with-pip) (If you already have Python3 installed and do not want to deal with additional `conda` enviroment, which gives a cleaner setup for future Python3 usage)