// split sound file into nxn files for input to game of life
// need to figure out how to translate (i,j) -> position in file
// that avoids redundancy/symmetry (e.g. (i,j) <> (j,i))
SndBuf split => dac;

dac => WvOut2 w => blackhole; 

"/Users/charleskramer/Desktop/chuck/audio/Bern-Audio/02-Inside-metal-bin.wav" => split.read;

"/Users/charleskramer/Desktop/chuck/audio/Bern-Audio/" => w.autoPrefix;


0 => split.pos;

5 => int n;

"bern" => string name;

for (0 => int i; i < n; i++) {
	
	for (0 => int j; j < n; j++) {
		
		name + i + j => string filename;
		<<< "filename", filename >>>;
		filename => w.wavFilename;
		(split.samples()/(n*n))::samp => now;
	//	1::second => now;
		
	}
}

null @=> w;
	