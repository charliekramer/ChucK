
.2 => float gainSet;
120. => float BPM;

30::second => dur length;

(60./BPM)::second => dur beat;

beat - (now % beat) => now;

.1*5 => float beatFrac; // fraction of beat for playback;

SndBuf2 buf => PitShift pitch => Gain gain => Pan2 panL => dac;
gain => Echo echo => Pan2 panR=> dac;

1.5*beat => echo.max => echo.delay;
1 => echo.mix;
.7 => echo.gain;

echo => echo;

Std.rand2f(-1,1) => panL.pan;
-1*panL.pan() => panR.pan;

57 => float midiBase;

[0.,2.,4., 5.,7.,9.,11.,12.] @=> float notes[];
float pitches[notes.cap()];

for (0 => int i; i < notes.cap(); i++) {
    
    Std.mtof(midiBase+notes[i])/Std.mtof(midiBase) => pitches[i];
    
    }


"/Users/charleskramer/Desktop/chuck/audio/stair_squeak.wav" => buf.read;

0 => buf.pos;

1 => buf.loop;

.05*20 => buf.rate;

1. => pitch.shift;

1 => pitch.mix;

now + length => time future;

while (now < future) {
    
    Std.rand2(0,buf.samples()) => buf.pos;
    
    beatFrac*beat => now;
    //Math.pow(1.5,Std.rand2(-2,2)) => pitch.shift;
    pitches[Std.rand2(0,pitches.cap()-1)] => pitch.shift;
    
    }

0 => buf.gain;

15::second => now;