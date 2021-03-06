.1 => float gainSet;
5 => float maxDur; // max duration of loop in seconds; < .1 may crash

.5 => float tailProb; //probability of long echo tail (2x maxDur seconds)

0 => int x; 

.5 => float chorusMix;

now + 30::second => time future;

while (now < future) {
    Std.rand2(1,4) => x; // random number of loops
    for (0 => int i; i<x; i++) {
        spork~player();
    }
    maxDur::second => now;
}
    
15::second => now;

fun void player() {
    adc => Gain gain => Envelope env => Echo echo => NRev rev => Chorus chorus => PitShift pitch => Pan2 pan => dac;
    gainSet => gain.gain;
    chorusMix => chorus.mix;
    .2 => rev.mix;
    Std.rand2f(-1,1) => pan.pan;//randomize stereo placement
    Std.rand2f(0.1,maxDur) => float x; // randomized sample duration
    1 => pitch.mix;
    Std.rand2(1,3)*.5 => pitch.shift; // randomized pitch
    //<<< "x", x>>>;
    x::second => env.duration;
    env.duration() => echo.max;
    env.duration()*.75 => echo.delay;
    .5 => echo.gain;
    .5 => echo.mix;
    echo => echo;
    1 => env.keyOn;
    //<<< "on" >>>;
    env.duration() => now;
    1 => env.keyOff;
    //<<< "off" >>>;
    if (Std.rand2f(0,1) > tailProb) 2*maxDur::second => now;
    env.duration() => now;
}
    
