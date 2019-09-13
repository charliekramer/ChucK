.5*2 => float gainSet;

59-24=> float midiBase;
5=> int nOsc;// orchestral for large (up to 15)

1 => int sweepArp; //sweep through notes
16 => float beatDiv; // beat division if sweep thru notes

60./80.*2*2 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

StifKarp sk[nOsc];
SinOsc LFO[nOsc]; //pretty cool w/ sqrOsc too
Pan2 pan[nOsc];
PitShift pitch[nOsc];

1 => float pitchMix;

.1 => float LFOBase; // LFO base frequency
.05 => float LFOGain; // common gain for LFOs;


spork~pitchLFOs();

for (0 => int i; i < sk.size(); i++) {
	pitchMix => pitch[i].mix;
	LFO[i] => blackhole;
	gainSet/nOsc => sk[i].gain;
	sk[i] => pitch[i] => pan[i] => dac;
	Std.mtof(midiBase)*(1+i*0) => sk[i].freq;
	-1+ i*2./(1.*(nOsc-1))  => pan[i].pan; 
	<<< "i", i, "pan[i]", pan[i].pan() >>>;
	LFOBase*(1.+i/(nOsc-1)*1.) => LFO[i].freq;
	LFOGain => LFO[i].gain;
}



while (true) {
	for(0 => int i; i < nOsc; i++) {
		spork~note(i,beat*(1+i));
		//<<<i, pitch[i].shift() >>>;
		if (sweepArp == 1) {
			
			beat/beatDiv => now;	// for successive notes w/ panning
		}
	}
	2*beat - sweepArp*beat*nOsc/beatDiv => now;
}

fun void note (int j, dur duration) {
	1 => sk[j].noteOn;
	duration => now;
}

fun void pitchLFOs () {
	while (true) {
		for (0 => int i; i < nOsc; i++) {
			(1.+LFO[i].last()) => pitch[i].shift;
			100::ms => now;
		}
		1::samp => now;
	}
	1::ms => now;
}

