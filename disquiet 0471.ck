.5 => float gainSet;
20::second => dur length;

SndBuf bufL => PitShift pitchL => Gain gainL => dac.left;
SndBuf bufR => PitShift pitchR => Gain gainR => dac.right;

1 => bufL.rate => bufR.rate;

gainSet => bufL.gain => bufR.gain;

gainL => Echo echoL => dac.right;
gainR => Echo echoR => dac.left;

1 => echoL.mix => echoR.mix;
.7 => echoL.gain => echoR.gain;
echoL => echoR;
echoR => echoL;

"/Users/charleskramer/Downloads/ice.wav" => bufL.read;

"/Users/charleskramer/Downloads/ice.wav" => bufR.read;

1 => pitchL.mix => pitchR.mix;
1 => pitchL.shift => pitchR.shift;

.25::second => dur beat;

2::second => echoL.max => echoR.max;

1.5*beat => echoL.delay => echoR.delay;

bufL.samples() => bufL.pos;
bufR.samples() => bufR.pos;

now + length => time future;

while (now < future) {
    
    0 => bufL.pos;
    Math.pow(1.5,Std.rand2(-2,2)) => pitchL.shift;
    beat => now;
    0 => bufR.pos;
    Math.pow(1.5,Std.rand2(-2,2)) => pitchR.shift;
    beat => now;
    
}

8*beat => now;