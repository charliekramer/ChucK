.1*2 => float gainSet;

Step step => Echo echo => dac;

gainSet => step.gain;

SinOsc LFO => blackhole;

62 => float midiBase;
Std.mtof(midiBase) => LFO.freq;

SqrOsc timeLFO1 => blackhole;
SinOsc timeLFO2 => blackhole;

.5 => timeLFO1.gain;
1.2*.5*.5 => timeLFO1.freq;
.2 => timeLFO2.gain;
.2*.5*.5 => timeLFO2.freq;

60./60. => float beatSec;
beatSec::second => dur beat;

5*beat => echo.max;
1.5*beat => echo.delay;
.2 => echo.mix;
.4 => echo.gain;
echo => echo;


float nSamp;

while (true) {
	
	(1+timeLFO1.last())*(1+timeLFO2.last())*100. => nSamp;
	LFO.last() => step.next;
	nSamp::samp => now;
	
}