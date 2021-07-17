.1 => float gainSet;

30::second => dur length;

Wurley osc; // tubebell, wurley, frenchrn; turn down gain for bell

gainSet => osc.gain;

ADSR env;


44 => float midiBase;

Std.mtof(midiBase) => osc.freq;

5::second => dur beat;

(beat,10::ms,1.,1.75*beat) => env.set;


2 => int n;

NRev rev[n];
Echo echo[n];


for (0 => int i; i<n; i++) {
    if (i == 0) {
        osc => rev[i] => echo[i];
        }
    else echo[i-1] => rev[i] => echo[i];
    
    .7 => rev[i].mix;
    2*beat => echo[i].max;
    Std.rand2f(.5,1.5)*.75*beat => echo[i].delay;
    .6 => echo[i].mix;
    .6 => echo[i].gain;
    echo[i] => echo[i];
    
}

echo[n-1] => env => Dyno dyn => NRev revLast => Pan2 pan => dac;

.2 => revLast.mix;

Std.rand2f(-.25,.25) => pan.pan;

1 => osc.noteOn;

now + length => time future;

while (now < future) {
    1 => env.keyOn;
    2*beat => now;
    1 => env.keyOff;
    2*beat => now;
}

beat => now;


