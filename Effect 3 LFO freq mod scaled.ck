// three lfos multiplied together determine frequency--two of which change frequency every 4 beats

.3*1*2 => float gainSet;

SinOsc lfo1 => blackhole;
SinOsc lfo2 => blackhole;
SinOsc lfo3 => blackhole;
Blit sin => HalfRect frsin => Chorus c =>  Echo echo => PRCRev rev => Gain gain => dac;

.1 => c.modFreq;
.2 => c.modDepth;
.5 => c.mix;

[0.,3.,4.,-1.,.5,.25,.3] @=> float freqs[]; // needs to be at least 4 long

gainSet => gain.gain;

1 => lfo1.gain => lfo2.gain => lfo3.gain;

62 => float midiBase;
Std.mtof(midiBase) => float baseFreq; 
60./60. => float beatsec;
beatsec::second => dur beat;

.2 => rev.mix;

.3 => echo.mix;
.5 => echo.gain;
echo => echo;
10*beat => echo.max;
1.5* beat => echo.delay;

beat - (now % beat) => now;

//750::ms => dur increment; // increment for lfo; shorter = smoother
//100::ms => increment;
beat/4. => dur increment;

7 => float lfo1High;
3 => float lfo1Low;

5 => float lfo2High;
2 => float lfo2Low;


lfo1High => lfo1.freq;
lfo2High => lfo2.freq;
.5 => lfo3.freq;

2 => lfo1.sync;
2 => lfo2.sync;

float product;

while (true) {
now + 4*beat => time future;
    
	while (now < future) {
	    (((1+lfo1.last())*(1+lfo2.last())*(1+lfo3.last()))/8.) => product;
		if (product < .1) Std.mtof(midiBase+freqs[0]) => sin.freq;
		else if (product < .35) Std.mtof(midiBase+freqs[1]) => sin.freq;
		else if (product < .65) Std.mtof(midiBase+freqs[2]) => sin.freq;
		else Std.mtof(midiBase+freqs[3]) => sin.freq;
		Std.rand2(1,6) => sin.harmonics;  // use for Blit
//		1 => sin.noteOn;
	    increment => now;
	}
	if (lfo1.freq() == lfo1High) {
	lfo1Low => lfo1.freq;
       }
	else 
	{lfo1High => lfo1.freq;
    }
	if (lfo2.freq() == lfo2High) {
		lfo2Low => lfo2.freq;
	}
	else 
	{lfo2High => lfo2.freq;
    }

	<<< lfo1.freq(), lfo2.freq()>>>;
}

