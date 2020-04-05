# Experiment for experimental programming class 2018

## Instructions

* *fixationExperiment.m* is the main script.
* Modify line 33 in *fixationExperiment.m* for full experiment. Currently it is limited to five iterations for testing purposes.
* Check out the pictures folder and add more pictures to the actual folder used for more pictures. They should be automatically used.
* Run *ptb3-matlab* as superuser to avoid bugs.

## Short description
The experiment presents a series of pictures to the subject and tracks its eye movement. On fixation points, a Gaussian, Laplacian or no filter are applied to the area around the fixation point, until another fixation point is detected or 5 seconds have passed. Eye movements are recorded, as are fixation points. Short eye movements are considered as saccadic and do not change the fixation point - longer distances change the fixation points.
