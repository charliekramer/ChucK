// 2 square width cycle

.05 => float gainSet;

SqrOsc sin;
Pan2 mix;
SqrOsc tri;

SinOsc lfo  => blackhole;

59 => float midiBase;

Std.mtof(midiBase)/8.*1.001 => sin.freq;
Std.mtof(midiBase)/8.*.999 => tri.freq;
gainSet => sin.gain;
gainSet => tri.gain;


.25 => lfo.freq;
.2 => lfo.gain;

sin => dac;
tri => dac;


while (true) {
	(lfo.last()+1)*.7 => tri.width;
	(lfo.last()+1)*.6 => sin.width;
	//(2 - lfo.last())*.7 => sin.width;
	1::samp => now;
	
}
