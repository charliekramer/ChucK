// https://www.youtube.com/watch?v=ezmpolryqUE

60./120.*2. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

PulseOsc  osc => LPF f => Envelope e => dac;

Std.mtof(36) => osc.freq;
osc.freq()*2. => f.freq;
10 => f.Q;

//[.25, .125, 1.-.375] @=> float beats[];

[.25, .125, (1.-(.5+.125)),.25] @=> float beats[];

.5 => osc.gain;


for (0 => int i; true; i++) {
    beats[i % beats.size()] => float beatset;
    beatset*beat => e.duration;
    1. => e.value;
    e.keyOff();
    beatset*beat => now;
}
