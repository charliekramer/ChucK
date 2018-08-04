// tube bell melody

60./154. => float beattime; 
beattime::second => dur beat; 
beat - (now % beat) => now;

TubeBell bellL => NRev revL => Echo eL => dac.left;
TubeBell bellR => NRev revR => Echo eR => dac.right;

0.5 => bellL.gain;
0.5 => bellR.gain;

Std.mtof(57+12) => bellL.freq;
Std.mtof(57+7) => bellR.freq;

0.5 => revL.mix;
0.5 => revR.mix;

1::second => eL.delay;
1.5::second => eR.delay;

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
