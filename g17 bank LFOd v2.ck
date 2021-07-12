10 => float gainSet;
5 => int n;
gainSet / n => gainSet;

30::second => dur sporkLength;
60::second => dur sporkOutro;
30 => float midiBase;
.015 => float freqDelta;

1::second*4 => dur beat;

beat - (now % beat) => now;
    
float freq;
    
for (0 => int i; i < n; i++) {
  Std.mtof(midiBase)*Std.rand2f(1.-freqDelta,1.+freqDelta) => freq;
  spork~phaser(freq,sporkLength,i);
}

sporkLength + sporkOutro => now;


fun void phaser(float freq, dur length, int i) {
    SinOsc phasor => Gen17 gen => PoleZero filt => Envelope env => Echo echo =>  NRev rev => Pan2 pan => dac;
    SinOsc LFO[4];
    
    2*beat => echo.max;
    1.5*beat => echo.delay;
    .7 => echo.mix;
    .7 => echo.gain;
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
    time loop;   
    
    while (now < future) {
        
        [(2+LFO[0].last()),(1.5+LFO[1].last()),
        (1+LFO[2].last()*.45),(.5+LFO[3].last()*.25)
        ] => gen.coefs;
        1 => env.keyOn;
        now + beat => loop;
        while (now < loop) {
            [(2+LFO[0].last()),(1.5+LFO[1].last()),
            (1+LFO[2].last()*.45),(.5+LFO[3].last()*.25)
            ] => gen.coefs;
            .1::second => now;
            }
        1 => env.keyOff;
        now + beat => loop;
        while (now < loop) {
            [(2+LFO[0].last()),(1.5+LFO[1].last()),
            (1+LFO[2].last()*.45),(.5+LFO[3].last()*.25)
            ] => gen.coefs;
            .1::second => now;
        }
        
    }
    
    sporkOutro => now;
    
    }

