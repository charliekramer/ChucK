ModalBar bar => Echo e => NRev r => Gain g => dac;

SinOsc s[2] => dac;

0.01 => s[0].gain => s[1].gain;

62 => int midiBase;

1.5 => float freqMult;

Std.mtof(midiBase)*.9 => s[0].freq;
Std.mtof(midiBase)*1.1 => s[0].freq;

60./60. => float beatsec;
beatsec::second => dur beat;

beat - (now % beat) => now;


0.7 => e.gain;
e => e;
10::second => e.max;
.75*beat => e.delay;

0.1 => r.mix;

1 => bar.preset;

.5 => bar.damp;

0.5 => g.gain;



while (true) {
    Std.mtof(midiBase) => float baseFreq => bar.freq;
    for (0 => int i; i < 5; i++) {   
        1 => bar.noteOn;
        beat => now;
        <<< "I", i>>>;
        bar.freq()*freqMult => bar.freq;
    }
}
    
    
    
    