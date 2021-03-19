// not sure the prob function working

7 => int nPan;
1.5 => float gainSet;
3::minute => dur length;

BandedWG osc;
Envelope env[nPan];
Echo echo[nPan];
NRev rev[nPan];
Pan2 pan[nPan];

gainSet => osc.gain;

int nKey;

.5::second => dur beat;

for (0 => int i; i < nPan; i++) {
    -1 + 2.*i/(nPan*1.-1.) => pan[i].pan;
    osc => env[i] => echo[i] => rev[i] => pan[i] => dac;
    4*2*beat => echo[i].max;
    4*1.5*beat => echo[i].delay;
    .7 => echo[i].mix;
    .7 => echo[i].gain;
    echo[i] => echo[i];
}

0 => int bell; // set = 1 to stop noteoff;


//[60., 67.,72.] @=> float notes[];
//[60., 65.,67.,72.] @=> float notes[];
//[52., 60., 62., 65.,67.,72.] @=> float notes[];
[52., 55.,57., 58., 60., 62., 65.,67.,72.] @=> float notes[];
//[67.,72.] @=> float notes[];
notes.cap() => int n; //number of notes in scale;
float f[n]; //empirical count of notes
float p[n]; // probability of notes

int choice;
float frac;
int nBeat;
4 => int maxBeat;
.1 => float cutoff;

beat - (now % beat) => now;

now + length => time future;

initProbs(p,f);

for (0 => int i; i < n; i++) {
    <<< "pi", i, p[i]>>>;
}

while ((now < future) || (std(p) > cutoff)) {
   <<< "**** iteration ***">>>; 
   //Std.rand2(0,n-1) => choice;
   chooser(p) => choice;
   <<< "choice",choice>>>;
   fUpdate(choice);
   Std.mtof(notes[choice]) => osc.freq;
   1 => osc.noteOn;
   Std.rand2(0,nPan-1) => nKey;
   1 => env[nKey].keyOn;
   if (Std.rand2f(0.,1.) > .9) {
       Std.rand2(4,8) =>maxBeat;
       <<< "maxBeat reset">>>;
   }
   Std.rand2(1,maxBeat) => nBeat;
   Std.rand2f(0,1) => frac;
   (nBeat*frac)*beat => now;
   if (bell == 0) 1 => osc.noteOff;
   1 => env[nKey].keyOff;
   nBeat*(1-frac)*beat => now;
}
<<< " out" >>>;
1::minute => now;

fun void fUpdate(int i) {
    f[i] + 1 => f[i];
    
    for (0 => int j; j < n; j++){
        f[j]/sum(f) => p[j];
    }
    
    for (0 => int j; j < n; j++) {
           <<< "i f", j,f[j] >>>;
    }

}

fun float sum(float x[]) {
    0 => float total;
    for (0 => int j; j < n; j++) {
        total + x[j] => total;
    }
    return total;
}

fun float std(float x[]) {
    0 => float sdev;
    0 => float avg;
    for (0 => int i; i < n; i++) {
        avg + x[i]/n => avg;
    }
    for (0 => int i; i < n; i++) {
        sdev + Math.pow((x[i]-avg),2.) => sdev;
    }
    return Math.pow(sdev,.5);
}

fun void initProbs(float x[], float y[]) {
    for (0 => int i; i < n; i++) {
        1./x.cap() => x[i];
        10. => y[i];
    }
}

fun int chooser(float x[]) {
    Std.rand2f(0.,1.) => float s;
    <<< "s ", s>>>;
    for (0 => int i; i < n; i++) {
        <<< "i p", i,x[i] >>>;
    }
    0 => int j;
    if (s < x[0]) return j;
    for (1 => int i; i < n; i++) {
        if (s > cumulative(x,i-1) && s < cumulative(x,i)) i => j;
    }
    return j;
}
    
fun float cumulative(float x[], int j) {
    0 => float s;
    for (0 => int i; i <= j; i++) {
        s + x[i] => s;
    }
    <<< "cumulative",j, s>>>;
    return s;
}
        
        

