# Bayesian linear models for Clumped Isotope Thermometry

We include the basic scripts that were used to generate the results and figures in [Roman-Palacios et al.](https://www.essoar.org/doi/10.1002/essoar.10507995.1). This repo has the following structure:

- `Analyses`
  - `Datasets`: Raw datasets used in `BayClump` to analyze the Petersen et al., Anderson et al., and Sun et al. datasets.
  - `Results`: Results from using [BayClump](https://bayclump.tripatilab.epss.ucla.edu/) in the raw datasets.
    - `Anderson_ATM`: Results for the Anderson et al. (2021) reanalysis on the subsampled dataset.
    - `Anderson_Full`: Results for the Anderson et al. (2021) reanalysis on the full dataset.
    - `Petersen`: Results for the Peterse et al. (2019) reanalysis on the ATM dataset.
    - `Sun`: Results for the Sun et al. (2021) reanalysis on Anderson and Petersen calibration datasets.

- `Figures`
  - `Data`: The data used to generate the figures in the paper.
  - `Plots`: Final plots.
  - `*R files`: R scripts used to generate each of the figures.

