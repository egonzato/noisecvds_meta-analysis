This repository contains code for the article: 'Exposure-response relationship between transportation noise and cardiovascular disease outcomes: a systematic review and meta-regression analysis'

The repository is divided in three folders:

* `not_trimmed`: contains files for the three noise sources of interest (aircraft, railway and road traffic), in which code for meta-analysis and meta-regression is provided, together with forest and funnel plots. In this folder, trimming of extreme estimates is not performed before the analysis.

* `trimmed`: contains files for the three noise sources of interest (aircraft, railway and road traffic), in which code for meta-analysis and meta-regression is provided, together with forest and funnel plot. In this folder, trimming of extreme estimates is performed before the analysis.

* `general`: R files for performing general meta-analysis and meta-regression are available. In addition a third file, which uses the function `dosresmeta` from package `dosresmeta`, is available and illustrates how to convert categorical estimates to continuous ones with interpolation of dose-response estimates. 
