
SndBuf buf => blackhole;

SqrOsc sin => Gain gainL => Echo echoL => NRev revL => dac.left;
SawOsc sin2 => Gain gainR => Echo echoR => NRev revR => dac.right;

10::second => dur length;

(56.3+7+1.5+4.5+1.5)*0 + 11*7 => float midiBase;

5::second => echoL.max => echoR.max;
.125::second*.5 => echoL.delay;
echoL.delay()*1.5 => echoR.delay;
 .7 => echoL.mix => echoL.gain;
echoR => echoL;
1 => echoR.mix => echoR.gain;
echoL => echoR;

Std.mtof(midiBase) => sin.freq => sin2.freq;
  

"/Users/charleskramer/Desktop/chuck/audio/secrest_poem_2.wav" => buf.read;

1 => buf.loop;
.1 => buf.rate;

now + length => time future;

while (now < future) {
    Math.fabs(buf.last()) => gainL.gain => gainR.gain;
    1::samp => now;
    
}

5::second => now;
