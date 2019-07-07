// bass wavetable with echo
// array of sinoscs drive coeffs
// melody emerges

Phasor phase => Gen17 ct => Echo echo => PRCRev rev => Gain g => dac; // try replacing Phasor w/ sinosc etc

.1 => g.gain;

[1.,.5,.7,2,.3] => ct.coefs;

55 -12 => float midiBase;
Std.mtof(midiBase) => float baseFreq => phase.freq;

60./94.=> float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

.1 => rev.mix;

.5 => echo.mix;
.3 => echo.gain;
10*beat => echo.max;
1.5*beat => echo.delay;

SinOsc v[5];

for (0 => int i; i < v.cap(); i++) {
	v[i] => blackhole;
}

.1 => v[0].freq;
.25 => v[1].freq;
.5 => v[2].freq;
1 => v[3].freq;
2 => v[4].freq;


while (true) {
	
//	[Std.rand2f(0,1),Std.rand2f(0,1),Std.rand2f(0,2),Std.rand2f(0,1),Std.rand2f(0,1)] => ct.coefs;

	[v[0].last(),v[1].last(),v[2].last(),v[3].last(),v[4].last()] => ct.coefs;
//    [v[0].last(),v[1].last(),v[2].last(),1-v[1].last(),1-v[0].last()] => ct.coefs;


   beat/4 => now;
   
   Std.rand2(1,4)*baseFreq => phase.freq;
   if (Std.rand2f(0,1)>.75) phase.freq()*1.5 => phase.freq;
   
}


	