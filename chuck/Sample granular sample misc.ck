//sample manipulator/grandulator
// miscellaneous samples

SndBuf2 click => PitShift pitch => NRev rev => Dyno dyn => dac;

2 => click.gain;

0.0 => rev.mix;

60./94. => float beatsec;
94./138. => click.rate;

beatsec::second => dur beat;

beat - (now % beat) => now;

//"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav" => click.read;
//"/Users/charleskramer/Desktop/chuck/audio/wait_wilson.wav" => click.read;
//"/Users/charleskramer/Desktop/chuck/audio/lincolnshire_numberstation.wav" => click.read;
//"/Users/charleskramer/Desktop/chuck/audio/tyrolean_numberstation.wav" => click.read;
//"/Users/charleskramer/Desktop/chuck/audio/buzzer_numberstation.wav" => click.read;
//"/Users/charleskramer/Desktop/chuck/audio/pulse_sample.wav" => click.read;
//"/Users/charleskramer/Desktop/chuck/audio/voicemail-31.wav" => click.read;
"/Users/charleskramer/Desktop/chuck/audio/delme.wav" => click.read;


0 => click.pos;

fun void granularize(SndBuf myWav, int steps) 
{
    myWav.samples()/steps => int grain;
    Math.random2(0, myWav.samples() - grain) + grain => myWav.pos;
    grain :: samp => now;
}


fun void speedBuf (SndBuf myWav, float speed, dur playTime, float pitchCorrect)
{
    0=>myWav.pos;
    speed => myWav.rate;
    pitchCorrect => pitch.shift;
    1 => pitch.mix;
    1 => myWav.loop;
    playTime => now;
    
}

fun void grainPlay (SndBuf inBuf, int startPos, int length) {
    startPos =>inBuf.pos;
    length::samp => now;
}

fun void grainRandTime (SndBuf inBuf, int startPos) {
    startPos =>inBuf.pos;
    Std.rand2(10,500) ::ms => now;
}
// chooser
// 1 => speedBuf;
// 2 => granularize
// 3 => timed play starting at zero
// 4 => specify start and end positions;
// 5 => random play time between 10 and 50 ms starting from defined position

1 => int chooser;

int randStartPos;

while (true) {
    
    if (chooser == 1) speedBuf (click, 1., beat*164, 1.);
//    if (chooser == 1) speedBuf (click, 154./138., beat*164, 138./154);
    
    else if (chooser == 2) granularize(click,900/4);
    
    else if (chooser == 3)
    {
        0 => click.pos;
        beat*64=> now;
    }
    else if (chooser == 4)
    {
        0.6=>click.rate; //backwards changes tone
        1.5 => pitch.shift;
        grainPlay(click, 500000, 50000);
    }
    else {
		Std.rand2(0,click.samples()) => randStartPos;
        grainRandTime(click,randStartPos); 
  //        grainRandTime(click,500); 

    }
        
}
