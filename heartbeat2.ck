
.5 => float gainSet;
.5::second => dur beat;
.125 => float beatFrac; // for envelope
44 => float midiBase;

360::second => dur length;
60::second => dur outro;

beat - (now % beat) => now;

SinOsc sin => ADSR env => dac;

Std.mtof(midiBase) => sin.freq;
gainSet*2 => sin.gain;

(beatFrac*beat,beat,1,beatFrac*beat) => env.set;

spork~chords();

now + length => time future;

while (now < future) {
 1 => env.keyOn;
 .5*beat => now;
 1 => env.keyOff;
 .5*beat => now;
 1 => env.keyOn;
 .5*beat => now;
 1 => env.keyOff;
 .5*beat => now;
 1 => env.keyOff;
 2*beat => now;    
    
}

outro => now;

fun void chords() {
 Wurley osc[3];
 Echo echo[3];
 NRev rev[3];
 LPF filt[3];
 Pan2 pan[3];
 
 [0., 2., 5., 7., 9., 12., 14.] @=> float notes[];
 
 -.5 => pan[0].pan;
 0 => pan[1].pan;
 -pan[0].pan() => pan[2].pan;
 
 for (0 => int i; i < osc.cap(); i++) {
     osc[i] => filt[i] => echo[i] => rev[i] => pan[i] => dac;
     gainSet => osc[i].gain;
     Std.mtof(midiBase)*4 => filt[i].freq;
     2 => filt[i].Q;
     4*1.5*beat => echo[i].max => echo[i].delay;
     .7 => echo[i].gain => echo[i].mix;
     echo[i] => echo[i];
 }
 
 while (true) {
     for (0 => int i; i < osc.cap(); i++) {
         Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => osc[i].freq;
         1 => osc[i].noteOn;
         Std.rand2f(.1,5)*beat => now;
     }
     
     12*Std.rand2(1,6)*beat => now;    
     
 }   
    
}
