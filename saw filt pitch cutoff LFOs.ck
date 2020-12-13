.1 => float gainSet;

3::minute => dur length;

SawOsc saw => Envelope env => LPF filt => Echo echo1 => Echo echo2 => dac;
echo2 => Echo echo3 => dac.left;
echo1 => Echo echo4 => dac.right;

gainSet => saw.gain;

SinOsc pitchLFO => blackhole;
SinOsc filtLFO => blackhole;

SinOsc echo3gain => blackhole;
SinOsc echo4gain => blackhole;

.1 => pitchLFO.freq;
.15 => filtLFO.freq;

.05 => echo3gain.freq;
.045 => echo4gain.freq;

57 => float midiBase;

4::second => echo1.max => echo2.max;
1.5::second => echo1.delay;
1.5*echo1.delay() => echo2.delay;
.7 => echo1.mix => echo2.mix;
.7 => echo1.gain => echo2.mix;
echo2 => echo1;

4::second => echo3.max => echo4.max;
1.25::second => echo3.delay;
1.25*echo1.delay() => echo4.delay;
.2 => echo3.mix => echo4.mix;
.2 => echo3.gain => echo4.gain;
echo3 => echo3;
echo4 => echo4;

now + length => time future;

1 => env.keyOn;

while (now < future) {
    (1+.05*pitchLFO.last())*Std.mtof(midiBase) => saw.freq;
    (2+filtLFO.last())*Std.mtof(midiBase) => filt.freq;
    (.5 + .5*echo3gain.last()) => echo3.gain;  
    (.5 + .5*echo4gain.last()) => echo4.gain;
    1::samp => now;
}

1 => env.keyOff;

.5::minute => now;

    