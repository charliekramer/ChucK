.5 => float gainSet;
3::second => dur length;
44+12+12+12 => float midiBase;

SinOsc sin => Envelope env => Echo echo => Pan2 pan => dac;
SinOsc sin2 => Envelope env2 => Echo echo2 => Pan2 pan2 => dac;
Std.rand2f(.99,1.01)*Std.mtof(midiBase) => sin.freq;
Std.rand2f(.99,1.01)*Std.mtof(midiBase) => sin2.freq;

gainSet => sin.gain => sin2.gain;

Std.rand2f(-1,1) => pan.pan;
-pan.pan() => pan2.pan;

.25::second => dur beat;
1.5*beat => echo.max => echo.delay;
.8 => echo.gain => echo.mix;
echo => echo;

1.25*beat => echo2.max => echo2.delay;
.8 => echo2.gain => echo2.mix;
echo2 => echo2;

spork~sinR(length);
spork~sinL(length);

length => now;

20::second => now;


fun void sinR (dur len) {
    now + len => time future;
    while (now < future) {
        1 => env.keyOn;
        Std.rand2(1,6)*beat/3 => now;
        1 => env.keyOff;
        Std.rand2(1,6)*beat/3 => now;  
    }
}

fun void sinL (dur len) {
    now + len => time future;
    while (now < future) {
        1 => env2.keyOn;
        Std.rand2(1,6)*beat/3 => now;
        1 => env2.keyOff;
        Std.rand2(1,6)*beat/3 => now;  
    }
}
