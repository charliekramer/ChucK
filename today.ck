.5 => float gainSet;

30::second*2 => dur length;
15::second*2 => dur outro;

ModalBar osc => NRev rev => Echo echo => Pan2 pan => dac;
gainSet => osc.gain;

62-12 => float midiBase;

.55::second => dur beat;

1.5*beat => echo.max => echo.delay;
.3 => echo.mix;
.5 => echo.gain;
echo => echo;

Std.rand2f(-1,1) => pan.pan;

[17.,14.,7.,5.,7.,12.,10.,12.] @=> float notes[];
[1.66,3.34,.33,.33,1.34,.33,.33,3.34] @=> float beats[];

0 => float sum;

for (0 => int j; j < beats.cap(); j++) {
    sum+beats[j] => sum;
    }
    
<<< "sum,", sum>>>;

0 => int i;

now + length => time future;

while (now < future) {
    Std.mtof(midiBase+notes[i%notes.cap()]) => osc.freq;
    1 => osc.noteOn;
    beat*beats[i%beats.cap()] => now;
    i++;
}

outro => now;
