.5 => float gainSet;

.5::second => dur beat;

beat - (now % beat) => now;

3::minute => dur length;

Wurley osc1 => Echo echo1 =>  Pan2 pan1 => dac;
Wurley osc2 => Echo echo2 =>  Pan2 pan2 => dac;

echo1 => NRev rev1 => ADSR env1 => pan1 => dac;
echo2 => NRev rev2 => ADSR env2 => pan2 => dac;

(2*beat,0*beat,1.,1*beat) => env1.set;

(2*beat,0*beat,1.,1*beat) => env2.set;

.75 => pan1.pan;
-.75 => pan2.pan;

beat*2 => echo1.max => echo2.max;
1.5*beat => echo1.delay;
1.25*beat => echo2.delay;
.5 => echo1.mix;
.5 => echo2.mix;
.9 => echo1.gain;
.9 => echo2.gain;
echo1 => echo1;
echo2 => echo2;

.8 => rev1.mix;
.8 => rev2.mix;

gainSet => osc1.gain;
gainSet => osc2.gain;

59 => float midiBase;

[0., 2., 5., 7., 9.] @=> float notes1[];

[0., 4., 11., 12.] @=> float notes2[];

[-12., -5, 7., 12.] @=> float adds[];

float note1;
float note2;
float alpha;
int nIteration;
int j;

now + length => time future;

while (now < future) {
    
    1 => alpha;
    5 =>  nIteration;
    0 =>  j;
    
    midiBase+notes1[Std.rand2(0,notes1.cap()-1)] => note1;
    midiBase+notes2[Std.rand2(0,notes2.cap()-1)] => note2;
     
     while (j < nIteration) {
         Std.mtof(note1) => osc1.freq;
         Std.mtof(note2) => osc2.freq;
         1 => osc1.noteOn;
         1 => osc2.noteOn;
         1 => env1.keyOn;
         1 => env2.keyOn;
         Std.rand2f(.5,2)*alpha*beat => now;
         1 => env1.keyOff;
         1 => env2.keyOff;
         beat => now;
         j++;
         alpha*.7 => alpha;
         note1 + adds[Std.rand2(0,adds.cap()-1)] => note1;
         note2 + adds[Std.rand2(0,adds.cap()-1)] => note2; 
     }
     
     1 => env1.keyOn;
     1 => env2.keyOn;
     4*Std.rand2f(1,3)*beat => now;
     1 => env1.keyOff;
     1 => env2.keyOff;
     
     beat*Std.rand2f(1,1.5) => beat;
     
}


15::second => now;
 