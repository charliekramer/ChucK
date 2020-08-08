/*
SawOsc saw => dac;
SqrOsc LFO => blackhole;
*/
SqrOsc saw => dac;
PulseOsc LFO => blackhole;

.2 => LFO.width;

25*.7 => float baseFreq => saw.freq;
33 => LFO.freq;
50 => float LFOGain => LFO.gain;

SinOsc gainLFO => blackhole;

0.01*.5*.5 => gainLFO.freq;
1 => gainLFO.gain;

while (true) {
    LFO.last()*baseFreq => saw.freq;
    gainLFO.last()*LFOGain => LFO.gain;
    1::samp => now;
    
}