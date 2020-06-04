.03 => float gainSet;

3::minute => dur length;

6 => int n;
Envelope env[n];

Rhodey rhodes1 =>  Gain gain1 => dac;
Rhodey rhodes2 =>  Gain gain2 => dac;
gain1 => env[0] =>  NRev rev1 => dac;
gain1 => env[1] =>  Echo echo1 => dac;
gain1 => env[2] =>  PitShift pitch => dac;
gain2 => env[3] =>  Pan2 pan1 => dac;
gain2 => env[4] =>  Pan2 pan2 => dac;
gain2 => env[5] =>  Echo echo2 => dac;

gainSet => gain1.gain => gain2.gain;

1::second => dur beat;

beat - (now % beat) => now;

.9 => rev1.mix;
5*beat => echo1.max => echo2.max;
1.5*beat => echo1.delay;
.35*beat => echo2.delay;
.8 => echo1.mix => echo2.mix;
.8 => echo1.gain => echo2.gain;
echo1 => echo1;
echo2 => echo2;

1 => pitch.mix;
1.5 => pitch.shift;

-1 => pan1.pan;
1 => pan2.pan;




57 => float midiBase;

[0., 2., 3., 5., 7., 8., 10., 12.] @=> float scale[];

[2,1,0,4,0] @=> int notes1[];
[4,3,2,1,2] @=> int notes2[];

[1.,1.,1.,1.,4.] @=> float beats[];

now + length => time future;

while (now < future) {
   
    for (0 => int j; j < notes1.cap(); j++) {
        
        for (0 => int i; i < env.cap(); i++) {
            
            Std.rand2(0,1) => env[i].keyOn;
            
        }
        
        Std.mtof(midiBase + scale[notes1[j]]) => rhodes1.freq;
        Std.mtof(midiBase + scale[notes2[j]]) => rhodes2.freq;
        1 => rhodes1.noteOn;
        1 => rhodes2.noteOn;
        beats[j]*beat => now;
    }
}

10::second => now;