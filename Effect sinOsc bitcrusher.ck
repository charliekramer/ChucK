SqrOsc s => NRev rev => Dyno dyn => dac; // SqrOsc is cool too 

.01 => float gainSet;

SinOsc t => blackhole;

1 => int randDrops; // randomize dropped samples

.1 => t.freq;

.5 => float revMix; // peak reverb level over cycle

.1 => s.width;

44100/100 => int maxLen;

int drops[4];

for (0 => int i; i < drops.size(); i++) {
	Std.rand2(1,maxLen) => drops[i];
	<<< "i, drops[i] ", i, drops[i]>>>;
}

110/2. => s.freq;
Std.mtof(61-12) => s.freq;

0 => int i;
131 => int iMax;
0 => int jCount;

while (true) {
	i++;
	
	if (randDrops == 0) {
		if (i%130 == 0 || i%201 ==0 || i% 737 == 0) 0 =>s.gain;
	}
	else {
		if (checkDrop(drops, i)) 0 => s.gain;
	} 
    if (i%iMax > jCount ) 0.0 =>s.gain;
	jCount++;
	if (jCount > iMax) 0 => jCount;
	revMix*(1+t.last())*.5 => rev.mix;
	1::samp => now;
    .1::ms => now;
	gainSet => s.gain;

}

fun int checkDrop (int dropMx[], int i) {
	
	0 => int isDrop;
	for (0 => int j; j < dropMx.size(); j++) {
		if (i%dropMx[j] == 0) 1 => isDrop;
	}
	return isDrop;
}