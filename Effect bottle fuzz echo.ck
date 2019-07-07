
// bottle thru fuzz with small scale

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


// pitch after echo
BlowBotl botl => Fuzz fuzz => BPF bpf => Echo echo =>  PitShift pitch => PRCRev rev => Gain gain => Pan2 pan => dac;
// pitch before echo 
//BlowBotl botl => Fuzz fuzz => BPF bpf => PitShift pitch => Echo echo =>  PRCRev rev => Gain gain => Pan2 pan => dac;

2 => fuzz.intensity;

.5 => gain.gain;


55 => int midiBase;

[0,0,0,1,1,11,11,12,12,12] @=> int notes[];

60./94. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat ) => now;

10*beat => echo.max;
beat*1.5*2 => echo.delay;
.4 => echo.gain;
.5 => echo.mix;
echo => echo;

.3 => rev.mix;

10 => bpf.Q;

spork~panner(.1);

1 => pitch.mix;
spork~pitchCycle(.035,.5);

while (true) {
	Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => botl.freq;
	botl.freq()*Std.rand2f(.9,2.5) => bpf.freq;
	1 => botl.noteOn;
	1*beat => now;
	1 => botl.noteOff;
	7*beat => now;
}

fun void panner (float rate) {
	
	SinOsc s => blackhole;
	rate => s.freq;
	while (true) {
		s.last() => pan.pan;
		1::ms => now;
	}
}

fun void pitchCycle (float rate, float gain) {
	
	SinOsc t => blackhole;
	gain => t.gain;
	rate => t.freq;
	while (true) {
		(1+t.last())/2 => pitch.shift;
		1::ms => now;
	}
}

