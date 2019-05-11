SinOsc sin => Envelope env => NRev rev => Gain gain => dac;
ModalBar bar => rev => gain => dac;
StifKarp karp => rev => gain => dac;

4 => bar.preset;

.05 => gain.gain;

.5 => sin.gain;
 1 => bar.gain;
.6 => karp.gain;

.4 => rev.mix;

44 => float midiBase;

Std.mtof(midiBase) => sin.freq;
Std.mtof(midiBase) => bar.freq;
Std.mtof(midiBase) => karp.freq; 

60./94.*2 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

0 => bar.modeGain;

now + 64*beat => time future;

float x;
.29=> float p1; // sin
p1 + .29=> float p2; // bar
p2 + .29=> float p3; 

while (now < future) {
	Std.rand2f(0,1) => x;
	if (x < p1) 1 => env.keyOn;
	else if (x < p2) 1 => bar.noteOn;
	else if (x < p3) 1 => karp.noteOn;
	beat => now;
	1 => env.keyOff;
	1 => bar.noteOff;
	1 => karp.noteOff;
	beat => now;
}
	


