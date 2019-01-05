BlitSquare blit =>  LPF lpf => Echo echo => NRev rev => Gain g => dac;

.2 => g.gain;

60./120.*.5 => float beatSec;

beatSec::second => dur beat;

beat - (now % beat) => now;

60-24 => int midiBase;
Std.mtof(midiBase) => blit.freq;

blit.freq()*12. => float upFreq; //filter high and low frequencies
blit.freq()/10. => float downFreq;

2 => int harmonicMult;
4 => int cycLength;

.01 => rev.mix;

beat*1.5 => echo.delay;
.5 =>echo.gain;
.5 => echo.mix;
echo => echo;

0=> int i; 

while (true) {
	i++;
	i*harmonicMult => blit.harmonics;
	upFreq => lpf.freq;
	beat => now;
	downFreq => lpf.freq;
	beat => now;
	if (i == cycLength) 0=> i;
}
 