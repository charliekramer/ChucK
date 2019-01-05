// rhodey chords spooky

Rhodey rhodes[4] => BPF f =>  DelayA d => NRev rev => Chorus c => Dyno dyn => dac;

58 => int baseNote;

10::second => dur chordTime;

Std.mtof(baseNote)*1 => f.freq;
1 => f.Q;

0.005/8. => float rhodesGain;
0.7 => rev.mix;
10::second => d.max;
1.5::second => d.delay;
d => d;
0.6 => d.gain;
0.06 => c.modFreq;
0.1 => c.modDepth;
0.2 => c.mix;


[0, 3, 5, 7] @=> int notes1[];

for (0 => int i; i < notes1.cap()-1; i++) {
    rhodes[i] => f => d => rev => c => dyn => dac;
    rhodesGain => rhodes[i].gain;
    Std.mtof(baseNote+notes1[i]) => rhodes[i].freq;
    1 => rhodes[i].noteOn;
}

chordTime => now;

[2, 6, 6, 8] @=> int notes2[];


for (0 => int i; i < notes2.cap()-1; i++) {
    Std.mtof(baseNote+notes2[i]) => rhodes[i].freq;
    1 => rhodes[i].noteOn;
}

 chordTime => now;

while (true) { // to repeat
    
    for (0 => int i; i < notes1.cap()-1; i++) {
        Std.mtof(baseNote+notes1[i]) => rhodes[i].freq;
        1 => rhodes[i].noteOn;
    }
    
   chordTime => now;
    
 //   [2, 6, 6, 8] @=> int notes2[];
    
    
    for (0 => int i; i < notes2.cap()-1; i++) {
        Std.mtof(baseNote+notes2[i]) => rhodes[i].freq;
        1 => rhodes[i].noteOn;
    }
   chordTime => now;

}
    
    





