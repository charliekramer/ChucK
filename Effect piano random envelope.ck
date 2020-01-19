.1 => float gainSet;
.15 => float maxDur; // max duration of loop in seconds; < .1 may crash

0 => int x;

now + 30::second => time future;

while (now < future) {
    Std.rand2(1,4) => x; // random number of loops
    for (0 => int i; i<x; i++) {
        spork~player();
    }
    maxDur::second => now;
}
    


fun void player() {
    SndBuf buf => Envelope env => Pan2 pan => dac;
    gainSet => buf.gain;
    "/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;
    Std.rand2f(-1,1) => pan.pan;//randomize stereo placement
    Std.rand2(0,buf.samples()) => buf.pos; // randomize start position;
    Std.rand2f(0.1,maxDur) => float x; // randomized sample duration
    (2*Std.rand2(0,1) - 1)*Std.rand2(1,3)*.5 => buf.rate; // randomized rate
    //<<< "x", x>>>;
    x::second => env.duration;
    1 => env.keyOn;
    //<<< "on" >>>;
    env.duration() => now;
    1 => env.keyOff;
    //<<< "off" >>>;
    env.duration() => now;
}
    
