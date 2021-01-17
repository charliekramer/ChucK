.1 => float gainSet;

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

1 => float ratio; // 1 for even sound, small for hard attack

beat*ratio => dur a; //all 50 ms
beat*1 => dur d;
beat*(2-ratio) => dur r;

4*beat - (now % (4*beat)) => now; 

1 => float r_echo; // 2, 4, 8, 3, 6, or < 1 for cylon
2::second => echo.max;
(a+d)*r_echo => echo.delay; //2*(a+d)
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