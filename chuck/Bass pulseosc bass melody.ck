//noisy panning pulseosc
//synch
60./154. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;


PulseOsc p => Echo e => NRev rev => Pan2 pan => dac;

Std.mtof(60-24-3) => float baseFreq;

0.06=>p.gain;

.75::second => e.delay;
0.1 => e.mix;

0.5 => rev.mix;

while (true)
{
    Math.random2f(0.01,.5) => p.width;
    beat/4 =>now;
    Math.random2f(-.75,.75) => pan.pan;
    if(Math.random2(0,1) == 1)
    {
        baseFreq=>p.freq;
    }
    else
    {
        baseFreq*2=>p.freq;
    }
}
