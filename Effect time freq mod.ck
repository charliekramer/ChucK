Blit osc => Envelope env => dac;
SinOsc beatLFO => blackhole;
SinOsc freqLFO => blackhole;

SinOsc harmonicLFO => blackhole;

.5*.1 => beatLFO.freq;
.25*.125 => freqLFO.freq;

.2*.125 => harmonicLFO.freq;

6 => osc.harmonics;
57 => float midiBase;
Std.mtof(midiBase) => osc.freq;

1::ms => dur beat;
.5*beat => env.duration;

while (true) {
    1 => env.keyOn;
    (1+beatLFO.last()+.1)*beat => now;
    (1+.01*freqLFO.last())*Std.mtof(midiBase) => osc.freq;
    Std.ftoi((2+harmonicLFO.last())*6) => osc.harmonics;
    
    1 => env.keyOff;
    (1+beatLFO.last()+.1)*beat => now;
}