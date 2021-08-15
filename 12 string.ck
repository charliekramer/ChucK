
.2 => float gainSet;

30::second => dur length;

57-12-12 => float midiBase;
4::second => dur beat;
12 => int n;
2 => int beatMod; // gargles for large n and beatMod
.01 => float spread;

beat - (now % beat) => now;

[0.,5.,7.,12.,-7.,-5.,-12] @=> float notes[];

0 => int j;

now + length => time future;

while (now < future) {

j++;

spork~goNote(midiBase+notes[Std.rand2(0,notes.cap()-1)],beat,n,spread);

.25*beat => now;

if (j % beatMod == 0) .25*beat => now;

}

beat => now;




fun void goNote(float note, dur beat, int n, float spread) {
    
    
    StifKarp osc[n];
    Pan2 pan[n];
    ADSR env;
    
    (10::ms, 1::ms,1, beat) => env.set;
    
    for (0 => int i; i < n; i++) {
        osc[i] =>  env => pan[i] => dac;
        gainSet => osc[i].gain;
        Std.mtof(note)*Std.rand2f(1-spread,1+spread) => osc[i].freq;
        Std.rand2f(-1,1) => pan[i].pan;
        1 => osc[i].noteOn;
        }
    1 => env.keyOn;
    1::ms => now;
    1 => env.keyOff;
    beat => now;
    
    
    }