print("\n\nStarting Batch Convert Script created by Eric Gemmell\n");
INPUT_DIR = getDirectory("Select Input Directory");
OUTPUT_DIR = getDirectory("Select Output Directory");

function Merge_Layers_And_Save_File(input, output, filename) {
		print("\nMerging Layers for Image, " + filename);
        open(input + filename);
        getDimensions(width, height, channels, slices, frames);
        if(channels==1){
        		print("channels are 1 only");
        }
        else if(channels==2){
        		print("channels are 2 only");
        		run("Split Channels");
        		run("Merge Channels...", "c1=C1-"+filename+" c2=C2-"+filename+" create");
        }
        else{
        		run("Split Channels");
        		run("Merge Channels...", "c1=C1-"+filename+" c2=C2-"+filename+" c3=C3-"+filename+" create");
        }
        saveAs("Png", output + filename);
        print("Saved File, " + filename);
        close();
}

function Convert_Files_In_Directory(dir,output_dir) {
	files = getFileList(dir);
    for (i=0; i<files.length; i++) {
    	print(files[i]);
    	if (endsWith(files[i], "/")){
    		print("Found Subdirectory, "+ files[i]);
        	Convert_Files_In_Directory(dir+files[i],output_dir);
    	}
        else if(endsWith(files[i], ".lsm")){
        	print("editing file, "+files[i]);
        	Merge_Layers_And_Save_File(dir,output_dir,files[i]);
		}
	}
}

function Iterate_Through_Each_Directory(dir){
	directories = getFileList(dir);
	print("Iterating Through Main Directories");
    for (i=6; i<directories.length; i++) {
    	if (endsWith(directories[i], "/")){
    		print("Starting Main Directory, "+directories[i]);
    		File.makeDirectory(OUTPUT_DIR+directories[i]); 
    		Convert_Files_In_Directory(dir+directories[i],OUTPUT_DIR+directories[i]);
    	}
    }
}

setBatchMode(true);

Iterate_Through_Each_Directory(INPUT_DIR);

setBatchMode(false);