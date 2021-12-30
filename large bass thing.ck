
.01 => float gainSet;

44-12 => float midiBase;


ADSR env;


5.25::second => dur beat;

(beat, beat, 1.0, 2*beat) => env.set;

spork~oscs();

1 => env.keyOn;
2*beat => now;
1 => env.keyOff;
8*beat => now;




fun void oscs() {
    SinOsc SinLFO => blackhole;
    SinOsc SqrLFO => blackhole;
    SinOsc TriLFO => blackhole;
    SinOsc SawLFO => blackhole;
    
    Gain gain;
    
    SinOsc sin => env => gain => Echo echoSin => NRev SinRev => Pan2 SinPan => dac;
    SawOsc saw => env => gain => Echo echoSaw => NRev SawRev => Pan2 SawPan => dac;
    SqrOsc sqr => env => gain => Echo echoSqr => NRev SqrRev => Pan2 SqrPan => dac;
    TriOsc tri => env => gain => Echo echoTri => NRev TriRev => Pan2 TriPan => dac;
    
    .75*beat => echoSin.max => echoSin.delay => echoSqr.max => echoSqr.delay =>
                echoSaw.max => echoSaw.delay => echoTri.max => echoTri.delay;
    .5 => echoSin.gain => echoSaw.gain => echoSqr.gain => echoTri.gain;
    .5 => echoSin.mix => echoSaw.mix => echoSqr.mix => echoTri.mix;
    echoSin => echoSin;
    echoSaw => echoSaw;
    echoSqr => echoSqr;
    echoTri => echoTri;
    
    .5 => SinRev.mix => SawRev.mix => SqrRev.mix => TriRev.mix;
                
    Std.rand2f(-1,-.5) => SinPan.pan;
    Std.rand2f(-.5,0) => SawPan.pan;
    Std.rand2f(0,.5) => SqrPan.pan;
    Std.rand2f(.5,1) => TriPan.pan;
    
    Std.mtof(midiBase) => sin.freq => saw.freq => sqr.freq => tri.freq;
    gainSet => gain.gain;
    
    
    
    Std.rand2f(.05,.1) => SinLFO.freq;
    SinLFO.freq()*1.1 => SqrLFO.freq;
    SinLFO.freq()*1.2 => TriLFO.freq;
    SinLFO.freq()*1.3 => SawLFO.freq;
    
    while (true) {
        
        Math.fabs(SinLFO.last())*1.00 => sin.gain;
        Math.fabs(SawLFO.last())*0.07 => saw.gain;
        Math.fabs(SqrLFO.last())*0.10 => sqr.gain;
        Math.fabs(TriLFO.last())*0.80 => tri.gain;
        
        1::samp => now;
        
        }
    
    
    
    
    }