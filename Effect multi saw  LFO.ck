.2 => float gainSet;
10 => int n;
SawOsc saw[n];

3::second => dur breaks;
.5 => float pBreak;
5::second => dur beat; //used to test for break;

Rhodey sin => Echo echo => dac;
Flute tri => echo => dac;

gainSet => sin.gain;
gainSet => tri.gain;

beat*5 => echo.max;
beat*.25*1.5 => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

1 => float baseFreq;
.9 => float freqMult;

60-12-1.3-12 => float midiBase;

for (0 => int i; i < saw.cap(); i++) {
    saw[i] => blackhole;
    Math.pow(freqMult,i+1)*baseFreq => saw[i].freq;
    <<< " i freq ", i, saw[i].freq() >>>;
}
1 => sin.noteOn;
1 => tri.noteOn;
while (true) {
    
    Std.mtof(midiBase)*(1+sum()/saw.cap()) => sin.freq;
    Std.mtof(midiBase)*Math.pow((1+sum()/saw.cap()),.5) => tri.freq;
    
    1::samp => now;
    if ( ( (now % beat) == 0::second) && (Std.rand2f(0,1) > pBreak)) {
        1 => sin.noteOff;
        1 => tri.noteOff;
        0 => sin.gain;
        0 => tri.gain;
        <<< " break " >>>;
        breaks => now;
        gainSet => sin.gain;
        gainSet => tri.gain;
        1 => sin.noteOn;
        1 => tri.noteOn;
        Std.rand2f(.125,.75)*1.5*beat => echo.delay;
    }
        
}


fun float sum () {
    0 => float total;
    for (0 => int i; i< saw.cap(); i++) {
        saw[i].last() +=> total;
    }
    return total;
}
