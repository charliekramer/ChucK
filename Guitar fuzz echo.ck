class Fuzz extends Chugen
{
	1.0/2.0 => float p;
	
	3 => intensity;
	
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

class Gate extends Chugen
{
	
	float t;
	
	.5 => t;
	
	fun float tick(float in)
	{
		if (Math.fabs(in) < t) return 0.0;
		else return in;
	}
	
	fun void threshold(float i)
	{
		i => t;
	}
}

class GrainSkipper extends Chugen 
{
	
	1 => int skipNum;
	
	fun void skip (int i)
	{
		i => skipNum;
	}
	
	fun float tick(float in)
	{
		if (now % skipNum::samp == 0::samp) return 0.0;
		else return in;
	}
	
}


adc => Gain inGain => Dyno dyn => HPF l =>  Fuzz fuzz => Gate gate => Echo echo => NRev rev=>  Fuzz fuzz2 => Chorus chorus => Gain outGain => Gain master => dac;
adc => Gain inGain2 =>  dyn => l =>  Echo echo2 =>  NRev rev2=>  Chorus chorus2 => Gain outGain2 => master => dac;


.05 => gate.threshold;

2 => fuzz.intensity;
0 => fuzz2.intensity;

25 => l.freq;
20 => l.Q;

0.01 => inGain.gain;
.7=>inGain2.gain;
0 => outGain.gain;
2 => outGain2.gain;

10::second => echo.max => echo2.max;

.75::second => echo.delay => echo2.delay;

.1 => echo.gain => echo2.gain;
.1 => echo.mix => echo2.mix;
echo => echo;
echo2 => echo2;

.1 => rev.mix => rev2.mix;



1::week => now;





