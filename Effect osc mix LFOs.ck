.1 => float gainSet;

.5::minute => dur length;

SinOsc sin => Echo sinEcho => NRev sinRev => Pan2 sinPan => dac;
TriOsc tri => Echo triEcho => NRev triRev => Pan2 triPan => dac;
SqrOsc sqr => Echo sqrEcho => NRev sqrRev => Pan2 sqrPan => dac;
PulseOsc pulse => Echo pulseEcho => NRev pulseRev => Pan2 pulsePan =>  dac;

.2 => sinRev.mix => triRev.mix => sqrRev.mix => pulseRev.mix;

-1 => sinPan.pan;
.25 => triPan.pan;
-.25 => sqrPan.pan;
1 => pulsePan.pan;



6::second => sinEcho.max => triEcho.max => sqrEcho.max => pulseEcho.max;
5::second => sinEcho.delay => triEcho.delay => sqrEcho.delay=> pulseEcho.delay;
.5 => sinEcho.mix => triEcho.mix=> sqrEcho.mix=> pulseEcho.mix;
.5 => sinEcho.gain => triEcho.gain => sqrEcho.gain => pulseEcho.gain;
sinEcho => sinEcho;triEcho => triEcho;sqrEcho => sqrEcho; pulseEcho => pulseEcho;

.25 => pulse.width;

60-12 => float midiBase;

gainSet => sin.gain => tri.gain => sqr.gain => pulse.gain;

Std.mtof(midiBase) => sin.freq => tri.freq => sqr.freq => pulse.freq;

SinOsc sinLFO => blackhole;
SinOsc triLFO => blackhole;
SinOsc sqrLFO => blackhole;
SinOsc pulseLFO => blackhole;

1.1 => float freqMult;

.05 => sinLFO.freq;
sinLFO.freq()*freqMult => triLFO.freq;
triLFO.freq()*freqMult => sqrLFO.freq;
sqrLFO.freq()*freqMult => pulseLFO.freq;

now + length => time future;

while (now < future) {
    
    .5*(1+sinLFO.last())*gainSet => sin.gain;

    .5*(1+triLFO.last())*gainSet => tri.gain;
    
    .5*(1+sqrLFO.last())*gainSet => sqr.gain;
    
    .5*(1+pulseLFO.last())*gainSet => pulse.gain;
    
    1::samp => now;
    
}

while (gainSet > .01) {
    
    gainSet*.999999 => gainSet;
    
    .5*(1+sinLFO.last())*gainSet => sin.gain;

    .5*(1+triLFO.last())*gainSet => tri.gain;
    
    .5*(1+sqrLFO.last())*gainSet => sqr.gain;
    
    .5*(1+pulseLFO.last())*gainSet => pulse.gain;
    
    1::samp => now;
}
    