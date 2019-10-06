// based on Chaos Noise Chugin
//Chaotic recursion noise generator chugen
// P. Cook, March 2013

class ChaosNoise extends Chugen {
    0.1 => float x;
    
    fun float tick(float input) {
        // here we ignore the input
        4.0 * x * (1.0-x) => x;
        return x;
    }
    
    fun void seed(float mySeed)  {
        mySeed => x;
    }
}

.1 => float gainSet;

ChaosNoise nz[2];

//SawOsc nz[2];
Echo delay[2];
LPF filter[2];
nz[0] => filter[0] => delay[0] => dac.left; 0.3 => nz[0].seed;
nz[1] => filter[1] => delay[1] => dac.right; 0.7 => nz[1].seed;

2000 => filter[0].freq => filter[1].freq;
2 => filter[0].Q => filter[1].Q;

SinOsc LFO[2];
SinOsc LFO_Master => blackhole;

LFO[0] => blackhole;
LFO[1] => blackhole;

.01 => float baseFreq;

baseFreq => LFO[0].freq;
.9 => float freqFraction;
freqFraction*baseFreq => LFO[1].freq;

.05 => LFO_Master.freq;

5::second => delay[0].max => delay[1].max;
1::ms => delay[0].delay => delay[1].delay;

.5 => delay[0].mix => delay[1].mix;

.5 => delay[0].gain => delay[1].gain; //watch volume!

delay[0] => delay[0]; delay[1] => delay[1];

gainSet => nz[0].gain => nz[1].gain;

//1::second => now;

while (true) {
	100*(2+LFO[0].last()/2)::samp => delay[0].delay;
	100*(2+LFO[1].last()/2)::samp => delay[1].delay;
	1::samp => now;
	baseFreq*(2+LFO_Master.last()/2) => LFO[0].freq;
	freqFraction*LFO[0].freq() => LFO[1].freq;
}