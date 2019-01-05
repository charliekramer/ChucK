// pitch twist drone; runs for 2 minutes

BeeThree s => Echo echo => NRev rev => Gain g => dac;
BeeThree t => echo => rev => g => dac;
HevyMetl m => echo => Chorus c => rev => g =>  dac;

.03 => g.gain; .5 => m.gain; .7=> s.gain; .7 => t.gain;

.3 => rev.mix;

10::second => echo.max;
1.75::second => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

.007 => c.modFreq;
1 => c.modDepth;

Std.mtof(48) => float baseFreq;

baseFreq => s.freq;
baseFreq*.99 => t.freq;
baseFreq*.25*1.1 => m.freq;

3. => s.lfoDepth;
3. => t.lfoDepth;
0.01 => s.lfoSpeed;
.02 => t.lfoSpeed;

1 => t.noteOn;1 => s.noteOn; 1 => m.noteOn;

120::second => now;

1 => t.noteOff;1=>s.noteOff; 1=>m.noteOff;

5::second => now;