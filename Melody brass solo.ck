Brass brass => Echo echo => NRev rev => Gain g => dac;

1*4 => float gainSet;
gainSet => g.gain;

120::second => dur length;

60./94.*4 => float beatSec;
beatSec::second => dur beat;

59+12 => float midiBase;// too low -> doesn't sound
[0.,1.,3.,4.,5.,6.,7.,11.,12.] @=> float notes[];
//[0.,2.,4.,5.,6.,7.,11.,12.] @=> float notes[];


.2 => rev.mix;

5*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

Std.mtof(midiBase) => brass.freq;

1 => brass.noteOn;
1 => brass.startBlowing;
.5 => brass.volume; //.5
.57 => brass.lip; //.57
.0 => brass.slide; //0
.3 => brass.vibratoFreq; //.3
.5 => brass.vibratoGain; //.5
.1 => brass.rate;//.1

float beatDiv;

now + length => time future;

while (now < future) {
    
    Std.rand2f(.5,.6) => brass.lip;
    Std.rand2f(0.,.4) => brass.rate;
    Std.rand2f(0.,.1) => brass.slide;
    Std.rand2f(0.,2.) => brass.vibratoFreq;
    Std.rand2f(0.,.5) => brass.vibratoGain;
   
    Std.rand2f(0,2) => beatDiv;
    
    <<< " lip, ", brass.lip(), " rate, ", brass.rate(), " slide, ", brass.slide(), " vFreq, ", brass.vibratoFreq(), " vGain,", brass.vibratoGain(),
     "beatDiv", beatDiv >>>;
    
    
    Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => brass.freq;
    1 => brass.startBlowing;
    beatDiv*beat => now;
    
    1 => brass.stopBlowing;
    (2-beatDiv)*beat => now;
    
}