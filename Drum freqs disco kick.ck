.25 => float gainSet;

SinOsc sin1 => dac.left;
SinOsc sin2 => dac.right;
Envelope env => blackhole;
gainSet => sin1.gain => sin2.gain;

44 => float midiBase;


Std.mtof(midiBase) => sin1.freq => sin2.freq;



.25::second => dur beat;

beat => env.duration;

while (true) {
    
    1 => env.keyOn;
    now + beat => time future;
    while (now < future) {
        (2-env.value())*Std.mtof(midiBase) => sin2.freq;
        (2-env.value())*Std.mtof(midiBase)*1.1 => sin1.freq;
        1::samp => now;
    }
    1 => env.keyOff;
    now + beat =>  future;
    while (now < future) {
        
        env.value()*Std.mtof(midiBase)*.9 => sin1.freq;
        env.value()*Std.mtof(midiBase) => sin2.freq;
        1::samp => now;
    }
    Std.mtof(midiBase) => sin2.freq;
}