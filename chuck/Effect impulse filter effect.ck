// impulse-excited resonant filter drives
Impulse imp => ResonZ rez => Gain input => dac;
100 => rez.Q;
100 => rez.gain;
1.0 => input.gain;

Delay del[3];

input => del[0] => dac.left;
input => del[1] => dac;
input => del[2] => dac.right;

for (0 => int i; i < 3; i++) {
    del[i] => del[i];
    0.6 => del[i].gain;
    (0.8 +i*0.3) :: second => del[i].max => del[i].delay;
}
57 => int baseNote;
[0, 4, 5, 7, 10, 12] @=> int notes[];
notes.cap() -1 => int numNotes;

while (1) {
    Std.mtof(baseNote+notes[Math.random2(0, numNotes)]) => rez.freq;
    1.0 => imp.next;
    0.4::second => now;
}
    