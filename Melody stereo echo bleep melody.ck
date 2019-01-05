// stereo echo bleep with random filter

//synch code
60./120. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

// sound chain

Blit b => LPF f => Envelope env => Pan2 p1 => dac;
f => env => Echo e => Echo e2 => Pan2 p2 => dac;

0.1 => b.gain;

//effects mix
0.9 => e.mix;
0.9 => e2.mix;
beat/4 => e.delay => e2.delay;

//set up base frequencies for blit and filter
Std.mtof(60+12)=> float baseBFreq;
baseBFreq => b.freq;
baseBFreq*1.1 => float baseFFreq;
baseFFreq => f.freq;

1 => p1.pan;
-1 => p2.pan;
while (true)
{
    1 => env.keyOn;
    baseFFreq*Std.rand2f(1.0,8.0) => f.freq; 
    Math.random2(1, 5) => b.harmonics; 
    beat => now;
    1 => env.keyOff;
    // make this half the previous time for cool effects
    beat => now;
}
