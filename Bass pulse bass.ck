// modified https://www.youtube.com/watch?v=ezmpolryqUE

.1 => float gainSet;

60./94 => float beatsec;
beatsec::second => dur beat;
beat - (now % beat) => now;

PulseOsc  osc => LPF f => LPF f2 => Envelope e => dac;

Std.mtof(55-24) => osc.freq;
osc.freq()*3 => f.freq => f2.freq;
2 => f.Q => f2.Q;

gainSet => osc.gain;


/*
// function to sweep width

fun void widthSweep (PulseOsc o, dur t) {
    o.width(0.2);
    0.1 => float oDelta;
    while (true) {
        o.width()+oDelta => o.width;
        if (o.width() >.8 || o.width() < .2) oDelta*(-1.) => oDelta;
        t => now;
    }
}

spork~widthSweep(osc, 100::ms);
*/

//[.25, .125, 1.-.375] @=> float beats[];

8=> int div;

//[.25, .125, 1.-.375] @=> float beats[];
//[.25, .125, .375,.25] @=> float beats[];
[2./div, 2./div, 2./div ,2./div,2./div, 2./div, 3./div ,1./div] @=> float beats[];

for (0 => int i; true; i++) {
    beats[i % beats.size()] => float beatset;
    beatset*beat*2. => e.duration;
    Std.rand2f(.2,.7)=>osc.width;
    .9 => e.value;
    e.keyOff();
    beatset*beat*2. => now;
}
