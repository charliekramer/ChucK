
60./154. => float beattime;

beattime::second=>dur beat;
beat - (now % beat) => now;

SinOsc s => LPF f => Envelope env => dac;
1200 => f.freq;
880 => s.freq;

0.2 => s.gain;

while (true) {
    1=>env.keyOn;
    beat/4=>now;
    1=>env.keyOn;
    s.freq()*1.5=>s.freq;
    beat/4=>now;
    s.freq()/1.5=>s.freq;
    beat/4=>now;
    1=>env.keyOn;
    s.freq()*2.5=>s.freq;
    beat/4=>now;
    s.freq()/2.5=>s.freq;

    
}
