// oscillating mix of n echoes

.2 => float gainSet;

60::second => dur length;

TubeBell osc;

gainSet => osc.gain;

5 => int n;

56 => float midiBase;

[-12,-5,-7,0,5,7,12] @=> int notes[];

1::second => dur minTime;
10::second => dur maxTime;

15::second => dur beat;

-1 => float minPan;
1 => float maxPan;

dur echoTime[n];
SinOsc LFO[n];
Echo echo[n];
Gain gain[n];
Pan2 pan[n];


.1 => float minFreq;
.5 => float maxFreq;

for (0 => int i; i < n; i++) {
    (maxTime-minTime)*i/(n-1) + minTime => echoTime[i];
    (maxFreq - minFreq)*i/(n-1) + minFreq => LFO[i].freq;
    <<< LFO[i].freq() >>>;
    
    2*maxTime => echo[i].max;
    echoTime[i] => echo[i].delay;
    .7 => echo[i].gain;
    .7 => echo[i].mix;
    echo[i] => echo[i];
    (maxPan - minPan)*i/(n-1) +minPan => pan[i].pan;
    osc => echo[i] => pan[i] => dac;
   
    }
    

spork~gainLFOs();

now + length => time future;
    
while (now < future) {
    Std.mtof(midiBase+notes[Std.rand2(0,notes.size()-1)]) => osc.freq;
    1 => osc.noteOn;
    beat => now;
    }

10*maxTime => now;


fun void gainLFOs() {
    while (true) {
        for (0 => int i; i < n; i++) {
            (1+LFO[i].last())/2. => gain[i].gain;
            }
        
        1::samp => now;
        }
    
    }