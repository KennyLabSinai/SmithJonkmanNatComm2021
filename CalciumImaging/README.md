###Calcium Imaging Analysis code for Smith & Jonkman, et al., Nature Communications 2021

This code was adapted from:
Gritton, H.J., Howe, W.M., Romano, M.F. et al.
Unique contributions of parvalbumin and cholinergic interneurons in organizing striatal networks during movement.
Nat Neurosci 22, 586?597 (2019).
https://doi.org/10.1038/s41593-019-0341-3; PMID: 30804530

And their associated code:
https://github.com/HanLabBU/striatum_imaging_natureneuro

###Instructions for use:

#Preprocessing:
The preprocesss_allvids_AVI.m allows specification of a directory containing AVI videos recorded with
custom built miniscopes (miniscope.org; thanks to Denise Cai & Tristan Shuman for help construting microscopes). 
This script allows the user to specify a path to search for videos, then processes all files ending in '.avi'. 
This script runs the processOnlyAVI.m script on each video for pre-processing, which converts the videos to uint16 
arrays, applies a homomorphic filter, performs motion correction, and normalizes fluorescence over time 
to correct for photobleaching.

#ROI Selection & Trace extraction:
The extractTraces.m script offers a user-friendly interface for contrast adjustment & ROI selection, 
then extracts trace data from the converted uint16 video files. The user then has the opportunity to mark "bad" traces
that were extracted from ROIs that do not represent a healthy cell, and then filters those traces out of the data.

This script then outputs four files
1) ROIs.png - shows user-defined ROIs
2) traces_R.mat - matrix of raw traces extracted from all ROIs
3) cleaned_traces_R.mat - matrix of filtered traces

#Postprocessing:
In addition to extraction of traces, this repository also contains several scripts for visualizing and analyzing data.
- plot_rois_with_traces.m
- identifyPeakIndices.m
- make_pretty_figure.m

