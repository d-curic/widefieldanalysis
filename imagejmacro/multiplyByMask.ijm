//opens stack, converts to 16 bit, multiply by mask, save. 


dir1 = getDirectory("Choose Source Directory ");
format = getFormat();
list = getFileList(dir1);
setBatchMode(true);


for (i=0; i<list.length; i++) {    
	//open the mask

	open("mask.tif");
	
	
	if (endsWith(list[i], "mask.tif")) {
	} else {
	showProgress(i+1, list.length);    

    print(format);

	if (format == "TIFF"){
		print("Tiff file");
		open(dir1 + list[i] );	
	} else {
		run("Raw...", "open=" + dir1 + list[i] + " image=[16-bit Signed] width=128 height=128 number=90000");
	}
	
	//open(dir1+list[i]);
	// first convert to 16 bit
	run("16-bit");

	//multiply by mask
	imageCalculator("Multiply create 32-bit stack", list[i],"mask.tif");
	selectWindow("Result of " + list[i]);
	saveAs("Tiff", dir1 + list[i] + "_Cropped");

	//close all
	close("*");
	}
}


function getFormat() { 
	formats = newArray("TIFF", "8-bit TIFF", "JPEG", "GIF", "PNG",      
	"PGM", "BMP", "FITS", "Text Image", "ZIP", "Raw");    
	Dialog.create("Batch Convert");    
	Dialog.addChoice("Convert to: ", formats, "TIFF");    
	Dialog.show();    
	return Dialog.getChoice();
	}
