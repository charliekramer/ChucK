.1 => float gainSet;
PulseOsc osc => LPF filt => LPF filt2 => Echo echo => dac;

30::second => dur length;

44-12 => float midiBase;
Std.mtof(midiBase) => osc.freq;

SinOsc filtLFO => blackhole;
.2 => filtLFO.freq;

SinOsc widthLFO => blackhole;
.4 => widthLFO.freq;

10 => float a;

5 => filt.Q => filt2.Q;

2.5::second*2 => dur beat;
0 => osc.gain;
beat - (now % beat) => now;
gainSet => osc.gain;

beat*4 => echo.max;
beat*1.5/2 => echo.delay;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

spork~LFOWidth();

now + length => time future;

while (now < future) {
   
    spork~filtTrigger(a*(1.5 + filtLFO.last()));
    beat => now;
}

5*beat => now;

fun void filtTrigger(float a) {
    ADSR env => blackhole;
    (beat/2, 0::second, 1, beat/2) => env.set;
    
    1 => env.keyOn;
    now + beat/2 => time future;
    while (now < future) {
        env.value()*osc.freq()*a => filt.freq => filt2.freq;
        1::samp => now;
    }
    
    1 => env.keyOff;
    now + beat/2 =>  future;
    while (now < future) {
        env.value()*osc.freq()*a => filt.freq => filt2.freq;
        1::samp => now;
    }
    
} 

fun void LFOWidth() {
    while (true) {
        (1.1 +widthLFO.last())/2.1 => osc.width;
        1::samp => now;
    }
}