
.2 => float gainSet;
57-12+1 => float midiBase;
[0.,-.1,.1] @=> float notes[];
10 => float sigma;
.1 => float LFOfreq;
30::second => dur length;
15::second => dur outro;

.000125::second => dur beat;

Wurley osc => Echo echo => Pan2 pan => dac;

1.5*beat => echo.max => echo.delay;
.7 => echo.gain => echo.mix;
echo => echo;

SinOsc LFO => blackhole;
LFOfreq => LFO.freq;

0 => int i;

now + length => time future;

while (now < future) {
    
    Std.mtof(midiBase + sigma*LFO.last()*notes[ i % notes.size()]) => osc.freq;
    Std.rand2f(-.5,.5) => pan.pan;
    1 => osc.noteOn;
    beat => now;
    
    i++;
    
    }
    
outro => now;
