.2*2 => float gainSet;
45::second => dur length;

[0.,5.,-7.,7.,-5.,11.,-1.,12.,-12.] @=> float notes[];
51-12-12 => float midiBase;

16 => float mult;
SinOsc LFO => blackhole;
.1*mult => LFO.freq;

Rhodey bell => Gain gain => dac;
//1 => bell.preset; // if using modalbar
gainSet => bell.gain;
gain => Echo echoL => dac.left;
gain => Echo echoR => dac.right;

.25::second*mult => dur beat;

4*beat => echoL.max => echoR.max;
1.5*beat => echoL.delay;
.75*beat => echoR.delay;
.75 => echoR.gain => echoL.gain;
.5 => echoR.mix => echoL.mix;
echoL => echoL;
echoR => echoR;

beat - (now % beat) => now;

now + length => time future;
while (now <future) {
    
    Std.rand2(0,Std.ftoi(notes.cap()*(1+LFO.last())/2.0)) => int j;
    <<< "LFO", LFO.last(),"j", j >>>;
    Std.mtof(midiBase+notes[j]) => bell.freq;
    1 => bell.noteOn;
    beat => now;
    
    }
10::second => now;
