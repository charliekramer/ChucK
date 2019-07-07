Rhodey rhodes => BPF filt => Echo echo  => NRev rev => dac;
// cool with Flute too
echo => Echo echo2 => PitShift pitch => dac;

.9 => rhodes.gain;

SqrOsc PitchLFO => blackhole;
SinOsc DelayLFO => blackhole;

(59+24) - 36   => int midiBase; //60 -3 - 36

Std.mtof(midiBase) => rhodes.freq;

Std.mtof(midiBase) => filt.freq;
2 => filt.Q;

120./80.*.25 => float beatSec; // 120./94.*.25 HANGS WHEN .25 removed
beatSec::second => dur beat;

spork~LFOPitch(4., .5, 1/beatSec*.125/16); // a, b, LFO freq (a+b*LFO.last => pitch) // 4, .5, .125
                                           // divide freq for interesting textures (4, 16; default 1)

spork~LFODelay(1, .5, 1/beatSec*.125/16, 3); // a, b, LFO freq (a+b*LFO.last => pitch) 
                                               // 1, .5, .125;
											   // last = chooser
											   // 1 = echo
											   // 2 = echo2
											   // other = both;
                                           // divide freq for interesting textures (4, 16; default 1)
beat - (now % beat) => now;

.2 => rev.mix;

5*beat => echo.max;
1.5*beat => echo.delay;
.3 => echo.mix;
.5 => echo.gain;
echo => echo;

echo.max()*.5 => echo2.max;
echo.delay()*.75 => echo2.delay;
.7 => echo2.mix;
.9 => echo2.gain; // turn up to get more LFO effect
echo2 => echo2;

now + 120::second => time future;

while (now < future) {
	1 => rhodes.noteOn;
	10*beat => now;
}
<<< "ending ">>>;
10*beat => now;

fun void LFOPitch(float a, float b, float freq) {
	freq => PitchLFO.freq;
	while (true) {
		a+b*PitchLFO.last() => pitch.shift;
		1::samp => now;
	}
}	

fun void LFODelay(float a, float b, float freq, int choose) {
	freq => DelayLFO.freq;
	if (choose == 1) {
		while (true) {
			(a+b*DelayLFO.last())*beat => echo.delay;
			1::samp => now;
		}
	}
	
	else if (choose == 2) {
		while (true) {
			(a+b*DelayLFO.last())*beat => echo2.delay;
			1::samp => now;
		}
	}
	
	else {
		while (true) {
			(a+b*DelayLFO.last())*beat => echo.delay;
			(a+b*DelayLFO.last())*beat => echo2.delay;
			1::samp => now;
		}
	}
}