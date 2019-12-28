//opens stack, converts to 16 bit, multiply by mask, split into 2 and save both new peices. 


dir1 = getDirectory("Choose Source Directory ");
list = getFileList(dir1);
setBatchMode(true);


for (i=0; i<list.length; i++) {    
	//open the mask

	open("mask.tif");
	
	
	if (endsWith(list[i], "mask.tif")) {
	} else {
	showProgress(i+1, list.length);    
	
	run("Raw...", "open=" + dir1 + list[i] + " image=[16-bit Signed] width=128 height=128 number=90000");
	
	//open(dir1+list[i]);
	// first convert to 16 bit
	run("16-bit");

	//multiply by mask
	imageCalculator("Multiply create 32-bit stack", list[i],"mask.tif");
	selectWindow("Result of " + list[i]);
		
	// run the stack splitter
	run("Stack Splitter", "number=2");
	selectWindow("stk_0001_Result of " + list[i]);
	saveAs("Tiff", dir1 + list[i] + "part1");
	selectWindow("stk_0002_Result of " + list[i]);
	saveAs("Tiff", dir1 + list[i] + "part2");

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
