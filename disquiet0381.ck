SinOsc sin => BPF filter => ADSR env => Echo echo => Pan2 pan => dac;

SinOsc LFO => blackhole;// filter control
SinOsc LFO2 => blackhole;// pitch (FM);

220 => filter.freq;
2 => filter.Q;

60./94.*1.5 => float beatSec;
beatSec::second => dur beat;

10*beat => echo.max;
1.5*beat => echo.delay;
.3 => echo.mix;
.4 => echo.gain;
echo =>  echo;

beat - (now % beat) => now;

// filter LFO
.25/beatSec => LFO.freq;
1. => LFO.gain;

// pitch LFO
40 => LFO2.freq;
.0 => LFO2.gain;

(.5*beat, 0.1*beat, .9, .75*beat) => env.set;

55 => int midiBase; // base note

[0, 2, 4, 9] @=> int notes[]; // "sequencer"

[0, 2, 4, 9] @=> int basePlus[]; // hmm add this to base

spork~filtLFO();
spork~pitchLFO();


while (true) {
	for (0 => int i; i < notes.cap(); i++) {
		for (0 => int j; j < basePlus.cap(); j++) {
			Std.mtof(midiBase+notes[i]+basePlus[j])*(2+LFO2.last())/2. => sin.freq;
			1 => env.keyOn;
			Std.rand2f(-.8,.8) => pan.pan;
			.5*beat => now;
			1 => env.keyOff;
			.5*beat => now;
		}
	}
}

fun void filtLFO () {
	while (true) {
		(LFO.last()+1.2)*Std.mtof(midiBase) => filter.freq;
		1::samp => now;
	}
}
	
fun void pitchLFO () {
	while (true) {
		sin.freq() => sin.freq;
		1::samp => now;
	}
}
			

