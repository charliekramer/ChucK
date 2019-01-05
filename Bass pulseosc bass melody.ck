//noisy panning pulseosc
//synch
60./120.*2. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;


PulseOsc p => Echo e => NRev rev=> Pan2 pan => dac;

36 => int midiBase;
Std.mtof(midiBase) => float baseFreq => p.freq;

0.04=>p.gain;

.75::second => e.delay;
0.1 => e.mix;

0.9 => rev.mix;

0.5 => pan.pan;

while (true)
{
    Math.random2f(0.2,0.5) => p.width; // causes clicking
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
	if (Math.random2f(0,1) > .95) Std.mtof(midiBase-12) => p.freq;
}
