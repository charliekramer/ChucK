Impulse imp =>  ResonZ filt => Gain Gain1 => Dyno dyn => Pan2 pan1 => dac;
Impulse imp2 => ResonZ filt2 => Gain1 => pan1=> dac;
Impulse imp3 => ResonZ filt3 => Gain1 => pan1 => dac;
Gain1 => NRev rev => Dyno dyn2 => Pan2 pan2 => dac;
Gain1 => NRev rev2 => Echo echo => PitShift pitch => dac;

.1 => Gain1.gain;

-1 => pan1.pan;
pan1.pan()*-1 => pan2.pan;

SinOsc pitchLFO => blackhole;
.1*.05 => pitchLFO.freq;
1 => pitch.mix;


60./50. => float beatSec;
beatSec::second => dur beat;

beat*5 => echo.max;
beat*1.5 => echo.delay;
.5 => echo.gain;
.7 => echo.mix;
echo => echo;

SinOsc QLFO => blackhole;

.9 => rev.mix;
.9 => rev2.mix;

.4 => QLFO.freq;

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


while (true) {
    impGain => imp.next;
    (1.1+QLFO.last())*(1.1+QLFO.last())*baseQ + minQ => filt.Q => filt2.Q => filt3.Q;
    pitchLFO.last() => pitch.shift;
    <<< "filt.Q", filt.Q() >>>;
    
    beat => now;
    
    beat => now;
    
    
}