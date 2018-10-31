// pad with 3 oscillators and 4 chord tones
// frequency spreading, BFP, reverb

SawOsc s[2];
SawOsc t[2]; // doubling
SinOsc u[2]; // tripling--middle freq;
s[0] => BPF h => ADSR adsr => NRev rev =>  Gain g => Dyno d => Chorus c => dac;
t[0] => h => adsr => rev => g => dac;
u[0] => h => adsr => rev => g => dac;

.009/12 => s[0].gain => t[0].gain => u[0].gain ;
0.09/12 => g.gain;

[0, 4, 7, 12] @=> int notes[];
58 => int baseFreq;
0.002 => float freqSpread; // in percent of the original frequency;

Std.mtof(baseFreq)*1.0 => h.freq;
2. => h.Q;

Std.mtof(baseFreq+notes[0])*(1+freqSpread) => s[0].freq;
Std.mtof(baseFreq+notes[0]) => u[0].freq;
Std.mtof(baseFreq+notes[0])*(1-freqSpread) => t[0].freq;
//1 => s[0].noteOn;


for (0 => int i; i< s.cap(); i++) {

    s[i] => h => adsr => rev => g =>  dac;
    t[i] => h => adsr => rev => g =>  dac;
    u[i] => h => adsr => rev => g =>  dac;
    s[0].gain() => s[i].gain;
    t[0].gain() => t[i].gain;
    u[0].gain() => u[i].gain;
    Std.mtof(baseFreq+notes[i])*(1+freqSpread) => s[i].freq;
    Std.mtof(baseFreq+notes[i])*(1-freqSpread) => t[i].freq;
     Std.mtof(baseFreq+notes[i]) => u[i].freq;
//    1 => s[i].noteOn;
}
    
0.5 => rev.mix;
4::second => adsr.attackTime;
0.1::second => adsr.decayTime;
4::second => adsr.releaseTime;

while (true) {

1 => adsr.keyOn;

15.0::second => now;

<<< "key off" >>>;

1 => adsr.keyOff;

5.0::second => now;

}


