12 => int n;

Blit osc[n];
Envelope env[n];
Pan2 pan[n];
SinOsc freqLFO[n];
SinOsc harmonicLFO[n];

57-12-12 => float midiBase;
float freqBase[n];
.1::ms => dur beat;
SinOsc beatLFO => blackhole;
.5*.1*Std.rand2f(.9,1.1) => beatLFO.freq;

for (0 => int i; i < n; i++) {
    osc[i] =>  env[i] => pan[i] => dac;
    
    -1 + 2.*i/(n*1.-1.) => pan[i].pan;
    freqLFO[i] => blackhole;
    harmonicLFO[i] => blackhole;
    Std.mtof(midiBase)*Std.rand2f(.9,1.1) => freqBase[i];
    freqBase[i] => osc[i].freq;
    .25*.1*.5*.1*Std.rand2f(.9,1.1) => freqLFO[i].freq;
    .125*.1*.5*.1*Std.rand2f(.9,1.1) => harmonicLFO[i].freq;
    .5*beat => env[i].duration;
}

while (true) {
    for (0 => int i; i < n; i++) {
            1 => env[i].keyOn;
        }
    (1+beatLFO.last()+.1)*beat => now;
    for (0 => int i; i < n; i++) {
        (1+.01*freqLFO[i].last())*freqBase[i] => osc[i].freq;
        Std.ftoi((2+harmonicLFO[i].last())*6) => osc[i].harmonics;
        1 => env[i].keyOff;
    }
    (1+beatLFO.last()+.1)*beat => now;
}