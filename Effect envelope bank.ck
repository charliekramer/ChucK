SinOsc sin => Envelope envSin => NRev revSin =>  Echo echoSin => Pan2 panSin => dac;
TriOsc tri => Envelope envTri => NRev revTri =>  Echo echoTri => Pan2 panTri => dac;
SqrOsc sqr => Envelope envSqr => NRev revSqr =>  Echo echoSqr => Pan2 panSqr => dac;

SinOsc LFOSin => blackhole;
SinOsc LFOTri => blackhole;
SinOsc LFOSqr => blackhole;

.05 => LFOSin.freq;
.04 => LFOTri.freq;
.03 => LFOSqr.freq;

30::second => dur length;

.1 => float gainSet => sin.gain => tri.gain => sqr.gain;

//[0.,4.,5.,7.,9.,11] @=> float notes[];
[0.,12] @=> float notes[];


45 => float midiBase;
.5 => float sinKeyProb;
.5 => float triKeyProb;
.5 => float sqrKeyProb;
1 => int sinRandNotes;
1 => int triRandNotes;
1 => int sqrRandNotes;

Std.mtof(midiBase) => sin.freq => tri.freq => sqr.freq;

.5 => revSin.mix => revTri.mix => revSqr.mix;

100::ms => dur dur1; // 100 ms for fluttr, 1000 for waves

4*dur1 => echoSin.max => echoTri.max => echoSqr.max;
1.5*dur1 => echoSin.delay=> echoTri.delay=> echoSqr.delay;
.5 => echoSin.gain => echoTri.gain => echoSqr.gain;
.5 => echoSin.mix => echoTri.mix => echoSqr.mix;
echoSin => echoSin;
echoTri => echoTri;
echoSqr => echoSqr;

dur1 => envSin.duration => envTri.duration => envSqr.duration;
.5 => float fraction;

now + length => time future;

while (now < future) {
    
    LFOSin.last() => panSin.pan;
    LFOTri.last() => panTri.pan;
    LFOSqr.last() => panSqr.pan; 
    spork~keySin(sinKeyProb,sinRandNotes);
    spork~keyTri(triKeyProb,triRandNotes);
    spork~keySqr(sqrKeyProb,sqrRandNotes);
    
    dur1 => now;

}

10::second => now;

fun void keySin(float prob, int randNotes) {
    if (Std.rand2f(0,1) > prob) {
        1 => envSin.keyOn;
        if (randNotes == 1) {
            Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => sin.freq;
        }
        dur1 => now;
        1 => envSin.keyOff;
        dur1*fraction => now;
    }
}

fun void keyTri(float prob, int randNotes) {
    if (Std.rand2f(0,1) > prob) {
        1 => envTri.keyOn;
        if (randNotes == 1) {
            Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => tri.freq;
        }
        dur1 => now;
        1 => envTri.keyOff;
        dur1*fraction => now;
    }
}

fun void keySqr(float prob, int randNotes) {
    if (Std.rand2f(0,1) > prob) {
        1 => envSqr.keyOn;
        if (randNotes == 1) {
            Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => sqr.freq;
        }
        dur1 => now;
        1 => envSqr.keyOff;
        dur1*fraction => now;
    }
}

        