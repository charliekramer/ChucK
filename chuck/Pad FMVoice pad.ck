// FM voice pad based on FMv pad

FMVoices FMvLeft[4] ;
FMVoices FMvRight[4] ;

FMvLeft[0] => Chorus cL => NRev revL => Echo eL => Dyno dL => dac.left;
FMvRight[0] => Chorus cR => NRev revR => Echo eR => Dyno dR => dac.right;

.05 => cL.modFreq;
0.6 => cL.modDepth;
0.25 => cL.mix;

.01 => cR.modFreq;
0.6 => cR.modDepth;
0.25 => cR.mix;

// add FMv paramaters

0.85 => float vowel;
0.29 => float specTilt;
0.1 => float adsr;

// gain - effects;

0.005/3 => float allGain;
0.5 => revL.mix;
0.1 => eL.mix;
0.5 => revR.mix;
0.1 => eR.mix;

1::second => eL.delay;
1.5::second => eR.delay;

58-12 => int midiBase;
[0, 4, 5, 12] @=> int notes[];
.005 => float freqDelta; // in percentage difference


for (0 => int i; i < FMvLeft.cap()-1; i++) {
    
    Std.mtof(midiBase+notes[i])*(1 + freqDelta*i) => FMvLeft[i].freq;
    Std.mtof(midiBase+notes[i])*(1 - freqDelta*i) => FMvRight[i].freq;
    allGain => FMvLeft[i].gain =>  FMvRight[i].gain;
    vowel => FMvLeft[i].vowel => FMvRight[i].vowel;
    specTilt => FMvLeft[i].spectralTilt => FMvRight[i].spectralTilt;
    adsr => FMvLeft[i].adsrTarget => FMvRight[i].adsrTarget;
    
    if (i > 0 ) {
        FMvLeft[i] => cL =>  revL => eL => dac.left;
        FMvRight[i] => cR => revR => eR => dac.right;
    }
       
}

    
while (true) {
    
    for (0 => int i; i < FMvLeft.cap()-1; i++) {
     
       1 => FMvLeft[i].noteOn;
       1 => FMvRight[i].noteOn;
        
    }
    
    10::second => now;
    
    for (0 => int i; i < FMvLeft.cap()-1; i++) {
        
        1 => FMvLeft[i].noteOff;
        1 => FMvRight[i].noteOff;
        
    }
    
       .1::second => now;
    
}

   
        
    

