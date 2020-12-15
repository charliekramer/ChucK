.01 => float gainSet;

44 => float midiBase;

9 => int nOsc;

SinOsc osc[nOsc];

9 => int nLFO;

SinOsc LFO[nLFO];

Pan2 pan[nOsc];

float freqs[nLFO];

float gains[nLFO];

[1.,1.,2.,3.,5.,8.,13.,21.,34.] @=> freqs;


for (0 => int i; i < nOsc; i++) {
    freqs[i]*1 => LFO[i].freq;
    freqs[i]*20 => LFO[i].gain; 
    gainSet => osc[i].gain;  
    LFO[i].gain() => gains[i];
    Std.rand2f(-1,1) => pan[i].pan;
    Std.mtof(midiBase) => osc[i].freq;
}

LFO[0] => osc[0] => pan[0] => dac;

LFO[0] => LFO[1] => osc[1] => pan[1] => dac;

LFO[0] => LFO[1] => LFO[2] => osc[2] => pan[2] => dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => osc[3] => pan[3] => dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] =>osc[4] => pan[4] => dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => osc[5] => pan[5] =>dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => LFO[6] => osc[6] => pan[6] =>dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => LFO[6] => LFO[7] => osc[7] => pan[7] =>dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => LFO[6] => LFO[7] => LFO[8] => osc[8] => pan[8] =>dac;

spork~LFO_LFO();

3::second => now;


fun void LFO_LFO() {
    SinOsc gainLFOs[nOsc];
    for (0 => int i; i < nOsc; i++) {
        Std.rand2f(.02,.5) => gainLFOs[i].freq;
    }
    
    while (true) {
        for (0 => int i; i < nOsc; i++) {
            (.5+.5*gainLFOs[i].last())*gains[i] => LFO[i].gain;
        }    
     1::samp => now;   
    }
}