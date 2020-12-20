.2 => float gainSet;
SinOsc sin => Envelope env => dac.left;
SqrOsc sqr => LPF filt => env => dac.left;
TriOsc tri => env => dac.left;
PulseOsc pulse => filt => env => dac.left;
.25 => pulse.width;
gainSet => sin.gain; 
gainSet*.9 => sqr.gain; 
gainSet => tri.gain;
gainSet *.9=> pulse.gain;

dac.left => Echo echo => dac.right;
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

2.24::second*2 => dur beat;
1.5*beat => echo.max => echo.delay;

61.-12-12 => float midiBase;

Std.mtof(midiBase+24+6) => filt.freq;
1 => filt.Q;



8*beat => dur length;

now + length => time future;

1 => env.keyOn;

while (now < future) {
    Std.mtof(midiBase) => sin.freq;
    Std.mtof(midiBase-12) => sqr.freq;
    Std.mtof(midiBase+7) => tri.freq;
    Std.mtof(midiBase+11) => pulse.freq;
    beat => now;
    7 +=> midiBase;
    Std.mtof(midiBase) => sin.freq;
    Std.mtof(midiBase-12) => sqr.freq;
    Std.mtof(midiBase+7) => tri.freq;
    Std.mtof(midiBase+11) => pulse.freq;
    beat => now;
    7 -=> midiBase;
 }
 
 1 => env.keyOff;
 
 <<< "ending" >>>;
 
 15*beat => now;
   