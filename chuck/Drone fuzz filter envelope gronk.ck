

class Fuzz extends Chugen
{
	1.0/2.0 => float p;
	
	2 => intensity;
	
	fun float tick(float in)
	{
		Math.sgn(in) => float sgn;
		return Math.pow(Math.fabs(in), p) * sgn;
	}
	
	fun void intensity(float i)
	{
		if(i > 1)
			1.0/i => p;
	}
}

SawOsc s =>Fuzz fuzz => LPF bpf => Fuzz fuzz2 => Echo echo => NRev rev => Gain gain => dac;
SawOsc t =>  fuzz => BPF bpf2 => fuzz2 => echo => rev => gain => dac;
ADSR env => blackhole;

.004 => gain.gain;

60./120. => float beatsec;

beatsec::second*4. => dur beat;
beat - (now % beat) => now;
1 => float nBeat1; // number of beats for envelope A 
2 => float nBeat2; // number of beats for envelope R
0.2 => rev.mix;

10::second => echo.max;
beat*.75 => echo.delay;
.3 => echo.gain;
.2 => echo.mix;
echo => echo;

//ADSR env;

55*1.5*1.5 => float baseFreq;
baseFreq*1.5 => float baseFreq2;
baseFreq => s.freq => bpf.freq ;
baseFreq2=> t.freq => bpf2.freq;
10 => bpf.Q;
10 => bpf2.Q;

// bpf sweep parameters
// baseFreq*(env()*a+b) => bpf.freq 
4 => float b; // multiplies envelope value (original 4)
2 => float a; // adds to envelope value (original 2)

1 => fuzz.intensity;
25 => fuzz2.intensity;

env.set(nBeat1*beat, 2::second, .5, nBeat2*beat);


while (true) {

now + nBeat1*beat => time future;

1 => env.keyOn;
<<< "rising" >>>;

	baseFreq*(env.value()*b+a) => bpf.freq;
	baseFreq*(env.value()*b+a) => s.freq; 
    baseFreq2*(env.value()*b+a) => t.freq; 
	baseFreq2*(env.value()*b+a) => bpf2.freq;
	<<< s.freq(), t.freq(), bpf.freq(), bpf2.freq() >>> ;
		
		1 => env.keyOff;
		
		now + nBeat2*beat => future;
		<<< " fallling" >>>;
			<<< s.freq(), t.freq(), bpf.freq(), bpf2.freq() >>> ;

		20 => float bpfFreq;
		bpfFreq => bpf.freq; 
		2. => float freqMult;	// make this 3, 5, 10, 2.
		
		while (now < future) {
			100::ms => now;
			bpf.freq()*freqMult => bpf.freq;
			if (bpf.freq() > 2000 || bpf.freq() < 20) 1./freqMult => freqMult;
			// multiply by 10 for interesting
			}

}
