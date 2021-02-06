// run two instances with n > 1 and very short beat for cool grindy interference

.1 => float gainSet;
30::second => dur length;
0 => int invert; // fall instead of rise
59*.7*.7 => float midiBase;
20::ms => dur beat;
1. => float scale;//scale all saw freqs


5 => int n;
SawOsc saws[n];

PulseOsc osc => PitShift pitch => Gain gain => dac;
gainSet => osc.gain;
1 => pitch.mix;
Std.mtof(midiBase) => osc.freq;

gain => Echo echo => Pan2 pan => dac;

5::second => echo.max;
1.5::second => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

SinOsc widthLFO => blackhole;
SinOsc panLFO => blackhole;

.05 => widthLFO.freq;
.125 => panLFO.freq;



[.1,.2,.3,.4,.5] @=> float freqs[];
//[.5] @=> float freqs[];



for (0 => int i; i < n ; i++) {
    saws[i] => blackhole;
    freqs[i]*scale => saws[i].freq;
}

float p;


now + length => time future;

while (now < future) {
    0. => p;
    for (0 => int i; i < n ; i++) {
        p+ (saws[i].last()+1.1)/(1.0*n)  => p;
    }
    (1 + widthLFO.last())*.5 => osc.width;
    panLFO.last() => pan.pan;
    if (invert == 1) 2.1 - p => p;
    p => pitch.shift;
    beat => now;
}

0 => gain.gain;
    
10::second => now;
    

