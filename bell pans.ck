.2 => float gainSet;
70 => float midiBase;
2*30::second => dur length;
30::second => dur outro;

[-12,-5,-7, 0,4,5,7,12] @=> int notes[];

6 => int n;

2.5::second => dur beat;

float k;
TubeBell osc;
Pan2 pan[n];
SinOsc LFO[n];
SinOsc pitchLFO[n];
PitShift pitch[n];
NRev rev[n];
Echo echo[n];

Std.mtof(midiBase) => osc.freq;

for (0 => int i; i < n ; i++) {
    LFO[i] => blackhole;
    pitchLFO[i] => blackhole;
    .5 => rev[i].mix;
    gainSet => osc.gain;
    osc => rev[i] =>  pitch[i] => echo[i] => pan[i] => dac;
    1 => pitch[i].mix;
    2.*i/(n-1.) -1. => pan[i].pan;
    
    5*beat => echo[i].max;
    Std.rand2f(.75,3)*beat => echo[i].delay;
    .5 => echo[i].gain;
    .7 => echo[i].mix;
    echo[i] => echo[i];
    
    }
    
spork~LFO_spork();
 
now + length => time future;
    
while (now < future) {
    1 => osc.noteOn;
    Std.rand2(1,8)*.25*beat => now;
    Std.rand2f(.01,.025) => k;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc.freq;
    
    }

outro => now;

fun void LFO_spork() {
    for (0 => int i; i < n; i++) {
        Std.rand2f(.5,2) => LFO[i].freq;
        Std.rand2f(.5,2) => pitchLFO[i].freq;
    }
    while (true) {
        for (0 => int i; i < n; i++) {
            (1+LFO[i].last())*.5 => pan[i].gain;
            (1+pitchLFO[i].last()*k) => pitch[i].shift;
        } 
        1::samp => now;
    }
    
}
