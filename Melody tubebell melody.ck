// tube bell melody; church bells

.03 => float gainSet;
59 => float midiBase;

60./80. => float beattime; 
beattime::second => dur beat; 
beat - (now % beat) => now;

TubeBell bellL => Echo eL => NRev revL =>dac.left;
TubeBell bellR =>  Echo eR => NRev revR => dac.right;

gainSet => bellL.gain;
gainSet => bellR.gain;

Std.mtof(midiBase+12) => bellL.freq;
Std.mtof(midiBase+7) => bellR.freq;

0.5 => revL.mix;
0.5 => revR.mix;

10::second => eL.max => eR.max;
beat*1.5 => eL.delay;
beat*.75 => eR.delay;

0.3 => eL.mix;
0.3 => eR.mix;

1 => bellR.noteOn;
1 => bellL.noteOn;

while (true) {
    
    1 => bellL.noteOn;
    3*beat => now;
    2 => bellR.noteOn;
    5*beat => now;
    
    
}
