
.001 => float gainSet;
2.5::minute => dur length;

57-12 => int base1;

[0,5,10,15] @=> int chord1[]; //[0,5,10, 15] 

62-12 => int base2;

[0,5,10,17] @=> int chord2[]; //[0,5,10,17]

5::second => dur beat;

10*beat => dur outro;

0 => int octFlag; // randomize octaves

LPF filt1;
LPF filt2;

2 => filt1.Q;
2 => filt2.Q;

.2 => float filtFreq1;
.21 => float filtFreq2;

spork~filtLFO();

now + length => time future;

while (now < future) {
    spork~goChord1();
    
    Std.rand2(1,3)*beat => now;
    
    spork~goChord2();
    
    Std.rand2(3,5)*beat => now;
}

outro => now;

fun void goChord1() {
    
    
    SinOsc sin[chord1.cap()];
    SqrOsc sqr[chord1.cap()];
    TriOsc tri[chord1.cap()];
    
    NRev rev[chord1.cap()];
    Echo echo[chord1.cap()];
    Pan2 pan[chord1.cap()];
    
    ADSR env;
    
    1 => env.keyOff;
    
    (.5*beat,0.1::ms,1.,.5*beat) => env.set;
    
    for (0 => int i; i < chord1.cap(); i++) {
        
        .2 => rev[i].mix;
        1.5*beat*Std.rand2f(.5,2) => echo[i].max => echo[i].delay;
        .7 => echo[i].mix => echo[i].gain;
        echo[i] => echo[i];
        
        Std.rand2f(-.25,1) => pan[i].pan;
        
        sin[i] => filt1 => env => echo[i] => rev[i] => pan[i] => dac;
        sqr[i] => filt1 => env => echo[i] => rev[i] => pan[i] => dac;
        tri[i] => filt1 =>env => echo[i] => rev[i] => pan[i] => dac;
        
        Std.rand2f(.99,1.01)*Std.mtof(octFlag*12*Std.rand2(-1,1)+base1+chord1[Std.rand2(0,chord1.cap()-1)]) => sin[i].freq;
        Std.rand2f(.99,1.01)*Std.mtof(octFlag*12*Std.rand2(-1,1)+base1+chord1[Std.rand2(0,chord1.cap()-1)]) => tri[i].freq;
        Std.rand2f(.99,1.01)*Std.mtof(octFlag*12*Std.rand2(-1,1)+base1+chord1[Std.rand2(0,chord1.cap()-1)]) => sqr[i].freq;
        
        gainSet*Std.rand2f(0,1) => sin[i].gain;
        gainSet*Std.rand2f(0,1) => sqr[i].gain;
        gainSet*Std.rand2f(0,1) => tri[i].gain;
        }
      
    
    1 => env.keyOn;
    beat => now;
    1 => env.keyOff;
    10*beat => now;
    
    
    }
    
    fun void goChord2() {
        
        SinOsc sin[chord2.cap()];
        SqrOsc sqr[chord2.cap()];
        TriOsc tri[chord2.cap()];
        
        NRev rev[chord2.cap()];
        Echo echo[chord2.cap()];
        Pan2 pan[chord2.cap()];
        
        ADSR env;
        
        1 => env.keyOff;
        
        (.5*beat,0.1::ms,1.,.5*beat) => env.set;
        
        for (0 => int i; i < chord2.cap(); i++) {
            
            .2 => rev[i].mix;
            1.5*beat*Std.rand2f(.9,1.1) => echo[i].max => echo[i].delay;
            .7 => echo[i].mix => echo[i].gain;
            echo[i] => echo[i];
            
            
            Std.rand2f(-1,.5) => pan[i].pan;
            
            sin[i] => filt2 => env => echo[i] => rev[i] => pan[i] => dac;
            sqr[i] => filt2 => env => echo[i] => rev[i] => pan[i] => dac;
            tri[i] => filt2 => env => echo[i] => rev[i] => pan[i] => dac;
            
            Std.rand2f(.99,1.01)*Std.mtof(octFlag*12*Std.rand2(-1,1)+base1+chord2[Std.rand2(0,chord2.cap()-1)]) => sin[i].freq;
            Std.rand2f(.99,1.01)*Std.mtof(octFlag*12*Std.rand2(-1,1)+base1+chord2[Std.rand2(0,chord2.cap()-1)]) => tri[i].freq;
            Std.rand2f(.99,1.01)*Std.mtof(octFlag*12*Std.rand2(-1,1)+base1+chord2[Std.rand2(0,chord2.cap()-1)]) => sqr[i].freq;
            
            gainSet*Std.rand2f(0,1) => sin[i].gain;
            gainSet*Std.rand2f(0,1) => sqr[i].gain;
            gainSet*Std.rand2f(0,1) => tri[i].gain;
        }
        
        
        1 => env.keyOn;
        beat => now;
        1 => env.keyOff;
        10*beat => now;
        
        
    }
    
fun void filtLFO() {
    
    SinOsc LFO[2];
    
    filtFreq1 => LFO[0].freq;
    filtFreq2 => LFO[1].freq;  
    
    while (true) {
     Std.mtof(base1)*4*(1.2+.5*LFO[0].last()) => filt1.freq;
     Std.mtof(base1)*4*(1.2+.5*LFO[1].last()) => filt2.freq;
     1::samp => now;
        
    }
      
    }

