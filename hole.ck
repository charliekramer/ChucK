.5 => float gainSet;

SinOsc sin => ADSR env => Echo echo => dac;
SawOsc saw => env => echo =>dac;
TriOsc tri => env => echo => dac;
SqrOsc sqr => env => echo => dac;

gainSet => sin.gain;
.005*gainSet => saw.gain;
.005 *gainSet => sqr.gain;
.2*gainSet => tri.gain;


51-24+24 => float midiBase;
Std.mtof(midiBase) => sin.freq => saw.freq => tri.freq => sqr.freq;

1.2::second*2/3 => dur beat;
beat - (now % beat) => now;

(10::ms, 1::ms, 1., 250::ms) => env.set;

4*beat => echo.max;
.25*beat => echo.delay;
.5 => echo.gain => echo.mix;

spork~echoLFO();


while (true) {
    1 => env.keyOn;
    .5*beat => now;
    1 => env.keyOff;
    .5*beat => now;
}
    
fun void echoLFO() {
        SinOsc LFO => blackhole;
        2000*.25*.5*.5*.5*.5*.5*.5*.5*.5*.5=> LFO.freq;
    
    while (true) {
        (1+LFO.last()+.1)*.5*beat => echo.delay;
        1::samp => now;
    }
        
}        
    

