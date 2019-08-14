TubeBell bell => Echo echo1 => Echo echo2 => Echo echo3 => Gain g => dac;

.03 => g.gain;

59+12 => float midiBase;

Std.mtof(midiBase) => bell.freq;

60./80. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

10*beat => echo1.max => echo2.max => echo3.max;

.5 => echo1.mix => echo2.mix => echo3.mix;

echo1 => echo1; .5 => echo1.gain;
echo2 => echo2;.5 => echo2.gain;
echo3 => echo3; .3 => echo2.gain;

.25 => float b; // delay = a + b*Std.rand2(0,n)
.5 => float a; // .25, .5 good for a, b // small (.01,.05) for grindy effects
3 => int n; // 2, 3
64 => int nBeats; // how long to play

.5*beat => echo1.delay => echo2.delay => echo3.delay;

now + nBeats*beat => time future;

while (now < future) {
	1 =>bell.noteOn;
	beat => now;
	1 => bell.noteOff;
	3*beat => now;
	(Std.rand2(0,n)*b+a)*beat => echo1.delay;
	(Std.rand2(0,n)*b+a)*beat => echo2.delay;
	(Std.rand2(0,n)*b+a)*beat => echo3.delay;
}

now + 32*beat => future;

<<< "fade" >>>;

while (now < future) {
	g.gain()*.9 => g.gain;
	beat => now;
}

