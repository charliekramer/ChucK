

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

SqrOsc s => ADSR env =>Fuzz fuzz => LPF bpf => Fuzz fuzz2 => Echo echo => NRev rev => Gain gain => dac;

.05 => gain.gain;


60./120. => float beatsec;

beatsec::second*4. => dur beat;

beat - (now % beat) => now;

0 => rev.mix;

beat*.75 => echo.delay;
.8 => echo.gain;
.5 => echo.mix;
echo => echo;

//ADSR env;

11*2 => float baseFreq;
baseFreq => s.freq => bpf.freq;
10 => bpf.Q;

// bpf sweep parameters
// baseFreq*(env()*a+b) => bpf.freq 
4 => float b; // multiplies envelope value
2 => float a; // adds to envelope value

1 => fuzz.intensity;
25 => fuzz2.intensity;

env.set(beat, .1::second, 1, beat);


while (true) {

now + beat => time future;

1 => env.keyOn;
while (now < future) {
	1::samp => now;
//	<<< env.value(), env.last() >>>;
	baseFreq*(env.value()*b+a) => bpf.freq;
}
	
1 => env.keyOff;

now + beat => future;

while (now < future) {
	1::samp => now;
//	<<< env.value(), env.last() >>>;
	baseFreq*(env.value()*b+a) => bpf.freq;
}

}
