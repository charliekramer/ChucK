SinOsc x[8][8]; // 6,6 [20 is pretty cool; need to reduce b to 1

.01 => float gainSet;

Gain master;

gainSet/(x.cap()*x.cap()) => master.gain; // watch volume with large arrays

for (0 => int i; i <= x.cap()-1; i++) {
	for (0 => int j; j <= x.cap()-1; j++) {
		x[i][j] => master => dac;
	}
}

10::ms => dur loop1Dur; // 10::ms, 1::ms 1000::ms filling with frequencies
10::ms => dur loop2Dur; // 10::ms, 1::ms  resetting frequencies

Std.mtof(55-12-12) => float baseFreq; // reset frequency 110
baseFreq => float a; // a*i+b*j => x[i][j].freq;
50 => float b; // 440,50


while (true) {

<<< "loop 1">>>;

for (0 => int i; i <= x.cap()-1; i++) {
	for (0 => int j; j <= x.cap()-1; j++) {
		a*i+b*j => x[i][j].freq;
		//		<<< i, j, x[i][j].freq >>>;
		loop1Dur => now;
	}
}

<<< "loop 2">>>;

for (0 => int i; i <= x.cap()-1; i++) {
	for (0 => int j; j <= x.cap()-1; j++) {
		baseFreq => x[i][j].freq;
		//		<<< i, j, x[i][j].freq >>>;
		loop2Dur => now;
	}
}


}