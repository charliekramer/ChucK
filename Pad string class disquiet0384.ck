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
//		<<< i, sin[i].freq() >>>;
		masterGain => sin[i].gain;
	}
	
	fun void nOsc(int tempN) {
		tempN => n;
//		<<< "nOsc", n>>>;
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

60./80. => float beatSec;
beatSec::second => dur beat;

//beat - (now % beat) => now;

StringPatch s1;
StringPatch s2;
StringPatch s3;

59-12 => float midiBase;// 
.005 => float spread => s1.spread;
3 => s1.nOsc;
Std.mtof(midiBase) => s1.freq;
3 => s2.nOsc;
Std.mtof(midiBase+4) => s2.freq;
3 => s3.nOsc;
Std.mtof(midiBase+7) => s3.freq;

//0 2 4 5 7 9 11 12 14 16 17 19 21

[[0, 4, 7],
 [2, 5, 9],
 [4, 7, 11],
 [5, 9, 12],
 [7, 11, 14],
 [9, 12, 16],
 [11, 14, 17],
 [12, 16, 19]]  @=> int notes[][];

Gain g => ADSR env => HPF filter => NRev rev => dac;

Std.mtof(midiBase) => filter.freq;
10 => filter.Q;

.5 => rev.mix;
masterGain => s1.gain;
masterGain => s2.gain;
masterGain => s3.gain;

(8*beat,.0::second, .9, 7*beat) => env.set;

s1.connect(g);
s2.connect(g);
s3.connect(g);

spork~spread_LFO(.5,.1);

now + 8*64*beat => time future;

0 => int beatcount;

while (now < future) {
	load_notes(Std.rand2(0,7));
	1 => env.keyOn;
	8*beat => now;
	1 => env.keyOff;
	8*beat => now;
	16+=> beatcount;
	<<< "beatcount", beatcount>>>;
}

// finish on tonic

load_notes(0);
	1 => env.keyOn;
	8*beat => now;
	1 => env.keyOff;
	8*beat => now;
	16+=> beatcount;
	<<< "END beatcount", beatcount>>>;

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

fun void load_notes(int row) {
	Std.mtof(midiBase+notes[row][0]) => s1.freq;
	Std.mtof(midiBase+notes[row][1]) => s2.freq;	
	Std.mtof(midiBase+notes[row][2]) => s3.freq;
    <<< "notes",midiBase+notes[row][0], midiBase+notes[row][1], midiBase+notes[row][2] >>>;
	
}
	