// logistic equation simulator
//http://bendov.info/cours/chaos/logistic.htm
// x(t) = k*x(t-1)*(1-x(t-1))
//Values of k smaller than 3 give a constant value. 
//Then starts a period doubling with a second bifurcation at 3.5, 
//chaos shortly afterwards, and 3-step period around k=3.8 

TriOsc s => Envelope env => Gain gain => dac;

.1 => float x;
Std.mtof(60-24) => float maxFreq;
Std.mtof(60-36) => float minFreq;

3.7 => float k;

60./120*.25 => float beatSec;
beatSec::second => dur beat;

while (true) {
	
	k*x*(1-x) => x;
	minFreq+x*(maxFreq-minFreq) => s.freq;
	<<< "x, s.freq", x, s.freq() >>>;
	1 => env.keyOn;
	beat => now;
	1 => env.keyOff;
	beat => now;
}
	