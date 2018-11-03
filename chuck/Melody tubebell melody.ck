// tube bell melody

60./94. => float beattime; 
beattime::second => dur beat; 
beat - (now % beat) => now;

TubeBell bellL => Echo eL => NRev revL =>dac.left;
TubeBell bellR =>  Echo eR => NRev revR => dac.right;

0.1 => bellL.gain;
0.1 => bellR.gain;

Std.mtof(58+12) => bellL.freq;
Std.mtof(58+7) => bellR.freq;

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
