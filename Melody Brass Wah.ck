.5 => float gainSet;

60::second => dur length;

Brass brass => BPF filt => Echo echo => dac;
//brass => dac;

1 => brass.startBlowing;

2 => filt.Q;

gainSet => brass.gain;

59+12+7+1 => float midiBase;
Std.mtof(midiBase) => brass.freq => filt.freq;

SinOsc filtLFO => blackhole;

.2 => filtLFO.gain;
2.5 => filtLFO.freq;
.9 => float cutoffFilt; // resets gain and freq of filtLFO

60./90.*4 => float beatSec;
beatSec::second => dur beat;

4.1*beat => echo.max;
1.5*beat => echo.delay;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;
.9 => float cutoffEcho;


spork~wah();

now + length => time future;

while (now < future) {
    1 => brass.startBlowing;
    Std.rand2(1,4)*beat => now;
    1 => brass.stopBlowing;
    randBrass();
    Std.rand2(1,4)*beat => now;
    if (Std.rand2f(0.,1.) > cutoffFilt) {
        <<< "filtLFO reset" >>>;
        Std.rand2f(.1,10) => filtLFO.freq;
        Std.rand2f(.1,.7) => filtLFO.gain;
    }
    if (Std.rand2f(0.,1.) > cutoffEcho) {
        <<< "echo reset" >>>;
        Std.rand2f(.2,4)*beat => echo.delay;
        }
}

8*beat => now;


fun void wah() {
    while (true) {
        (1+filtLFO.last())*brass.freq() => filt.freq;
        1::samp => now;
    }
}


fun void randBrass() {
    Std.rand2f(.5,.6) => brass.lip;
    Std.rand2f(0.,.4) => brass.rate;
    Std.rand2f(0.,.1) => brass.slide;
    Std.rand2f(0.,2.) => brass.vibratoFreq;
    Std.rand2f(0.,.5) => brass.vibratoGain;
   
}