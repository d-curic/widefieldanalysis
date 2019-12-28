//automatically select the masked ROI and crop out the background. Requires the select bounding box plug in found at
//https://github.com/fiji/Fiji_Plugins/blob/master/src/main/java/fiji/selection/Select_Bounding_Box.java

dir1 = getDirectory("Choose Source Directory ");
list = getFileList(dir1);
setBatchMode(true);

for (i=0; i<list.length; i++) {    
	
	if (endsWith(list[i], "mask.tif")) {
	} else {
	showProgress(i+1, list.length);    
	
	open(dir1+list[i]);

	run("Select Bounding Box");
	run("Crop");

	saveAs("Tiff", dir1 + list[i]);
	
	//close all
	close("*");
	}
}
