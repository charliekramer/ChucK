

SinOsc sin1 => dac;
SinOsc sin2 => dac;
Envelope env => blackhole;

44 => float midiBase;


Std.mtof(midiBase) => sin1.freq => sin2.freq;



.25::second => dur beat;

beat => env.duration;

while (true) {
    
    1 => env.keyOn;
    now + beat => time future;
    while (now < future) {
        (2-env.value())*Std.mtof(midiBase) => sin2.freq;
        1::samp => now;
    }
    1 => env.keyOff;
    now + beat =>  future;
    while (now < future) {
        env.value()*Std.mtof(midiBase) => sin2.freq;
        1::samp => now;
    }
    Std.mtof(midiBase) => sin2.freq;
}