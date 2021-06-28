.2 => float gainSet;
51 => float midiBase;
5 => int n;

15::second => dur runLen;
20*60::second => dur length;
30::second => dur outro;
4::second => dur keyLen;

.25 => float minSec;
2.5*5 => float maxSec;

1 => int randNotes; // choose notes randomly in which case notes.cap() can be > n

SqrOsc sqrs[n];
Rhodey rhodes[n];
Chorus chorus[n];
Pan2 pan[n];
Echo echo[n];
NRev rev[n];
Envelope env[n];

[0.,2.,4.,5.,7,9.,11.,12.,14.,-12.,-7.,-5] @=> float notes[];

for (0 => int i; i < n; i++) {
    gainSet=>rhodes[i].gain;
    Std.mtof(midiBase+notes[i]) => rhodes[i].freq;
    .3 => chorus[i].mix;
    .2 => chorus[i].modDepth;
    .2 => rev[i].mix;
    if (randNotes==1)  Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => rhodes[i].freq; 
    rhodes[i] => echo[i] => env[i] => chorus[i] => rev[i] => pan[i] => dac;
    sqrs[i] => blackhole;
    maxSec::second => echo[i].max;
    
    keyLen => env[i].duration;
    1 => env[i].keyOff;
    
    Std.rand2f(minSec,maxSec)::second => echo[i].delay;
    .7 => echo[i].gain;
    .7 => echo[i].mix;
    echo[i] => echo[i];
    Std.rand2f(-1,1) => pan[i].pan;
    Std.rand2f(.5,5) => sqrs[i].freq;
    .125*sqrs[i].freq() => chorus[i].modFreq;
    }
    

keyOn();

now + length => time end;
while (now < end) {
    now + runLen => time run;
    while (now < run) {
        for (0 => int i; i < n; i++) {
            (1+sqrs[i].last())*.5 => rhodes[i].noteOn;
        }
        
        1::samp => now;
        
    }
    keyOff();
    keyLen => now;
    reset();
    keyOn();
    keyLen => now;
}

outro => now;

fun void reset() {
    <<< " reset" >>>;
    for (0 => int i; i < n; i++) {
        Std.rand2f(minSec,maxSec)::second => echo[i].delay;
        if (randNotes==1)  Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => rhodes[i].freq; 
        Std.rand2f(-1,1) => pan[i].pan;
        Std.rand2f(.5,5) => sqrs[i].freq;
    }
}

fun void keyOff() {
    for (0 => int i; i < n; i++) {
        1 => env[i].keyOff;
        }
    
}

fun void keyOn() {
    for (0 => int i; i < n; i++) {
        1 => env[i].keyOn;
    }
    
}
