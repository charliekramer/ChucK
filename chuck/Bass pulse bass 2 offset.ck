// https://www.youtube.com/watch?v=ezmpolryqUE

60./154. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

PulseOsc  osc => LPF f => Envelope e => dac;
220 => f.freq;
Std.mtof(9+12+12) => osc.freq;

//[.25, .125, 1.-.375] @=> float beats[];

[.25, .125, (1.-(.5+.125)),.25] @=> float beats[];


for (0 => int i; true; i++) {
    beats[i % beats.size()] => float beatset;
    beatset::second => e.duration;
    .1 => e.value;
    e.keyOff();
    beatset::second => now;
}
