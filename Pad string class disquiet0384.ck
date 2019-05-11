// fixes;
// LFO to spread; may be less clunky to define static variable?

class StringPatch {
	
	10 => int n;
	220 => float baseFreq;
	.1 => static float spr;
	1 => float masterGain;
	
	SawOsc sin[n];
	
	for (0 => int i; i < n; i++) {
		baseFreq*(1+spr*i*Math.pow(-1,i)) => sin[i].freq;
		<<< i, sin[i].freq() >>>;
		masterGain => sin[i].gain;
	}
	
	fun void nOsc(int tempN) {
		tempN => n;
		<<< "nOsc", n>>>;
	}
	
	 fun float spread(float tempSpread) {
		tempSpread => spr;
		for (0 => int i; i < n; i++) {
			baseFreq*(1+spr*i*Math.pow(-1,i)) => sin[i].freq;
		}
	}
	
	fun void freq(float tempFreq) {
		tempFreq => baseFreq;
		for (0 => int i; i < n; i++) {
			baseFreq*(1+spr*i*Math.pow(-1,i)) => sin[i].freq;
		}
	}
	
	fun void gain(float tempGain) {
		tempGain => masterGain;
		for (0 => int i; i < n; i++) {
			masterGain => sin[i].gain;
		}
	}
	
	fun void connect(UGen ugen) {
		for (0 => int i; i < n; i++) {
			sin[i] => ugen;
		}
	}
	
}

.01 => float masterGain;

60./94. => float beatSec;
beatSec::second => dur beat;

//beat - (now % beat) => now;

StringPatch s1;
StringPatch s2;
StringPatch s3;

44 => float midiBase;
.005 => float spread => s1.spread;
3 => s1.nOsc;
Std.mtof(midiBase) => s1.freq;
3 => s2.nOsc;
Std.mtof(midiBase+4) => s2.freq;
3 => s3.nOsc;
Std.mtof(midiBase+7) => s3.freq;

Gain g => ADSR env => HPF filter => NRev rev => dac;

Std.mtof(midiBase) => filter.freq;
10 => filter.Q;

.5 => rev.mix;
masterGain => s1.gain;
masterGain => s2.gain;
masterGain => s3.gain;

(4*beat,.0::second, .9, 3*beat) => env.set;

s1.connect(g);
s2.connect(g);
s3.connect(g);

spork~spread_LFO(.5,.1);

now + 64*beat => time future;

0 => int beatcount;

while (now < future) {
	1 => env.keyOn;
	4*beat => now;
	1 => env.keyOff;
	4*beat => now;
	8+=> beatcount;
	<<< "beatcount", beatcount>>>;
}

5::second => now;

fun void spread_LFO (float freq, float gain) {
	
	SinOsc LFO => blackhole;
	freq => LFO.freq;
	gain => LFO.gain;
	while (true) {
		(1+LFO.last())*spread => s1.spread;
		(1+LFO.last())*spread => s2.spread;
		(1+LFO.last())*spread => s3.spread;
		1::samp => now;
	}
}
