// based on chuck examples

Bowed bow => Echo e => PRCRev rev => dac;

59 -24=> float midiBase;

0.2 => rev.mix;

.8 => bow.gain;

.8 => e.gain;
.2 => e.mix;

10::second => e.max;
1.5::second => e.delay; 
e=>e;

// scale
[0, 2, 4, 7, 8, 11] @=> int scale[];

// infinite time loop
while( true )
{
    // set
    Std.rand2f(.4,.6) => bow.bowPressure;
    Std.rand2f(.4,.6) => bow.bowPosition;
    0 => bow.vibratoFreq;
    0 => bow.vibratoGain;
    .9 => bow.volume;

    // print
    <<< "---", "" >>>;
    <<< "bow pressure:", bow.bowPressure() >>>;
    <<< "bow position:", bow.bowPosition() >>>;
    <<< "vibrato freq:", bow.vibratoFreq() >>>;
    <<< "vibrato gain:", bow.vibratoGain() >>>;
    <<< "volume:", bow.volume() >>>;

    // set freq
    scale[Math.random2(0,scale.size()-1)] + midiBase -12 => Std.mtof => bow.freq;
    // go
    .8 => bow.noteOn;

    // advance time
    Math.random2f(1.9, 2)::second => now;
    1 => bow.noteOff;
     Math.random2f(5, 6)::second => now;
}
