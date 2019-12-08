// Mono version
// TubeBell bell => Echo echo1 => Echo echo2 => Echo echo3 => Gain g => dac;
// stereo 
TubeBell bell => Echo echo1 => Echo echo2 => Gain g => Pan2 pan1 => dac;
bell => Echo echo3 => PitShift pitch => Gain g2 => Pan2 pan2 => dac;
1 => pan1.pan;
-1 => pan2.pan;

1 => pitch.mix;
2 => pitch.shift;

.3 => g.gain;
.15*g.gain()=> g2.gain;

59+12-12 => float midiBase;

Std.mtof(midiBase) => bell.freq;

60./80. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

10*beat => echo1.max => echo2.max => echo3.max;

.5 => echo1.mix => echo2.mix => echo3.mix;

echo1 => echo1; .7 => echo1.gain; .7 => echo1.mix;
echo2 => echo2; .7 => echo2.gain;  .7 => echo2.mix;
echo3 => echo3;  1 => echo3.gain;   1 => echo3.mix;

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
    (Std.rand2(0,3)*.5+1) => pitch.shift;
}

now + 32*beat => future;

<<< "fade" >>>;

while (now < future) {
	g.gain()*.7 => g.gain => g2.gain;
	beat => now;
}

