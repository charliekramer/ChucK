
0.2 => float gainSet;

67-12-12 => float midiBase;

.25::second*8 => dur beat;

60::second => dur length;

[[0.,2.,4.,5.],

[0.,4.,5.,7.], 

[0.,7.,9.,12.],

[0.,9.,11.,12.],

[0.,11.,12.,14.], 

[0.,2.,4.,5.]] @=> float notes[][];

for (0 => int i; i < 6; i++) {
    for (0 => int j; j < 4; j++) {
        <<< notes[i][j] >>>;
    }
}

4 => int nOsc;
Wurley osc[nOsc];
Echo echo[nOsc];
NRev rev[nOsc] ;
Pan2 pan[nOsc];

for (0 => int i; i < nOsc; i++) {
    osc[i] => echo[i] => rev[i] =>pan[i] => dac;
    gainSet => osc[i].gain;
    4* beat => echo[i].max;
    1.5*beat => echo[i].delay;
    .7 => echo[i].mix => echo[i].gain;
    echo[i] => echo[i];
    .2 => rev[i].mix;
    Std.rand2f(-1,1) => pan[i].pan;
    }
    
int i,j;
    
4 => int nBeat;

now + length => time future;

while (now < future) {
 Std.rand2(0,5) => j;
 Std.rand2(0,3) => i;
 spork~play(j,i);
 Std.rand2(0,5) => j;
 Std.rand2(0,3) => i;
 spork~play(j,i);
 Std.rand2(0,5) => j;
 Std.rand2(0,3) => i;
 spork~play(j,i);
 9*beat => now;
    
}
 
 10*beat => now;
    
fun void play(int j, int i) {
    
    Std.rand2(0,2)*beat => now;
    
    for (0 => int k; k < nBeat; k++) {
        
        Std.mtof(midiBase+notes[j][Std.rand2(0,3)]) => osc[i].freq;
        1 => osc[i].noteOn;
        beat => now;
    }
    5*beat => now;

        
}