60./154. => float beattime;
beattime::second => dur beat;

SinOsc s => LPF f => Envelope env => NRev r => dac;
660=> f.freq;
220/2 => s.freq;
4 => float div; //beat division

while (true) {
    0=>env.keyOn;
    beat/div=>now;
    1=>env.keyOn;
    beat/div=>now;

}

    
    