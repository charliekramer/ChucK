ModalBar bar1 => Echo echo1 => Pan2 pan1 => dac;
ModalBar bar2 => Echo echo2 => Pan2 pan2 => dac;


59 => float midiBase;

SinOsc pitchLFO => blackhole;

.1 => pitchLFO.freq;
.1 => pitchLFO.gain;

SinOsc panLFO => blackhole;

.1 => panLFO.freq;
1 => panLFO.gain;

SinOsc echoLFO => blackhole;

.1 => echoLFO.freq;
.5 => echoLFO.gain;

0 => int j;

8*100::ms => dur beat;

beat - (now % beat) => now;

5*beat => echo1.max => echo2.max;
1.25*beat => echo1.delay => echo2.delay;
.5 => float echoMix => echo1.mix => echo2.mix;
.3 => echo1.gain => echo2.gain;
echo1 => echo1;
echo2 => echo2;

now + 30::second => time future;

while (now < future) {
    
    j % 17 => bar1.preset;
    
    j % 17 +2 => bar2.preset;
    
     panLFO.last() => pan1.pan;
    -panLFO.last() => pan2.pan;
    
    (1+pitchLFO.last())*Std.mtof(midiBase) => bar1.freq;
    (1-pitchLFO.last())*Std.mtof(midiBase) => bar2.freq;
    
    (1+echoLFO.last())*echoMix => echo1.mix => echo2.mix;
    
    1 => bar1.noteOn;
    1 => bar2.noteOn;
    
    beat => now;
    <<< future - now >>>;
}
 
 
 5::second => now;   
    
    