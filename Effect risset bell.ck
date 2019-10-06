// Bell instrument
// Doidge and Jerse Computer Music (1985) p 94
SinOsc s[12]; // only requires 11 but dispensing with [0] to make translation easier
ADSR env[12];
NRev rev[12];
Pan2 pan[12];
Gain g;

.05 =>g.gain;

s[0] => blackhole; // not gonna use it

for (1 => int i; i < 12; i++) {
     s[i] => env[i]=> rev[i] => pan[i] => g => dac;
     0.5 => rev[i].mix;
     env[i].set(10::ms, 8::ms, .9, 5000::ms);
}

1::second => now;

[0.,  1.,  .67, 1., 1.8, 2.67, 1.67, 1.46, 1.33, 1.33,   1., 1.33] @=> float rissetAmps[];
[0.,  1.,  .9, .65, .55, .325,  .35,  .25,   .2,  .15,   .1, .075] @=> float rissetDurs[];
[0., .56, .56, .92, .92, 1.19, 1.17,   2., 2.74,   3., 3.76, 4.07] @=> float rissetFreqsTimes[];
[0.,  0.,  1.,  0., 1.7,   0.,   0.,   0.,   0.,   0.,   0.,   0.] @=> float rissetFreqsPlus[];

0.2 => float baseAmp;
15::second => dur baseDur;
Std.mtof(61) => float baseFreq; //60*4

0 => int panBell; // switch for evenly spread panning. 

0 => int panBellRand; // switch for random panning; overrides panBell if both are on

if (panBell ==1 ) -1.-2./12. => pan[0].pan;

for (1=> int i; i < 12; i++) {
    if(panBell ==1 )  pan[i-1].pan() + 2./12. => pan[i].pan;
    rissetAmps[i]*baseAmp/11. => s[i].gain;
    rissetDurs[i]*baseDur => env[i].decayTime;
    rissetFreqsTimes[i]*baseFreq + rissetFreqsPlus[i] => s[i].freq;
}

while (true) {

    for (1=> int i; i < 12; i++) {
            1 => env[i].keyOn;
    1::ms => now; // 1::ms for bell; make this 100 or 1000 ms for freaky tone cascade
    }

    for (1=> int i; i < 12; i++) {
        if (panBellRand == 1) Std.rand2f(-.75,.75) => pan[i].pan;
        1 => env[i].keyOff;
    }

    baseDur + 2::second => now;

}