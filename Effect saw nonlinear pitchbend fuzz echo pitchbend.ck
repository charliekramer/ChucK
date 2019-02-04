
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


// nonlinear pitch bend
// based on bass and blowbotl fuzz echo shreds

SawOsc botl =>  Envelope env => PitShift pitch => Echo echo => Fuzz fuzz =>  PRCRev rev => Gain gain => Gain master => Pan2 pan => dac;
SawOsc st2 => env => Gain gain2 => master => dac;

.2 => master.gain;
.2 => gain.gain;
.0 => gain2.gain; 

2 => fuzz.intensity;

8 => float divisor; // smaller=>faster. .125, 2, 4, 8

4 => int func; // 1 = multiplicative, 2 = additive, 3 = divided, 4 = sqrt

60 => int midiBase;

[0,0,0,1,1,11,11,12,12,12] @=> int notes[];

60./120. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat ) => now;

10*beat => echo.max;
beat*1.5*2 => echo.delay;
.4 => echo.gain;
.5 => echo.mix;
echo => echo;

.1 => rev.mix;

//1 => bpf.Q;

spork~panner(.1,.2);

1 => pitch.mix;
spork~pitchCycle(.035,.5,1::ms);

while (true) {
	Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => botl.freq;
	botl.freq() => st2.freq;
//	botl.freq()*Std.rand2f(20,30) => bpf.freq;
	1 => env.keyOn;
	divisor*beat => now;
	1 => env.keyOff;
	divisor*beat => now;
}

fun void panner (float rate, float gain) {
	
	SinOsc s => blackhole;
	rate => s.freq;
	gain => s.gain;
	while (true) {
		s.last() => pan.pan;
		1::ms => now;
	}
}

fun void pitchCycle (float rate, float gain, dur pitchTime) {
	
	SinOsc t => blackhole;
	SqrOsc u => blackhole;
	TriOsc v => blackhole;
	gain => t.gain;
	rate => t.freq;
	rate*200 => u.freq;
	rate*310 => v.freq;
	while (true) {
		if (func == 1) (1+v.last())*(1+u.last())*(1+t.last())/3 => pitch.shift;
		if (func == 2) (1+v.last()+u.last()+t.last())/3 => pitch.shift;
		if (func == 3) 1/(1+v.last()+u.last()+t.last())/3 => pitch.shift;
		if (func == 4) Math.sqrt((1+v.last()*u.last()*t.last()))/3 => pitch.shift;
		pitchTime => now;
	}
}

