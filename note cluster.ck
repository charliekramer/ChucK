.5 => float gainSet;
44 => float midiBase;
1.25::second => dur beat;
.5 => float cutoff;
5.00::minute => dur length;
30::second => dur outro;
5 => int maxNotes; // max notes in cluster
int kNotes;

now + length => time future;

while (now < future) {
    
    Std.rand2(1,maxNotes) => kNotes;
    
    for (0 => int i; i<kNotes; i++) {
        if (Std.rand2f(0,1) > cutoff) {
            spork~oneNoteWurley(Std.rand2(2,8)/4.*Std.mtof(midiBase+Std.rand2(0,1)*2),beat*Std.rand2(1,8)/4);
        }
        if (Std.rand2f(0,1) > cutoff) {
            spork~oneNoteBell(Std.rand2(2,8)/4.*Std.mtof(midiBase+Std.rand2(0,1)*2),beat*Std.rand2(1,8)/4);
        }
        beat/10 => now;
    }
    Std.rand2f(5,19)*beat => now;
}

outro => now;

fun void oneNoteWurley(float freq, dur beat) {
    Wurley osc => Echo echo => NRev rev => Envelope env => Pan2 pan => dac;
    freq => osc.freq;
    gainSet => osc.gain;
    
    Std.rand2f(-1,1) => pan.pan;
    
    echo => HPF filt => echo;
    1.5*beat => echo.max => echo.delay;
    .5 => echo.mix => echo.gain;
    .5  => filt.gain;
    .5 => rev.gain;
    .2 => rev.mix;
    1.5*osc.freq() => filt.freq;
    15 => filt.Q;
    
    4*beat => env.duration;

    1 => osc.noteOn;
    1 => env.keyOn;
    6*beat => now;
    1 => env.keyOff;
    6*beat => now;
    
}

fun void oneNoteBell(float freq, dur beat) {
    TubeBell osc => Echo echo => NRev rev => Envelope env => Pan2 pan => dac;
    freq => osc.freq;
    gainSet => osc.gain;
    
    Std.rand2f(-1,1) => pan.pan;
    
    echo => HPF filt => echo;
    1.5*beat => echo.max => echo.delay;
    .5 => echo.mix => echo.gain;
    .5  => filt.gain;
    .5 => rev.gain;
    .2 => rev.mix;
    1.5*osc.freq() => filt.freq;
    15 => filt.Q;
    
    4*beat => env.duration;
    
    1 => osc.noteOn;
    1 => env.keyOn;
    6*beat => now;
    1 => env.keyOff;
    6*beat => now;
    
}