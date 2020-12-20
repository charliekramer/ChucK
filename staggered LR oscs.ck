.2 => float gainSet;
56.-12-12 => float midiBaseL;
56.1-12-12=> float midiBaseR;

TriOsc oscL => ADSR envL => dac.left;
Std.mtof(midiBaseL) => oscL.freq;
gainSet => oscL.gain;

1::second => dur beatL;

(beatL,.1::ms,1,2*beatL) => envL.set;

TriOsc oscR => ADSR envR => dac.right;
Std.mtof(midiBaseR) => oscR.freq;
gainSet => oscR.gain;

1.5::second => dur beatR;

(beatR,.1::ms,1,2*beatR) => envR.set;

spork~runL();
spork~runR();

35::second => now;


fun void runL() {
    
    while (true) {
        1 => envL.keyOn;
        envL.attackTime() => now;
        1 => envL.keyOff;
        envL.releaseTime() => now;
        
        
    }
    
}

fun void runR() {
    
    while (true) {
        1 => envR.keyOn;
        envR.attackTime() => now;
        1 => envR.keyOff;
        envR.releaseTime() => now;
        
        
    }
    
}