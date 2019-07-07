60./94.=> float beatsec; //just to synchbeat - (now % beat) => now;

beatsec::second => dur beat;
beat - (now % beat) => now;

Wurley wurley => Echo echo => NRev rev => Dyno d => Pan2 p => dac;  //basic soundchain
Echo e2 => dac.left; //auxiliary echoes left and right
Echo e3 => dac.right;

echo => e2;
echo => e3;

Std.mtof(55-24) => wurley.freq => float baseFreq; // base frequency for the ascending/descending notes
0.05 => wurley.gain; //wurley parameters
.1 => wurley.lfoSpeed;
0.9 => wurley.lfoDepth;

0.2 => rev.mix; //echo/reverb parameters

10::second => echo.max => e2.max => e3.max;

.1::second => dur auditionTime; //how long to play "audition" of echo chain components as it's constructed

beat*1.5 => echo.delay;
beat*.4 => e2.delay;
beat*1.25 => e3.delay;

// set up echo chain piece by piece

0.0 => echo.mix => e2.mix => e3.mix;
1=> wurley.noteOn;
auditionTime => now;

0.5 => echo.mix;
1=> wurley.noteOn;
//<<< "echo on">>>;
auditionTime => now;

echo => echo;
0.7 => echo.gain;
1=> wurley.noteOn;
//<<< "feedback">>>;
auditionTime => now;

0.5 => e2.mix;
0.7 => e2.gain;
1=> wurley.noteOn;
<<< "e2 on">>>;
auditionTime => now;

e2 => e2;
1=> wurley.noteOn;
//<<< "e2 feedback">>>;
auditionTime=> now;

0.5 => e3.mix;
0.7 => e3.gain;
//<<< "e3 on">>>;
1=> wurley.noteOn;
auditionTime => now;

e3 => e3;
1=> wurley.noteOn;
//<<< "e3 feedback">>>;
auditionTime => now;

//now set up nested loops to generate pitches from base pitch by raising
// frequency multiplier to the power i+j

1.5 => float freqMult; //also try 1.4, 1.5,1.8; .9, .99,.5 for weird results
5 => int iMax;
5 => int jMax;
2::second => dur perfTime; //how long to play each pitch


while (true) {
    for (1 => int i; i <= iMax; i++) {
        for (0 => int j; j < jMax; j++) {
           baseFreq*Math.pow(freqMult,i+j) => wurley.freq;
           1 => wurley.noteOn;
 //          <<< "freq", wurley.freq(), "freqMult", freqMult, "i j", i, j >>>;
          perfTime => now;
      }
    }
}
        
