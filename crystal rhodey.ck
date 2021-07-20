.3 => float gainSet;

.75 => float panSet;

.2 => float revSet;

44-12 => float midiBase;

60::second => dur length;
30::second => dur outro;

//[0,2,3,2,3,5,0,2,3,3,5,7] @=> int notes[];
//[0,3,10,0,3,8,0,3,7,0,3,5] @=> int notes[];
//[12,10,8,7,5,3,10,8,7,5,3,0] @=> int notes[];
[0,0,5,0,0,0,7,0,0,5,7,0,7,5] @=> int notes[]; // bass line; multiply beat


.75::second*4 => dur beat;

beat - (now % beat) => now;

Rhodey osc =>  Echo echo => Gain gain => NRev rev => Pan2 pan => dac;

gain => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;

gainSet => osc.gain;

4*beat => echo.max => echo2.max;
1.5*beat => echo.delay;
1.5*echo.delay() => echo2.delay;
.7 => echo.mix => echo2.mix;
.7 => echo.gain => echo2.gain;
echo => echo;
echo2 => echo2;

revSet => rev.mix => rev2.mix;

panSet => pan.pan;
-pan.pan() => pan2.pan;

0 => int i;

now + length => time future;

while (now < future) {
    
    Std.mtof(midiBase+notes[i%notes.cap()]) => osc.freq;
    1 => osc.noteOn;
    beat=>now;
    i++;
}

outro => now;