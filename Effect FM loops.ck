// weird grindy noise as secondary FM carrier changes freq and FM ratio moves

SinOsc m => SinOsc c => Echo e => PRCRev rev => Dyno d => Gain g => dac;
m => SinOsc t =>  e =>  rev => d => g => dac;

.05*1*2*.5*10 => float gainSet;

0.0 => rev.mix;

.05 => c.gain => t.gain;

.1::second => dur goTime;

5 => int iterations; 

gainSet => g.gain;

2 => m.sync =>t.sync;

Std.mtof(61-36) => c.freq;

10::second => e.max;
1.5::second => e.delay;
0.6 => e.gain;
.5 => e.mix;
e => e;


10. => float maxRatio; // 10.
.001 => float ratioDelta; //.001

7./5. + 2./4*2.*1.333333*1.33333*0=> float ratio => float baseRatio;
ratio*c.freq() => m.freq;
10*10*10 => m.gain; // 1000

.1*c.freq() => t.freq;

0 => int j;

while (j < iterations) {
    while (ratio < maxRatio) {
        ratio + ratioDelta => ratio;
        ratio*c.freq() => m.freq;
        .1*c.freq() => t.freq;
        while ( t.freq() < 1000) {
            t.freq()+10 => t.freq;
            goTime => now;
        }
    }
    baseRatio => ratio;
    j++;
}

15::second => now;