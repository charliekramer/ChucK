// also uses sometimes youre the ghost and that's ok
int nSample;
float maxSecs,secs,minS,maxS;

1 => float gainSet;
5 => int maxSample;
1  => minS;
4 => maxS;

1 => int loop; // whether to loop sample


3.5::minute => dur length;

now + length => time future;

while (now < future) {
    Std.rand2(1,maxSample) => nSample;
    0 => maxSecs;
    
    for (0 => int i; i < nSample; i++) {
        Std.rand2f(1,30) => secs;
        if (secs > maxSecs) secs => maxSecs;
        spork~bufSpork(secs::second);
    }
    maxSecs::second*.75 => now;
}

2::second => now;

fun void bufSpork(dur runtime) {
    SndBuf2 buf => Envelope env => Echo echo => Dyno dyn => Pan2 pan => dac;
    //"/Users/charleskramer/Desktop/chuck/audio/Ether_Drive_March_15_2021_20122_PM.wav" => buf.read;
    "/Users/charleskramer/Desktop/chuck/audio/sometimesYoureTheGhostAndThatsOK.wav" => buf.read;
    
    loop => buf.loop;
    gainSet => buf.gain;
    
    runtime => echo.max;
    runtime/8 => echo.delay;
    .7 => echo.mix;
    .7 => echo.gain;
    echo => echo;
    
    Std.rand2f(-1,1) => pan.pan;
    
    Std.rand2(0,buf.samples()) => buf.pos;
    
    runtime/4 => env.duration;
    1 => env.keyOn;
    runtime*3/4 => now;
    1 => env.keyOff;
    runtime/4 => now;
}