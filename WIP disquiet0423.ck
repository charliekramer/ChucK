Wurley wurley => HPF filt => NRev rev => dac;

60./120.*2 => float beatSec;
beatSec::second => dur beat;

660 => filt.freq;
2 => filt.Q;

57 => float midiBase;
[0.,7.,4.,7.,0., 5., 4., 12.] @=> float notes[];

0 => int i;

.1 => rev.mix;

0.9 => wurley.gain;

while (true) {
    
    pitchLFO();
    i++;
}

fun void pitchLFO () {
    SinOsc LFO => blackhole;
    .1 => LFO.gain;
    .1 => LFO.freq;
    now + beat => time future;
    while (now < future) {
        Std.mtof(midiBase + notes[i % notes.cap()])*(1+LFO.last()) => wurley.freq;
        1 => wurley.noteOn;
        1::samp => now;
    }
    1 => wurley.noteOff;
}
