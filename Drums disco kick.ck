.1 => float gainSet;
30::second => dur length;
44 => float midiBase;
5.25::second => dur beat;

1.1 => float a; // 2 for disco beat
.1 => float b; // 1 for disco beat

0 => int drop; // if you want to drop the pitch after it reaches unison
1 => int rando; //randomize number of beats

SinOsc sin1 => Chorus cho1 => Echo echo1 => NRev rev1 => Pan2 pan1 => dac;
SinOsc sin2 => Chorus cho2 => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;
Envelope env => blackhole;

Std.rand2f(.1,.3) => cho1.modFreq;
Std.rand2f(.1,.3) => cho2.modFreq;

Std.rand2f(.75,1.5)*beat => echo1.max => echo1.delay;
Std.rand2f(.75,1.5)*beat => echo2.max => echo2.delay;
.5 => echo1.gain => echo2.gain;
.7 => echo1.mix => echo2.mix;
echo1 => echo1;
echo2 => echo2;

.2 => rev1.mix => rev2.mix;

Std.rand2f(-1,1) => pan1.pan;
-pan1.pan() => pan2.pan;

gainSet => sin1.gain => sin2.gain;

Std.mtof(midiBase) => sin1.freq => sin2.freq;

beat - (now % beat) => now;

1*beat => env.duration;

now + length => time end;

while (now < end) {
    
    1 => env.keyOn;
    now + beat*(1+rando*Std.rand2f(.9,1.1)) => time future;
    while (now < future) {
        (a-b*env.value())*Std.mtof(midiBase) => sin2.freq;
        1::samp => now;
    }
    1 => env.keyOff;
    now + beat*(1+rando*Std.rand2f(.9,1.1)) =>  future;
    while (now < future) {
        if (drop == 1) env.value()*Std.mtof(midiBase) => sin2.freq;
        1::samp => now;
    }
    Std.mtof(midiBase) => sin2.freq;
}
<<< "ending disco">>>;

0 => sin1.gain => sin2.gain;

10*beat => now;