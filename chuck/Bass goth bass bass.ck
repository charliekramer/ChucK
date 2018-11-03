// modified https://www.youtube.com/watch?v=ezmpolryqUE

60./94. => float beatsec;
beatsec::second => dur beat;
beat - (now % beat) => now;

PulseOsc  osc => LPF f => Envelope e => NRev rev => dac;

Std.mtof(58-24) => osc.freq;
osc.freq()*4. => f.freq;

.8 => osc.gain;
.1 => rev.mix;

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
//[2./div, 2./div, 2./div ,2./div,2./div, 2./div, 3./div ,1./div] @=> float beats[];
[3*.25,.25, 3*.25,.25] @=> float beats[];


for (0 => int i; i < 1000000; i++) {
    beats[i % beats.size()] => float beatset;
    beatset::second => e.duration;
    Std.rand2f(.1,.5)=>osc.width;
    .5 => e.value;
    e.keyOff();
    (beatset*beatsec)::second => now;
}
