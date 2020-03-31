.3 => float gainSet;

TriOsc saw => Echo echo => ADSR env => dac;

1.5::minute => dur length;

20::second => echo.max;
15::second => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

gainSet => saw.gain;

60-24 => float midiBase;

float f1, f2;

1 => float gain1;
35 => float freq1;
1 => float gain2;
77 => float freq2;


spork~fun1(gain1,freq1);

spork~fun2(gain2,freq2);

Std.rand2f(0.,1) => float a;

spork~aRand(.9,1::second);

now + length => time future;

(500::ms,10::ms,1.0,20::second) => env.set;
1 => env.keyOn;

while (now < future) {
    Std.mtof(midiBase+a*f1+(1-a)*f2) => saw.freq;
    
    1::samp => now;
}

1 => env.keyOff;
20::second => now;

fun void aRand(float pval, dur testTime) {
    while (true) {
        if (Std.rand2f(0,1) > pval) {
            Std.rand2f(0,1) => a;
        }
        testTime => now;
    }
}

fun void fun1(float _gain, float _freq) {
    SinOsc sin => blackhole;
    TriOsc tri => blackhole;
    _freq => sin.freq => tri.freq;
    _gain => sin.gain => tri.gain;
    while (true) {
        sin.last()+tri.last() => f1;
        1::samp => now;
    }
}

fun void fun2(float _gain, float _freq) {
    SqrOsc sqr => blackhole;
    TriOsc tri => blackhole;
    _freq => sqr.freq => tri.freq;
    _gain => sqr.gain => tri.gain;
    while (true) {
        sqr.last()+tri.last() => f2;
        1::samp => now;
    }
}

        
        