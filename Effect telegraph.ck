.2 => float gainSet;

TriOsc sin => Envelope env1 => Envelope env2 => Envelope env3 => Echo echo => dac;
TubeBell rhodes => env1 => env2 => env3 => echo => dac;
BandedWG band => env1 => env2 => env3 => echo => dac;

gainSet => sin.gain;
gainSet*1 => rhodes.gain => float rhodesBaseGain;
gainSet*1 => band.gain => float bandBaseGain;

SinOsc gainLFO => blackhole;

.1 => gainLFO.freq;

.05::second => dur beat;

<<< env1.duration(), env2.duration(), env3.duration() >>>;

10*beat => echo.max;
7.5*beat => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

57-12 => float midiBase;

while (true) {
    Std.rand2(0,1) => env1.keyOn;
    Std.rand2(0,1) => env2.keyOn;
    Std.rand2(0,1) => env3.keyOn;
    1 => rhodes.noteOn;
    1 => band.noteOn;
    (.5+.5*gainLFO.last())*2*rhodesBaseGain => rhodes.gain;
    (1-(.5+.5*gainLFO.last())*2)*bandBaseGain => band.gain;
    (1+env1.value())*(1+env2.value())*(1+env3.value())*Std.mtof(midiBase) => sin.freq;
    sin.freq() => rhodes.freq => band.freq;
    beat => now;
    Std.rand2(0,1) => env1.keyOff;
    Std.rand2(0,1) => env2.keyOff;
    Std.rand2(0,1) => env3.keyOff;
    1 => rhodes.noteOff;
    1 => band.noteOff;
    (1+env1.value())*(1+env2.value())*(1+env3.value())*Std.mtof(midiBase) => sin.freq;
    sin.freq() => rhodes.freq => band.freq;
    beat => now;
}