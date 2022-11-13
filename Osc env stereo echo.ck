.2 => float gainSet;

30::second => dur length;

60::second => dur outro;

1.125::second*2 => dur beat;

.1 => float cutoff;

TriOsc osc => Envelope env => Echo echoL => PitShift pitchL => NRev revL => dac.left;
echoL => Gain gainR => Echo echoR => PitShift pitchR => NRev revR => dac.right;

gainSet => osc.gain;



3*beat => echoL.max => echoL.delay;
.5 => echoL.gain => echoL.mix;
echoL => echoL;

.7 => revL.mix => revR.mix;

1.75*echoL.delay() => echoR.max => echoR.delay;
.5 => echoR.gain => echoR.mix;
echoR => echoR;

1/echoL.gain() => gainR.gain;

spork~pitchLFOSqr(.05,.015,.5); //freq, gain for pitch LFO, mix for pitch shifters
spork~pitchLFOSin(.1,.015,1);

now + length => time future;

while (now < future) {
    1 => env.keyOn;
    
    beat => now;
    
    1 => env.keyOff;
    
    beat => now;
    
    if (Std.rand2f(0,1) > cutoff) {
        Std.rand2f(5,15)*beat => now;
        }
    
    }
    
 outro => now;
 
 fun void pitchLFOSin(float freq, float gain, float mix) {
     
     SinOsc LFOL => blackhole;
     SinOsc LFOR => blackhole;
     
     mix => pitchL.mix => pitchR.mix;
     
     gain => LFOL.gain => LFOR.gain;
     freq => LFOL.freq;
     freq*.9 => LFOR.freq;
     
     while (true) {
         (1+LFOL.last()) => pitchL.shift;
         (1+LFOR.last()) => pitchR.shift;
         1:: samp => now;
     }
     
 }
    
fun void pitchLFOSqr(float freq, float gain, float mix) {
    
    SqrOsc LFOL => blackhole;
    SqrOsc LFOR => blackhole;
    
    mix => pitchL.mix => pitchR.mix;
        
    gain => LFOL.gain => LFOR.gain;
    freq => LFOL.freq;
    freq*.9 => LFOR.freq;
    
    while (true) {
        (1+LFOL.last()) => pitchL.shift;
        (1+LFOR.last()) => pitchR.shift;
        1:: samp => now;
        }
    
    }