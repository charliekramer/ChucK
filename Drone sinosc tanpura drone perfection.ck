//Tanpura in C#/G# + prayer bowls in B/A/G/F/E/D/C = perfection
// A = midi 57 or 45

.01*.5 => float gainSet;

SinOsc s => NRev rev => Chorus c => Gain sGain => dac;
SqrOsc t => rev => c => Gain tGain => dac;

0.9 => rev.mix;
gainSet/4 => sGain.gain;
gainSet/4 => tGain.gain;

0.7 => t.phase;


now + 2::minute => time future;
while (now < future) {
    Std.mtof(49)=>s.freq;
    s.freq()/2 =>t.freq;
    7::second => now;

    Std.mtof(56)=>s.freq;
    s.freq()/2 =>t.freq;
    7::second => now;
}

