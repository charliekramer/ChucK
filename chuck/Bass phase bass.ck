//fat phase bass with filter sweep

//time synch code
60./154. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

4. => float beatdiv; //beat division

// soundchain with two sinosc, lpf, envelope, and phase on one sinosc
SinOsc s => LPF l => ADSR e  => Gain g => Dyno d => dac;
SinOsc t => Phasor p => l => e => g =>  d => dac;

// set individual sinosc gains and master
1 => s.gain => t.gain;
.025 => g.gain;

//set Dyno to limiter
d.limit;

//set oscillator base frequency
Std.mtof(57-24) => s.freq => t.freq => float baseFreq;

//frequency spreading
.5 => float delta;
s.freq()+delta => s.freq;
t.freq()-delta => t.freq;

//set LPF cutoff
s.freq()*25 => l.freq;

// phaser parameters; c is carrier
SinOsc c => p;
.001 => c.freq;
7 => c.gain;
4 => p.gain;
1 => p.sync;

// sweep filter paramters
250. => float filterDelta;
l.freq()+1000. => float filterMax;
l.freq()-1000. => float filterMin;

while (true)
{
    1 => e.keyOn;
    beat/beatdiv => now;
    1 => e.keyOff;
    baseFreq*Std.rand2(1,1) => s.freq => t.freq;
    beat/beatdiv => now;
    l.freq()+filterDelta => l.freq;
    if (l.freq() > filterMax || l.freq() < filterMin) -1.*=> filterDelta;
    
}