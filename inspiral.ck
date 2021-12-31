.5 => float gainSet;
.25::second => dur beat;
300::second => dur length;
47 => float midiBase;
4 => int maxNotes;


[0.,3.,7.,9.,10.,12.] @=> float notes[];

10::second => now;

<<< "starting in 5" >>>;
1::second => now;

<<< "starting in 4" >>>;
1::second => now;

<<< "starting in 3" >>>;
1::second => now;

<<< "starting in 2" >>>;
1::second => now;

<<< "starting in 1" >>>;
1::second => now;

now + length => time future;

while (now < future) {
    
    spork~play();
    maxNotes*beat => now;
    
    }

20*beat => now;

fun void play() {
 
 Rhodey osc => Echo echo => NRev rev => Pan2 pan => dac;
 echo => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;
 
 1.5*beat => echo.max => echo.delay;
 .7 => echo.mix;
 .5 => echo.gain;
 echo => echo;
 
 1.75*beat => echo2.max => echo2.delay;
 .7 => echo2.mix;
 .5 => echo2.gain;
 echo2 => echo2;
 
 Std.rand2f(-1,1) => pan.pan;
 -pan.pan() => pan2.pan;
 
 .5 => rev.mix => rev2.mix;
 
 gainSet => osc.gain;
 Std.rand2(1,maxNotes) => int nNotes;
 
 for (0 => int i; i < nNotes; i++) {
     Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc.freq;
     1 => osc.noteOn;
     Std.rand2f(.5,2)*beat => now;
     }
     
     10*beat => now;
    
}