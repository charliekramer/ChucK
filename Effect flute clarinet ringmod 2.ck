.3 => float gainSet;

Flute sin => Gain gain => dac;
Clarinet tri => gain => dac;

gainSet => sin.gain => tri.gain;

TriOsc LFO1 => blackhole;
TriOsc LFO2 => blackhole;

60./120.*.5 => float beatSec;
beatSec::second => dur beat;

33 => float baseFreq;
.133/1 => float scaleLFO; // .125 for high pitch


.1*scaleLFO => LFO1.freq;
.05 => LFO1.gain;

.14*scaleLFO => LFO2.freq;
.5 => LFO2.gain;

3 => gain.op;

while (true) {
    (1+LFO1.last())*baseFreq => sin.freq;
    (1+LFO2.last())*baseFreq => tri.freq;
    1 => sin.noteOn;
    1 => tri.noteOn;
    beat => now;
         
}