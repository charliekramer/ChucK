.2 => float gainSet;
60::second => dur length;
12 => int n;
SqrOsc noteLFO[n];
SqrOsc gainLFO[n];

Brass brass => Echo echo => dac;
gainSet => brass.gain;

2::second => dur echoBeat;
4*echoBeat => echo.max;
1.5*echoBeat => echo.delay;
.2 => echo.mix;
.7 => echo.gain;
echo => echo;

1000::ms => dur beat;

65 => float midiBase; // flubs out if this is too low

for (0 => int i; i < n; i++) {
    noteLFO[i] => blackhole;
    gainLFO[i] => blackhole;
    Std.rand2f(.1,8) => noteLFO[i].freq;
    Std.rand2f(.1,8) => gainLFO[i].freq;
}

0 => float sum;

randBrass();

1 => brass.noteOn;
1 => brass.startBlowing;
.5 => brass.volume; //.5
.57 => brass.lip; //.57
.0 => brass.slide; //0
.3 => brass.vibratoFreq; //.3
.5 => brass.vibratoGain; //.5
.1 => brass.rate;//.1

now + length => time future;

while (now < future) {
    0 => sum;
    for (0 => int i; i < n; i++) {
        (1+gainLFO[i].last()) => noteLFO[i].gain;
        sum + noteLFO[i].last() => sum;
    }
    
    Std.mtof(midiBase + sum) => brass.freq;
    1 => brass.startBlowing;
    beat*Std.rand2f(.1,10) => now;
    //1 => osc.stopBlowing;
    //1::samp => now;
    randBrass();
}

15::second => now;

fun void randBrass() {
    Std.rand2f(.5,.6) => brass.lip;
    Std.rand2f(0.,.4) => brass.rate;
    Std.rand2f(0.,.1) => brass.slide;
    Std.rand2f(0.,2.) => brass.vibratoFreq;
    Std.rand2f(0.,.5) => brass.vibratoGain;
    
}
         
