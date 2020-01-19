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

.1 => float gainSet;

SqrOsc noise => BPF filt => Envelope env => Fuzz fuzz => Chorus chorus => Echo echo => Gain gain => dac;
SinOsc LFO0 => blackhole;
.2 => LFO0.freq;

500 => noise.freq;
500 => filt.freq;
20 => filt.Q;

2::second => dur beat;

5*beat => echo.max;
1.75::second => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

gainSet => gain.gain;

25 => fuzz.intensity;

100 => chorus.modFreq;
.25 => chorus.modDepth;

spork~modFreq();

<<< chorus.mix(), chorus.modFreq(), chorus.modDepth() >>>;

now + 2.5::minute => time future;

while (now < future) {
    
    1 => env.keyOn;
    Std.rand2f(.5,5)*beat => now;
    
    1 => env.keyOff;
    Std.rand2f(.5,5)*beat => now;
    
    Std.rand2f(.25,2.5)*beat => echo.delay;
    Std.rand2f(50,750) => filt.freq => noise.freq;
    Std.rand2f(5,50) => filt.Q;
}

30::second => now;

fun void modFreq() {
    while (true) {
        10.1 + 10*LFO0.last() => chorus.modFreq;
        1::samp => now;
    }
}