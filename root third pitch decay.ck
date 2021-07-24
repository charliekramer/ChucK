
.3 => float gainSet;

44 => float midiBase;

60::second => dur length;
120::second => dur outro;

SinOsc LFOL => blackhole;
SinOsc LFOR => blackhole;

.2 => LFOL.freq;
.15 => LFOR.freq;

.999 => float pitchDelta; // pitch decay
.99 => float echoDelta; // offset to echo beat
1./.9 => float beatDelta; // beat*beatDelta => beat;

SqrOsc osc => Envelope env => Echo echo => Dyno dyn => Gain gainL => dac;
osc => env => echo => dyn => Gain gainR => dac.right;

gainSet => osc.gain;

2::second*2*2*2 => dur beat;

2*beat*echoDelta => echo.max => echo.delay;
.9 => echo.gain => echo.mix;
echo => echo;

spork~gainLFOs(.5); // float passed = LFO gains

1 => env.keyOn;

now + length => time future;

while (now < future) {
    
    Std.mtof(midiBase) => osc.freq;
    3./8.*beat => now;
    Std.mtof(midiBase+4) => osc.freq;
    5./8.*beat => now;
    midiBase*pitchDelta => midiBase;
    beat*beatDelta => beat;
    
    }

1 => env.keyOff;
outro => now;

fun void gainLFOs(float alpha) {
    while (true) {
        (1+alpha*LFOL.last()) => gainL.gain;
        (1+alpha*LFOR.last()) => gainR.gain;
        1::samp => now;
    }
    
    
    }
