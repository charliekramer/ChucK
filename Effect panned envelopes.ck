TriOsc sinL => Envelope envL => dac.left;
TriOsc sinR => Envelope envR => dac.right;
SqrOsc LFOL => blackhole;
SqrOsc LFOR => blackhole;

110 => sinL.freq;
105 => sinR.freq;


.9 => LFOL.gain;
.1 => LFOL.freq;

.9 => LFOR.gain;
.11 => LFOR.freq;

.05::second => dur beat;

while (true) {
    1 => envR.keyOff;
    1 => envL.keyOn;
    (1+LFOL.last())*beat => now;
    1 => envL.keyOff;
    1 => envR.keyOn;
    (1+LFOR.last())*beat => now;
}