// single piano note, at each sample or bunch of samples randomly modify rate
// from uniform distribution. add a copy whose rate is the same (per sample) 
// times a second distribution. 

SndBuf2 s =>  Gain g => dac;
SndBuf2 s2 => g =>dac;

.3 => g.gain;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => s.read;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => s2.read;

0 => s.pos;
0 => s2.pos;
//s2.samples()=> s2.pos;

1 => s.loop;
1 => s2.loop;

.5 => float mu; //center of distribution for rate of main sample
0.5 => float delta1; //width of distribution for rate of main sample (set by sin after first go)
0.5 => float delta2; // width of distribution for rate of secondary sample (relative to width of first)

SinOsc v => blackhole;

.1 => v.freq;
.1 => v.gain;


while (true) {
	
	1::samp => now; // default one samp; 100 sounds like explosion w/ v freq and gain at .1
//	Std.rand2f(-1,2) => s.rate; //doom
	Std.rand2f(mu-delta1,mu+delta1) => s.rate; 
	Std.rand2f(1-delta2,1+delta2)*s.rate()=>s2.rate;
	v.last()=>delta1;
	
}
