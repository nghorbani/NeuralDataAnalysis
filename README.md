# Neural Data Analysis

## Spike detection, Feature extraction
[Code in Matlab](NDA_T1/main.m)

Spike detection and feature extraction from continuous tetrode recordings
![alt tag](images/spikes.png)

## Spike Sorting with Mixture of Gaussians
[Code in Matlab](NDA_T2/main.m)

Clusters and their means found in the PCA data.
![alt tag](images/MixureModels.png)

Bayesian information criterion in dependency on the number of mixture components. Computed on the PCA data of the spike detection.
![alt tag](images/BIC.png)

## Identifying single neurons (Cross-correlograms, LDA)
[Code in Matlab](NDA_T3/main.m)

Cross-correlation between the diferent clusters. Auto-correlation plots are marked in the respective color of its cluster.
![alt tag](images/correlograms.png)

## Spike inference from calcium data
[Code in Matlab](NDA_T4/main.m)

Inferring spike rates from a calcium trace obtained by calcium imaging.
![alt tag](images/calciumInfer.png)

## Raster plot
[Code in Matlab](NDA_T5/main.m)

Each line in certain direction group indicates the timings of the spike occurrence relative to the stimulus onset. The solid black line on the top of the figure indicates the timing of the stimulus.
![alt tag](images/raster.png)

## Peri-Stimulus Time Histogram
[Code in Matlab](NDA_T5/main.m)

Histogram method for spike rate estimation
![alt tag](images/psth.png)

## Linearity Index
[Code in Matlab](NDA_T5/main.m)

The modulation ratio is the amplitude of first harmonic R(F1) divided by the mean spike rate R(F0) for an optimal achromatic drifting sinusoidal grating stimulus. High values of R(F1)/R(F0) indicate that the cells are modulated by spatial pattern in the visual image. Low values of R(F1)/R(F0) signify that such cells are excited, but their spike rate is not modulated up and down by the passage of the bars of a drifting grating.(Skottun et al., 1991; Ringach et al., 2002)
Below we see PSTH for each cell in condition with the most spikes overlaying the sinusoid at modulation frequency of the stimulus.
![alt tag](images/linearity_index.png)

## Tuning curves
[Code in Matlab](NDA_T6/main.m)

Different tuning curve models were fitted to neurophysiological data of cells
responding to a grating moving in different directions.
![alt tag](images/tuning.png)
a. Fitting cosine tuning curve. b. Test for significant orientation selectivity; distribution of |q| under the null hypothesis c.Fit tuning curve using von Mises model d. Fit tuning functions using Poisson noise model. Red line in a,b,c indicates average responses to all conditions.

## Spatio-Temporal Receptive Fields
[Code in Matlab](NDA_T7/main.m)

To estimate the receptive feld of a neuron which responds to white-noise stimulus with the given spike counts, we assume a Linear-Nonlinear Poisson model.In this model w corresponds to the receptive field of the neuron.
![alt tag](images/spatiotemporal.png)

