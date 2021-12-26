.25 => float gainSet;
47 => float midiBase;
30::second => dur length;

.9 => float cutoff;

[midiBase,midiBase+2.,midiBase+5.,midiBase+7.,midiBase+12.] @=> float bases[];

[0.,5.,7.] @=> float notes[];

Wurley osc => Echo echo1 => Pan2 pan1 => dac;
osc => Echo echo2 => Pan2 pan2 => dac;

Std.rand2f(-1,1) => pan1.pan;
-pan1.pan() => pan2.pan;

gainSet => osc.gain;
Std.mtof(midiBase) => osc.freq;

.75::second => dur beat;

beat - (now % beat) => now;

1.5*beat => echo1.max => echo1.delay;
.7 => echo1.gain => echo1.mix;
echo1 => echo1;

1.75*beat => echo2.max => echo2.delay;
.7 => echo2.gain => echo2.mix;
echo2 => echo2;


0 => int i;

now + length => time future;
while (now < future) {
    
    if ((i % notes.cap()) == 0) {
        <<< " update i", i>>>;
        bases[Std.rand2(0,bases.cap()-1)] => midiBase;
        }
    
    Std.mtof(midiBase+notes[i % notes.cap()]) => osc.freq;
    1 => osc.noteOn;
    Std.rand2(1,3)*beat => now;
    if (Std.rand2f(0,1) > cutoff) {
        <<< "pause" >>>;
        Std.rand2(5,10)*beat => now;
        }
    i++;
    
    }

20*beat => now;