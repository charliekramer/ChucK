// define a time variable and use for open/close envelope for smoothness
// also panning/space

Gain gain => dac;

int minTime, maxTime;

now + 20::second => time future;

while (now < future) {
    
    Std.rand2(100,1000) =>  minTime;
    minTime*Std.rand2(5,10) =>  maxTime;
    
    spork~kitchen();
    .5*Std.rand2f(minTime,maxTime)::ms => now;
}

2000 => minTime;
2000 => maxTime;
spork~kitchen();
10::second => now;

fun void kitchen() {
    SndBuf2 buf => ADSR env => NRev rev => Echo echo => gain => Pan2 pan => dac;
    1 => float delayMult;
    (maxTime::ms, 1::ms, .9, maxTime::ms) => env.set;
    
    
    5::second => echo.max;
    1.5::second*delayMult => echo.delay;
    .5 => echo.gain;
    .5 => echo.mix;
    echo => echo;
    
    1.5::second*delayMult*Std.rand2f(.1,1.5) => echo.delay;
    Std.rand2f(.1,.9) => rev.mix;
    Std.rand2f(.7,1.5) => buf.rate;
    Std.rand2f(-1., 1.) => pan.pan;
    
    "/Users/charleskramer/Desktop/chuck/audio/kitchen_1.wav" => buf.read;
    
    Std.rand2(0,buf.samples()-1) => buf.pos;
    1 => env.keyOn;
    Std.rand2(minTime,maxTime)::ms => now;
    1 => env.keyOff;
    Std.rand2(minTime,maxTime)::ms => now;
    
}