.5 => float gainSet;

30::second => dur length;

SndBuf2 buf => ADSR env => PitShift pitch => NRev rev => Echo echo => Pan2 pan => dac;

gainSet => buf.gain;

.1 => rev.mix;
0 => pan.pan;

1 => pitch.mix;
1 => pitch.shift;

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

now + length => time future;

while (now < future) {
    1 => env.keyOn;
    a => now;
    1 => env.keyOff;
    r => now;
    Std.rand2(0,buf.samples()) => buf.pos;   
}

buf.samples() => buf.pos;

10::second => now;