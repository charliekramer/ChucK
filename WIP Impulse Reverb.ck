Impulse imp =>  ResonZ filt => Gain Gain1 => Dyno dyn => dac.left;
Impulse imp2 => ResonZ filt2 => Gain1 => dac.left;
Impulse imp3 => ResonZ filt3 => Gain1 => dac.left;
Gain1 => NRev rev => dyn => dac.right;

SinOsc LFO => blackhole;

.1 => rev.mix;

.1 => LFO.freq;

40 => float impGain => imp.gain;

Std.mtof(61-12) => filt.freq;
filt.freq()*.5 => filt2.freq;
filt.freq()*1.5 => filt3.freq;

100 => float baseQ => filt.Q => filt2.Q => filt3.Q;
10 => float minQ;


/*
BiQuad
.99 => filt.prad; 
1 => filt.eqzs;
*/

60./50. => float beatSec;
beatSec::second => dur beat;

while (true) {
    impGain => imp.next;
    (1.1+LFO.last())*(1.1+LFO.last())*baseQ + minQ => filt.Q => filt2.Q => filt3.Q;
    <<< "filt.Q", filt.Q() >>>;
    beat => now;
    beat => now;
    
    
}