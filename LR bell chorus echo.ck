TubeBell bellL => Chorus chorL => PitShift pitchL => Echo echoL => dac.left;
TubeBell bellR => Chorus chorR => PitShift pitchR => Echo echoR => dac.right;

.2 => float gainSet;

1::minute => dur length;

gainSet => bellL.gain => bellR.gain;

57 => float midiBase;
Std.mtof(midiBase) => bellL.freq;
bellL.freq()*1.5 => bellR.freq;

.2 => chorL.modFreq;
1.5*chorL.modFreq() => chorR.modFreq;

.75 => chorL.modDepth => chorR.modDepth;

.75 => chorL.mix => chorR.mix;

.25::second => dur beat;

4*beat => echoL.max => echoR.max;
1.5*beat => echoL.delay => dur baseDelay;
1.5*echoL.delay() => echoR.delay;
.75 => echoL.mix => echoR.mix;
.85 => echoL.gain => echoR.gain;
echoL => echoR => echoL;

1 => bellL.noteOn => bellR.noteOn;

spork~pitchLFO(.1,.1);
spork~echoLFO(.1,.1);

10::second => now;

now + length => time future;

while (now < future) {
    Std.rand2f(0,1) => float x;
    if (x < .33) {
        1 => bellL.noteOn;
        <<< "strike L">>>;
    }
    else if (x < .66) {
        1 => bellR.noteOn;
        <<<"strike R">>>;
    }
    
    else {
        1 => bellL.noteOn => bellR.noteOn;
        <<< "strike L&R">>>;
    }
    
    Std.rand2(8,20)*beat => now;
    
    Std.rand2(8,20)*beat => now;
}

10::second => now;


fun void pitchLFO(float freq, float gain) {
    SinOsc LFOL => blackhole;
    SinOsc LFOR => blackhole;
    
    freq => LFOL.freq;
    1.5*LFOL.freq() => LFOR.freq;
    gain => LFOL.gain => LFOR.gain;
    
    while (true) {
        (1+LFOL.last()) => pitchL.shift;
        (1+LFOR.last()) => pitchR.shift;
        1::samp => now;
    }
}


fun void echoLFO(float freq, float gain) {
    SinOsc LFOL => blackhole;
    SinOsc LFOR => blackhole;
    
    freq => LFOL.freq;
    1.5*LFOL.freq() => LFOR.freq;
    gain => LFOL.gain => LFOR.gain;
    
    while (true) {
        (1+LFOL.last())*baseDelay => echoL.delay;
        (1+LFOR.last())*baseDelay*1.5 => echoR.delay;
        1::samp => now;
    }
}

