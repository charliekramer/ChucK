//sample manipulator/grandulator
// miscellaneous samples
// stops at time "future"

2 => float gainSet;

SndBuf2 click => PitShift pitch => Echo echo => NRev rev => Dyno dyn => dac;

SinOsc LFO => blackhole;

60./94.*2 => float beatsec;
.7 => click.rate;
beatsec::second => dur beat;
beat - (now % beat) => now;

now + 15::second => time future;

.1 => LFO.freq;

gainSet => click.gain;

10*beat => echo.max;
1.5*beat => echo.delay;
.3 => echo.mix;
.5 => echo.gain;
echo => echo;

0.3 => rev.mix;

// chooser
// 1 => speedBuf;
// 2 => granularize
// 3 => timed play starting at zero
// 4 => specify start and end positions; (currently randomized length, speed, pitch)
// 5 => random play time between 10 and 50 ms starting from defined position
// 6 => (5) plus random rate (including backwards)
// 7 => (5) plus rate from LFO
// 8 => chord
// 9 => grain skipper

8 => int chooser;
1./1.0 => pitch.shift;
0.9 => pitch.mix;
1 => click.loop;

21 => int sampleChoose;

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
	else if (sampleChoose == 17)
	{"/Users/charleskramer/Desktop/chuck/audio/voicemail_goodbye.wav" => click.read;}
	else if (sampleChoose == 18)
	{"/Users/charleskramer/Desktop/chuck/audio/voicemail_unsecured_dad.wav" => click.read;}
	else if (sampleChoose == 19)
	{"/Users/charleskramer/Desktop/chuck/audio/glitchvector.wav" => click.read;}
	else if (sampleChoose == 20)
	{"/Users/charleskramer/Desktop/chuck/audio/countdown.wav" => click.read;}
	else if (sampleChoose == 21)
	{"/Users/charleskramer/Desktop/chuck/audio/mower_edit.wav" => click.read;}
	
	


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


while (now < future) {
    
    if (chooser == 1) speedBuf (click, 1., beat*4, 1.);
//    if (chooser == 1) speedBuf (click, 154./138., beat*164, 138./154);
    
    else if (chooser == 2) granularize(click,900);
    
    else if (chooser == 3)
    {
        0 => click.pos;
        beat*160=> now;
    }
    else if (chooser == 4)
    {
        Std.rand2f(.1,.3) => click.rate; //backwards changes tone
        Std.rand2f(.5,.7) => pitch.shift;
        grainPlay(click, click.samples()/2,Std.rand2(5000,10000));
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
		LFO.last()*2 => click.rate;
		grainRandTime(click,randStartPos); 
		
	}
	else if(chooser == 8) 
	{
		1 => float factor;
		while (now < future) {
		spork~speedBuf (click, .5/factor, beat*4*factor, 1.);
		spork~speedBuf (click, .5/factor, beat*4*factor, 1.33);
		spork~speedBuf (click, .5/factor, beat*4*factor, 1.5);
		beat*4*factor => now;
	    }
		
	}
	else 
	{
		grainSkipper(click,10, 10, 1); 
		
	}
        
}
// outro
0 => click.loop;
click.samples() => click.pos;
5::second => now;
