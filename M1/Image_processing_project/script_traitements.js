imp = IJ.openImage("/net/cremi/triquelme/espaces/travail/Imagerie/Souris/5eme_min/Souris_5.tif");
IJ.run(imp, "Subtract Background...", "rolling=50 light stack");
IJ.run(imp, "Gaussian Blur...", "sigma=2 stack");
IJ.run(imp, "8-bit", "");
IJ.setAutoThreshold(imp, "Minimum");
Prefs.blackBackground = false;
IJ.run(imp, "Convert to Mask", "method=Minimum background=Light calculate");
imp.show();
IJ.run("Set Measurements...", "centroid stack redirect=None decimal=3");
IJ.run(imp, "Analyze Particles...", "size=50-Infinity display clear stack");

