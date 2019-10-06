SinOsc s => Gain master => dac;

.99999 => float gainDecay; // decay gain after shred ends; .99999

10::second => dur length;

.01*3 => master.gain;

110 => s.freq; // 110

0::samp => dur jMin; //0
2500::samp => dur iMax; //250
0::samp => dur jCount; //0
10::samp => dur jDelta; //10

.1::ms => dur goTime; // .1 ms;

now + length => time future;

while (now < future) {

	if (now%iMax > jCount ) 0.0 =>s.gain;
	jCount+jDelta => jCount;
	if (jCount > iMax) jMin => jCount;
	goTime => now; //.1::ms
	1 => s.gain;
	
}

<<< "bitcrusher dur fadeout ">>>;

now + 30::second => future;

while (now < future) {
	
	if (now%iMax > jCount ) 0.0 =>s.gain;
	jCount+jDelta => jCount;
	if (jCount > iMax) jMin => jCount;
	goTime => now; //.1::ms
	1 => s.gain;
	master.gain()*gainDecay => master.gain;
	
}

	