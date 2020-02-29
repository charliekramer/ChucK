
Rhodey sin => Gain gain => dac;
Rhodey tri => gain => dac;

TriOsc LFO1 => blackhole;
TriOsc LFO2 => blackhole;

60./120. => float beatSec;
beatSec::second => dur beat;

.1 => LFO1.freq;
.05 => LFO1.gain;

.14 => LFO2.freq;
.5 => LFO2.gain;

3 => gain.op;

while (true) {
    (1+LFO1.last())*44 => sin.freq;
    (1+LFO1.last())*44 => tri.freq;
    1 => sin.noteOn;
    1 => tri.noteOn;
    beat => now;
         
}