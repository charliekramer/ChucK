.5 => float gainSet;

SndBuf2 buf => ADSR env => NRev rev => Echo echo => dac;

gainSet => buf.gain;

.7 => buf.rate; //.7

1 => float n; //1, 2, 4

n*50::ms => dur beat;

beat => dur a; //all 50 ms
beat => dur d;
beat => dur r;

beat - (now % beat) => now; 

2::second => echo.max;
(a+d)*2 => echo.delay; //2*(a+d)
.7 => echo.mix;
.7 => echo.gain;
echo => echo;

(a, d, 1, r) => env.set;

"/Users/charleskramer/Documents/FB_solo.wav" => buf.read;

0 => buf.pos;

while (true) {
    1 => env.keyOn;
    a => now;
    1 => env.keyOff;
    r => now;
    Std.rand2(0,buf.samples()) => buf.pos;   
}