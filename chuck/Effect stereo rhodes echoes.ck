Rhodey rhodesL;
Rhodey rhodesR;
Echo echoL;
Echo echoL2;
Echo echoR;
Echo echoR2;

60./94. => float beatSec;

beatSec::second => dur beat;

beat - (now % beat) => now;

rhodesL => echoL => dac.left;
echoR => dac.right;

57-12 => int midiNote;
Std.mtof(midiNote) => float baseFreq => rhodesL.freq =>rhodesR.freq;

echoL => echoR => echoL ;;
echoL => echoL2 => dac;
echoR => echoR2 => dac;
echoL2 => echoL2;
echoR2 => echoR2;


5::second => echoL.max => echoR.max => echoL2.max => echoR2.max;
beat/2.  => echoL.delay;
echoL.delay()*1.5 => echoL2.delay;
beat/2.*3 => echoR.delay;
echoR.delay()/1.5 => echoR2.delay;

.5 => echoR.gain => echoL.gain;
.7 => echoR2.gain => echoL2.gain;
1 => echoR.mix => echoL.mix;
1 => echoR2.mix => echoL2.mix;

2. => float freqWobble;

while (true) {
	
1 => rhodesL.noteOn;
1 => rhodesR.noteOn;
beat => now;  /// 1000 for notes, 100 for beats

Std.rand2f(baseFreq-freqWobble,baseFreq+freqWobble) => rhodesL.freq => rhodesR.freq;
//Std.rand2f(110,330) => rhodesL.freq => rhodesR.freq;

}