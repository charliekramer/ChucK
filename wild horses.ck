
.5 => float gainSet;

30::second => dur length;

.5 => float echoFrac; // echo = random(1,10)*echofrac; controls pacing of echoes

57-12 => int midiBase;
[[4,7,11],
[0,4,7],
[-2,2,5]] @=> int notes[][];

4::second => dur beat;

beat - (now % beat) => now;

for (1 => int j; j < 4; j++) {
    spork~notesGo(0,j,0);
    .5*beat => now;
    
    spork~notesGo(1,j,0);
    .5*beat => now;
    
    spork~notesGo(2,j,0);
    1*beat => now;
}

now + length => time future;

while (now < future) {
    spork~notesGo(0,Std.rand2(1,3),1);
    .5*beat => now;
    
    spork~notesGo(1,Std.rand2(1,3),1);
    .5*beat => now;
    
   spork~notesGo(2,Std.rand2(1,3),1);
    1*beat => now;
}  

2*beat => now;

fun void notesGo(int chord, int n, int rand) {
 StifKarp osc[n];
 Echo echo[n];
 Pan2 pan[n];
 for (0 => int i; i < n; i++) {
     
     Std.rand2f(.49,.51) => osc[i].stretch;
     Std.rand2f(.25,.75) => osc[i].pickupPosition;
     
     osc[i] => echo[i] => pan[i] => dac;
     gainSet => osc[i].gain;
     
     10*beat => echo[i].max;
     Std.rand2(1,10)*echoFrac*beat => echo[i].delay;
     .5 => echo[i].mix;
     .5 => echo[i].gain;
     echo[i] => echo[i];
     
     Std.rand2f(-.5,.5) => pan[i].pan;
     
     Std.mtof(midiBase + notes[chord][i]) => osc[i].freq;
     1 => osc[i].noteOn;
     if (rand == 1) Std.rand2f(0,1) => osc[i].noteOn;
 }   
 
    2*beat => now;
}