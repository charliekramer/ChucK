30 => int n;
SawOsc saw[n];

SinOsc sin => dac;

1 => float baseFreq;
.9 => float freqMult;

60 => float midiBase;

for (0 => int i; i < saw.cap(); i++) {
    saw[i] => blackhole;
    Math.pow(freqMult,i+1)*baseFreq => saw[i].freq;
    <<< " i freq ", i, saw[i].freq() >>>;
}

while (true) {
    Std.mtof(midiBase)*(1+sum()/saw.cap()) => sin.freq;
    1::samp => now;
}


fun float sum () {
    0 => float total;
    for (0 => int i; i< saw.cap(); i++) {
        saw[i].last() +=> total;
    }
    return total;
}
