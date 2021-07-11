#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Jan  7 10:36:50 2020

@author: Alexander C.W. Smith, PhD, for lab of Paul Kenny @ Mount Sinai

This creates an array of cell center coordinates transformed to the atlas, and then
isolates a region, and splits into two hemispheres. The result can be used as input for 
the clearMapSubregionParser script."
"""

import ClearMap.IO.IO as io
import os
import ClearMap.Visualization.Plot as plt
import ClearMap.Analysis.Label as lbl
import numpy as np

sampleName = 'IA1_LB'
parentDirectory = '/d2/studies/ClearMap/IA_iDISCO/'
execfile(os.path.join(parentDirectory, sampleName, 'parameter_file_'+sampleName+'.py'))

region = 'Caudoputamen'

points = io.readPoints(TransformedCellsFile)
data = plt.overlayPoints(AnnotationFile, points.astype(int), pointColor = None)
data = data[:,:,:,1:]
io.writeData(os.path.join(BaseDirectory, sampleName + '_Points_Transformed.tif'), data)

label = io.readData(AnnotationFile)
label = label.astype('int32')
labelids = np.unique(label)

outside = np.zeros(label.shape, dtype = bool);

"""
Automated isolation of points in caudoputamen (ABA region ID 672).
In order to find out the level to use, in console input:
>>> lbl.labelAtLevel(r, n)
where r is region ID, and n is level (I usually start at 5), if the output is not the
region ID, increase n.
"""
for l in labelids:
    if not (lbl.labelAtLevel(l, 6) == 672):
       outside = np.logical_or(outside, label == l);
#Load the transformed points, and set everything outside of the desired ROI to 0
heatmap = io.readData(os.path.join(BaseDirectory, sampleName, sampleName + '_Points_Transformed.tif'))
heatmap[outside] = 0;
#Split into right and let hemispheres:
Xmin = np.amin(np.nonzero(heatmap)[1])
Xmax = np.amax(np.nonzero(heatmap)[1])
Ymin = np.amin(np.nonzero(heatmap)[0])
Ymax = np.amax(np.nonzero(heatmap)[0])

heatmap_left = heatmap[Xmin-10:heatmap.shape[0]/2,Ymin-10:Ymax+10,:]
heatmap_right = heatmap[heatmap.shape[0]/2:Xmax+10,Ymin-10:Ymax+10:,:]
#Right result TIF files (which can be loaded into the clearMapSubregionParser.py script)
io.writeData(os.path.join(BaseDirectory, sampleName, sampleName + '_' + region + '_isolated_points_left.tif'), heatmap_left)
io.writeData(os.path.join(BaseDirectory, sampleName, sampleName + '_' + region + '_isolated_points_right.tif'), heatmap_right)


