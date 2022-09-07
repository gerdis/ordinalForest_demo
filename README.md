
Ordinal forest (OF) is an algorithm for the prediction of ordinal response variables (ordinal regression) which is based on random forest.
The method was developed by Hornung (2017) and is implemented in the ordinalForest package. 
It assumes that there is a (possibly latent) continuous variable $y^*$ underlying the ordinal response variable $y$.
The $J$ ordered classes of $y$ are assumed to correspond to $J$ adjacent intervals of potentially different width. 
Optimized score values representing the boundaries of these intervals are then used to construct a regression forest. 

For an in-depth description of the OF algorithm see the [package manual](https://cran.r-project.org/web/packages/ordinalForest/ordinalForest.pdf)
or [this paper](https://epub.ub.uni-muenchen.de/41183/1/TR.pdf).

This repo contains a little demo of the practical use of OF. 
It doesn't focues on hyperparameter tuning, 
but performance evaluation, model comparison and interpretation of feature effects through visualization with partial dependence plots (PDP). 
For this purpose, two different ordinal forests are trained to predict sensory quality of Portuguese *Vinho Verde* using the 
[Wine Quality Data Set](https://archive.ics.uci.edu/ml/datasets/wine+quality). 

### Overview

- **data/preprocess_train.R**: R script used for data preprocessing. Saves traindata and testdata in the _data/preprocessed_data/_ folder.

- **data/preprocessed_data/OF_traindata.dat**: preprocessed, resampled version of the "red wine" subset of the 
Wine Quality Data Set

- **data/preprocessed_data/OF_testdata**: stratified sample of preprocessed, resampled data

- **Demo.Rmd**: Rmarkdown file demonstrating how performance of OF models can be measured and compared, and feature effects can be visualized with PDPs.

- **Demo.pdf**: rendered from Demo.Rmd


### Credits/Links

[*ordinalForest* package manual](https://cran.r-project.org/web/packages/ordinalForest/ordinalForest.pdf)

[Explanation/definition of ranked probability score and ranked probability skill score](https://www.cawcr.gov.au/projects/verification/verif_web_page.html#RPS)

[This R script](https://gist.github.com/bgreenwell/1b8afb3c689354695a4890c03124c04a/) demonstrates the use of the *pdp* package with classification problems. 

### References

Cortez, P., Cerdeira, A., Almeida, F., Matos, T., & Reis, J. (2009). 
Modeling wine preferences by data mining from physicochemical properties. *Decision support systems, 47(4)*, 547-553.

Epstein, E. S. (1969). A scoring system for probability forecasts of ranked categories. 
*Journal of Applied Meteorology (1962-1982), 8(6),* 985–987.

Hornung, R. (2017). Ordinal Forests. *Institute for Medical Information Processing, Biometry and Epidemiology, University of Munich*.


### Disclaimer

I am not involved in the development of the *ordinalForest* package, or the other packages used for the project, in any way, shape or form. 
This repository contains a demo of the use of *ordinalForest* as I understand it to work. My explanations are not guaranteed to be accurate. 
