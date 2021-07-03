.1 => float gainSet;
.125 => float beatFrac;
1::minute => dur length;
(60./120.)::second*8 => dur beat;
//[0,1,4,5,6,7,8,11,12] @=> int notes[];
[0,2,4,5,7,9,11,12] @=> int notes[];

49 => int midiBase;

.5 => float lambda;//parameter of exponential distrib for note lengths;

FrencHrn f => NRev r => Pan2 pan1 => dac;
r => Echo echo => LPF filt => Pan2 pan2 => dac;

.25 => pan1.pan;
-pan1.pan() => pan2.pan;

Std.mtof(midiBase)*2 => filt.freq;
2 => filt.Q;

2*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

.4 => r.mix;
gainSet => f.gain;


Std.mtof(midiBase) => f.freq;
1 => f.noteOn;
Std.rand2(1,8)*beat => now;   
1 => f.noteOff;
beatFrac*Std.rand2(1,8)*beat => now;   
Std.mtof(midiBase+7) => f.freq;
1 => f.noteOn;
Std.rand2(1,8)*beat => now;   
1 => f.noteOff;
beatFrac*Std.rand2(1,8)*beat => now;   

now + length => time future;

while (now < future) {
 
  -1/lambda*(Math.log(1-Std.rand2f(0,1))) => float maxLen;
  Std.rand2(0,Std.ftoi(1./maxLen)) => int maxNum; 
  playNotes(Std.rand2f(0,maxLen),Std.rand2(1,maxNum));  
    
}

15::second => now;

fun void playNotes(float avgLength, int avgNumber){
    
    Std.rand2(Std.ftoi(avgNumber/2.), avgNumber*2) => int nNotes; 
    
    Std.rand2f(0,1) => f.controlOne;
    Std.rand2f(0,1) => f.controlTwo;
    
    for (0 => int i; i<nNotes; i++) { 
        Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => f.freq;
        1 => f.noteOn;
        beatFrac*Std.rand2f(avgLength/2,avgLength*2)*beat => now;   
        1 => f.noteOff;
        beatFrac*Std.rand2f(avgLength/2,avgLength*2)*beat => now;   
    }
 
}