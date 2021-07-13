
.1 => float gainSet;

30::second => dur length;

12 => int n;

57 => float midiBase;
.01 => float pitchDelta;

.7 => float revMix;

5::second => dur beat;

ModalBar bar[n];

Pan2 pan[n];
Envelope env[n];
Echo echo[n];
NRev rev[n];

[3,5,6,0,2,4,1] @=> int presets[];

0 => int t; // preset selector

for (0 => int i; i < n; i++) {
    
    presets[t] => bar[i].preset; //3,5,6,0,2,4,1
    
    gainSet => bar[i].gain;
    
    Std.mtof(midiBase)*Std.rand2f(1-pitchDelta,1+pitchDelta) => bar[i].freq;
    
    beat => echo[i].max;
    Std.rand2f(.1,.25)*beat => echo[i].delay;
    .7 => echo[i].gain;
    .7 => echo[i].mix;
    echo[i] => echo[i];
    
    revMix => rev[i].mix;
    
    Std.rand2f(-1,1) => pan[i].pan;
    
    bar[i] => echo[i] => rev[i] => env[i] => pan[i] => dac;
    
    Std.rand2f(.1,.5)*beat => env[i].duration;
    
    }
    
    int nDraws,j;
    
    now + length => time future;
    
    while (now < future) {
        
        Std.rand2(1,n) => nDraws;
        
        for (0 => int i; i<nDraws; i++) {
            Std.rand2(0,n-1) => j;
            1 => bar[j].noteOn;
            1 => env[j].keyOn;
        }
        beat => now;
        for (0 => int i; i<n; i++) {
            1 => env[i].keyOff;
        }
        beat => now;
        }