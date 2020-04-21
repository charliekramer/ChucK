
SndBuf2 buf => ADSR env => NRev rev => Echo echo => dac;

1 => float delayMult;

5::second => echo.max;
1.5::second*delayMult => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

"/Users/charleskramer/Desktop/chuck/audio/kitchen_1.wav" => buf.read;

0 => buf.pos;

while (true) {
    Std.rand2(0,buf.samples()-1) => buf.pos;
    1 => env.keyOn;
    1 => buf.rate;
    Std.rand2f(100,1000)::ms => now;
    1 => env.keyOff;
    Std.rand2f(100,1000)::ms => now;
    1.5::second*delayMult*Std.rand2f(.1,1.5) => echo.delay;
    Std.rand2f(.1,.9) => rev.mix;
    Std.rand2f(.7,1.5) => buf.rate;
    
}