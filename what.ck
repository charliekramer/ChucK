.2 => float gainSet;
57=> float midiBase;
30::second => dur length;
15::second => dur outro;

.5::second => dur beat;

beat - (now % beat) => now;

now + length => time future;
while (now < future) {
    spork~playNote();
    2*beat => now;
}
5*beat => now;
outro=> now;



fun void playNote() {
    Rhodey osc => Echo echo => Pan2 pan => dac;
    
    gainSet => osc.gain;
    
    Std.mtof(midiBase) => osc.freq;
    
    4*beat/Std.rand2(1,24 ) => echo.max => echo.delay;
    .5 => echo.mix => echo.gain;
    echo => echo;
    
    Std.rand2f(-1,1) => pan.pan;
    
    Std.rand2(1,8) => int nNotes;
    
    for (0 => int i; i < nNotes; i++) {
        1 => osc.noteOn;
        beat => now;
        }
    beat => now;
    
    }