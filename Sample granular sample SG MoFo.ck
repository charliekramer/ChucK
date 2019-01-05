//sample manipulator/granulator

SndBuf2 click => PitShift pitch => Dyno dyn => dac;

.5 => click.gain;

60./120. => float beatsec;

beatsec::second => dur beat;

beat - (now % beat) => now;

"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav" => click.read;

0 => click.pos;

fun void granularize(SndBuf myWav, int steps) 
{
    myWav.samples()/steps => int grain;
    Math.random2(0, myWav.samples() - grain) + grain => myWav.pos;
    grain :: samp => now;
}
/*
while (true) {
    granularize (click, 70);
}
*/

fun void speedBuf (SndBuf myWav, float speed, dur playTime, float pitchCorrect)
{
    0=>myWav.pos;
    speed => myWav.rate;
    pitchCorrect => pitch.shift;
    1 => pitch.mix;
    1 => myWav.loop;
    playTime => now;
    
}
 
//spork~speedBuf(click, 1, 200::second,1);
1 => click.rate;
while (true) {
granularize(click, 4);
}
beat=> now;