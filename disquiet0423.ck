Wurley wurley => HPF filt => NRev rev => Gain gain=> dac;
SinOsc sin => gain => blackhole;
1 => sin.gain;
3 => gain.op;

2 => wurley.gain;

60./120.*1 => float beatSec;
beatSec::second => dur beat;

660 => filt.freq;
2 => filt.Q;

57.1 => float midiBase;
[0.,7.,4.,7.,0., 5., 4., 12.] @=> float notes[];

0 => int i;

.1 => rev.mix;

0.9 => wurley.gain;

now + 120::second => time future;

while (true) {
    
    pitchLFO();
    i++;
    if (i%8 == 0) Std.rand2f(33,550) => sin.freq;
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
