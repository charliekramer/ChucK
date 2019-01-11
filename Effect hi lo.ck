SqrOsc s[2];

.2 => s[0].width;
.1 => s[1].width;

50 => int midiBase1;

.1 => float spread1;

80 => int midiBase2;

.1 => float spread2;

60./120. => float beatsec;

beatsec::second => dur beat;

beat - (now % beat) => now;

beat/4 => dur dur1;
beat/4 => dur dur2;

s[0] => ADSR adsr => Echo echo => NRev rev1 => dac;
s[1] =>  adsr => echo => PRCRev rev2 => dac;

10*dur1 => echo.max;
1.5*dur1 => echo.delay;
.3 => echo.gain;
.2 => echo.mix;
echo => echo;

adsr.set(.01*dur1,.01*dur1, .9, .01*dur1);

.9 => rev1.mix;
.9 => rev2.mix;

while (true) {
	
Std.rand2f(.1,.3) => spread1;
Std.rand2f(0,.5) => s[0].width;
Std.rand2f(0,.5) => s[1].width;

<<< "width1", s[0].width(), "width2", s[1].width(), "spread1", spread1>>>;

Std.mtof(midiBase1)*(1+spread1) => s[0].freq;
Std.mtof(midiBase1)*(1-spread1) => s[1].freq;

1 => adsr.keyOn;

.2*dur1 =>now;

1 => adsr.keyOff;

7.8*dur1 => now;

	
Std.rand2f(.4,.7) => spread2;
Std.rand2f(0,.5) => s[0].width;
Std.rand2f(0,.5) => s[1].width;

<<< "width1", s[0].width(), "width2", s[1].width(), "spread2", spread1>>>;



Std.mtof(midiBase2)*(1+spread2) => s[0].freq;
Std.mtof(midiBase2)*(1-spread2) => s[1].freq;

adsr.set(.01*dur2,.01*dur2, .9, .5*dur2);


1 => adsr.keyOn;

.2*dur2 =>now;

1 => adsr.keyOff;

7.8*dur2 => now;

}




