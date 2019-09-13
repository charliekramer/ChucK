.05 => float gainSet;

4 => int n;
SinOsc sin[n];

SinOsc LFO[n];

[.05,.07,.09,.11] @=> float LFOFreqs[];
[.01,.02,.03,.04] @=> LFOFreqs;

[2.,2.,2.,2.] @=> float LFOGains[];
//[0.,0.,0.,0.] @=>  LFOGains;
[4.,4.,4.,4.] @=>  LFOGains;
[8.,8.,8.,8.] @=>  LFOGains;


59 -12=> float midiBase;

[0., 4., 7., 12.] @=> float notes[];
[1.,1.,1.,1.] @=> float sigma[];

.1=> float hi; // hi and low points of the distribution
-.1 => float lo; // that randomizes the frequency

1::ms => dur loopTime; // time increment after each freq is randomized
                       // 1 ms, 10 ms
1::ms => dur allTime; // time increment after all freqs have been randomized

float freqs[n];

for (0 => int i; i < sin.cap(); i++) {
	
	gainSet => sin[i].gain;
	sin[i] => dac;
	Std.mtof(midiBase+notes[i]) => freqs[i] => sin[i].freq;
	LFO[i] => blackhole;
	LFOFreqs[i] => LFO[i].freq;
	LFOGains[i] => LFO[i].gain;
	
}

while (true) {
	
	for (0 => int i; i < sin.cap(); i++) {
		freqs[i]*(1+Std.rand2f(lo,hi)*sigma[i]*LFO[i].last()) => sin[i].freq;
		loopTime => now;
	}
	allTime=> now;
	
}