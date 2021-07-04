// could make this into a drum machine with each
// matrix entry a different drum sound
// now input a melody vector and it iterates it across columns
// generative modalbar v2
// star spangled banner
2 => float gainSet;
.2 => float revMixStraight;
.5 => float revMixEcho;

1::second => dur beat;
30::second => dur length;
15::second => dur outro;
43+12 => float midiBase;
3 => int beatPow; // beat divided by 2^rand(0,beatPow); 3
-2 => int dMin; // min and max of i, j delta distribution
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
/*
5 => int n;

[
[0,2,4,5,7],
[2,4,5,7,9],
[4,5,7,9,12],
[5,7,9,12,0],
[7,9,12,0,2]

] @=> int notes[][];
*/

[7,4,0,4,7,12] @=> int noteVector1[];
[12+4,12+2,12,4,6,7] @=> int noteVector2[];
[7,7,12+4,12+2,12,11] @=> int noteVector3[];
[9,11,12,12,7,4,0] @=> int noteVector4[];
[12+4,12+4,12+5,12+7,12+7] @=> int noteVector5[];
[12+5,12+4,12+2,12+4,12+5,12+5] @=> int noteVector6[];
[12+5,12+4,12+2,12+0,11] @=> int noteVector7[];
[9,11,12,4,6,7] @=> int noteVector8[];
[7,7,12,12,11,9,9,9,12+2,12+4,12+2,12,11,11] @=> int noteVector9[];
[7,7,12,12+2,12+4,12+5] @=> int noteVector10[];
[12,12+2,12+4,12+5,12+2,12,12] @=> int noteVector11[];


noteVector1 @=> int noteVector[];

noteVector.cap() => int n;

int notes[n][n];

for (0 => int i; i < n; i++) {
    for (0 => int j; j<n; j++) {
        noteVector[ (i+j) % n] => notes[i][j];
    }
}

        

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