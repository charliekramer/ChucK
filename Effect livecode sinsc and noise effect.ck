SinOsc s => Chorus c => Envelope e => Dyno d => dac;
Noise n => LPF l => Envelope ne=> d => dac;

.05 => float gainSet;

60./94. => float beatSec;
beatSec::second => dur beat;

55 => int midiBase;
gainSet=>n.gain => s.gain;

4 => int speed; //larger =>faster

Std.mtof(midiBase)=>float basefreq;
basefreq=>l.freq;

basefreq => float sfreq;
while (true) {
    1=>e.keyOn=>ne.keyOn;
    1=>ne.keyOn;
    basefreq*(1+Std.randf())=>l.freq;
    sfreq*(.5+Std.randf()/2)=>s.freq;
    beat*.75/speed=>now;
    1=>e.keyOff=>ne.keyOn;
    1=>ne.keyOff;
    beat*.25/speed=>now;
}
