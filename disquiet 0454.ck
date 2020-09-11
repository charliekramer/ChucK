SinOsc osc1 => Echo echo1 => Pan2 pan1 => dac;
SinOsc osc2 => Echo echo2 => Pan2 pan2 => dac;
SinOsc osc3 => Echo echo3 => Pan2 pan3 => dac;

.5 => float gain1;
.5*0 => float gain2;
.5*0 => float gain3;

30::second => dur length;

SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;
SinOsc LFO3 => blackhole;
.10 => LFO1.freq;
.03 => LFO2.freq;
.07 => LFO3.freq;

45 => int midiBase;
[3,1,18,15,12,9,14,5] @=> int notes1[];
[5,12,9,26,1,2,5,20,8] @=> int notes2[];
[11,18,1,13,5,18] @=> int notes3[];

.25::second => dur beat;
beat - (now % beat) => now;

4*beat => echo1.max => echo2.max => echo3.max;
1.5*beat => echo1.delay;
2/3*beat => echo2.delay;
2.25*beat => echo3.delay;
.8 => echo1.gain => echo2.gain => echo3.gain;
.0 => echo1.mix => echo2.mix => echo3.mix;
//echo1 => echo2 => echo3 => echo1;

0 => int i;

spork~LFOGains();

now + length => time future;

while (now < future) {
        
        Std.mtof(midiBase+notes1[i % notes1.cap()]) => osc1.freq;
        Std.mtof(midiBase+notes2[i % notes2.cap()]) => osc2.freq;
        Std.mtof(midiBase+notes3[i % notes3.cap()]) => osc3.freq;
        
        beat => now;
     
    i++;
}

5::second => now;

fun void LFOGains() {
    while (true) {
        (1+LFO1.last())/2*gain1 => osc1.gain;
        (1+LFO2.last())/2*gain2 => osc2.gain;
        (1+LFO3.last())/2*gain3 => osc3.gain;
        LFO1.last() => pan1.pan;
        LFO2.last() => pan2.pan;
        LFO3.last() => pan3.pan;
        1::samp => now;
    }
}
        
    
    