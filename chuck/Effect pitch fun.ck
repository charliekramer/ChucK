// pitch/filter/echo/pan mod of sawOsc

SawOsc s => LPF f => Echo e => Pan2 pan => dac;

.2 => s.gain;

60./94. => float beatSec;
beatSec::second => dur beat;

beat*4 => dur freqCycle;
beat=> dur filtCycle;
10::second => e.max;
filtCycle*1.5 => e.delay;
e=>e;
0.5 => e.gain;
0.2 => e.mix;
beat*16 => dur panCycle;
.5 => float panFreq;

//0 => pan.pan;

20 => f.Q;

fun void autoPan (Pan2 pan) {
    SqrOsc sqr => blackhole;
    panFreq => sqr.freq;
    while (true) {
       <<< sqr.last() >>>;
       sqr.last()*.75 => pan.pan;
        panCycle/2 => now;
    }
}
    

fun void freqS (SawOsc u) {
    
    2 => float lowFreq => u.freq;
    440 => float hiFreq;
    100 => int nStep;
    (hiFreq - lowFreq)/nStep => float stepSize;
    freqCycle => dur cycle;
    cycle/nStep => dur stepLength;
    1. => float stepDir;
    
    while (true) {  
        u.freq()+stepSize*stepDir => u.freq;
 ///       <<< "U freq, stepSize, stedDir", u.freq(), stepSize, stepDir>>>;
        stepLength => now;
        if (u.freq() > hiFreq || u.freq() < lowFreq) -1*stepDir=>stepDir;
    }
}


fun void freqF (LPF f) {
    
    2 => float lowFreq => f.freq;
    880 => float hiFreq;
    10000 => int nStep;
    (hiFreq - lowFreq)/nStep => float stepSize;
    filtCycle => dur cycle;
    cycle/nStep => dur stepLength;
    1. => float stepDir;
    
    while (true) {  
        f.freq()+stepSize*stepDir => f.freq;
        stepLength => now;
        if (f.freq() > hiFreq || f.freq() < lowFreq) -1*stepDir=>stepDir;
    }
}


spork~freqS(s);
spork~freqF(f);
spork~autoPan(pan);


40::second => now;

0 => s.gain;

10::second => now;
    
    