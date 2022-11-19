
.2 => float gainSet;
47 => float midiBase;
.1 => float midiGap; // target gap between notes
1./15 => float LFOfreq1; // rate at which moves toward/away gap
1./17 => float LFOfreq2;
(LFOfreq1 + LFOfreq2) => float filtFreq; // rate for filter cutoff

60::second => dur length;
10::second => dur outro;

.25::second*2*2*2*2 => dur beat;

beat - (now % beat) => now;

Rhodey osc1 => LPF filt1 => Gain gain1 => dac;
Wurley osc2 => LPF filt2 => Gain gain2 => dac;

gain1 => Echo echo1 => Pan2 pan1 => dac;
gain2 => Echo echo2 => Pan2 pan2 => dac;

1.5*beat => echo1.max => echo1.delay;
.8 => echo1.gain => echo1.mix;
echo1 => echo1;

1.55*beat => echo2.max => echo2.delay;
.8 => echo2.gain => echo2.mix;
echo2 => echo2;

.75 => pan1.pan;
-.75 => pan2.pan;

gainSet => osc1.gain => osc2.gain;

SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;

SinOsc filtLFO => blackhole;

LFOfreq1 => LFO1.freq;
LFOfreq2 => LFO2.freq;
filtFreq => filtLFO.freq;

6*Std.mtof(midiBase+midiGap) => filt1.freq => filt2.freq;
5 => filt1.Q => filt2.Q;

now + length => time future;

while(now < future) {
 
 Std.mtof(midiBase+Math.fabs(LFO1.last())*midiGap) => osc1.freq;   
 Std.mtof(midiBase+Math.fabs(LFO2.last())*midiGap) => osc2.freq; 
 
 1 => osc1.noteOn;
 1 => osc2.noteOn;
 
 beat => now;  
 
 1 => osc1.noteOff;
 1 => osc2.noteOff;
 
 8*Std.mtof(midiBase+midiGap)*(1.1+filtLFO.last()) => filt1.freq => filt2.freq;
 
}

outro => now;
