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

Moog s => Envelope e => NRev r => Echo echo => Echo echo2 => dac;
Moog s2 => Envelope e2 => NRev r2 => Echo echo22 => Echo echo222 => dac;

0.5 => echo2.mix;

.9=>r.mix; 

[1., 1.25, 1.3333, 1.40, 1.5, 1.6666, 1.875, 2.0] @=> float scalepick[];

440=> float basefreq;


0 => int index;

1=>e.keyOn;
1=>s.gain;

1=>e2.keyOn;
1=>s2.gain;


while (true) {
    Math.random2(0,scalepick.cap()-1) => index;
    basefreq*scalepick[index]=>s.freq;
    if (index <6)
    {
    basefreq*scalepick[index+2]=>s2.freq;
    }
    else
    {
    basefreq*scalepick[index-2]=>s2.freq;
    }

    1=>s.noteOn;
     1=>s2.noteOn;
    10::second =>now;
}
    