.2 => float gainSet;

45::second => dur length;
20::second => dur outro;

Rhodey osc => LPF filt => Gain gain;
Wurley osc2 => filt => gain;

gainSet => osc.gain => osc2.gain;

57-12-12 => float midiBase;
Std.mtof(midiBase) => osc.freq => osc2.freq;
osc.freq()*4 => filt.freq;
5 => filt.Q;

5 => int n;

Echo echo[n];
Pan2 pan[n];

.25::second => dur beat;

for (0 => int i; i < n; i++) {
    gain => echo[i] => pan[i] => dac;
    
    10*beat => echo[i].max;
    Std.rand2f(.1,10)*beat => echo[i].delay;
    .7 => echo[i].gain;
    .7 => echo[i].mix;
    echo[i] => echo[(i+1)%n];
    
    Std.rand2f(-1,1) => pan[i].pan;
    
    
    }
    
spork~filtLFO();


now + length => time future;

while (now < future) {
    Std.rand2f(0,1) => osc.noteOn;
    Std.rand2f(0,1) => osc2.noteOn;
    12*beat => now;
}

outro => now;

fun void filtLFO() {
    SinOsc LFO => blackhole;
    .1 => LFO.freq;
    
    
    while (true) {
        
        (4.+2*LFO.last())*osc.freq() => filt.freq;
        1::samp => now;
        
    }
    
    }