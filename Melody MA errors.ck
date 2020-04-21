ModalBar wurley => LPF filt => Echo echo => dac;

SinOsc filtLFO => blackhole;

.1 => filtLFO.freq;

//.5 => wurley.filterSweepRate;
//2 => wurley.filterQ;

.25::second*.5 => dur beat;

60-12*1 => float midiBase;

Std.mtof(midiBase+12) => filt.freq;
10 => filt.Q;

[0., 3., 4., 5., 6., 7., 9., 11., 12.] @=> float scale[];

[0,0,2,0,2,0,0] @=> int notes[];

[0., 0., 0.] @=> float shock[];
[.5, .3, .1] @=> float alpha[];

beat*(notes.size()+2) => echo.max;
beat*(notes.size()) => echo.delay;
beat*1.5*.25 => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

beat - (now % beat) => now;


while (true) {
    for (shock.size()-1 => int j; j > 0; j--) {
        shock[j-1]=>shock[j];
    }
    Std.rand2f(-.1,.1) => shock[0];
    for (0 => int i; i < notes.size(); i++) {
        Std.mtof(midiBase+scale[notes[i]]+shocks(shock)) => wurley.freq;
        1 => wurley.noteOn;
        beat => now;
        Std.mtof(midiBase+filtLFO.last()*filtLFO.last()*12*3) => filt.freq;
    }
}

fun float shocks(float shock[]) {
    0 => float sum;
    for (0 => int i; i < shock.size(); i++) {
        sum + alpha[i]*shock[i] => sum;
    }
    return sum;
}