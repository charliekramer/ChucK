// fat osc bass

60./154. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

SinOsc s[3] ;
s[0] => LPF l  => Pan2 pan0 => dac;
s[1] => l => Pan2 pan1 => dac;
s[2] => l => Pan2 pan2 => dac;

-1. => pan1.pan;
1 => pan2.pan;

0.2 => float gainset;

.05 => float diff;

220/4=> s[0].freq;
s[0].freq() + diff => s[1].freq;
s[1].freq() + diff => s[2].freq;

s[0].freq()*5 => l.freq;

2 => float beatdiv;

while (true) {
    
    gainset => s[0].gain => s[1].gain => s[2].gain;
    beat/beatdiv => now;
    0.0 => s[0].gain => s[1].gain => s[2].gain;
    beat/beatdiv => now;
    
}

    




