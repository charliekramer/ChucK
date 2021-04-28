
.3 => float gainSet;

5::minute => dur length;

5::second => dur beat;

int n;

now + length => time future;

while(now < future) {
    
    Std.rand2(1,3) => n;
    
   
    for (0 => int i; i < n; i++) {
        spork~piano_go();
    }

3*beat => now;

}

2*beat => now;




fun void piano_go() {
    SndBuf buf => Echo echo => NRev rev => Envelope env => Pan2 pan => dac;
    "/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;
    gainSet => buf.gain;
    Std.rand2f(.5,4)*beat => env.duration;
    Std.rand2f(-1,1) => buf.rate;
    Std.rand2(0,buf.samples()) => buf.pos;
    Std.rand2f(-1,1.) => pan.pan;
    Std.rand2f(0,1) => rev.mix;
    .25*env.duration() => echo.max => echo.delay;
    .7 => echo.mix => echo.gain;
    echo => echo;
    1 => env.keyOn;
    env.duration() + Std.rand2f(.5,4)*beat => now;
    1 => env.keyOff;
    env.duration() => now;
    
}