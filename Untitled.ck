SawOsc saw => LPF filt => Echo echo => Pan2 pan => dac;

SinOsc LFO1 => blackhole; // for filter
SinOsc LFO1 => blackhole; // for pan 


59 => float midiBase;

60./80. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;
