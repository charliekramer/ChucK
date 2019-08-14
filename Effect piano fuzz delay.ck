
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

.5 => float gainSet;
.95 => float fadeRate; // multiplies gain each iteration; 1 gets very loud

SndBuf2 buf => Echo echo1 => Dyno dyn => Echo echo2 => Gain gain => dac;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;

buf.samples() => buf.pos;
1 => buf.rate;
1 => buf.loop;

buf.samples()/2*0 => int startBuf; // starting place for buffer play

gainSet => gain.gain;

SinOsc rateLFO => blackhole;

.33 => rateLFO.freq;
0 => float rateA;
.7 => float rateB; 
//	rateA+rateB*rateLFO.last() => buf.rate;

20::second => dur playLength;

5::second => echo1.max;
4.5::second => echo1.delay;
.3 => echo1.gain;
.5 => echo1.mix;

echo1 => Fuzz fuzz => echo1;

.5 => fuzz.intensity;

5::second => echo2.max;
4.25::second => echo2.delay;
.3 => echo2.gain;
.5 => echo2.mix;

echo2  => echo2;

startBuf => buf.pos;

now + 60::second => time future;

while (now < future) {
	
	playLength => now;
	rateA+rateB*rateLFO.last() => buf.rate;
	gain.gain()*fadeRate => gain.gain;
	
}

buf.samples() => buf.pos;

now + 60::second =>  future;

while (now < future) {
	
	1::second => now;
	rateA+rateB*rateLFO.last() => buf.rate;
	gain.gain()*fadeRate => gain.gain;
	
}

20::second => now;