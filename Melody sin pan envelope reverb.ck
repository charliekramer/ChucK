// osc sounds in left and reverbs in right
// run thru envelope
// timed but not synched
// time limited (120 sec)
SinOsc sin => ADSR env => NRev rev => dac.left; // change oscillator
env => NRev rev2 => Gain revGain => dac.right;

.05*4 => sin.gain;

45::second => dur duration;

SinOsc LFO => blackhole; // to modulate RHS reverb mix

.8 => float revMax;
.2 => float revMin;
.1 => float revDelta;

(revMax - revMin)*.5 => float b;
b + revMin => float a;

.0 => rev.mix;
revMin => rev2.mix;

59+12=> float midiBase;

Std.mtof(midiBase)/Math.pow(1.5,0) => sin.freq; // divide by 1.5

60./80.*2 => float beatSec;

beatSec::second => dur beat;

.1/(beatSec*6.)*20 => LFO.freq;

(.5*beat, .1*beat, .1, .5*beat) => env.set; // change decay parameter to .1

now + duration => time future;

while (now < future) {

 	1 => env.keyOn;
 	2*beat => now;
 	1 => env.keyOff;
 	4*beat => now;

//    <<< rev2.mix() >>>;
	LFO.last()*b + a => rev2.mix;
	
}
	