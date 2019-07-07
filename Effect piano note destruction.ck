// single piano note, at each sample or bunch of samples randomly modify rate
// from uniform distribution. add a copy whose rate is the same (per sample) 
// times a second distribution. 
// updated to include rate = MA(3) and sin+noise options
// 

.1 => float gainSet;

SndBuf2 s => PitShift pitch => Echo echo => PRCRev rev => Gain g => dac;
SndBuf2 s2 => echo => rev => g =>dac;

1 => pitch.shift;
0 => pitch.mix;

.0 => rev.mix;

60./94.*2 => float beatSec;
beatSec::second => dur beat;

10*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.gain;
.0 => echo.mix;
echo => echo;

gainSet => g.gain;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => s.read;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => s2.read;

0 => s.pos;
0 => s2.pos;
//s2.samples()=> s2.pos;

1 => s.loop;
1 => s2.loop;

.75 => float mu; //center of distribution for rate of main sample
0.7 => float delta1; //width of distribution for rate of main sample (set by sin after first go)
0.7 => float delta2; // width of distribution for rate of secondary sample (relative to width of first)

SinOsc v => blackhole; // v modulates mu

.1 => v.freq;
.5 => v.gain;

1::samp => dur increment;


while (false) { // true = unsmoothed version
	
	increment => now; // default one samp; 100 sounds like explosion w/ v freq and gain at .1
	//	Std.rand2f(-1,2) => s.rate; //doom
	Std.rand2f(mu-delta1,mu+delta1) => s.rate; 
	Std.rand2f(1-delta2,1+delta2)*s.rate()=>s2.rate;
	v.last()=>delta1;
	
}



1. => float srate_1 => float srate_2 => float srate_3;

while (false) { // true = smoothed MA(3)
	
	1*increment => now; // default one samp; 100 sounds like explosion w/ v freq and gain at .1
//	Std.rand2f(-1,2) => s.rate; //doom

	srate_2 => srate_3;
	srate_1 => srate_2;
	s.rate() => srate_1;
	(Std.rand2f(mu-delta1,mu+delta1)+srate_1+srate_2+srate_3)/4 => s.rate; 
	Std.rand2f(1-delta2,1+delta2)*s.rate()=>s2.rate;
	v.last()=>delta1;
	
}

SinOsc u => blackhole; // rate is random shock plus u;

.5 => u.freq;
.2 => u.gain;


while (false) { // rate = sin + noise
	
	increment => now; // default one samp; 100 sounds like explosion w/ v freq and gain at .1
	//	Std.rand2f(-1,2) => s.rate; //doom
	
	Std.rand2f(mu-delta1,mu+delta1)+u.last() => s.rate; 
	Std.rand2f(1-delta2,1+delta2)*s.rate()=>s2.rate;
	v.last()=>delta1;
	
}


1=> int n; // skip size

0 => s2.gain;

while (false) { // bitskipper (forward and backward)
	
	s.pos()+n => s.pos;
	1::samp => now;
}

3 => int nreps;
1. => pitch.mix;
0=>s2.gain;
//Math.log(nreps+1) => pitch.shift;
1::samp => increment;

while (false) { // bit repeater
	
	for (0 => int i; i< nreps; i++) {
		s.pos()-Std.rand2(1,1) => s.pos; // make second number larger
		1*increment => now;
	}
	
	1*increment => now;
}

1.0005 => float gamma1;
gamma1 => float gamma;
.9 => s.rate;

1=> s2.gain;

while (true) { // warped chorusy thing

	
	10::ms => now;
	s.rate()*gamma => s.rate;
	if (s.rate() > 1.03) 1./gamma1 => gamma;
	if (s.rate()<.97) gamma1=> gamma;
}





	
	

