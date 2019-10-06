// fat osc bass

0.01 => float gainset;

60./80.*4 => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

SinOsc s[3] ; 
s[0] => LPF l  => Pan2 pan0 => dac;
s[1] => l => Pan2 pan1 => dac;
s[2] => l => Pan2 pan2 => dac;

-1. => pan1.pan;
1 => pan2.pan;



.2 => float diff;

2 => s[0].sync => s[1].sync => s[2].sync;

Std.mtof(59-12)=> s[0].freq;
s[0].freq() + diff => s[1].freq;
s[0].freq() - diff => s[2].freq;

s[0].freq()*15 => l.freq;

2 => float beatdiv;

while (true) {
    
    gainset => s[0].gain => s[1].gain => s[2].gain;
    beat/beatdiv => now;
    0.0 => s[0].gain => s[1].gain => s[2].gain;
    beat/beatdiv => now;
    
}

    




