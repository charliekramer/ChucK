
.5 => float gainSet;

TriOsc osc1 => LPF filt1 => Envelope env1 => Echo echo1 =>dac;

SawOsc osc2 => LPF filt2 => Envelope env2 => Echo echo2 => dac;

SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;

60./120.*.5*16 => float beatSec;

beatSec::second => dur beat;

30::second => dur length;

2*beat => echo1.max => echo2.max;
1.5*beat => echo1.delay => echo2.delay;
.5 => echo1.mix => echo2.mix;
.5 => echo1.gain => echo2.gain;
echo1 => echo2 => echo1;

1/(4*beatSec) => LFO1.freq;
1/(8*beatSec) => LFO2.freq;

10 => filt1.Q;
10 => filt2.Q;

.9 => float brassCutoff;

gainSet => osc1.gain => osc2.gain;

45 => float midiBase;

//[0.,-12.,-24,12.,24]  @=> float octave[];
//[0.,4., 5.,7.,9.,11.,12.]  @=> float notes[];
// pelog
[0., -12., 12.] @=> float octave[];
[0., 1., 3., 5., 6., 12.] @=> float notes[];

1 => int randBeat; // randomize melody note lengths;
[1,2,3,4,5,6] @=> int beatDiv[];
1 => int nBeat;



spork~filtLFO();

Std.mtof(midiBase) => osc1.freq => osc2.freq;

now + length => time future;

while (now < future) {
    if (randBeat == 1) beatDiv[Std.rand2(0,beatDiv.cap()-1)] => nBeat;
    for (0 => int i; i < nBeat; i++) {
        <<< "i, nBeat ", i, nBeat>>>;
        1 => env2.keyOff;
        Std.mtof(midiBase+octave[Std.rand2(0,octave.cap()-1)]) => osc1.freq;  
        1 => env1.keyOn;
        beat/nBeat => now;
        1 => env1.keyOff;
        Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc2.freq;
        1 => env2.keyOn;
        beat/nBeat => now;
    }
    
    if (Std.rand2f(0,1) > brassCutoff) spork~brassNote();
}

<<< "ending alt notes" >>>;
20*beat => now;


fun void filtLFO() {
    while (true) {
        (5+3*LFO1.last())*Std.mtof(midiBase) => filt1.freq;
        (5+3*LFO2.last())*Std.mtof(midiBase) => filt2.freq;
        1::samp => now;
    }
}

fun void brassNote() {
   Brass brass => Echo echo3 => dac;
   gainSet*8 => brass.gain;
   Std.mtof(midiBase+Std.rand2(1,2)*12 + Std.rand2(0,1)) => brass.freq;
   1 => brass.noteOn;
   1 => brass.startBlowing;
   .5 => brass.volume; //.5
   .57 => brass.lip; //.57
   .0 => brass.slide; //0
   .3 => brass.vibratoFreq; //.3
   .5 => brass.vibratoGain; //.5
   .1 => brass.rate;//.1
   
   <<< "BRASS((((((((((((((((((((05" >>>;
   
   10*beat =>echo3.max;
   3.25*beat => echo3.delay;
   .5 => echo3.mix;
   .5 => echo3.gain;
   echo3 => echo3;
   
   1 => brass.startBlowing;
   20*beat => now;
   1 => brass.stopBlowing;
   20*beat => now;
}
   
