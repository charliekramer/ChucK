.1 => float gainSet;
4 => int n;
gainSet / n => gainSet;

120::second => dur sporkLength;
120::second => dur sporkOutro;
30 => float midiBase;
.015 => float freqDelta;

1::second*8 => dur beat;

beat - (now % beat) => now;
    
float freq;
    
for (0 => int i; i < n; i++) {
  Std.mtof(midiBase)*Std.rand2f(1.-freqDelta,1.+freqDelta) => freq;
  spork~phaser(freq,sporkLength,i);
}

sporkLength + sporkOutro => now;


fun void phaser(float freq, dur length, int i) {
    Phasor phasor => Gen17 gen => Envelope env => Echo echo => PoleZero filt =>  NRev rev => Pan2 pan => dac;
    SinOsc LFO[4];
    
    2*beat => echo.max;
    1.5*beat => echo.delay;
    .3 => echo.mix;
    .3 => echo.gain;
    echo => echo;
      
    gainSet => phasor.gain;
    
    [1.,.5,.7,2,.3] => gen.coefs;
    
    freq => phasor.freq;
    -1 + 2.*i/(1.*n) => pan.pan;
    //Std.rand2f(-1,1) => pan.pan;
    
    for (0 => int i; i < LFO.cap(); i++) {
        LFO[i] => blackhole;
        Std.rand2f(.1,.5) => LFO[i].freq;
        }
        
    now + length => time future;    
    
    while (now < future) {
        
        [1.,(.5+LFO[0].last()*.45),(.5+LFO[1].last()*.45),
        (.5+LFO[2].last()*.45),(.5+LFO[3].last()*.45)
        ] => gen.coefs;
        1 => env.keyOn;
        beat => now;
        1 => env.keyOff;
        1*beat => now;
    }
    
    sporkOutro => now;
    
    }