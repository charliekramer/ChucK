// Drum machine rando dronemetal

class Fuzz extends Chugen
{
	1.0/2.0 => float p;
	
	2 => intensity;
	
	fun float tick(float in)
	{
		Math.sgn(in) => float sgn;
		return Math.pow(Math.fabs(in), p) * sgn;
	}
	
	fun void intensity(float i)
	{
		if(i > 1)
			1.0/i => p;
	}
}


//synch code
60./120. => float beatSec;
beatSec::second=>dur beat;
beat - (now % beat) => now;

//soundchain
Gain g => dac;
//SndBuf click => NRev r => Echo e => g => dac;
SndBuf click => NRev r =>  g => dac;
SndBuf kick  => g => dac;
SndBuf hat  => g => dac;

1.5 => click.gain;
2 => kick.gain;

//METAL
HevyMetl metal => Fuzz fuzz => Gain metalGain => dac;
HevyMetl metalHarmony => Fuzz fuzz2 => Gain harmonyGain => dac;
3 => fuzz.intensity;
3 => fuzz2.intensity;
.1 => metalGain.gain;
.1 => harmonyGain.gain;
37=>metal.freq;
72 => metalHarmony.freq;
.08=>metal.gain;
.08 => metalHarmony.gain;
80=>metal.lfoSpeed;
80 => metalHarmony.lfoSpeed;
1=>metal.lfoDepth;
1 => metalHarmony.lfoDepth;

//reverb paramter
.1=>r.mix;

//read sound files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/snare_03.wav" => click.read;
me.dir(-1)+"chuck/audio/hihat_01.wav" => hat.read;

//point to end of buffer for each
kick.samples()=>kick.pos;
click.samples()=>click.pos;
hat.samples()=>hat.pos;

//probability arrays; p(beat) for each instrument
[0.7,0.0,0.7,0.0,0.7,0.0,0.7,0.0] @=> float kick_prob_1[];
[0.0, 0.7,0.0,0.7,0.0,0.7,0.0,0.7] @=> float click_prob_1[];
[0.25,0.25,0.25,0.25,0.25,0.25,0.25,0.25] @=> float hat_prob_1[];


fun void section( float kickArray[], float clickArray[], float hatArray[], float beattime)
{
    for ( 0 => int i; i < kickArray.cap(); i++)
    {
        if (Math.randomf()<kickArray[i])
        {
            0=>kick.pos;
        }
        if (Math.randomf()<clickArray[i])
        {
            0=>click.pos;
        } 
        if (Math.randomf()<hatArray[i])
        {
            0=>hat.pos;
        } 
        if(kick.pos()==0 || click.pos()==0 || hat.pos()==0) {
            1=>metal.noteOn;
			1=>metalHarmony.noteOn;
            metal.freq()*Math.random2f(.9,1.1)=>metal.freq;
			if(metal.freq() < 20. || metal.freq() > 40) 30 => metal.freq;
			metal.freq()*(1+Math.random2(0,16)*.25)=>metalHarmony.freq;
		    //Meshuggah
        }
    beattime/Math.random2(1,2)=>float beattime2;    
    beattime2::second=>now; 
    1=>metal.noteOff;
	1=>metalHarmony.noteOff;
     
    }
}

while (true)
{
    .025=>g.gain;
    section(kick_prob_1,click_prob_1,hat_prob_1,.5);
 //   section(kick_prob_2,click_prob_2,hat_prob_2,0.25);

}




