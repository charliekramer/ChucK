.01*.01*.25*8 => float gainSet;
30::second => dur runtime;

5 => int n;

PercFlut wurley[n]; // sounds nice with BeeThree, Wurley too or PercFlut
JCRev rev1;
JCRev rev2;
ADSR env;
Echo echo;
Pan2 pan1;
Pan2 pan2;
SinOsc LFO => blackhole;

Gain main;


59-12 +12=> float midiBase;
[0., 2., 4., 5., 7., 9., 11., 12.] @=> float notes[];

for (0 => int i; i < n; i++) {
	wurley[i] => rev1 => env => rev2 => main => pan1 =>dac;
	env =>  echo => pan2 => dac;
	gainSet => wurley[i].gain;
}

.01 => main.gain;
.7 => rev1.mix => rev2.mix;

0 => pan1.pan;
0.75 => pan2.pan;

60./80.*4 => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

beatSec/16 => LFO.freq; // frequency for echo panner

1.5*beat*2 => echo.max;
2*beat => echo.delay;
.5 => echo.mix;
.9 => echo.gain;
echo => echo;

env.set(3*beat, .1*beat, 1, 1*beat);

int start;
int chordN;
float octave;

spork~panLFO();

now + runtime => time future;

while (now < future) {
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
	1 => env.keyOff;
	4*beat => now;
	for (0 => int i; i < wurley.size(); i++) {
		1 => wurley[i].noteOff;
	}
}

<<< "ending" >>>;

for (0 => int i; i < 3; i++) {
	Std.mtof(midiBase+notes[2*i])=> wurley[i].freq;
	1 => wurley[i].noteOff;
}

1 => env.keyOn;
8*beat => now;
1 => env.keyOff;
8*beat => now;

fun void panLFO () {
	while (true) {
		
		LFO.last() => pan2.pan;
		1::samp => now;
	}
}
		
	
	
	