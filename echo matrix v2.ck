// echo matrix
// echo is a vector this time (same w/ pan etc)
// unstable at hi combos of echo[i] gain and gain[i][j] gain

.7*3 => float gainSet;
48 => float midiBase;
45::second => dur length;
30::second => dur outro;
6 => int n;
1.5::second*4 => dur beat;
.2 => float revMix;
.25 => float echoGain;
.5 => float minGain;// in distribution for
.5 => float maxGain;// gain[i][j];
.125 => float minBeat; // in distribution for
4.25 => float maxBeat;// length of echo[i].delay;


[0.,4.,5.,7.,12.] @=> float notes[];


ModalBar osc; //modalBar/ nice with FrencHrn and Bowed, BlowHole, BlowBotl

gainSet => osc.gain;

Std.mtof(midiBase) => osc.freq;

Gain gain[n][n];

Echo echo[n];

Pan2 pan[n];

NRev rev[n];

for (0 => int i; i < n; i++) {
    osc => echo[i] => rev[i] => pan[i] => dac;
    revMix => rev[i].mix;
    maxBeat*beat => echo[i].max;
    Std.rand2f(minBeat,maxBeat)*beat => echo[i].delay;
    echoGain => echo[i].gain;
    .7 => echo[i].mix;
    map(i,0,n-1,-1,1) => pan[i].pan; 
    <<< "i, pan", i,pan[i].pan()>>>;
       
    for (0 => int j; j < n; j++) {
        Std.rand2f(minGain,maxGain) => gain[i][j].gain;
        echo[i] => gain[i][j] => echo[j];
        
        }
    }
    
int i, j;
 
now + length => time future;
    
while (now < future) {
    1 => osc.noteOn;
    beat => now; 
    1 => osc.noteOff;
    3*beat => now;
    
    Std.rand2f(minGain,maxGain) => gain[Std.rand2(0,n-1)][Std.rand2(0,n-1)].gain;
    Std.rand2f(minBeat,maxBeat)*beat => echo[Std.rand2(0,n-1)].delay;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc.freq;
        
    }
    
outro => now;

fun float map (float xin, float xmin, float xmax, float ymin, float ymax) {
        float a, b;
        (ymax - ymin)/(xmax - xmin) => b;
        ymax - b*xmax => a;
        return a + b*xin;
    }
    