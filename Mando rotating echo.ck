.01 => float gainSet;
30::second => dur length;

Mandolin osc => Gain gain => Pan2 panOsc => dac; // also good with stifkarp
gain => Echo echo => Pan2 panEcho => dac;

gainSet => osc.gain;

57=> float midiBase;
Std.mtof(midiBase) => osc.freq;

SinOsc panLFO => blackhole;

.5::second*2 => dur beat;

0 => osc.gain;

.125*beat => dur beatDiv;

beatDiv - (now % (beatDiv)) => now; // this might fix phase cancellation?

gainSet => osc.gain;



spork~echoPanLFO(1,.2); // glitches with gain = 1?

2*beat => echo.max;
1.5*beat => echo.delay;
1 => echo.mix;
.7 => echo.gain;

now + length => time future;

while (now < future) {
    
    1 => osc.noteOn;
    .25*beat => now;
    
    1 => osc.noteOn;
    .25*beat => now;
    
    .5*beat => now;
}

10*beat => now;

fun void echoPanLFO(float gain, float rate) {
    gain => panLFO.gain;
    rate => panLFO.freq;
    while (true) {
        panLFO.last() => panOsc.pan;
        -panLFO.last() => panEcho.pan;
        1::samp => now;
     }
 }