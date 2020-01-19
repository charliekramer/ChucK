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


Impulse imp => BPF filt => Echo echo1 => Fuzz fuzz => NRev rev => Echo echo => Gain gain => dac;

.1 => gain.gain;

.2 => rev.mix;
60./80.*4 => float beatSec;
beatSec::second => dur beat;
5*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

2*beat => echo1.max;
.5*beat*2/3 => echo1.delay;
.1 => echo1.mix;
.5 => echo1.gain;
echo1 => echo1;

25 => fuzz.intensity;//25

57 => float midiBase;
Std.mtof(midiBase) => float baseFreq => filt.freq; //110
1 => filt.Q; // randomly driven below

1.5 => float div1; //beat division/ share of 2 given to first beat

baseFreq*.1 => float minFreq; // for random shocks to filter
baseFreq*5 => float maxFreq; // for random shocks to filter
1.5 => float multiplier; // multiplier**(rand2(-1,1))*filter => filter

beat - (now % beat) => now;

now + 30::second => time future;

while (now < future) {
    
    1 => imp.next;
    beat*div1 => now;
    0 => imp.next;
    beat*(2-div1) => now;
    
    Std.rand2f(1,50) => filt.Q;
    Math.pow(multiplier,Std.rand2(-1,1))*filt.freq() => filt.freq;
    if (filt.freq() > maxFreq || filt.freq() < minFreq) baseFreq => filt.freq;
   
}

15*beat => now;