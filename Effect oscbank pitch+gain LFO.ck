.5 => float gainSet;
5+1+1+1+2+1 => int nOsc;

45::second => dur length;

TriOsc s[nOsc];
SinOsc gainLFO[nOsc];
SinOsc pitchLFO[nOsc];
float freqs[nOsc];
float gains[nOsc];

221 => float baseFreq;
.0550 => float gainLFOFreq;
.5 => float gainLFOGain;
.05 => float pitchLFOFreq;
.01 => float pitchLFOGain;

for (0 => int i; i < nOsc; i++) {
    s[i] => dac;
    gainLFO[i] => blackhole;
    pitchLFO[i] => blackhole;
    gainSet/nOsc => gains[i];
    baseFreq*(1.0 + 1.0*i/nOsc) => freqs[i];
    gainLFOFreq*(1.0 + 1.0*i/nOsc) => gainLFO[i].freq;
    gainLFOGain*(1.0 + 1.0*i/nOsc) => gainLFO[i].gain;
    pitchLFOFreq*(1.0 + 1.0*i/nOsc) => pitchLFO[i].freq;
    pitchLFOGain*(1.0 + 1.0*i/nOsc) => pitchLFO[i].gain;
}

now + length => time future;

while (now < future) {
    
    for (0 => int i; i < nOsc; i++) {
        (1+gainLFO[i].last())*gains[i] => s[i].gain;    
        (1+pitchLFO[i].last())*freqs[i] => s[i].freq;
    }
    1::samp => now;
    
}

now + 15::second => future;

while (now < future) {
    
    for (0 => int i; i < nOsc; i++) {
        s[i].gain()*.99 => s[i].gain;    
        (1+pitchLFO[i].last())*freqs[i] => s[i].freq;
    }
    10::ms => now;
    
}
    
    