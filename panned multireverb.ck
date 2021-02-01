.1 => float gainSet;
.2 => float returnGain; // echo return;
.1 => float revMix;

1 => float nBeat; //  2, .5 number of beats in dur beat
8 => float beats; // 4 number of beat per loop

60::second => dur length;

57 - 12 => float midiBase;

Std.mtof(midiBase) => float filtFreq;

[0.,4., 5.,7.,-4.,-5.,-7.] @=> float notes[];

.2 => float noteProb;

Impulse imp => BPF filt => Gain gain => dac;
200 => imp.gain;
200 => filt.Q;
filtFreq => filt.freq;

imp => LPF filt2 => gain => dac;
200 => filt2.Q;
filtFreq => filt2.freq;
.01 => float filt2Gain => filt2.gain;


imp => BRF filt3 => LPF filtH => gain => dac;
200 => filt3.Q;
filtFreq => filt3.freq;
.03 => float filt3Gain => filt3.gain;
10*filtFreq => filtH.freq;
2 => filtH.Q;

Gain return_gain;

gainSet => gain.gain;

3 => int n;
Echo echo[n];
Pan2 pan[n];

gain => echo[0] => NRev rev1 => pan[0] => dac;
gain => echo[1] => PRCRev rev2 => pan[1] => dac;
gain => echo[2] => JCRev rev3 => pan[2] => dac;

-1 => pan[0].pan;
1 => pan[1].pan;

revMix => rev1.mix => rev2.mix => rev3.mix;

.25::second*nBeat => dur beat;
for (0 => int i; i < n; i++) {
    2::second => echo[i].max;
    beat*(1+i) => echo[i].delay;
    .7 => echo[i].gain;
    1 => echo[i].mix;
}

echo[2] => return_gain => echo[0] => return_gain => echo[1] => return_gain => echo[2];

spork~gainLFO(0.025,.0375,.0125); // echo chain, filt2 (LPF), filt3 (BRF)

beat - (now % beat) => now;

now + length => time future;

while (now < future) {
    1 => imp.next;
    beats*beat => now; //5 i cool too
    if (Std.rand2f(0,1) > 1 - noteProb) {
        Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => filtFreq;
        <<< "note reset" >>>;
        filtFreq => filt.freq => filt2.freq => filt3.freq;
    }
    
}

10::second => now;

fun void gainLFO(float freq1, float freq2, float freq3) {
    SinOsc LFO1 => blackhole;
    freq1 => LFO1.freq;
    SinOsc LFO2 => blackhole;
    freq2 => LFO2.freq;
    SinOsc LFO3 => blackhole;
    freq3 => LFO3.freq;
    
    while (true) {
        
        Math.fabs(LFO1.last())*returnGain => return_gain.gain;
        Math.fabs(LFO2.last())*filt2Gain => filt2.gain;
        Math.fabs(LFO3.last())*filt3Gain => filt3.gain;
        1::samp => now;
    }
}
    
    

