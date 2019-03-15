SinOsc x[6][6]; // 6,6

Gain master;

.01 => master.gain; // watch volume with large arrays

for (0 => int i; i <= x.cap()-1; i++) {
	for (0 => int j; j <= x.cap()-1; j++) {
		x[i][j] => master => dac;
	}
}

10::ms => dur loop1Dur; // 10::ms, 1::ms 1000::ms filling with frequencies
10::ms => dur loop2Dur; // 10::ms, 1::ms  resetting frequencies

440 => float a; // a*i+b*j => x[i][j].freq;
50 => float b; // 440,50
110 => float baseFreq; // reset frequency 110

while (true) {

for (0 => int i; i <= x.cap()-1; i++) {
	for (0 => int j; j <= x.cap()-1; j++) {
		a*i+b*j => x[i][j].freq;
		//		<<< i, j, x[i][j].freq >>>;
		loop1Dur => now;
	}
}

for (0 => int i; i <= x.cap()-1; i++) {
	for (0 => int j; j <= x.cap()-1; j++) {
		baseFreq => x[i][j].freq;
		//		<<< i, j, x[i][j].freq >>>;
		loop2Dur => now;
	}
}


}