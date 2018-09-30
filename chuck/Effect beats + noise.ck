//sinosc beating plus noise jabs

SinOsc s => Echo echo => Gain g => dac;
SinOsc t => echo => g => dac;
Noise n =>  ResonZ f => Envelope env => echo => NRev rev => g => dac;

4 => n.gain;
.4 => rev.mix;
10 => f.Q;

.2 => g.gain;

10::second => echo.max;

2.25::second => echo.delay;
.9 => echo.gain;
.5 => echo.mix;
echo => echo;

220 => s.freq;
220 => t.freq;

while (t.freq() < 440.) {
	.1::second => now;
	t.freq()+ .1 => t.freq;
	t.freq()*Std.rand2f(.1,6.) => f.freq;
	
	if (Std.rand2f(0,1) > .9) {
		1 => env.keyOn;
	}
	else {
		1 => env.keyOff;
	}
	1 => t.gain => s.gain;
}