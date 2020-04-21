.5 => float gainSet;
2::minute => dur length;

TubeBell bell => Gain gain => dac;
gain =>  PitShift pitch => Echo echo => Pan2 pan1 => dac;
echo => Pan2 pan2 => dac;
echo => Pan2 pan3 => dac;

gainSet => gain.gain;

1 => pitch.mix;

spork~pitchLFO();

44+12 => float midiBase;
Std.mtof(midiBase) => bell.freq;
[0.,5., 7., -5.,-7.] @=> float notes[];

15::second => echo.max;
15::second => echo.delay;
.9 => echo.gain;
.9 => echo.mix;
echo => echo;

7::second => dur beat;

now + length => time future;

while (now < future) {
    1 => bell.noteOn;
    beat => now;
    Std.mtof(midiBase + notes[Std.rand2(0,notes.cap()-1)]) => bell.freq;
}

now + 30::second => future;

while (now < future) {
    echo.gain()*.99 => echo.gain;
    echo.mix()*.99 => echo.mix;
    100::ms => now;
}

fun void pitchLFO () {
    SinOsc sinLFO => blackhole;
    SinOsc pan1LFO => blackhole;
    SinOsc pan2LFO => blackhole;
    SinOsc pan3LFO => blackhole;
    
    .1 => sinLFO.freq;
    .01 => sinLFO.gain;
    .7 => pan1LFO.freq;
    .12 => pan2LFO.freq;
    .06 => pan3LFO.freq;
    
    while (true) {
        (1+sinLFO.last()) => pitch.shift;
        pan1LFO.last() => pan1.pan;
        pan2LFO.last() => pan2.pan;
        pan3LFO.last() => pan3.pan;
        
        1::samp => now;
    }
}