
.05*8 => float gainSet;

1. => float sign; //  direction of LFO

1 => int n;

150::second => dur length; 


BPF filter[n];
float freqs[n];
Noise noise;
Gain gain; 
Dyno dyn;
SinOsc LFO[n];
Echo echo;

4::second => echo.max;
2::second => echo.delay;
.2 => echo.mix;
.7 => echo.gain;
echo => echo;

.01 => float LFOFreq;

57. => float midiBase; //220 for horriblesound

for (0 => int i; i < n; i++) {
    noise => filter[i] => echo => gain => dyn => dac;
    Std.rand2f(.5,2)*Std.mtof(midiBase) => freqs[i] => filter[i].freq;
    200 => filter[i].Q;
    LFO[i] => blackhole;
    Std.rand2f(.5,2)*LFOFreq => LFO[i].freq;
}


1/(1.*n*n) => noise.gain; //.0000001 for horriblesound 
gainSet => gain.gain; //.00000000001 for horriblesound



//SinOsc LFO => blackhole;

//.1 => LFO.freq; //.2 horriblesound

//Std.mtof(midiBase)=> filt.freq;

//4 => filt.Q; //4 horriblesound

now + length => time future;

while (now < future) {
    
    for (0 => int i; i < n; i++) {   
        (1.+sign*LFO[i].last()*.5)*freqs[i] => filter[i].freq;
    }
    1::samp => now;
    
}

0 => noise.gain;
20::second => now;