.3 => float gainSet;
.5::second => dur beat;
15::second => dur length;
30::second => dur outro;

SndBuf buf => PitShift pitch => NRev rev1 => Envelope env1 => PRCRev rev2 => Envelope env2 => Pan2 pan1 => dac;
env2 => PitShift pitch2 => NRev rev3 => Echo echo => Envelope env3 => Pan2 pan2 => dac;

1 => env3.keyOn;

gainSet => buf.gain;

Std.rand2f(.9,1.1)*1.5*beat => echo.max => echo.delay;
.7 => echo.mix => echo.gain;
echo => echo;

.9 => rev3.mix;

.5 => pan1.pan;
-pan1.pan() => pan2.pan;

1 => pitch.mix => pitch2.mix;

.9 => rev1.mix => rev2.mix;

[.1,1.,.5,1.5,2.,5.,.25,.7,7.,.16] @=> float rates[];

beat => env1.duration => env2.duration;

"/Users/charleskramer/Desktop/chuck/audio/obfuscation.wav" => buf.read;

1 => buf.loop;

now + length => time future;

while (now < future) {
    rates[Std.rand2(0,rates.cap()-1)] => buf.rate;
    Std.rand2f(.1,2)/buf.rate() => pitch.shift;
    1/pitch.shift() => pitch2.shift;
    Std.rand2(0,1) + Std.rand2(0,1) + Std.rand2(0,1) => env1.keyOn;
    Std.rand2(0,1) + Std.rand2(0,1) + Std.rand2(0,1) => env2.keyOn;
    
    beat => now;
    
    Std.rand2(0,1) => env1.keyOff;
    Std.rand2(0,1) => env2.keyOff;
    
}

5*beat => env1.duration => env2.duration;
1 => env1.keyOff;
1 => env2.keyOff;
5*beat => now;
outro => env3.duration;
env3.keyOff;
outro => now;
