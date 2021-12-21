
.5 => float gainSet;
44+12-12-12 => float midiBase;
30::second => dur length;

TriOsc osc => ADSR env => Gain gain => LPF filt1 => Pan2 pan1 => dac;
SqrOsc osc2 => env;
SawOsc osc3 => env;
gain => Echo echo => LPF filt2 => Pan2 pan2 => dac;

gainSet => gain.gain;

Std.mtof(midiBase) => osc.freq => osc2.freq => osc3.freq;

2*osc.freq() => filt1.freq => float filt1Base;
8*osc.freq() => filt2.freq => float filt2Base;
2 => filt1.Q => filt2.Q;

2*2*8*.25::second => dur beat;

beat - (now %beat) => now;

.125*beat => dur a;
.0*beat => dur d;
.00*beat => dur s;
 beat - a => dur r;

.25*beat => echo.max => echo.delay;
.9 => echo.gain;
1 => echo.mix;
echo => echo;

spork~rotatePan(.05);
spork~rotateFilt(.1,.11,.5);

now + length => time future;

while (now < future) {
 
    1 => env.keyOn;
    a => now;
    1 => env.keyOff;
    r => now;
    
}

10*beat => now;
 
 fun void rotateFilt(float rate1, float rate2, float delta) {
     SinOsc sin1 => blackhole;
     rate1 => sin1.freq;
     SinOsc sin2 => blackhole;
     rate2 => sin2.freq;
     while (true) {
         (1+sin1.last()*delta)*filt1Base => filt1.freq;
         (1+sin2.last()*delta)*filt2Base => filt2.freq;
         1::samp => now;
     }
    
     
     }   
    
fun void rotatePan(float rate) {
    SinOsc sin => blackhole;
    rate => sin.freq;
    while (true) {
        sin.last() => pan2.pan;
        -sin.last() => pan1.pan;
        1::samp => now;
        } 
        
    }