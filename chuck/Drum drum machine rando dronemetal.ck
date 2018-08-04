//synch code
0.5::second=>dur beat;
beat - (now % beat) => now;

//soundchain
Gain g => dac;
//SndBuf click => NRev r => Echo e => g => dac;
SndBuf click => NRev r =>  g => dac;
SndBuf kick  => g => dac;
SndBuf hat  => g => dac;

//METAL
HevyMetl metal => dac;
37=>metal.freq;
0.3=>metal.gain;
80=>metal.lfoSpeed;
1=>metal.lfoDepth;


//reverb paramter
.3=>r.mix;

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
            metal.freq()*Math.random2f(.9,1.1)=>metal.freq;
            //Meshuggah
        }
    beattime*Math.random2f(0.5,1.5)=>beattime;    
    beattime::second=>now; 
    1=>metal.noteOff;
     
    }
}

while (true)
{
    .025=>g.gain;
    section(kick_prob_1,click_prob_1,hat_prob_1,.5);
 //   section(kick_prob_2,click_prob_2,hat_prob_2,0.25);

}

