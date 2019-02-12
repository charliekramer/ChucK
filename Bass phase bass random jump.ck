Phasor p => SawOsc s => Gain g => dac;
SawOsc v => g => dac;

60./120. => float beatSec;
beatSec::second => dur beat;

0 => g.gain; // zero out so you don't get an immediate burst of 440

beat - (now % beat) => now;

0.025 => g.gain;

Std.mtof(60-24)*1. => s.freq => float baseFreq;
s.freq() => v.freq;

.1 => p.freq;

2 => s.sync;

while (true) {
	
	p.phase() => s.phase;
	Std.rand2f(.95,1.05)*baseFreq => s.freq;
	beat/4 => now;
	Std.rand2f(.99,1.01)*baseFreq => s.freq;
	beat/4 => now;
	p.phase() => s.phase;
	Std.rand2f(.99,1.01)*baseFreq => s.freq;
	beat/4 => now;
	Std.rand2f(.90,1.1)*baseFreq => s.freq;
	beat/4 => now;

}