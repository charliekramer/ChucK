// 3x hevymetl with freq spread, modulating filter, chorus, phasing

.1::second => dur beat; // frequency of filter changes

HevyMetl m[3]; // HevyMetl, Flute, Mandolin
m[0] => Phasor p => LPF f => Chorus c0 => Dyno d => Gain g => dac;
m[1] => Phasor p1 => Chorus c1 => g => dac.left;
m[2] => Phasor p2 => Chorus c2 => g => dac.right;

44. => float baseFreqF => f.freq;
15 => f.Q;

.5 => c0.modDepth => c1.modDepth => c2.modDepth;
.25 => c0.modFreq;
c0.modFreq()*1.1 => c1.modFreq;
c0.modFreq()*.8 => c2.modFreq;

1 => g.gain;
.1 => m[0].gain =>m[1].gain =>m[2].gain;

44. => float baseFreq;
1.0001=> float freqSpread; // 1.0001, 1.0005 drone

baseFreq => m[0].freq;
baseFreq*freqSpread=>m[1].freq;
baseFreq/freqSpread=>m[2].freq;

.12 => p.freq;
1 => p.sync; // CAUTION very loud when == 1

.71 => p1.freq;
1 => p1.sync;

.23 => p2.freq;
1 => p2.sync;

SinOsc s => blackhole; // modulate filter frequency
.13 => s.freq;
1 => s.gain;

while (true) {
    
.8=>m[0].noteOn; .8 => m[1].noteOn; .8 => m[2].noteOn;

beat => now; // basically controls freq of filter changes

 baseFreqF + 0.1*baseFreqF*s.last() => f.freq;

}

