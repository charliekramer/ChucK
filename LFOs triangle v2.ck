.01 => float gainSet;

11-.015 => float midiBase; // 11 interesting

31 => float gainMult;
43 => float freqMult;
.0001 => float echoMin;// in seconds
.0005 => float echoMax; // seconds


3 => int nOsc; // <= dimension of arrays as filled below;
               // could algorithmically define from fibonacci formula
SinOsc osc[nOsc]; //try different oscs

TriOsc LFO[nOsc];

Envelope env[nOsc]; 

1::second => dur envDur;

Pan2 pan[nOsc];

Echo echo[nOsc];

float freqs[nOsc];

float gains[nOsc];

[1.,1.,2.,3.,5.,8.,13.,21.,34.] @=> freqs;

[100.,100.,100.,100.,100.,100.,100.,100.,100.] @=> gains;

for (0 => int i; i < nOsc; i++) {
    2::second => echo[i].max;
    Std.rand2f(echoMin,echoMax)::second => echo[i].delay;
    .8 => echo[i].mix => echo[i].gain;
    echo[i] => echo[i];
    freqs[i]*freqMult => LFO[i].freq;
    gains[i]*gainMult => LFO[i].gain; 
    gainSet => osc[i].gain;  
    envDur => env[i].duration;
    Std.rand2f(-1,1) => pan[i].pan;
    Std.mtof(midiBase) => osc[i].freq;
    LFO[i] => blackhole;
    osc[i] => env[i] => echo[i] => pan[i] => dac;
    1 => env[i].keyOn;
}

float sum;
spork~FMs();
spork~LFO_LFO();

15::second => now;

for (0 => int i; i < nOsc; i++) {
    1 => env[i].keyOff;
}

30::second => now;

fun void FMs() {
    while (true) {
        for (0 => int i; i < nOsc; i++) {
            for (0 => int j; j <= i; j++) {
                sum + LFO[j].last() => sum;
            }
            sum + Std.mtof(midiBase)*Std.rand2f(.9,1.1) => osc[i].freq;
           
       }
        0 => sum;
        1::samp => now;
    }
}

fun void LFO_LFO() {
    SinOsc gainLFOs[nOsc];
    for (0 => int i; i < nOsc; i++) {
        Std.rand2f(.01,.05) => gainLFOs[i].freq;
        gainLFOs[i] => blackhole;
    }
    
    while (true) {
        for (0 => int i; i < nOsc; i++) {
            (.5+.5*gainLFOs[i].last())*gains[i] => LFO[i].gain;
         }    
     1::samp => now;   
    }
}

/*

LFO[0] => osc[0] => pan[0] => dac;

LFO[0] => LFO[1] => osc[1] => pan[1] => dac;

LFO[0] => LFO[1] => LFO[2] => osc[2] => pan[2] => dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => osc[3] => pan[3] => dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] =>osc[4] => pan[4] => dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => osc[5] => pan[5] =>dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => LFO[6] => osc[6] => pan[6] =>dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => LFO[6] => LFO[7] => osc[7] => pan[7] =>dac;

LFO[0] => LFO[1] => LFO[2] => LFO[3] => LFO[4] => LFO[5] => LFO[6] => LFO[7] => LFO[8] => osc[8] => pan[8] =>dac;
*/