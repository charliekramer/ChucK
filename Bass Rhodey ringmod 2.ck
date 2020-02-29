.2*5 => float gainSet;

Rhodey sin => Gain gain => dac;
Rhodey tri => gain => dac;

gainSet => gain.gain;

TriOsc LFO1 => blackhole;
TriOsc LFO2 => blackhole;

60-36-12 => float midiBase;

60./120.*4 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

.1 => LFO1.freq;
.05 => LFO1.gain;

.14 => LFO2.freq;
.5 => LFO2.gain;

3 => gain.op;

while (true) {
    (1+LFO1.last())*Std.mtof(midiBase) => sin.freq;
    (1+LFO2.last())*Std.mtof(midiBase) => tri.freq;
    1 => sin.noteOn;
    1 => tri.noteOn;
    beat => now;
         
}