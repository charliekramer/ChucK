.0005 => float gainSet;

SinOsc sin => ADSR env => LPF filt => NRev rev => Gain gain => dac;
SqrOsc sqr => env => filt => rev => gain => dac;
SawOsc saw => env => filt => rev => gain => dac;
TriOsc tri => env => filt => rev => gain => dac;

.05 => rev.mix;

59 - 12 -12 => float midiBase;

60::second => dur length;

[0.,1.,3.,4.,5.,6.,7.,11.,12.] @=> float notes[];

Std.mtof(midiBase) => sin.freq => sqr.freq => saw.freq => tri.freq;

Std.mtof(midiBase)*1.2 => filt.freq;
10 => filt.Q;//5 or 25

gainSet => gain.gain;

1 => sin.gain; //1
1 => sqr.gain;//.5
1 => saw.gain;//.3
1 => tri.gain;//.5

60./94.*.25 => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

//(.015*beat,.025*beat,.2,1*beat) => env.set;
(.15*beat,.25*beat,.5,4*beat) => env.set;


float beatDiv;

now + length => time future;

while (now < future) {
    
    Std.rand2f(0,1) => beatDiv;
    1 => env.keyOn;
    beatDiv*beat => now;
    1 => env.keyOff;
    (2-beatDiv)*beat => now;
    Std.mtof(midiBase + notes[Std.rand2(0,notes.cap()-1)]) => sin.freq => sqr.freq => saw.freq => tri.freq;
    sin.freq()*2 => filt.freq;
   
   Std.rand2(0,6)*.25*beat => now;  // .5 or .25
    
   }
   
   5::second => now;
