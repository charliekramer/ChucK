//sample manipulator/grandulator, echo and reverb and pitch shift
// see below for options
// miscellaneous samples
// stops at time "future"

.02*10 => float gainSet;

now + 45::second => time future;

SndBuf2 click => PitShift pitch => Echo echo => NRev rev => Gain gain => Dyno dyn => dac;

SinOsc LFO => blackhole;

SinOsc rateLFO1 => blackhole;
3 => rateLFO1.freq;
.1 => rateLFO1.gain;
SinOsc rateLFO2 => blackhole;
5 => rateLFO2.freq;
.1 => rateLFO2.gain;

SinOsc sin => gain => dac;
0 => sin.gain;
//spork~ringmod(6,333);

60./60. => float beatsec;
beatsec::second => dur beat;
beat - (now % beat) => now;

// chooser
// 1 => speedBuf; play for nBeats
// 2 => granularize
// 3 => timed play starting at zero
// 4 => specify start and end positions; (currently randomized length, speed, pitch)
// 5 => random play time between 10 and 50 ms starting from defined position
// 6 => (5) plus random rate (including backwards)
// 7 => (5) plus rate from LFO
// 8 => chord
// 9 => grain skipper
// 10 => skip = exp(gain) (zeros volume)
// 11 => skip = exp(gain) (skips samples)
// 12 => multi rate LFO (product of rateLFO1 and rateLFO2, above)


3 => int chooser;
40 => int nBeats;
(5/1.0-.7)*1.1*1.1 => float bufPitch => pitch.shift; // for weird secrest = 5 and rate = .1
1*.9 => pitch.mix; // for weird secrest = .9
1 => click.loop;
.1 => float bufRate => click.rate; // may be overridden in function;for weird secrest = .1
61*44100*0 => int startPos;

.1 => LFO.freq;

10*beat => echo.max;
1.5*beat*4. => echo.delay;
.1 => echo.mix;
.5 => echo.gain;
echo => echo;

0.7 => rev.mix;

gainSet => click.gain;
32 => int sampleChoose; // 28 is secrest

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
	else if (sampleChoose == 22)
	{"/Users/charleskramer/Desktop/chuck/audio/cartoons.wav" => click.read;}
	else if (sampleChoose == 23)
	{"/Users/charleskramer/Desktop/chuck/audio/numberstation-808-english.wav" => click.read;}
	else if (sampleChoose == 24)
	{"/Users/charleskramer/Desktop/chuck/audio/numberstation-808-german.wav" => click.read;}
	else if (sampleChoose == 25)
	{"/Users/charleskramer/Desktop/chuck/audio/numberstation-808-both.wav" => click.read;}
	else if (sampleChoose == 26)
	{"/Users/charleskramer/Desktop/chuck/audio/eric-mcluhan-kmox-10-sea-of-information.wav" => click.read;}
    else if (sampleChoose == 27)
    {"/Users/charleskramer/Desktop/chuck/audio/secrest_poem_1.wav" => click.read;}
    else if (sampleChoose == 28)
    {"/Users/charleskramer/Desktop/chuck/audio/secrest_poem_2.wav" => click.read;}
    else if (sampleChoose == 29)
    {"/Users/charleskramer/Desktop/chuck/audio/PB_radio.wav" => click.read;}
    else if (sampleChoose == 30)
    {"/Users/charleskramer/Desktop/chuck/audio/breathe.wav" => click.read;}
    else if (sampleChoose == 31)
    {"/Users/charleskramer/Desktop/chuck/audio/afc1939007_afs02246b.wav" => click.read;} //https://www.loc.gov/item/afc1939007_afs02246b/
    else if (sampleChoose == 32)
    {"/Users/charleskramer/Desktop/chuck/audio/04252020.wav" => click.read;} //ambient recording april 25 2020
    


	
	
	


0 => click.pos;

fun void granularize(SndBuf myWav, int steps) 
{
    myWav.samples()/steps => int grain;
    Math.random2(0, myWav.samples() - grain) + grain => myWav.pos;
    grain :: samp => now;
}


fun void speedBuf (SndBuf myWav, float speed, dur playTime, float pitchCorrect)
{
    startPos=>myWav.pos;
    speed => myWav.rate;
    pitchCorrect => pitch.shift;
    1 => pitch.mix;
    0 => myWav.loop;
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
		
fun void expSkip(SndBuf inBuf, float _a) {
    .1 => float a;
    _a => a;
    
    0 => inBuf.pos;
    
    float mss;
    
    while (true) {
        
        Math.exp(inBuf.last()*a) => mss;
        0 => inBuf.gain;
        mss::ms => now;
        1 => inBuf.gain;
        mss::ms => now;
        if (inBuf.pos() == inBuf.samples()) 0 => inBuf.pos;
      
    }
}

fun void expSkipSamp(SndBuf inBuf, float _a) {
    .1 => float a;
    _a => a;
    
    0 => inBuf.pos;
    
    float mss;
    
    while (true) {
        
        Math.exp(inBuf.last()*a) => mss;
        Std.rand2(0,Std.ftoi(mss)*15) => mss;
        inBuf.pos() + Std.ftoi(mss) => inBuf.pos;
        10::samp => now;
       
        if (inBuf.pos() == inBuf.samples()) 0 => inBuf.pos;
        
    }
}
            

int randStartPos;


while (now < future) {
    
    if (chooser == 1) speedBuf (click, bufRate, beat*nBeats,bufPitch);
//    if (chooser == 1) speedBuf (click, 154./138., beat*164, 138./154);
    
    else if (chooser == 2) granularize(click,900);
    
    else if (chooser == 3)
    {
        0 => click.pos;
        beat*nBeats=> now;
    }
    else if (chooser == 4)
    {
        Std.rand2f(-2,2) => click.rate; //backwards changes tone
        Std.rand2f(.5,.7) => pitch.shift;
        grainPlay(click, Std.rand2(0,click.samples()),Std.rand2(5000,10000));
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
        startPos => click.pos;
		.7 => float factor;
		while (now < future) {
		spork~speedBuf (click, .5/factor, beat*4*factor, 1.);
		spork~speedBuf (click, .5/factor, beat*4*factor, 1.33);
		spork~speedBuf (click, .5/factor, beat*4*factor, 1.5);
		beat*4*factor => now;
	    }
		
	}
	else if (chooser == 9)
	{
		grainSkipper(click,100, 100, 1); 
		
	}
    else if (chooser == 10)
    {
        expSkip(click,.01); 
        
    }
    else if (chooser == 11) 
    {
        expSkipSamp(click,.2); 
        
    }
    else {
        (1+rateLFO1.last())*(1+rateLFO2.last()) => click.rate;
        1::samp => now;
        if (click.pos() == click.samples()) 0 => click.pos;
    }
        
}

fun void ringmod(float _gain, float _freq) {
    3 => gain.op;
    _gain => sin.gain;
    while (true) {
        beat => now;
        Std.rand2f(.7,1.5)*_freq => sin.freq;
    }
}

// outro
0 => click.loop;
click.samples() => click.pos;
5::second => now;
