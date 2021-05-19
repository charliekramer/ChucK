//timed (see below) 

2*.5 => float gainSet;

.5::minute => dur length;

SndBuf s  => PitShift pitch => Echo echo => Gain gain => dac;


.16/(1.5*1.5) => s.rate;
1.15*1.5*1.5 => pitch.shift;
1 => pitch.mix;

5::ms => echo.delay;
.7 => echo.mix;
.9 => echo.gain;
echo => echo;

gainSet => gain.gain;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => s.read;
"/Users/charleskramer/Desktop/chuck/audio/secrest_poem_1.wav" => s.read;
"/Users/charleskramer/Desktop/chuck/audio/nixon_humiliate.wav" => s.read;


//"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => s.read;

138 => float loopSpeed; // native speed of loop

//"/Users/charleskramer/Desktop/chuck/audio/loopermanferryterry101bpmjazzsambadrum.wav" => s.read;
///101 => loopSpeed;

//"/Users/charleskramer/Desktop/chuck/audio/looperman-83bpm-l-0850517-0116649-miazyo-sazzyjazzydrumlings.wav" => s.read;
//83 => loopSpeed;

//"/Users/charleskramer/Desktop/chuck/audio/looperman-1564425-0149579-brisk-bossa-nova-drumgroove.wav" => s.read;
//87 => loopSpeed;


0 => s.pos;
1 => s.loop;

now + length => time future;

while (now < future) {	

1::samp => now;

}
0 => s.loop;

s.samples() => s.pos;

10::second => now;
