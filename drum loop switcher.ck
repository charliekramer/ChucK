
.2 => float gainSet;
2::minute => dur length;

SndBuf buf => Gain gain => Echo echo => dac.left;
SndBuf buf2 => Gain gain2 => Echo echo2 => dac.right;

gainSet => buf.gain => buf2.gain;


55 => float BPM;

BPM/94. => float baseRate =>buf.rate => buf2.rate;


60./BPM => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

[.25*4,.5*2,1.] @=> float speeds[];

1.5*beat => echo.max => echo2.max => echo.delay => echo2.delay;

"/Users/charleskramer/Desktop/chuck/audio/50 Best Free Drum Loops/Run Down drums_94bpm.wav" => buf.read;
"/Users/charleskramer/Desktop/chuck/audio/50 Best Free Drum Loops/Shroom LANDR Break08_94bpm.wav" => buf2.read;
1 => buf.loop => buf2.loop;

now + length => time future;

while (now < future) {

    Std.rand2f(0,1) => gain.gain;
    1 - gain.gain() => gain2.gain; 
    beat => now;
    if (Std.rand2f(0,1) >.5) {
        speeds[Std.rand2(0,speeds.cap()-1)]*baseRate => buf.rate; 
        speeds[Std.rand2(0,speeds.cap()-1)]*baseRate => buf2.rate;
        
    }
    
    }
    
20::second => now;