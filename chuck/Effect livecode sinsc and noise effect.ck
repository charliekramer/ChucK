SinOsc s => Chorus c => Envelope e => Dyno d => dac;
Noise n => LPF l => Envelope ne=> d => dac;
660=>float basefreq;
basefreq=>l.freq;
.2=>n.gain => s.gain;
1::second => now;
660.=> float sfreq;
while (true) {
    1=>e.keyOn=>ne.keyOn;
    1=>ne.keyOn;
    basefreq*(1+Std.randf())=>l.freq;
    sfreq*(.5+Std.randf()/2)=>s.freq;
    0.1::second=>now;
    1=>e.keyOff=>ne.keyOn;
    1=>ne.keyOff;
    0.1::second=>now;
}
