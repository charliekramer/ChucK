// based on kick break fuzz chorus reverb

.2 => float gainSet;

60./120. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

//soundchain
SndBuf kick  =>  HPF filter => NRev rev => JCRev revplus =>  Pan2 pan => dac;
SndBuf kick2 =>  HPF filter2 => JCRev rev2 => NRev rev2plus => Pan2 pan2 => dac;

gainSet => kick.gain => kick2.gain;

20 => filter.freq => filter2.freq;
2 => filter.Q => filter2.Q;

 1 => pan.pan;
-1 => pan2.pan;

0 => kick.loop;
0 => kick2.loop;

.5 => rev.mix;
.5 => revplus.mix;
.5 => rev2.mix;
.5 => rev2plus.mix;

//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/kick_01.wav" => kick2.read;

// wind to end of file
kick.samples()=>kick.pos;
kick2.samples()=>kick2.pos;

    for ( 1 => int i; true; i++)
    {
		
        // kick test
       if (i % 8 == 1 )
        {
            kick.samples()/2=>kick.pos;  
        } 
		if (i % 8 == 4)  
        {
			kick.samples()/2=>kick2.pos;  
		} 
 
    -1*Std.rand2f(.1,.2)  => kick.rate;
	-1*Std.rand2f(.1,.2)  => kick2.rate;
	
	<<< "beat", kick.pos(), kick2.pos() >>>;
 
	4*beat=>now;
	
	0 => kick.pos;
	0 => kick2.pos;
	
    }
