.7 => float gainSet;

3::minute => dur length;

5 => int n;

.2 => float prob; // prob generate new note;

59 => float midiBase;

Rhodey rhodes;

Std.mtof(midiBase) => rhodes.freq;

ADSR env[n];
NRev rev[n];
Pan2 pan[n];
Echo echo[n];

.9 => float revMix;

.5::second => dur beat;

for (0 => int i; i < n; i++) {
    rhodes => env[i] => echo[i] => rev[i] => pan[i] => dac;
    2*beat => echo[i].max;
    1.75*beat => echo[i].delay;
    .5 => echo[i].mix;
    .8 => echo[i].gain;
    echo[i] =>  echo[i];
    gainSet => rhodes.gain;
    (beat, 0*beat, 1, 2*beat) => env[i].set;
    -1 + 2.*i/(n*1.-1.) => pan[i].pan;
    //<<< pan[i].pan() >>>;
    revMix => rev[i].mix;
}

now + length => time future;

while (now < future) {   
     
    for (0 => int i; i < n; i++) {
        1 => rhodes.noteOn;
        1 => env[i].keyOn;
        beat => now;
        1 => env[i].keyOff;
    }
    
    5::second => now;
    
    if (Std.rand2f(0,1) > prob ) {
        <<< "generate new freq" >>>;
        Math.pow(1.5,Std.rand2(-1,1))*rhodes.freq() => rhodes.freq;
    }
    
    if (rhodes.freq() > 1000 || rhodes.freq() < 100) {
        <<< "out of bounds" >>>;
        Std.mtof(midiBase)*Std.rand2f(.9,1.1) => rhodes.freq;
    }



}

<<< " ending" >>>;

10*beat => now;

