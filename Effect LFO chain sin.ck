SawOsc sin => LPF filt => Gain gain => dac.left;
gain => NRev rev => dac.right;

//.2 => sin.width;

.5 => float gainSet;
10 => float filtMult; // multiply sum of LFOs times this time sin freq;

.5::minute => dur length;

1 => rev.mix;
.4 => rev.gain;

3 => int n;

40-12 => float midiBase;
Std.mtof(midiBase) => sin.freq;


2 => filt.Q;
sin.freq()*1.5 => filt.freq;

SinOsc LFO[n];

SinOsc filtLFO[n];

for (0 => int i; i < n; i++) {
    LFO[i] => blackhole;
    filtLFO[i] => blackhole;
    1./(i+1.) => LFO[i].freq;
    1.5/(i+1.5) => filtLFO[i].freq;
    1./n*1. => LFO[i].gain;
    1./n*1. => filtLFO[i].gain;
}

now + length => time future;

while (now < future) {
    
    LFOs() => sin.gain;
    (1+filtLFOs())*sin.freq()*filtMult => filt.freq;
    1::samp => now;
    
}

fun float LFOs() {
    0 => float temp;
    for (0 => int i; i < n; i++) {
        temp + LFO[i].last() => temp;
    }
    return temp;
}

fun float filtLFOs() {
    0 => float temp;
    for (0 => int i; i < n; i++) {
        temp + filtLFO[i].last() => temp;
    }
    return temp;
}

10::second => now;


