# DNAm-contamination

This repository tracks some of the analysis I did in Python to validate my approach of estimating contamination in placental DNA methylation samples.

Contamination is a big issue in placental research as complete separation of the maternal tissue and DNA from placental can be difficult. 

However, the influence of contamination on DNA methylation studes of the placenta has not been comprehensively explored, nor are there standardized tools to assess contamination in this type of data.

In this research, I developed approaches to estimate contamination in placental DNA methylation samples. Although I did the majority of this analysis in R, which is not yet published, I chose to write the validation analysis scripts in python to acquire experience.

`1-10 update microsatellites v2.ipynb` is a jupyter notebook where I used pandas and numpys to clean up the microsatellite data and join to the DNA methylation results. I used regex to manipulate strings, and pandas/numpy to summarize numerical data. 
