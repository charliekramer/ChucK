.1 => float gainSet;
30::second => dur length;

Noise noise => LPF filt => NRev rev => Pan2 pan => dac;
rev => Echo echo => PitShift pitch => Pan2 pan2 => dac;
SinOsc filtLFO => blackhole;
SinOsc panLFO => blackhole;

.25 => filtLFO.freq;
.125 => panLFO.freq;
1 => pitch.mix;
1/(1.5*1.5*1.5) => pitch.shift;
.125::second => dur beat;
Std.mtof(57+7) => float filtBase;
1*4 => filt.Q;
.8 => rev.mix;


4*beat => echo.max;
1.5*beat => echo.delay;
1 => echo.mix;
.8 => echo.gain;
echo => echo;

gainSet => noise.gain;

now + length => time future;
while (now < future) {
    filtBase*(1+.5*filtLFO.last()) => filt.freq;
    
    panLFO.last() => pan.pan;
    -pan.pan() => pan2.pan;
    
    beat => now;
}

0 => noise.gain;
5::second => now;