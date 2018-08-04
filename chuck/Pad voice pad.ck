// vocal melody for three chord rhodey sequence

1::second=>dur beat;
beat - (now % beat) => now;

VoicForm voice[4] ;

Echo e1 => Echo e2 => Echo e3 => NRev rev => Gain g1 => Pan2 pan => dac;

for (0 => int i; i<4; i++) {
    voice[i] => e1 => e2 => e3 => rev => g1 => dac;
    0.025 => g1.gain;
    0.02 => voice[i].gain;
    0.3 => rev.mix;
    1000::ms => e1.max => e2.max => e3.max;
    750::ms => e1.delay ;
    1500::ms => e2.delay;
    750::ms/2 => e3.delay;
    .5 => e1.mix => e2.mix => e3.mix;
    10 => voice[i].phonemeNum;
    .1 =>voice[i].voiceMix;
    .2 => voice[i].vibratoFreq;
    0.0 => voice[i].vibratoGain;
    0.1 => voice[i].pitchSweepRate;
}

0 => pan.pan;

55-12 => int baseNote;

[baseNote,baseNote+4,baseNote+5,baseNote+7] @=> int notes[];


while (true) {
    
    55+12 => baseNote;
    
    [baseNote,baseNote+4,baseNote+5,baseNote+7] @=> notes;
    
    for (0 => int i; i < notes.cap(); i++) {
        Std.mtof(notes[i]) => voice[i].freq;
        2*Std.rand2(0,2) => voice[i].phonemeNum;
        1 => voice[i].noteOn;
        5*beat/4 => now;
    }
    
    
    45+12 => baseNote;
    
    [baseNote,baseNote+4,baseNote+5,baseNote+9] @=> notes;
    
    for (0 => int i; i < notes.cap(); i++) {
        Std.mtof(notes[i]) => voice[i].freq;
         2*Std.rand2(0,2) => voice[i].phonemeNum;
        1 => voice[i].noteOn;
        4*beat/4 => now;
    }
    
  
    
    36+12 => baseNote;
    
    [baseNote,baseNote+4,baseNote+5,baseNote+7] @=> notes;
    
    for (0 => int i; i < notes.cap(); i++) {
        Std.mtof(notes[i]) => voice[i].freq;
         2*Std.rand2(0,2) => voice[i].phonemeNum;
        1 => voice[i].noteOn;
         3*beat/4 => now;
    }
    
   
    
}

