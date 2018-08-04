/*
degree	ratio
2m	1.066666667
2	1.125
3m	1.2
3	1.25
4	1.333333333
tri	1.40625
5	1.5
6m	1.6
6	1.666666667
7m	1.8
7	1.875
12	2
*/

Moog s => Envelope e => NRev r => Echo echo => Echo echo2 => Pan2 p => dac;

0.5 => echo2.mix;

.9=>r.mix; 

[1., 1.25, 1.3333, 1.40, 1.5, 1.6666, 1.875, 2.0] @=> float scalepick[];

660=> float basefreq;


0 => int index;

1=>e.keyOn;
.6=>s.gain;

while (true) {
    Math.random2(0,scalepick.cap()-1) => index;
    Math.random2f(-1.,1.)=>p.pan;
    basefreq*scalepick[index]=>s.freq;
//    55.=>s.freq;
    1=>s.noteOn;
    2.5::second =>now;
}
    