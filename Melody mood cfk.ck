
Moog m => Gain g1 =>  Gain masterL => dac.left;

g1 => Echo echo => Gain echoGain => Gain masterR => dac.right;

2 => echoGain.gain;

1 => m.filterQ;
10 => m.filterSweepRate;
500 => m.vibratoFreq;
.1 => m.vibratoGain;
1 =>m.afterTouch;
Std.mtof(55-12) => m.freq;

60./94.*.25=> float beatSec;

beatSec::second => dur beat;

beat - (now % beat) => now;

5*beat => echo.max;
1.5*beat*2 => echo.delay;
.4 => echo.gain;
1 => echo.mix;
echo => echo;

.5 => float mult;

0 => int j;

while (true) {

	
m.freq()*mult => m.freq;

1 => m.noteOn;
beat => now;
1 => m.noteOff;
beat => now;	

j++;
if (j == 5) {
	0 => j;
	1/mult => mult;
}


}