//noise envelope

Noise noise1 => ADSR envelope1 => LPF filter1 => Echo echo1 => NRev rev1 => Gain gain1 => dac;
Noise noise2 => LPF filter2 => NRev rev2 => ADSR envelope2 => Echo echo2 => Gain gain2 => dac;
Noise noise3 => LPF filter3 => Echo echo3 => NRev rev3 => ADSR envelope3 => Gain gain3 => dac;

.0 => gain1.gain;// envelope => echo => reverb
.5 => gain2.gain;// reverb  => envelope => echo 
.0 => gain3.gain;// echo => reverb => envelope 
 
60./94.*4 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

(4*beat, 0.1*beat,0.1,.01*beat) => envelope1.set;
(4*beat, 0.1*beat,0.1,.01*beat) => envelope2.set;
(4*beat, 0.1*beat,0.1,.01*beat) => envelope3.set;

220 => filter1.freq;
1 => filter1.Q;
220 => filter2.freq;
1 => filter2.Q;
220 => filter3.freq;
1 => filter3.Q;

.5 => rev1.mix;
.5 => rev2.mix;
.5 => rev3.mix;


beat*5 => echo1.max;
beat*1.5 => echo1.delay;
.5 => echo1.mix;
.5 => echo1.gain;
echo1 => echo1;
beat*5 => echo2.max;
beat*1.5 => echo2.delay;
.5 => echo2.mix;
.5 => echo2.gain;
echo2 => echo2;
beat*5 => echo3.max;
beat*1.5 => echo3.delay;
.5 => echo3.mix;
.5 => echo3.gain;
echo3 => echo3;

.25/beatSec => float freqCyc;
spork~filterCycle(filter1, freqCyc, 440, .5); 
spork~filterCycle(filter2, freqCyc*1.1, 220, .2); 
spork~filterCycle(filter3, freqCyc*.9, 110, .1); 

now + 128*beat => time future;

while (now < future) {
	1 => envelope1.keyOn;
	1 => envelope2.keyOn;	
	1 => envelope3.keyOn;
	Std.rand2f(4,4)*beat => now;
	1 => envelope1.keyOff;
	1 => envelope2.keyOff;
	1 => envelope3.keyOff;
	Std.rand2f(4,4)*beat => now;
}

10*beat => now;

fun void filterCycle(LPF filt, float rate, float center, float gain) {
	SinOsc LFO => blackhole;
	rate => LFO.freq;
	gain => LFO.gain;
	while (true) {
		(1+LFO.last())*center => filt.freq;
		1::ms => now;
	}
}
