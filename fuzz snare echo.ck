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

.3 => float gainSet;

3::minute => dur length;

[.125,.25,.5,1.,2.] @=> float rates[];
1. => float rate;
.2 => float pValRate; //prob of rate reset

[.125,.25,.5,1.,2.] @=> float divs[];

1. => float div;
.2 => float pValDiv; // prob of beat div reset

SndBuf snare  => Fuzz fuzz => Echo echo => NRev rev => Gain g =>Dyno dyn => dac.left;

25 => fuzz.intensity;

g => Echo echoRev => NRev rev2 => Dyno dyn2 => dac.right;

gainSet => dyn.gain;
gainSet => dyn2.gain;

"/Users/charleskramer/Desktop/chuck/audio/snare_01.wav" => snare.read;

2.5::second => dur beat;

4*beat => echo.max => echoRev.max;
1.2*beat => echo.delay;
2.3*beat => echoRev.delay;
1 => echoRev.mix;
1 => echoRev.gain;
.7 => echo.mix;
.7 => echo.gain;

now + length => time future;

while (now < future) {
    
    0 => snare.pos;
    div*beat => now;
    
    if (Std.rand2f(0,1) > (1-pValDiv)) {
        divs[Std.rand2(0,divs.cap()-1)] => div;
        <<< "beat reset">>>;
    }
    
    if (Std.rand2f(0,1) > (1-pValRate)) {
        rates[Std.rand2(0,rates.cap()-1)] => rate;
        <<< "rate reset">>>;
    }
    rate => snare.rate;
       
}

20::second => now;