// bottle pad

BlowBotl bottleLeft[4] ;
BlowBotl bottleRight[4] ;

bottleLeft[0] => NRev rev => Echo e => dac.left;
bottleRight[0] =>  rev =>  e => dac.right;


// add blowbotl paramaters

0.1 => float noiseGain;
.1 => float vibFreq;
0.1 => float vibGain;
.1 => float rate;


// gain - effects;

0.05 => float allGain;
0.2 => rev.mix;
0.1 => e.mix;

1::second => e.delay;

57 => int midiBase;
Std.mtof(midiBase+12) => float baseFreq;
[0, 3, 5, 12] @=> int notes[];
.01 => float freqDelta;


for (0 => int i; i < bottleLeft.cap()-1; i++) {
    
    Std.mtof(midiBase+notes[i]) + freqDelta*i => bottleLeft[i].freq;
    Std.mtof(midiBase+notes[i])- freqDelta*i => bottleRight[i].freq;
    allGain => bottleLeft[i].gain =>  bottleRight[i].gain;
    noiseGain => bottleLeft[i].noiseGain => bottleRight[i].noiseGain;
    vibFreq => bottleLeft[i].vibratoFreq => bottleRight[i].vibratoFreq;
    vibGain => bottleLeft[i].vibratoGain => bottleRight[i].vibratoGain;
    rate => bottleLeft[i].rate => bottleRight[i].rate;
    
    if (i > 0 ) {
        bottleLeft[i] => rev => e => dac.left;
        bottleRight[i] => rev => e => dac.right;
    }
        
 
    
}

    
while (true) {
    
    for (0 => int i; i < bottleLeft.cap()-1; i++) {
     
       1 => bottleLeft[i].noteOn;
       1 => bottleRight[i].noteOn;
        
    }
    
    10::second => now;
    
    for (0 => int i; i < bottleLeft.cap()-1; i++) {
        
        1 => bottleLeft[i].noteOff;
        1 => bottleRight[i].noteOff;
        
    }
    
       1::second => now;
    
}

   
        
    

