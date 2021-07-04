// could make this into a drum machine with each
// matrix entry a different drum sound
.5 => float gainSet;
.2 => float revMixStraight;
.5 => float revMixEcho;

1::second => dur beat;
30::second => dur length;
15::second => dur outro;
43+12 => float midiBase;
3 => int beatPow; // beat divided by 2^rand(0,beatPow); 3
-5 => int dMin; // min and max of i, j delta distribution
3 => int dMax;

beat - (now % beat) => now;

BandedWG osc[2];
Echo echo[2];
Pan2 pan[4];
Gain gain[2];
NRev rev[4];

.25 => pan[0].pan;
-.25 => pan[1].pan;
-5. => pan[2].pan;
.5 => pan[3].pan;



for (0 => int i; i<2; i++) {
    gainSet => osc[i].gain;
    osc[i] => gain[i] => rev[i] => pan[i]=> dac;
    gain[i] => echo[i] => rev[i+2] => pan[i+2] =>dac;
    1.5*beat => echo[i].max => echo[i].delay;
    .5 => echo[i].gain;
    1 => echo[i].mix;
    echo[i] => echo[i];
    revMixStraight => rev[i].mix;
    revMixEcho => rev[i+2].mix;
    }

5 => int n;

[
[0,2,4,5,7],
[2,4,5,7,9],
[4,5,7,9,12],
[5,7,9,12,0],
[7,9,12,0,2]

] @=> int notes[][];

0 => int i;
0 => int j;

0 => int t;

now + length => time future;

while (now < future) {
    
    <<< "i, j, note",i,j,notes[i][j] >>>;
    Std.mtof(midiBase+notes[i][j]) => osc[t].freq;
    1 => osc[t].noteOn;
    beat/(Math.pow(2,Std.rand2(0,beatPow))) => now;
    1 => osc[t].noteOff;
    
    wrap(i+Std.rand2(-dMin,dMax),n) => i;
    wrap(j+Std.rand2(-dMin,dMax),n) => j;
    
    t++;
    t%2 => t;
}

outro => now;

fun int wrap(int in, int dim) {
    
    //if (in > dim-1) return 0;
    //else if (in < 0) return dim-1;
    if (in > dim-1) return in % dim;
    else if (in < 0) return dim-in;
    
    else return in;
    
}