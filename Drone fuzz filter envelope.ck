

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

SqrOsc s => ADSR env =>Fuzz fuzz => LPF bpf => LPF bpf2 => Fuzz fuzz2 => Echo echo => NRev rev => Gain gain => dac;

.01 => gain.gain;

60./80. => float beatsec; // *.01 = cool

beatsec::second*4. => dur beat;

beat - (now % beat) => now;

0 => rev.mix;

beat*.75 => echo.delay;
.8 => echo.gain;
.5 => echo.mix;
echo => echo;

//ADSR env;

Std.mtof(59-24) => float baseFreq;
baseFreq => s.freq => bpf.freq => bpf2.freq;
10 => bpf.Q;
2 => bpf2.Q; // put at 1 for less musical sound

// bpf sweep parameters
// baseFreq*(env()*a+b) => bpf.freq 
20 => float b; // multiplies envelope value
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
	baseFreq*(env.value()*b+a) => bpf.freq => bpf2.freq;
}
	
1 => env.keyOff;

now + beat => future;

while (now < future) {
	1::samp => now;
//	<<< env.value(), env.last() >>>;
	baseFreq*(env.value()*b+a) => bpf.freq => bpf2.freq;
}

}
