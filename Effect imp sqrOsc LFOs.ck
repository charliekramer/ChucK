//Impulse imp => LPF filt => HPF filt2 => Dyno dyn => dac;
Impulse imp => HPF filt => LPF filt2 => Dyno dyn => dac;

100 => imp.next;

.15::second=> dur beat;
beat - (now % beat) => now;

55*2 => float baseFreq => filt.freq => filt2.freq;
15 => filt.Q => filt2.Q;

SqrOsc LFO1 => blackhole;
SqrOsc LFO2 => blackhole;

.5 => LFO1.freq;
.35 => LFO2.freq;

baseFreq => float bF;

SqrOsc LFO3 => blackhole;
SqrOsc LFO4 => blackhole;

.2 => LFO3.freq;
.25 => LFO4.freq;



while (true) {
    100 => imp.next;
    beat => now;
    (3.5+LFO1.last()+LFO2.last())*bF => filt.freq => filt2.freq;
    Std.rand2f(5,40) => filt.Q;
    Std.rand2f(5,40) => filt2.Q;
    (4+LFO3.last()+LFO4.last())*baseFreq/4 => bF;
      
}