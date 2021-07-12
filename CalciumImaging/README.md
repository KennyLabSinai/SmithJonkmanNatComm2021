###Calcium Imaging Analysis code for Smith & Jonkman, et al., Nature Communications 2021

This code was adapted from:
Gritton, H.J., Howe, W.M., Romano, M.F. et al.
Unique contributions of parvalbumin and cholinergic interneurons in organizing striatal networks during movement.
Nat Neurosci 22, 586?597 (2019).
https://doi.org/10.1038/s41593-019-0341-3; PMID: 30804530

And their associated code:
https://github.com/HanLabBU/striatum_imaging_natureneuro

###Instructions for use:
The preprocesss_allvids_AVI.m allows specification of a directory containing AVI videos recorded with
custom built miniscopes (miniscope.org). This script searched for files ending in 'msCam1', and runs the processOnlyAVI.m script for pre-processing.

###ROI Selection:
The selectSingleFrameRoisNew.m script allows selection of ROIs (cells) to extract traces from.


