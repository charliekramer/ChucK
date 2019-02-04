// real time granulator
// https://ccrma.stanford.edu/~adam/220a/spectral_granulation.ck
44100 => int sr; 

adc => FFT fft => blackhole;
SinOsc sin ;//=> FFT fft => blackhole;
IFFT ifft => Gain g => dac;


2048 => fft.size;
4 => int hopCount;
fft.size() / hopCount => int hop;
Windowing.hann(fft.size()) => fft.window;
//1.0 / hopCount => g.gain;

complex s[fft.size()/2];

class SpecFrame
{
	complex s[fft.size()/2];
	0 => int lowBin;
	fft.size()/2 - 1 => int highBin;
	
	fun void applyGain()
	{
		for (0 => int i;i< s.size();++i)
		{
			if (i < lowBin)
				s[i] * .25 => s[i];
			
			if (i > highBin)
				s[i] * .25 => s[i]; 
		}
	}
}

hopCount => int numFrames;

SpecFrame frames[numFrames];
numFrames - 1 => int writeIndex;
0 => int readIndex;

for (0=>int i; i < numFrames; ++i)
{
	
	Math.pow(i / numFrames $ float, 2.5) => float f;
	
	((fft.size()/2) / numFrames) * i => frames[i].highBin;
	frames[i].highBin - ((fft.size()/2) / numFrames) => frames[i].lowBin;
}


spork ~shred1();

fun void shred1() {
	while (true) {
		sin.freq() * 1.01 => sin.freq;
		
		if (sin.freq() > 10000)
			220 => sin.freq;
		100::samp => now;
	}
}


while( true )
{
	// take fft
	fft.upchuck();
	// get contents
	
	for (0 => int i;i<frames[writeIndex].s.size();++i)
	{
		0 => frames[writeIndex].s[i];
	}
	
	fft.spectrum( frames[writeIndex].s );
	
	frames[writeIndex].applyGain();
	
	Std.rand2(0, numFrames-1) => int randomIndex;
	
	for (0 => int i;i<frames[writeIndex].s.size();++i)
	{
		frames[writeIndex].s[i] => frames[randomIndex].s[i];
	}
	
	// take ifft
	ifft.transform( frames[readIndex].s );
	
	(readIndex + 1) % (numFrames) => readIndex;
	(writeIndex + 1) % (numFrames) => writeIndex;
	
	// advance time
	hop::samp => now;
	
	
}