// based on goth drum machine
//prob kick
//random gen effx, hat, snare, keys
60./120.*1.5 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

.02 => float gainSet;

//soundchain
Gain g => dac;
SndBuf kick  => HPF filt => g => dac;
g =>  Echo echo => Chorus chorus => NRev rev => Gain echogain => Dyno dyn => dac;
SndBuf kick2 => filt => g => dac;
SndBuf snare  => g => dac;
SndBuf hat => g => dac;
Shakers shak => g => dac;
SndBuf clap => g => dac;

.5 => float pDelay;
.1 => float pRev;
.1 => float pChorus;
.2 => float pFilt;
.1 => float pClap;
.1 => float pKeys;
.2 => float pSnare;
.3 => float pHat;


40 => float baseFreq;
2 => float baseQ;

baseFreq => filt.freq;
baseQ => filt.Q;


8*beat => echo.max;
1.5*beat*.5 => echo.delay;
.5 => echo.mix;
.9 => echo.gain;
echo => echo;
1 => echogain.gain;

1 => chorus.mix;
50 => chorus.modFreq;
0 =>chorus.mix;

gainSet => g.gain;
0.1*4 => hat.gain;
0.1 => shak.gain;
0.0 => rev.mix;
2.5 => snare.gain;
2 => clap.gain;
1.5*gainSet => float keysGain;

//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/kick_01.wav" => kick2.read;
me.dir(-1)+"chuck/audio/snare_01.wav" => snare.read;
me.dir(-1)+"chuck/audio/hihat_01.wav" => hat.read;
me.dir(-1)+"chuck/audio/clap_01.wav" => clap.read;

// wind to end of file
kick.samples()=>kick.pos;
snare.samples()=>snare.pos;
hat.samples()=>hat.pos;

0=> echo.mix;

while (true) {
    
    Std.rand2(1,2)*4 => int randBeats;
    
    <<< "*** beats ,", randBeats, " ******">>>;
    
    if (Std.rand2f(0,1) > 1- pDelay) {
        <<< "delay " >>>;
        1 => echo.mix;
        1.5*beat*Std.rand2(1,3)*.5 => echo.delay;
    }
    
    if (Std.rand2f(0,1) > 1 - pChorus) {
        
        <<< "chorus " >>>;
        1 => chorus.mix;
        50*Std.rand2f(1,10) => chorus.modFreq;
    }
    
    if (Std.rand2f(0,1) > 1 - pRev) {
        
        <<< "rev " >>>;
        Std.rand2f(0,.7) => rev.mix;
    }
    
    if (Std.rand2f(0,1) > 1 - pFilt) {
        
        <<< "filt " >>>;
        Std.rand2f(40,400) => filt.freq;
        Std.rand2f(2,10) => filt.Q;
    }
    
    if (Std.rand2f(0,1) > 1 - pClap) {
        
        <<< "clap " >>>;
        spork~claps();
        
        }
        
     if (Std.rand2f(0,1) > 1 - pHat) {
            
            <<< "hats " >>>;
            spork~hats();
            
        }
     
     if (Std.rand2f(0,1) > 1 - pSnare) {
            
          <<< "snares " >>>;
          spork~snares();
            
       }      
        
    if (Std.rand2f(0,1) > 1 - pKeys) {
            
        <<< "keys " >>>;
        spork~keys();
            
        }
        
     
    for ( 1 => int i; i < randBeats; i++)
    {
            00=>kick.pos;
            0=> kick2.pos;
            0.7 => kick.rate;
            1.3 => kick2.rate;
        
    beat =>now;  
    }
    
    0 => echo.mix;
    0 => chorus.mix;
    0 => rev.mix;
    baseFreq => filt.freq;
    baseQ => filt.Q;
    
}

fun void claps() {
    Std.rand2(1,32) => int nClaps;
    Math.pow(2,Std.rand2(1,4))  => float beatDiv;
    
    
    for (1 => int i; i < nClaps; i++) {
        0 => clap.pos;
        Std.rand2f(.5,2) => clap.rate;
        beat/beatDiv => now;
    }
}

fun void snares() {
    Std.rand2(1,32) => int nSnares;
    Math.pow(2,Std.rand2(1,4))  => float beatDiv;
    
    
    for (1 => int i; i < nSnares; i++) {
        0 => snare.pos;
        Std.rand2f(.5,2) => snare.rate;
        beat/beatDiv => now;
    }
}

fun void hats() {
    Std.rand2(1,32) => int nHats;
    Math.pow(2,Std.rand2(1,4))  => float beatDiv;
    
    
    for (1 => int i; i < nHats; i++) {
        0 => hat.pos;
        Std.rand2f(.5,2) => hat.rate;
        beat/beatDiv => now;
    }
}


fun void keys() {
    3 => int nKeys;
    Wurley keys[nKeys];
    Echo echo;
    NRev rev;
    
    .2 => rev.mix;
    
    10*beat => echo.max;
    1.5*beat*Std.rand2(1,3)*.5 => echo.delay;
    .5 => echo.mix;
    .7 => echo.gain;
    echo => echo;
    
    
    60-12 => float midiBase;
    
    [-7., -5., -2., 0., 4., 5, 7., 9., 11., 12., 14] @=> float notes[];
    
    for (0 => int i; i < nKeys; i++) {
        keysGain => keys[i].gain;
        keys[i] => echo => rev => dac;
        Std.mtof(midiBase+notes[Std.rand2(1,notes.cap()-1)]) => keys[i].freq;
        
    }
    
    Std.rand2(1,32) => int nChords;
    Math.pow(2,Std.rand2(1,4))  => float beatDiv;
    
    
    for (1 => int i; i < nChords; i++) {
        
        for (0 => int j; j < nKeys; j++) {
            1 => keys[j].noteOn;
        }
            
        
        beat/beatDiv => now;
    }
    
    15::second => now;
}

    
   
