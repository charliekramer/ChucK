// vocal melody for three chord rhodey sequence

1::second=>dur beat;
beat - (now % beat) => now;

VoicForm voice[4] ;

Echo e1 => Echo e2 => Echo e3 => NRev rev => Gain g1 => Pan2 pan => dac;

for (0 => int i; i<4; i++) {
    voice[i] => e1 => e2 => e3 => rev => g1 => dac;
    0.01 => g1.gain;
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

[baseNote,baseNote,baseNote,baseNote] @=> int notes[];

[3,1,4,1,5,9,2,6,5,3,5,8,9,7,9,3,2,3,8,4] @=> int noteDelta[];

//[3,1,4,1] @=> int noteDelta[];


for (0 => int j; j <= noteDelta.cap()-4; j++) {
    
    
    [baseNote+noteDelta[j],baseNote+noteDelta[j+1],baseNote+noteDelta[j+2],baseNote+noteDelta[j+3]] @=> notes;
    
	<<< noteDelta[j], noteDelta[j+1], noteDelta[j+2], noteDelta[j+3] >>>;
	
    for (0 => int i; i < notes.cap(); i++) {
        Std.mtof(notes[i]) => voice[i].freq;
        2*Std.rand2(0,2) => voice[i].phonemeNum;
        1 => voice[i].noteOn;
        Std.rand2(4,7)*beat/2 => now;
    }  
    
}


  

for (0 => int i; i < notes.cap(); i++) {
	1 => voice[i].noteOff;
	Std.rand2(4,7)*beat/2 => now;
}

10::second => now;

