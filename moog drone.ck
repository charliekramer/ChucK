Moog moog => LPF filt => Echo echo => NRev rev => Chorus cLeft => dac.left;
rev => Chorus cRight => dac.right;

20::second=> dur length;
.2*2*2*4 => float gainSet;
62-24-12+12=> float midiBase;
gainSet => moog.gain;

.0025::second*1 => dur beat; //very short = atmospheric-turn up gain
beat*2 => echo.max;
beat*1.5 => echo.delay;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

.1 => cLeft.modFreq;
.11 => cRight.modFreq;

Std.mtof(midiBase) => moog.freq;

Std.mtof(midiBase)*1.5 => filt.freq;

now+length => time future;

while (now<future) {
    
    1 => moog.noteOn;
    Std.rand2f(0,1) => moog.filterSweepRate;
    Std.rand2f(0,1) => moog.filterQ;
    Std.rand2f(0,.05) => moog.vibratoGain;
    Std.rand2f(.1,.5) => moog.vibratoFreq;
    Std.rand2(1,4)*beat => now;
    1 => moog.noteOff;
    Std.rand2(1,4)*beat => now;
    
}

20::second=> now;