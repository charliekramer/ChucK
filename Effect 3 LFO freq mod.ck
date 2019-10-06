// three lfos multiplied together determine frequency--two of which change frequency every 4 beats

SinOsc lfo1 => FullRect fr1 => blackhole;
SinOsc lfo2 => FullRect fr2 => blackhole;
SinOsc lfo3 => FullRect fr3 => blackhole;
SinOsc sin => HalfRect frsin => Echo echo => PRCRev rev => Gain gain => dac;

.3 => gain.gain;

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

750::ms => dur increment; // increment for lfo; shorter = smoother
500::ms=> increment;

7 => float lfo1High;
3 => float lfo1Low;

5 => float lfo2High;
3 => float lfo2Low;


lfo1High => lfo1.freq;
lfo2High => lfo2.freq;
.5 => lfo3.freq;

2 => lfo1.sync;
2 => lfo2.sync;


while (true) {
now + 4*beat => time future;
    
	while (now < future) {
	    ((lfo1.last()*lfo2.last()*lfo3.last())/2.+.5)*baseFreq => sin.freq;
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

