.3 => float gainSet;
.01 => float delta;
53 => float midiBase;
90::second => dur length;

.75::second*.25*2*2*2 => dur beat;

Echo sinEcho => NRev sinRev => Pan2 sinPan => dac;
Echo triEcho => NRev triRev => Pan2 triPan => dac;
Echo sqrEcho => NRev sqrRev => Pan2 sqrPan => dac;

.7 => sinRev.mix => triRev.mix => sqrRev.mix;

SinOsc sin => Envelope sinEnv => sinEcho;
TriOsc tri => Envelope triEnv => triEcho;
SqrOsc sqr => Envelope sqrEnv => sqrEcho;
gainSet => sin.gain => tri.gain;
gainSet*.15 => sqr.gain;

Std.rand2f(-1,1) => triPan.pan;
-triPan.pan() => sqrPan.pan;

4*beat => sinEcho.max => triEcho.max => sqrEcho.max;
Std.rand2(1,4)*.5*beat => sinEcho.delay;
Std.rand2(1,4)*.5*beat => triEcho.delay;
Std.rand2(1,4)*.5*beat => sqrEcho.delay;
.7 => sinEcho.gain => triEcho.gain => sqrEcho.gain;
.7 => sinEcho.mix => triEcho.mix => sqrEcho.mix;
sinEcho => sinEcho;
triEcho => triEcho;
sqrEcho => sqrEcho;

now + length => time future;

while (now < future) {
 
 fireNote();
    
}

20*beat => now;

fun void fireNote() {
   
    Std.mtof(midiBase)*Std.rand2f(1-delta,1+delta) => sin.freq;
    Std.mtof(midiBase)*Std.rand2f(1-delta,1+delta) => tri.freq;
    Std.mtof(midiBase)*Std.rand2f(1-delta,1+delta) => sqr.freq;
    
    Std.rand2(0,1) => sinEnv.keyOn;
    Std.rand2(0,1) => triEnv.keyOn;
    Std.rand2(0,1) => sqrEnv.keyOn;
    beat/Std.rand2(1,4) => dur partBeat;
    partBeat => now;
    1 => sinEnv.keyOff;
    1 => triEnv.keyOff;
    1 => sqrEnv.keyOff;
    beat - partBeat => now;
    
    
    }