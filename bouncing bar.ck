
.2 => float gainSet;
30::second => dur length;
30::second => dur outro;

ModalBar bar => Echo echoL => Gain gainL => NRev revL => Pan2 panL => dac;
gainL => Echo echoR => PitShift pitch => NRev revR => Pan2 panR => dac;

gainSet => bar.gain;

57  => float midiBase;

[0., -5., -7.,2.,4.,5.,7.,9., 11.,12.] @=> float notes[];

2::second*1 => dur beat; //*1.5, etc

beat - (now % beat) => now;

2*beat => echoL.max => echoR.max;
2*beat => echoL.delay;
.7 => echoL.gain;
.7 => echoL.mix;
echoL => echoL;

.25*beat => echoR.delay; //*1.5
.7 => echoR.gain;
.7 => echoR.mix;
echoR => echoR;

-.5 => panL.pan;
.5 => panR.pan;

spork~LFO_revR(.05,.9);
spork~LFO_revL(.04,.9);

now + length => time future;

while (now < future) {
    
    1 => bar.noteOn;
    //Math.pow(1.5,Std.rand2(-8,2))*.25*beat => echoR.delay;
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)])/Std.mtof(midiBase) => pitch.shift;
    beat => now;
    1 => bar.noteOff;
    beat => now;
    
    
}

outro => now;

fun void LFO_revR(float freq, float max) {
    SinOsc LFO => blackhole;
    freq => LFO.freq;
    while (true) {
        max*(1+LFO.last())/2. => revR.mix;
        1::ms => now;
        }
}

fun void LFO_revL(float freq, float max) {
    SinOsc LFO => blackhole;
    freq => LFO.freq;
    while (true) {
        max*(1+LFO.last())/2. => revL.mix;
        1::ms => now;
    }
}
