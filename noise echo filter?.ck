.5 => float gainSet;

100::ms => dur beat; // multiply by say 10 or 15 for long drone

60::second => dur length;

30::second => dur outro;

Noise noise => LPF filt => Echo echo => Echo longEcho => dac;

gainSet => noise.gain;

58 => float midiBase;

Std.mtof(midiBase) => filt.freq;
20 => filt.Q;

10::ms => dur echoBase; 

40::ms => echo.max => echo.delay;

echo => echo;

SinOsc LFOEcho => blackhole;

.5 => LFOEcho.freq; //.5, .25

SqrOsc LFOBeat => blackhole;
PulseOsc LFOBeat2 => blackhole;

4*LFOEcho.freq() => LFOBeat.freq;// multiple of LFOECho.freq;/ 4
.5*LFOBeat.freq() => LFOBeat2.freq;
.25 => LFOBeat2.width;
1 => LFOBeat2.gain; // zero out for simpler arpeggio sound

1.5::second => longEcho.max => longEcho.delay; //1.5 second;
.3 => longEcho.gain;
.3 => longEcho.mix;
longEcho => longEcho;

now + length => time future;

while (now < future) {
    
   (1+LFOEcho.last()+1)*echoBase => echo.delay;
   beat*(2+LFOBeat.last())*(1+.45*LFOBeat2.last()) => now; 
   
    
}

.9 => echo.gain => echo.mix;

0 => noise.gain;

outro => now;