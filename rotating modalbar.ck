.1 => float gainSet;

-.75 => float panSet;
.5 => float cutoff;

43-12 => float midiBase;

.25::second*4 => dur beat;

60::second => dur length;
60::second => dur outro;

ModalBar osc => Echo echo => Gain gain => NRev rev  => Pan2 pan => dac;

gain => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;

panSet => pan.pan;
-panSet => pan2.pan;

2*beat => echo.max => echo2.max;
1.5*beat => echo.delay;
1.5*beat*.25 => echo2.delay;

.5 => echo.mix => echo2.mix;
.5 => echo.gain => echo2.gain;

echo => echo;
echo2 => echo2;
echo2 => echo;

spork~revLFO();

now + length => time future;

while (now < future) {
 
 Std.mtof(midiBase + Std.rand2(0,4)*7) => osc.freq;
 
 1 => osc.noteOn;
 beat => now;   
 
 if (Std.rand2f(0,1) > cutoff) {
     Std.rand2f(.1,2)*beat => echo2.delay;
     }
    
}


while (pan2.gain() > .025) {
 pan.gain()*.999 => pan.gain;
 pan2.gain()*.999 => pan2.gain;
 10::ms => now;
}


fun void revLFO() {
 SinOsc LFO1 => blackhole;
 SinOsc LFO2 => blackhole;
 .05 => LFO1.freq;
 .055 => LFO2.freq;
 
 while (true) {
  
  (1+LFO1.last())*.5 => rev.mix;
  (1+LFO2.last())*.5 => rev2.mix;
  
  1::samp => now;   
 }
 
     
}
