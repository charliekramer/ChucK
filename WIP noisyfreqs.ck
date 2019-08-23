4 => int n;
SinOsc sin[n];

SinOsc LFO[n];

[.1,.3,.5,.7] @=> float LFOFreqs[];
[5.,5.,5.,5.] @=> float LFOGains[];


59-12 => float midiBase;

[0., 4., 7., 12.] @=> float notes[];
[1.,1.,1.,1.] @=> float sigma[];

float freqs[n];

for (0 => int i; i < sin.cap(); i++) {
	
	sin[i] => dac;
	Std.mtof(midiBase+notes[i]) => freqs[i] => sin[i].freq;
	LFO[i] => blackhole;
	LFOFreqs[i] => LFO[i].freq;
	LFOGains[i] => LFO[i].gain;
	
}

while (true) {
	
	for (0 => int i; i < sin.cap(); i++) {
		freqs[i]*(1+Std.rand2f(-.1,.1)*sigma[i]*LFO[i].last()) => sin[i].freq;
	}
	1::ms => now;
	
}