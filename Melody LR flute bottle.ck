
.2 => float gainSet;

2*60::second => dur length;
4*60::second => dur outro;

Flute flute1R => Echo echoR => NRev revR => dac.right;
Flute flute2R => echoR => revR => dac.right;
BlowBotl band1L => Echo echoL => NRev revL => dac.left;
BlowBotl band2L => echoL => revL => dac.left;

gainSet => flute1R.gain => flute2R.gain => band1L.gain => band2L.gain;

.2 => revR.mix => revL.mix;

57 => float midiBase;
[0., 2., 5.,7., 12.] @=> float notes[];

1.5::second*8 => dur beat;
beat - (now % beat) => now;

5*beat => echoR.max => echoL.max;
1.5*beat => echoR.delay;
1.5*beat => echoL.delay;
.75 => echoR.gain => echoL.gain;
.75 => echoR.mix => echoL.mix;
echoR => echoR;
echoL => echoL;

now + length => time future;

while (now < future) {
    
    Std.mtof(midiBase + notes[Std.rand2(0,notes.cap()-1)]) => flute1R.freq; 
    flute1R.freq() => band1L.freq;
    flute1R.freq()*1.5 => flute2R.freq;
    flute2R.freq() => band2L.freq;
    
    1 => flute1R.noteOn;
    beat => now;

    1 => flute2R.noteOn;
    beat => now;
    
    1 => flute1R.noteOff;
    1 => flute2R.noteOff;
    
    1 => band1L.noteOn;
    beat => now;
    
    1 => band2L.noteOn;
    beat => now;
    
    1 => band1L.noteOff;
    1 => band2L.noteOff;
    
}

outro => now;