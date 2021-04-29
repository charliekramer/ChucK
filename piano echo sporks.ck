
.3 => float gainSet;

2::minute => dur length;

5::second => dur beat;

1 => int delta; // draw from percentage diff from zero distribution
.01 => float diff; // if so distribution is uniform on 1 + - diff

int n;

now + length => time future;

while(now < future) {
    
    Std.rand2(1,3) => n;
    
   
    for (0 => int i; i < n; i++) {
        spork~piano_go();
    }

3*beat => now;

}

30::second => now;


fun void piano_go() {
    SndBuf buf => Echo echo => NRev rev => Envelope env => Pan2 pan => dac;
    //"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;
    //"/Users/charleskramer/Desktop/chuck/audio/National_Anthem_performed_at_CPAC_2021.wav" => buf.read;
    "/Users/charleskramer/Desktop/chuck/audio/guitar_drone.wav" => buf.read;
    gainSet => buf.gain;
    Std.rand2f(.5,4)*beat => env.duration;
    Std.rand2f(-1,1) => buf.rate;
    if (delta == 1) Math.pow(-1,Std.rand2(0,1))*Std.rand2f(1.-diff,1+diff) => buf.rate;
    <<< "buf rate", buf.rate() >>>;
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