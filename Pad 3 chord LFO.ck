.1 => float gainSet;

30::second => dur length;

TriOsc sin[3];

SinOsc LFO[3];

NRev rev;

.1 => rev.mix;

Gain gain;
gainSet => gain.gain;

58 => float midiBase;

60./94.*5 => float beatSec;
beatSec::second => dur beat;

[0.,4.,7.] @=> float notes[];
[1.,1.,1.] @=> float LFOGains[];
[1./beatSec,.1/beatSec,.15/beatSec] @=> float LFOFreqs[];

for (0 => int i; i < sin.cap(); i++) {
    sin[i] => gain => rev => dac;
    Std.mtof(midiBase + notes[i]) => sin[i].freq;
    LFO[i] => blackhole;
    LFOGains[i] => LFO[i].gain;
    LFOFreqs[i] => LFO[i].freq;
}

//beat => now;

now + length => time future;

while (now < future) {
    
    for (0 => int i; i < sin.cap(); i++) {
        Std.fabs(LFO[i].last()) => sin[i].gain;
    }
    1::samp => now;
}

<<< " wind down">>>;

while (gain.gain() > gainSet*.01) {
    gain.gain()*.99 => gain.gain;
    10::ms => now;
    
}