
.4 => float gainSet;
47-12 => float midiBase;
[-12.,-7.,-5.,0.,2.,4.,5.,7.,9.,11.,12] @=> float notes[];
4 => int nNotes;
1 => float nBeat;
2*.25::second => dur beat;
60::second => dur length;
.9 => float cutOff;

beat - (now % beat) => now;

Gain gain => LPF filtLeft => Echo echoLeft => dac.left;

gain => LPF filtRight => Echo echoRight => dac.right;

2*Std.mtof(midiBase) => filtLeft.freq => filtRight.freq;
2 => filtLeft.Q => filtRight.Q;

spork~filtLFOs(.1,.15);

1.5*beat => echoLeft.max => echoLeft.delay;
.7 => echoLeft.gain => echoLeft.mix;
echoLeft => echoLeft;

1.75*beat => echoRight.max => echoRight.delay;
.7 => echoRight.gain => echoRight.mix;
echoRight => echoRight;

now + length => time future;

while (now < future) {
    
 spork~goNote();
 
 4*beat => now;   
    
}

10*beat => now;

fun void goNote() {
    
    StifKarp osc => gain;
    gainSet => osc.gain;
    Std.mtof(midiBase) => osc.freq;
    
    for (0 => int i; i < nNotes; i++) {
        if (Std.rand2f(0.,1.) > cutOff) {
            Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc.freq;    
            }
        1 => osc.noteOn;
        nBeat*beat => now;
        Std.mtof(midiBase) => osc.freq;
  
    }
    
    beat => now;
}

fun void filtLFOs(float freqL, float freqR) {
    SinOsc LFOL => blackhole;
    SinOsc LFOR => blackhole;
    freqL => LFOL.freq;
    freqR => LFOR.freq;
    
    while (true) {
        
    (4+2*LFOL.last())*Std.mtof(midiBase) => filtLeft.freq;          
    (4+2*LFOR.last())*Std.mtof(midiBase) => filtRight.freq;    
    1::samp => now;
        
    }
    
}
