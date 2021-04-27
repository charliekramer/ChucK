Bowed osc => Gain gain => NRev revL => Pan2 panL => dac;
gain => Echo echo => NRev revR => Pan2 panR => dac;

.3 => float gainSet;
47-12 => float midiBase;
.04 => float vibGain; // .40 => weird freakout
90::second => dur length;

5::second => echo.max => echo.delay;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

.2 => revL.mix => revR.mix;

Std.rand2f(-1,1) => panL.pan;
-1*panL.pan() => panR.pan;

Std.mtof(midiBase) => osc.freq;

.5 => osc.bowPressure;
.5 => osc.bowPosition;

400.2 => osc.vibratoFreq;

vibGain => osc.vibratoGain;

1 => osc.startBowing;

spork~vibGainLFO(osc.vibratoGain());

now + length => time future;

while (now < future) {
 
 1::samp => now;
    
}

20::second => now;


fun void vibGainLFO(float baseGain) {
 SinOsc sin => blackhole;
 .1 => sin.freq;
 while (true) {
     (1+sin.last()*.5)*baseGain => osc.vibratoGain;
     1::samp => now;
     }  
    
}