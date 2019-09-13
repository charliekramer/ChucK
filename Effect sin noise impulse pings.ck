SinOsc sin => ResonZ filt => Gain master => ADSR env => NRev rev =>  Pan2 pan => dac;
Noise noise => ResonZ noise_filt => master =>  ADSR noise_env => NRev noise_rev => Pan2 noise_pan => dac;
Impulse imp => ResonZ imp_filt => master => ADSR imp_env => NRev imp_rev => Pan2 imp_pan => dac;

.04*2 => master.gain;
45::second => dur duration;
59 +12+ 12+7=> float midiBase;

[0.,4.,5.,7.,9.,12.,16] @=> float notes[];

.3 => float sinP;
.3 => float noiseP;

(10::ms, 10::ms, 1, 10::ms) => env.set;	
Std.mtof(midiBase) => sin.freq;
Std.mtof(midiBase) => filt.freq;
20 => filt.Q;
.2 => rev.mix;

(10::ms, 10::ms, 1, 10::ms) => noise_env.set;
.5 => noise.gain;
Std.mtof(midiBase) => noise_filt.freq;
20 => noise_filt.Q;	
.2 => noise_rev.mix;
	
(10::ms, 10::ms, 1, 10::ms) => imp_env.set;	
100 => imp.gain;
200 => imp_filt.gain;
Std.mtof(midiBase) => imp_filt.freq;
200 => imp_filt.Q;	
.3 => imp_rev.mix;

float x;

now + duration => time future;

while (now < future) {
	Std.rand2f(0,1) => x;
	if (x < sinP ) {
		Std.mtof(midiBase+notes[Std.rand2(0,notes.size()-1)]) => sin.freq;
		sin.freq() => filt.freq;
		Std.rand2f(-1,1) => pan.pan;
		spork~sin_ping();
	}
	else if (x < sinP + noiseP) {
		Std.mtof(midiBase+notes[Std.rand2(0,notes.size()-1)]) => noise_filt.freq;
		Std.rand2f(-1,1) => noise_pan.pan;
		spork~noise_ping();
	}
	else {
		Std.mtof(midiBase+notes[Std.rand2(0,notes.size()-1)]) => imp_filt.freq;
		Std.rand2f(-1,1) => imp_pan.pan;
		spork~imp_ping();
	}
	Std.rand2f(1,5)::second => now; //1,5 second; try /10
}

sin_ping();
noise_ping();	
imp_ping();


fun void sin_ping() {
	
	<<< "sin ping" >>>;
	
	1 => env.keyOn;
	
	.2::second => now;
	
	1 => env.keyOff;
	
	5::second => now;
}

fun void noise_ping() {
	
	
	<<< "noise ping" >>>;
	
	1 => noise_env.keyOn;
	
	.2::second => now;
	
	1 => noise_env.keyOff;
	
	5::second => now;
}

fun void imp_ping () {
	
	
	<<< "imp ping" >>>;
	1 => imp_env.keyOn;
	1 => imp.next;
	
	.2::second => now;
	
	1 => imp_env.keyOff;
	
	5::second => now;
}

