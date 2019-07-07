Impulse imp => BPF filt => Echo echo => NRev rev =>  Gain g => dac;
SinOsc filtLFO => blackhole;
SinOsc timeLFO => blackhole;

5 => float gainSet;

4. => float impGain;

gainSet => g.gain;

.3 => rev.mix;// .3

10::second => echo.max;
.75::second => echo.delay; //.75
.3 => echo.mix; //.3
.5 => echo.gain; //.5
echo => echo;

.1 => filtLFO.freq;//.25
1 => filtLFO.gain; // 1 

.05 => timeLFO.freq; //.25
1 => timeLFO.gain; //1

5 => filt.Q; //5
1 => filt.gain;
440 => float centerFreq; //440

100 => float maxTime; //100
10 => float minTime; //10
float impTime;
(maxTime - minTime)*.5 => float b;
b + minTime => float a;

1 => int LFOtime; // use LFO to control time

while (true) {
	
	impGain => imp.next;
	
	(centerFreq - filtLFO.last()*centerFreq*.9) => filt.freq;
	
	if (LFOtime  == 1) {
		a+b*timeLFO.last() => impTime;
		impTime::ms => now;
	}
	else {
		
		10::ms => now; // halve doubles freq; higher (100 ms) produces raindrops
	}
	
}