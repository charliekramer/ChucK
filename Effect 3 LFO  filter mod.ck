// three lfos multiplied together determine frequency--two of which change frequency every 4 beats

class Fuzz extends Chugen
{
	1.0/2.0 => float p;
	
	2 => intensity;
	
	fun float tick(float in)
	{
		Math.sgn(in) => float sgn;
		return Math.pow(Math.fabs(in), p) * sgn;
	}
	
	fun void intensity(float i)
	{
		if(i > 1)
			1.0/i => p;
	}
}


SinOsc lfo1 => FullRect fr1 => blackhole;
SinOsc lfo2 => FullRect fr2 => blackhole;
SinOsc lfo3 => FullRect fr3 => blackhole;
Blit  sin => Fuzz fuzz => BPF filter => BPF filter2 => Fuzz fuzz2 => Echo echo => PRCRev rev => Dyno dyn => Gain gain => Pan2 pan => dac;

2.7 => fuzz.intensity;
1.5 => fuzz2.intensity;

 .5 => gain.gain;

60 => int midiBase;
Std.mtof(midiBase) => float baseFreq; // *1.5 is cool too
baseFreq => filter.freq => filter2.freq;
5 => filter.Q => filter2.Q; // smaller for more noise ; 5 start
60./120. => float beatsec;
beatsec::second => dur beat;

.2 => rev.mix;

.3 => echo.mix;
.5 => echo.gain;
echo => echo;
10*beat => echo.max;
1.5* beat => echo.delay;

beat - (now % beat) => now;

50::ms => dur increment; // increment for lfo; shorter = smoother
//100::ms => increment;

8 => float lfo1High; // 7 
2 => float lfo1Low; // 3

4 => float lfo2High; //5
.5 => float lfo2Low; // 3

2.2 => float b; //divides multiplied frequencies; 2.2
.5 => float a; // added to multiplied frequencies; .5

lfo1High => lfo1.freq;
lfo2High => lfo2.freq;
.5 => lfo3.freq; // guess, .5

2 => lfo1.sync;
2 => lfo2.sync;
2 => lfo3.sync;

while (true) {
now + 4*beat => time future;
    
	while (now < future) {
		Std.rand2(1,6) => sin.harmonics;
	    (((1+lfo1.last())*(1+lfo2.last())*(1+lfo3.last()))/b+a)*baseFreq => filter.freq => filter2.freq;
	    increment => now;
	}
	Std.rand2f(-.3,.3) => pan.pan;
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

