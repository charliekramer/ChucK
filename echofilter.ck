
.25 => float gainSet;

30::second => dur length;
15::second => dur outro;

35 => float midiBase;

.2 => float LFORate; //rate for delay time LFO

SawOsc osc => Envelope env => Echo echo => Echo echo2 => dac.left;


echo2 => Echo echo3 => NRev rev => dac.right;

gainSet => osc.gain;

1.5::second => dur beat;

.5*beat => env.duration;

2*beat => echo2.max;
beat => echo2.delay;
.5 => echo2.gain;
.5 => echo2.mix;
echo2 => echo2;

2*beat => echo3.max;
2*echo2.delay() => echo3.delay;
.5 => echo3.gain;
.5 => echo3.mix;
echo3 => echo3;

Std.mtof(midiBase) => osc.freq;

SinOsc LFO => blackhole;
LFORate => LFO.freq;

1::second => echo.max;

1.2/osc.freq()*second => echo.delay;
.9 => echo.gain;
1 => echo.mix;
echo => echo;

now + length => time future;

1 => env.keyOn;

while (now < future) {
    
    
    (1+LFO.last())*.5 => echo.mix;
    
    1::samp => now;
    
}

1 => env.keyOff;

outro => now;
