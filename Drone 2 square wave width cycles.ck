// 2 square width cycle

.01 => float gainSet;

SqrOsc sin;
SqrOsc tri;

SinOsc lfo  => blackhole;

59=> float midiBase;

Std.mtof(midiBase)/8.*1.001 => sin.freq;
Std.mtof(midiBase)/8.*.999 => tri.freq;
gainSet => sin.gain;
gainSet => tri.gain;


.25 => lfo.freq;
.2 => lfo.gain;

sin => dac;
tri => dac;


while (true) {
	(lfo.last()+1)*.5 => tri.width;
	(lfo.last()+1)*.3 => sin.width;
	//(2 - lfo.last())*.7 => sin.width;
	1::ms  => now;
	
}
