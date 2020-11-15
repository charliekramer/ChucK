.001 => float gainSet;

51-12 => float midiBase;

1.3::second => dur beatBase;

7::second => dur length;

Gain gain;
1 => gain.gain;


spork~hole1();
spork~hole2();

now + length => time future;

while (now < future) {
    1::samp => now;
}

now + 15::second => future;

while (now < future) {
    gain.gain()*.99 => gain.gain;
    20::ms => now;
}
    
fun void hole1() {
    SinOsc sin => ADSR env => gain => Echo echo => Dyno dyn => Pan2 pan => dac;
    SawOsc saw => env => gain => echo => dyn => pan => dac;
    TriOsc tri => env => gain => echo => dyn =>pan => dac;
    SqrOsc sqr => env => gain => echo => dyn =>pan => dac;
    
    .25 => pan.pan;
    
    gainSet => sin.gain;
    .005*gainSet => saw.gain;
    .005 *gainSet => sqr.gain;
    .2*gainSet => tri.gain;
    
    Std.mtof(midiBase) => sin.freq => saw.freq => tri.freq => sqr.freq;
    
    beatBase*1 => dur beat;
    beat - (now % beat) => now;
    
    (10::ms, 1::ms, 1., 250::ms) => env.set;
    
    4*beat => echo.max;
    .25*beat => echo.delay;
    .5 => echo.gain => echo.mix;
    
    while (true) {
        1 => env.keyOn;
        .5*beat => now;
        1 => env.keyOff;
        .5*beat => now;
    }
        
}        

fun void hole2() {
    SinOsc sin => ADSR env => gain => Echo echo => Dyno dyn => Pan2 pan => dac;
    SawOsc saw => env => gain => echo => dyn =>pan => dac;
    TriOsc tri => env => gain => echo => dyn =>pan => dac;
    SqrOsc sqr => env => gain => echo => dyn =>pan => dac;
    
    -.25 => pan.pan;
    
    gainSet => sin.gain;
    .005*gainSet => saw.gain;
    .005 *gainSet => sqr.gain;
    .2*gainSet => tri.gain;
    
    Std.mtof(midiBase) => sin.freq => saw.freq => tri.freq => sqr.freq;
    
    beatBase*1.1 => dur beat;
    beat - (now % beat) => now;
    
    (10::ms, 1::ms, 1., 250::ms) => env.set;
    
    4*beat => echo.max;
    .25*beat => echo.delay;
    .5 => echo.gain => echo.mix;
    
    while (true) {
        1 => env.keyOn;
        .5*beat => now;
        1 => env.keyOff;
        .5*beat => now;
    }
    
} 

