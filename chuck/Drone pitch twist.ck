// pitch twist drone; runs for 2 minutes

BeeThree s => NRev rev => Gain g => dac;
BeeThree t => rev => g => dac;
HevyMetl m => Chorus c => rev => g =>  dac;

.05 => g.gain; .5 => m.gain; .7=> s.gain; .7 => t.gain;

.3 => rev.mix;


.007 => c.modFreq;
1 => c.modDepth;

Std.mtof(58-12) => float baseFreq;

baseFreq => s.freq;
baseFreq*.99 => t.freq;
baseFreq*.25 => m.freq;

1 => s.lfoDepth;
1 => t.lfoDepth;
0.01 => s.lfoSpeed;
.02 => t.lfoSpeed;

1 => t.noteOn;1 => s.noteOn; 1 => m.noteOn;

120::second => now;

1 => t.noteOff;1=>s.noteOff; 1=>m.noteOff;

5::second => now;