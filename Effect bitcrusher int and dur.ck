SinOsc s => Chorus c => Echo echo => Gain g => Pan2 pan => dac;

.1 => float gainSet;

120 => float length; // length in seconds

gainSet => s.gain;

.5 => c.modFreq;
.5 => c.modDepth;
.5 => c.mix;

10::second => echo.max;
.75::second => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

Std.mtof(59) => float baseFreq => s.freq;

fun void pitchy() {
	SinOsc v => blackhole;
	.2 => v.freq;
	while (true) {
		(1+v.last()/4.)*baseFreq => s.freq;
		1::samp => now;
	}
}

fun void panner(float gain) {
	SinOsc w => blackhole;
	.2 => w.freq;
	while (true) {
		w.last()*gain=> pan.pan;
		1::samp => now;
	}
}

fun void chopper(float gain, float freq) {
	SqrOsc u => blackhole;
	freq => u.freq;
	while (true) {
		(1+u.last())*gain=> g.gain;
		1::samp => now;
	}
}
	
		
spork~pitchy();
spork~panner(1);
//spork~chopper(1.,2.);

0 => pan.pan;

0::samp => dur jMin;
250::samp => dur iMax;
0::samp => dur jCount;
1::samp => dur jDelta;


0 => int i;
250 => int iiMax;
0 => int jjCount;

now + length::second => time future;

while (now < future) {
	
	Std.rand2f(.8,1.5)*baseFreq => s.freq;
	
	if (now%iMax > jCount ) 0.0 =>s.gain;// => g.gain;
	jCount+jDelta => jCount;
	if (jCount > iMax) jMin => jCount;
	i++;
	if (i%130 == 0 || i%201 ==0 || i% 737 == 0) 0 =>s.gain; // => g.gain;;
	if (i%iiMax > jjCount ) 0.0 =>s.gain; //=> g.gain;
	jjCount++;
	if (jjCount > iiMax) 0 => jjCount;
	.1::ms => now;
	gainSet => s.gain; // => g.gain;
	
}

<<< "bitcrusher ending" >>>;

0 => s.gain;

5::second => now;
