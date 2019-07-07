//rhodey 3 chords

60./94. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

.02 => float masterGain;


Rhodey piano[4];
piano[0] => JCRev rev => dac;
piano[1] => rev => dac;
piano[2] => rev => dac;
piano[3] => rev => dac;


0.9 => rev.mix;
masterGain => piano[0].gain => piano[1].gain => piano[2].gain => piano[3].gain;


55 => int midiBase; // original = 55;

midiBase => int baseNote;

[baseNote+4,baseNote+5,baseNote+7] @=> int notes[];


while (true) {
    

midiBase => baseNote;

[baseNote,baseNote+4,baseNote+5,baseNote+7] @=> notes;

for (0 => int i; i < notes.cap(); i++) {
    Std.mtof(notes[i]) => piano[i].freq;
    1 => piano[i].noteOn;
}

5*beat => now;


midiBase - 10 => baseNote;

[baseNote,baseNote+4,baseNote+5,baseNote+9] @=> notes;

for (0 => int i; i < notes.cap(); i++) {
    Std.mtof(notes[i]) => piano[i].freq;
    1 => piano[i].noteOn;
}

4*beat => now;

midiBase - 19 => baseNote;

[baseNote,baseNote+4,baseNote+5,baseNote+7] @=> notes;

for (0 => int i; i < notes.cap(); i++) {
    Std.mtof(notes[i]) => piano[i].freq;
    1 => piano[i].noteOn;
}

3*beat => now;

}