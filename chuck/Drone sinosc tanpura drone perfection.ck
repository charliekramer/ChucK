//Tanpura in C#/G# + prayer bowls in B/A/G/F/E/D/C = perfection
// A = midi 57 or 45
SinOsc s => NRev rev => Chorus c => Gain sGain => dac;
SqrOsc t => rev => c => Gain tGain => dac;

0.9 => rev.mix;
0.05/4 => sGain.gain;
0.05/4 => tGain.gain;

0.7 => t.phase;

while (true) {
    Std.mtof(49)=>s.freq;
    s.freq()/2 =>t.freq;
    100::second => now;

    Std.mtof(56)=>s.freq;
    s.freq()/2 =>t.freq;
    10::second => now;
}

