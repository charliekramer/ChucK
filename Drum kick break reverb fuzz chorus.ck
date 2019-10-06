// based on kick break reverb
//synch

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

60./50. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

//soundchain
Gain g => dac;
SndBuf kick  =>   NRev rev => Fuzz fuzz => Chorus c => g => dac;
SndBuf kick2  => rev => fuzz => c =>  g => dac;
SndBuf snare  => rev => fuzz => c => g => dac;
SndBuf hat => rev =>fuzz => c => g => dac;
Shakers shak => rev => fuzz => c => g => dac;

0.001 => g.gain;

1 => fuzz.intensity;

0.2 => rev.mix;

.3 => c.mix;
.25 => c.modFreq;
1 => c.modDepth;

1.0 => kick.gain;
1.0 => kick2.gain;
0.1 => hat.gain;
0.1 => shak.gain;
2.5 => snare.gain;

0 => hat.gain => shak.gain => snare.gain; // kick only;

0 => int funkoption; 
0 => int fourFloor; // four on the floor kick

0.7 => kick.rate;
0.7 => kick2.rate;
0.5 => snare.rate;
0.5 => hat.rate;

//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/kick_01.wav" => kick2.read;
me.dir(-1)+"chuck/audio/snare_01.wav" => snare.read;
me.dir(-1)+"chuck/audio/hihat_01.wav" => hat.read;

// wind to end of file
kick.samples()=>kick.pos;
snare.samples()=>snare.pos;
hat.samples()=>hat.pos;


    for ( 1 => int i; true; i++)
    {
        // kick test
        if (i % 32 == 1 ) //|| i % 32 == 5 || i % 256 > 248)
        {
            00=>kick.pos;
            0=> kick2.pos;
            
        }   
        // kick--funk option 
        if (funkoption == 1)
        {
            if (i % 16 == 3 || i % 16 == 4)
            {
                00=>kick.pos;
                0=> kick2.pos;

            }
        }
		if (fourFloor == 1) 
		{
			if (i % 8 == 1 || i % 8 == 5)  
			{
				00=>kick.pos;
				00=>kick2.pos;
			}
		}	
		
        // snare test (divide i by 3 or 4 for funk action)
        if (i % 16 == 5 || i % 16 == 13 || i % 64 > 61 || i % 128 > 120)
			// modify the second test for coolness
        {
            00=>snare.pos;
        } 
        // snare--funk option
        if (funkoption == 1) 
        {
            if (i % 16 == 6 || i % 16 == 15 || i % 8 == 11)
            {
                00=>snare.pos;
            }
        }
            // hat test
        if (i % 8 == 1 || i % 8 == 3 || i % 8 == 5 || i % 8 == 7)
        {
            00=>hat.pos;
        } 
        // hat--funk option
        if (funkoption == 1 )
        {
            if (i % 16 == 2 || i % 16 == 4 || i % 16 == 6 || i % 16 == 8)
            {
                00=>hat.pos;
            } 
        }
        // some random shaker action
        if (Std.rand2f(0.,1.) > 0.9) 
        {
            Std.rand2f(0.,1.) => shak.noteOn;
            Std.rand2(1,22) => shak.preset;
        }
        

 // fills here
  //  0=> snare.pos;
 // 0=> kick.pos => kick2.pos;
 

    beat/4=>now;  
    }
