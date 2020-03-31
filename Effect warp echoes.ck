.5 => float gainSet;
Clarinet rhodes =>  Echo echo1 => PitShift pitch1 => Gain gain1 =>dac;
rhodes =>  Echo echo2 => PitShift pitch2 => Gain gain2 =>dac;

SinOsc gainLFO => blackhole;
SinOsc pitch1LFO => blackhole;
SinOsc pitch2LFO => blackhole;

gainSet => rhodes.gain;

44-12 => float midiBase;
Std.mtof(midiBase) => rhodes.freq;

40::second => dur length;

1 => gainLFO.gain;
.05 => gainLFO.freq;

.01 => pitch1LFO.gain;
.0250 => pitch1LFO.freq;

.05 => pitch2LFO.gain;
.033 => pitch2LFO.freq;

(60./94.)::second*4 => dur beat;

3::second => dur dur1;
1.7::second => dur dur2;

dur1 => echo1.max => echo1.delay;
.5 => echo1.gain;
.5 => echo1.mix;
echo1 => echo1;

dur2 => echo2.max => echo2.delay;
.5 => echo2.gain;
.5 => echo2.mix;
echo2 => echo2;

1 => pitch1.mix;
1 => pitch2.mix;

spork~LFOs();

now + length => time future;
while (now < future) {
    
    1 => rhodes.noteOn;
    beat => now;
   // 1 => rhodes.noteOff;
   // beat => now;
    
}
1 => rhodes.noteOff;
20::second => now;


fun void LFOs() {
    while (true) {
        1+pitch1LFO.last() => pitch1.shift;
        1+pitch2LFO.last() => pitch2.shift;
        Std.fabs(gainLFO.last())  => gain1.gain;
        1 - gain1.gain() => gain2.gain;
        1::samp => now;
    }
}