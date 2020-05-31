// https://attunedvibrations.com/free-healing-tones/

[174.,285.,396.,417.,528.,639.,741.,852.,963.] @=> float tones[];

BandedWG osc => dac;

0 => int i;

1::second => dur beat;

while (true) {
    tones[i % tones.cap()] => osc.freq;
    1 => osc.noteOn;
    beat => now;
    i++;
}

