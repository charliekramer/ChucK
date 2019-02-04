SndBuf2 s => Chorus c => Echo echo => Gain g => Pan2 pan => dac;

.5 => c.modFreq;
.5 => c.modDepth;
.5 => c.mix;

10::second => echo.max;
.75::second => echo.delay;
.3 => echo.gain;
.3 => echo.mix;
echo => echo;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => s.read;

//4400=> float baseFreq => s.freq;

fun void pitchy() {
	SinOsc v => blackhole;
	.2 => v.freq;
	while (true) {
		(1+v.last()/4.)*1.0=> s.rate;
		1::samp => now;
	}
}
		
spork~pitchy();

0 => pan.pan;

0::samp => dur jMin;
250::samp => dur iMax;
0::samp => dur jCount;
1::samp => dur jDelta;


0 => int i;
250 => int iiMax;
0 => int jjCount;

0 => s.pos;



while (true) {
	
	s.pos()+1 => s.pos;
	
	if (s.pos() == s.samples()) 0 => s.pos;
	
//	if (now%iMax > jCount ) 0.0 =>s.gain;// => g.gain;
	jCount+jDelta => jCount;
	if (jCount > iMax) jMin => jCount;
	i++;
	if (i%130 == 0 || i%201 ==0 || i% 737 == 0) 0 =>s.gain; // => g.gain;;
//	if (i%iiMax > jjCount ) 0.0 =>s.gain; //=> g.gain;
	jjCount++;
	if (jjCount > iiMax) 0 => jjCount;
	.1::ms => now;
	1 => s.gain; // => g.gain;
	
}

