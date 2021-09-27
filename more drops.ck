
1::second => dur beat;

15::minute => dur length;

now + length => time future;

while (now < future) {
    spork~drop();
    2*beat => now;
}

10*beat => now;

fun void drop () {   
    Shakers shak => PitShift pitch => Echo echo => PitShift pitch2 => Echo echo2 => NRev rev => Dyno dyn => Pan2 pan => dac; 
    0.2=>rev.mix;
    4 => shak.preset;
    1.=> shak.energy;
    4=> shak.gain;
    0.5=>shak.decay;
    
    0 => pitch.mix => pitch2.mix;
    Std.rand2f(.7,1.5) => pitch.shift;
    Std.rand2f(.7,1.5) => pitch2.shift;
    
    Std.rand2f(-1,1) => pan.pan;
    
    Std.rand2f(1,5)*beat => echo.max => echo.delay;
    .7 => echo.mix => echo.gain;
    echo => echo;
    
    Std.rand2f(.75,1.5)*echo.max() => echo2.max => echo2.delay;
    .7 => echo2.mix => echo2.gain;
    echo2 => echo2;
    
    1 => shak.noteOn;
    
    10*echo.delay() => now;
    
    
      
    }