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

Noise noise => BPF BPfilt => LPF LPfilt => NRev rev =>  Gain gain =>  Pan2 pan1 => dac;
gain => Echo echo => Pan2 pan2 => dac;
echo => Fuzz fuzz => dac;

.05 => fuzz.gain;
25 => fuzz.intensity;

-1 => pan1.pan;
1 => pan2.pan;

100::ms => echo.max;
10::ms => echo.delay;
.5 => echo.mix;
.7 => echo.gain;
echo => echo;

[10::ms, 20::ms, 19::ms, 25::ms, 23::ms] @=> dur echoDur[];
[.7,     .7,     .7,     .7,     .7  ] @=> float echoGain[];

.2 => rev.mix;

5 => BPfilt.Q;
2 => LPfilt.Q;
220 => float baseFreq;

5::second => dur length;

now + length => time future;


for (0 => int i; i < echoDur.cap(); i++) {
    echoDur[i] => echo.delay;
    echoGain[i] => echo.gain;
    while (now < future) {
        Std.rand2f(.5,1)*baseFreq => BPfilt.freq;
        BPfilt.freq()*2 => LPfilt.freq;
        .01::second*Std.rand2f(.5,2) => now;
    }
    now + length =>  future;
}

0 => noise.gain;
15::second => now;
    