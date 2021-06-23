
.1 => float gainSet;
3 => int n;
10::second => dur beat;
51-12-12=> float midiBase;
45::second => dur length;
.01 => float freqDelta;
.01 => float minLFOFreq;
.5 => float maxLFOFreq;

Clarinet osc[n];
Envelope env[n];
NRev rev[n];
Pan2 pan[n];
PitShift pitch[n];
SinOsc lfo[n];
SinOsc pitchLfo[n];

beat*.25 - (now % beat*.25) => now;

for (0 => int i; i < n; i++) {
    gainSet => osc[i].gain;
    Std.mtof(midiBase)*Std.rand2f(1-freqDelta,1+freqDelta) => osc[i].freq;
    osc[i] => pitch[i] => env[i] => rev[i] => pan[i] => dac;
    1 => pitch[i].mix;
    -1 + 2*(i*1. )/(n-1)*1. => pan[i].pan;
    .5*beat => env[i].duration;
}

spork~lfos(minLFOFreq,maxLFOFreq);

now + length => time future;

while (now < future) {
    
    for (0 => int i; i < n ; i++) {
        Std.rand2f(0,1) => osc[i].noteOn;
        1 => env[i].keyOn;
    }
    
    .5*beat => now;
    
    for (0 => int i; i < n ; i++) {
        1 => env[i].keyOff;
    }
    
    .5*beat => now;
 
    
}

5::second => now;
    

fun void lfos(float minRate, float maxRate) {
    
    for (0 => int i; i < n ; i++) {
        Std.rand2f(minRate,maxRate) => lfo[i].freq;
        Std.rand2f(minRate,maxRate) => pitchLfo[i].freq;
     }
    
    while(true) {
     
     for (0 => int i; i < n ; i++) {
         (1+lfo[i].last())*.5 => rev[i].mix;
         1+pitchLfo[i].last() => pitch[i].shift;
     }
     
     1::samp => now;
   }  

}
    
 

