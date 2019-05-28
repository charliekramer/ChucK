Rhodey rhodes => BPF filt => Echo echo  => NRev rev => dac;
echo => Echo echo2 => PitShift pitch => dac;

SqrOsc PitchLFO => blackhole;
SinOsc DelayLFO => blackhole;

(60-3) -36  => int midiBase;

Std.mtof(midiBase) => rhodes.freq;

Std.mtof(midiBase) => filt.freq;
2 => filt.Q;

120./94.*.25 => float beatSec;
beatSec::second => dur beat;

//spork~LFOPitch(4., .5, 1/beatSec*.125); // a, b, LFO freq (a+b*LFO.last => pitch) // 4, .5, .125

spork~LFODelay(.5, .25, 1/beatSec*.125*25, 1); // a, b, LFO freq (a+b*LFO.last => pitch) 
                                               // 1, .5, .125;
											   // last = chooser
											   // 1 = echo
											   // 2 = echo2
											   // other = both;

beat - (now % beat) => now;

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

now + 30::second => time future;

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