//sample manipulator/grandulator
// miscellaneous samples

SndBuf2 click => PitShift pitch => Echo echo => NRev rev => Dyno dyn => dac;

SinOsc LFO => blackhole;

60./120. => float beatsec;
1. => click.rate;
beatsec::second => dur beat;
beat - (now % beat) => now;

.5 => LFO.freq;

2 => click.gain;

10*beat => echo.max;
1.5*beat => echo.delay;
.1 => echo.mix;
.5 => echo.gain;
echo => echo;

0.3 => rev.mix;

// chooser
// 1 => speedBuf;
// 2 => granularize
// 3 => timed play starting at zero
// 4 => specify start and end positions;
// 5 => random play time between 10 and 50 ms starting from defined position
// 6 => (5) plus random rate (including backwards)
// 7 => (5) plus rate from LFO
// 8 => grain skipper

8 => int chooser;
1.0/1.0 => pitch.shift;
.7 => pitch.mix;

16 => int sampleChoose;

    if (sampleChoose == 1) 
	{"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav" => click.read;}
	else if (sampleChoose == 2) 
	{"/Users/charleskramer/Desktop/chuck/audio/wait_wilson.wav" => click.read;}
	else if (sampleChoose == 3)
	{"/Users/charleskramer/Desktop/chuck/audio/lincolnshire_numberstation.wav" => click.read;}
	else if (sampleChoose == 4)
	{"/Users/charleskramer/Desktop/chuck/audio/tyrolean_numberstation.wav" => click.read;}
	else if (sampleChoose == 5)
	{"/Users/charleskramer/Desktop/chuck/audio/buzzer_numberstation.wav" => click.read;}
	else if (sampleChoose == 6)
	{"/Users/charleskramer/Desktop/chuck/audio/pulse_sample.wav" => click.read;}
	else if (sampleChoose == 7)
	{"/Users/charleskramer/Desktop/chuck/audio/voicemail-31.wav" => click.read;}
	else if (sampleChoose == 8)
	{"/Users/charleskramer/Desktop/chuck/audio/delme.wav" => click.read;}
	else if (sampleChoose == 9)
	{"/Users/charleskramer/Desktop/chuck/audio/nari-lata-vela.wav" => click.read;}
	else if (sampleChoose == 10)
	{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesAnnouncement.wav" => click.read;}
	else if (sampleChoose == 11)
	{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesBackgroundMusic.wav" => click.read;}
	else if (sampleChoose == 12)
	{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesLanding.wav" => click.read;}
	else if (sampleChoose == 13)
	{"/Users/charleskramer/Desktop/chuck/audio/ethiopianAirlinesTakeoff.wav" => click.read;}
	else if (sampleChoose == 14)
	{"/Users/charleskramer/Desktop/chuck/audio/Sheriff_2014-12-04.wav" => click.read;}
	else if (sampleChoose == 15)
	{"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => click.read;}
	else if (sampleChoose == 16)
	{"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav" => click.read;}
	


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
    Std.rand2(10,500)::ms => now;
}

fun void grainSkipper (SndBuf inBuf, int skip, int length, int repeater) {
	0 => inBuf.pos;
	while (true) {
		inBuf.pos()+skip => inBuf.pos;
		length::samp => now;
		if (inBuf.pos() == inBuf.samples() && repeater == 1) 0 => inBuf.pos;
		}
	}
		


int randStartPos;

while (true) {
    
    if (chooser == 1) speedBuf (click, 1, beat*160, 1.);
//    if (chooser == 1) speedBuf (click, 154./138., beat*164, 138./154);
    
    else if (chooser == 2) granularize(click,900);
    
    else if (chooser == 3)
    {
        0 => click.pos;
        beat*160=> now;
    }
    else if (chooser == 4)
    {
        .1 => click.rate; //backwards changes tone
        .2 => pitch.shift;
        grainPlay(click, click.samples()/4+44000/2+2000, 150000);
    }
    else if (chooser == 5)
    {
		Std.rand2(0,click.samples()) => randStartPos;
        grainRandTime(click,randStartPos); 

    }
	else if (chooser == 6)
	{
		Std.rand2(0,click.samples()) => randStartPos;
		Std.rand2f(-2,2) => click.rate;
		grainRandTime(click,randStartPos); 
		
	}
	else if(chooser == 7) 
	{
		Std.rand2(0,click.samples()) => randStartPos;
		LFO.last()*4 => click.rate;
		grainRandTime(click,randStartPos); 
		
	}
	else 
	{
		grainSkipper(click,10, 10, 1); 
		
	}
        
}
