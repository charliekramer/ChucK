.1 => float gainSet;

3::minute => dur length;

57 => float midiBase;
[0., 5., 7., 9., 14.] @=> float notes[];

2.5::second*6=> dur beat;

Gain gainL, gainR;
gainSet => gainL.gain => gainR.gain;

gainL => Echo echoL => dac.left;
gainR => Echo echoR => dac.right;;

1*beat => echoL.max => echoR.max;
.25*beat => echoL.delay;
.35*beat => echoR.delay;
.7 => echoL.gain => echoR.gain;
.7 => echoL.mix => echoR.mix;
echoL => echoL;
echoR => echoR;


now + length => time future;

while (now < future) {
    
    spork~bellMod1();
    spork~bellMod2();
    Std.rand2f(.5,1.5)*beat => now;
}

beat => now;

fun void bellMod1() {
    Std.rand2f(.1,.2)*beat => now;
    
    TubeBell bell1 => gainL => dac.left;
    TubeBell bell2 => gainR => dac.right;
    float f1, f2;
    Std.mtof(midiBase+Std.rand2(-1,1)*12.+notes[Std.rand2(0,notes.cap()-1)]) => f1;
    Std.mtof(midiBase+Std.rand2(-1,1)*12.+notes[Std.rand2(0,notes.cap()-1)]) => f2;
    f1+f2 => bell1.freq;
    Math.fabs(f1-f2) => bell2.freq;
    1 => bell1.noteOn;
    1 => bell2.noteOn;
    Std.rand2f(.5,2)*beat => now;
}

fun void bellMod2() {
      
    Std.rand2f(.1,.2)*beat => now;  
     
    Std.rand2f(1,4) => float freq1a; 
    Std.rand2f(.2,.4) => float freq1b;
    Std.rand2f(1,4) => float freq2a;
    Std.rand2f(.2,.4) => float freq2b;
    
    float f1, f2;
    
    .03 => float gain1a;
    .2 => float gain1b;
    .03 => float gain2a;
    .03 => float gain2b;
    
    TubeBell bell1 => gainL => dac.left;
    TubeBell bell2 => gainR => dac.right;
    
    SinOsc LFO1a => blackhole;
    SinOsc LFO2a => blackhole;
    SinOsc LFO1b => blackhole;
    SinOsc LFO2b => blackhole;
    
    freq1a => LFO1a.freq;
    freq2a => LFO2a.freq;
    freq1b => LFO1b.freq;
    freq2b => LFO2b.freq;
    
    gain1a => LFO1a.gain;
    gain2a => LFO2a.gain;
    gain1b => LFO1b.gain;
    gain2b => LFO2b.gain;
    
    Std.mtof(midiBase+Std.rand2(-1,1)*12.+notes[Std.rand2(0,notes.cap()-1)]) => f1;
    Std.mtof(midiBase+Std.rand2(-1,1)*12.+notes[Std.rand2(0,notes.cap()-1)]) => f2;
    f1+f2 => bell1.freq;
    Math.fabs(f1-f2) => bell2.freq;
    1 => bell1.noteOn;
    1 => bell2.noteOn;
    now + Std.rand2f(.5,2)*beat => time future;
    while (now < future) {
        (1+LFO1b.last())*freq1a => LFO1a.freq;
        (1+LFO2b.last())*freq2a => LFO2a.freq;
        (1+LFO1a.last())*(f1+f2) => bell1.freq;
        (1+LFO2a.last())*Math.fabs(f1-f2) => bell2.freq;
        1::samp => now;
    }
}