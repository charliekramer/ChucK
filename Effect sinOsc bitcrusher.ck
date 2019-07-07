SqrOsc s => NRev rev => dac; // SqrOsc is cool too 

.005 => float gainSet;

SinOsc t => blackhole;

.1 => t.freq;

.5 => float revMix; // average reverb level over cycle

.1 => s.width;



110/2 => s.freq;
Std.mtof(55-12) => s.freq;

0 => int i;
131 => int iMax;
0 => int jCount;

while (true) {
	i++;
	
	if (i%130 == 0 || i%201 ==0 || i% 737 == 0) 0 =>s.gain;
    if (i%iMax > jCount ) 0.0 =>s.gain;
	jCount++;
	if (jCount > iMax) 0 => jCount;
	revMix*(1+t.last())*.5 => rev.mix;
	1::samp => now;
    .1::ms => now;
	gainSet => s.gain;

}