60./94. => float beattime;
beattime::second => dur beat;

SinOsc s => LPF f => Envelope env => NRev r => dac;
Std.mtof(55-12) => s.freq;
s.freq()*2. => f.freq;
2 => float div; //beat division

0.1 => s.gain;

while (true) {
    0=>env.keyOn;
    beat/div=>now;
    1=>env.keyOn;
    beat/div=>now;

}

    
    