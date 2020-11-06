StifKarp osc => LPF filt => Gain gain => dac;
gain => Echo echo => dac;

5::second => dur beat;

4*beat => echo.max;
.251.5*beat => echo.delay;
.9 => echo.gain;
.7 => echo.mix;
echo => echo;

Std.mtof(44) => osc.freq;
Std.mtof(440) => filt.freq; // goes bonkers with osc freq at 44 and filt freq at 440
5 => filt.Q;

1 => osc.pickupPosition;
1 => osc.sustain;
.1 => osc.stretch;
1 => osc.pluck;

//spork~filtLFO(Std.mtof(440),.1,.1);

beat => now;

1 => osc.noteOff;


while (echo.mix() > .001) {
    echo.mix()*.99 => echo.mix;
    50::ms => now;
} 


fun void filtLFO(float centerFreq, float freq, float gain) {
    SinOsc LFO => blackhole;
    freq => LFO.freq;
    gain => LFO.gain;
    while (true) {
        (1+LFO.last())*filt.freq() => filt.freq;
        1::samp => now;
    }
    
}