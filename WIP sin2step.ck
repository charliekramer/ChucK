
Step step => dac;

SinOsc LFO => blackhole;
SinOsc timeLFO => blackhole;

.5 => timeLFO.gain;
.2 => timeLFO.freq;

float nSamp;

while (true) {
	
	(1+timeLFO.last()) => nSamp;
	LFO.last() => step.next;
	nSamp::samp => now;
	
}