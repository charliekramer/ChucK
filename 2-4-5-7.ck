.7 => float gainSet;
60::second => dur length;

4 => int n; // number of osc

56+12 => float midiBase;

4*.75::second => dur beat;

beat - (now % beat) => now;

Clarinet osc[n];
//Wurley osc[n];
Echo echo[n];
LPF filt[n];
Pan2 pan[n];

[0.,-2.,-4.,-5.,-7.,0.,2.,4.,5.,7.] @=> float notes[];

for (0 => int i; i < n; i++) {
    gainSet => osc[i].gain;
    osc[i] => filt[i] => echo[i] => pan[i] => dac;
    Std.rand2f(-1,1) => pan[i].pan;
    1.5*beat => echo[i].max => echo[i].delay;
    .7 => echo[i].gain;
    .7 => echo[i].mix;
    echo[i] => echo[i];
    Std.mtof(midiBase)*6. => filt[i].freq;
    2 => filt[i].Q;
    }
    
now + length => time future;

0 => int t;
int j;

while (now < future) {
    
    t % n => j;
    
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc[j].freq;
    
    1 => osc[j].noteOn;
    
    Std.rand2(1,8)*beat => now;
    1 => osc[j].noteOff;
    
    t++;
    }
 
 20::second => now;
