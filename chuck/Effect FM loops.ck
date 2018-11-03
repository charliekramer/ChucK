// weird grindy noise as secondary FM carrier changes freq and FM ratio moves

SinOsc m => SinOsc c => Echo e => PRCRev rev => Dyno d => Gain g => dac;
m => SinOsc t =>  e =>  rev => d => g => dac;

0.2 => rev.mix;

.05 => c.gain => t.gain;

.07 => g.gain;

2 => m.sync =>t.sync;

44 => c.freq;

10::second => e.max;
1.5::second => e.delay;
0.6 => e.gain;
e => e;


7./5.=> float ratio => float baseRatio;
ratio*c.freq() => m.freq;
1000 => m.gain;

.1*c.freq() => t.freq;

while (true) {
    while (ratio < 10.) {
        ratio + .001 => ratio;
        ratio*c.freq() => m.freq;
        .1*c.freq() => t.freq;
        while ( t.freq() < 1000) {
            t.freq()+10 => t.freq;
            .1::second => now;
        }
    }
    baseRatio => ratio;
}