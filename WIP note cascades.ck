
ModalBar osc1 => Echo echo => NRev rev => dac;

80 => float startNote;
20 => float endNote;
startNote*Std.rand2f(.6,1) => float note;


.125::second => dur baseDur;
2*baseDur => echo.max;
1.5*baseDur => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

while (note > endNote) {
    1 => osc1.noteOn;
    Std.mtof(note) => osc1.freq;
    Std.rand2f(.2,2)*baseDur => now;
    note - Std.rand2f(.5,.01) => note;
    
}