.1 => float gainSet;
30::second => dur length;
53 => float midiBase;

Noise noise => Gain gain => LPF filtCenter => Gain gainCenter => dac;
gain => LPF filt => Echo echo => Gain gainPan => Pan2 pan => dac;

gainSet => noise.gain;

.2 => gainCenter.gain;

SinOsc panLFO => blackhole; 
SinOsc filtLFO => blackhole;

.1 => panLFO.freq;
.22 => filtLFO.freq;

2 => filt.freq;
2 => filtCenter.freq;

4*Std.mtof(midiBase) => filtCenter.freq;

1.5::second => echo.max => echo.delay;
.5 => echo.mix;
.7 => echo.gain;
echo => echo;

3 => int n;
float x;
SqrOsc osc[n];

for (0 => int i; i < n; i++) {
    Std.rand2f(.1,.5) => osc[i].freq;
    osc[i] => blackhole;
    }

now + length => time future;

while (now < future) {
    
    0 => x;
    
    for (0 => int j; j < n; j ++) {
        
        x+1+osc[j].last() => x;
        
        }
        
        x/n => gain.gain;
     
     1::samp => now;
     
     panLFO.last() => pan.pan;
     (2+filtLFO.last())*Std.mtof(midiBase) => filt.freq;
     
     
    }
    
 20::second => now;