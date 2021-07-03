.1 => float gainSet;
.125 => float beatFrac;
.5::minute => dur length;
(60./120.)::second*4 => dur beat;
[0,1,4,5,6,7,8,11,12] @=> int notes[];
49 => int midiBase;

FrencHrn f => NRev r => dac;
.2 => r.mix;
gainSet => f.gain;

now + length => time future;

while (now < future) {
 
 Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => f.freq;
 1 => f.noteOn;
 beatFrac*Std.rand2(1,8)*beat => now;   
 1 => f.noteOff;
 beatFrac*Std.rand2(1,2)*beat => now;   
    
}

5::second => now;