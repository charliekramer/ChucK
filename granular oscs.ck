

.05 => float gainSet;
47+12+12 => float midiBase;
90::second => dur length;
60::second => dur outro;

SinOsc sin => Envelope envSin => Echo echoSin => NRev revSin => Dyno dyn1 => Pan2 panSin => dac;
SqrOsc sqr => Envelope envSqr => Echo echoSqr => NRev revSqr => Dyno dyn2 => Pan2 panTri => dac;
TriOsc tri => Envelope envTri => Echo echoTri => NRev revTri => Dyno dyn3 => Pan2 panSqr => dac;
SawOsc saw => Envelope envSaw => Echo echoSaw => NRev revSaw => Dyno dyn4 => Pan2 panSaw => dac;

Std.rand2f(-1,0) => panSin.pan;
-panSin.pan() => panTri.pan;
Std.rand2f(0,1) => panSqr.pan;
-panSqr.pan() => panSaw.pan;


.50::second => echoSin.max => echoSin.delay;
.51::second => echoSqr.max => echoSqr.delay;
.52::second => echoTri.max => echoTri.delay;
.53::second => echoSaw.max => echoSaw.delay;
.7 => echoSin.mix => echoSin.gain;
.7 => echoSqr.mix => echoSqr.gain;
.7 => echoTri.mix => echoTri.gain;
.7 => echoSaw.mix => echoSaw.gain;
echoSin => echoSin;
echoSqr => echoSqr;
echoTri => echoTri;
echoSaw => echoSaw;

.7 => revSin.mix => revSqr.mix => revTri.mix => revSaw.mix;

gainSet => sin.gain;
gainSet*.5 => sqr.gain;
gainSet*.4 => saw.gain;
gainSet*.9 => tri.gain;

.999 => float cutSin;
.999 => float cutSqr;
.999 => float cutTri;
.999 => float cutSaw;

SinOsc LFOSin => blackhole;
SinOsc LFOSqr => blackhole;
SinOsc LFOTri => blackhole;
SinOsc LFOSaw => blackhole;

.10 => LFOSin.freq;
.11 => LFOSqr.freq;
.12 => LFOTri.freq;
.13 => LFOSaw.freq;

1::ms => dur beat;

now + length => time future;

while (now < future) {
    
    Std.mtof(midiBase)*Std.rand2f(.99,1.01) => sin.freq;
    Std.mtof(midiBase)*Std.rand2f(.99,1.01) => saw.freq;
    Std.mtof(midiBase)*Std.rand2f(.99,1.01) => sqr.freq;
    Std.mtof(midiBase)*Std.rand2f(.99,1.01) => tri.freq;
    
    (1+LFOSin.last()) => cutSin;
    (1+LFOSqr.last()) => cutSqr;
    (1+LFOTri.last()) => cutTri;
    (1+LFOSaw.last()) => cutSaw;
    
    if (Std.rand2f(0,1) > cutSin) {
        1 => envSin.keyOn;
        }
        
    if (Std.rand2f(0,1) > cutSqr) {
            1 => envSqr.keyOn;
        }
    
    if (Std.rand2f(0,1) > cutTri) {
        1 => envTri.keyOn;
    }    
    
    if (Std.rand2f(0,1) > cutSin) {
        1 => envTri.keyOn;
    }    
    
    beat => now;
    
    1 => envSin.keyOff => envSqr.keyOff => envTri.keyOff => envSaw.keyOff;
    
    }
    
    
outro => now;