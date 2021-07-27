
.1 => float gainSet;
500 => float impGain; // to drive filter
1.25::second => dur beat => dur baseBeat;
30::second => dur length;
15::second => dur outro;

76 => float midiBase;

Impulse imp => BPF filt => NRev rev => dac.left;
filt => Echo echo => NRev rev2 => dac.right;

impGain => imp.gain;

Std.mtof(midiBase) => filt.freq;
20 => filt.Q;

.2 => rev.mix => rev2.mix;

100*beat => echo.max => echo.delay;

spork~echoLFO();

now + length => time future;

while (now < future) {
 
 1 => imp.next;
 beat => now;
    
}

outro => now;

fun void echoLFO() {
 SinOsc LFO => blackhole;
 .053 => LFO.freq;
 
 while (true) {
  (10.1+10*LFO.last())*beat => echo.delay;
  (1.+LFO.last())*Std.mtof(midiBase) => filt.freq;
  (1.1+LFO.last())*(1.1+LFO.last())*baseBeat => beat;
  1::samp => now;   
     
 }
 
    
}
