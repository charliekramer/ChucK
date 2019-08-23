.01*.01 => float gainSet;

7 => int n;

BeeThree wurley[n]; // sounds nice with Wurley too
NRev rev1;
NRev rev2;
ADSR env;
Echo echo;
Pan2 pan1;
Pan2 pan2;
SinOsc LFO => blackhole;

Gain main;

.1 => LFO.freq;

59-12 => float midiBase;
[0., 2., 4., 5., 7., 9., 11., 12.] @=> float notes[];

for (0 => int i; i < n; i++) {
	wurley[i] => rev1 => env => rev2 => main => pan1 =>dac;
	env =>  echo => pan2 => dac;
	gainSet => wurley[i].gain;
}

.05 => main.gain;
.9 => rev1.mix => rev2.mix;

0 => pan1.pan;
0.75 => pan2.pan;

60./80. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

beatSec/16 => LFO.freq; // frequency for echo panner

1.5*beat*2 => echo.max;
2*beat => echo.delay;
.5 => echo.mix;
.9 => echo.gain;
echo => echo;

env.set(3*beat, .1*beat, 1, 2*beat);

int start;
int chordN;
float octave;

spork~panLFO();

while (true) {
	// choose random start place and length;
	Std.rand2(0,notes.cap()-1) => start;
	Std.rand2(2,n) => chordN;
	
	<<< "start, chordN, ", start, chordN >>>;
	
	for (0 => int i; i < chordN; i++) {
		Math.floor( 2*i / (notes.cap()-1) ) => octave;
		Std.mtof(midiBase + notes[(start+2*i) % (notes.cap()-1)] + octave) => wurley[i].freq;
		<<< "i, ", i, "note", (start+2*i) % (notes.cap()-1), notes[(start+2*i) % (notes.cap()-1)], "octave", octave>>>;
		1 => wurley[i].noteOn;
	}
	
	1 => env.keyOn;
	
	
	4*beat => now;
	<<< pan2.pan() >>>;
	1 => env.keyOff;
	4*beat => now;
	<<< pan2.pan() >>>;
}

fun void panLFO () {
	while (true) {
		
		LFO.last() => pan2.pan;
		1::samp => now;
	}
}
		
	
	
	