

.1 => float gainSet;

56 => float midiBase;

2::second => dur beat;

18::minute => dur length; // add two minutes to overall length for outro

.01 => float LFOGain;

now + length => time end;

while (now < end) {
    spork~fireFlute();
    Std.rand2f(4,6)*beat => now;
}

2::minute => now;





fun void fireFlute() {
    Flute flute => Echo echo => NRev rev =>  ADSR env => Pan2 pan => dac;
    gainSet => flute.gain;
    SinOsc LFO => blackhole;
    LFOGain => LFO.gain;
    Std.rand2f(.05,.5) => LFO.freq;
    
    6*beat => echo.max;
    Std.rand2f(2,4)*beat => echo.delay;
    .7 => echo.mix;
    .7 => echo.gain;
    echo => echo;
    
    Std.rand2f(-1,1) => pan.pan;
     
    1 => flute.noteOn;
    1 => env.keyOn;
    
    Std.rand2f(2,4)*beat => dur len;
    now + len => time future;
    
    (.5*beat, 1::ms, 1, 4*len) => env.set;
    
    while (now < future) {
         (1+LFO.last())*Std.mtof(midiBase) => flute.freq;
         1::samp => now;
     }
  
    1 => flute.noteOff;
    1 => env.keyOff;
    
    4*len => now;
    
   
    
    
    
}