//synch beat to other shreds
60./154. => float beatsec;
beatsec::second => dur beat;
beat - (now % beat) => now;
//line for offset from other loops
//0.25::second => now;

//beat for loop
0.125::second => dur loopBeat;

//soundchain

SinOsc s => LPF f => Envelope env => NRev r => dac;

//reverb parameters
0.1 => r.gain;
0.1 => r.mix;

//set frequencies

Std.mtof(57)=> float baseFreq;
baseFreq => s.freq;
baseFreq*2. => f.freq;

//make rock
while (true) {
    0=>env.keyOn;
    loopBeat=>now;
    1=>env.keyOn;
    loopBeat=>now;
    s.freq()*2.=>s.freq;
    if (s.freq() > baseFreq*8.) baseFreq => s.freq;

}

    
    