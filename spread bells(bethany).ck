
.2 => float gainSet;
30::second => dur length;
20 => int n;
TubeBell osc[n];

5::second => dur beat;
.1 => float offLen; //relative length of 'noteOff'

.2 => float revMix;

44 => float midiBase;
.1 => float minBeat;
1.0 => float maxBeat;
.95 => float minFreq;
1.05 => float maxFreq;

NRev rev[n];
Pan2 pan[n];

for (0 => int i; i < n; i++) {
    osc[i] => rev[i] => pan[i] => dac;
    2.*i/(n-1) -1. => pan[i].pan;
    <<< "pan i", pan[i].pan() >>>;
    revMix => rev[i].mix;
    gainSet => osc[i].gain;
    Std.mtof(midiBase)*Std.rand2f(minFreq,maxFreq) => osc[i].freq;
    spork~oscRun(i);
    
}
    
now + length => time future;
    
while (now < future) {
    beat => now;
        
}

5::second => now;
    
fun void oscRun(int i) {
    Std.rand2f(minBeat,maxBeat)*beat => dur oscBeat;
    while (now < future) {
        1 => osc[i].noteOn;
        oscBeat => now;
        1 => osc[i].noteOff;
        offLen*oscBeat => now;
        }
        
}