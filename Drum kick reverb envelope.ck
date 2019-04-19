// based on kick break fuzz chorus reverb

60./120. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

//soundchain
SndBuf kick  =>  LPF f => NRev rev => JCRev revplus => ADSR envelope => Gain g => dac.left;
SndBuf kick2 =>  f => JCRev rev2 => NRev rev2plus => ADSR envelope2 => Gain g2 => dac.right;

5 => f.Q;
440 => f.freq;

(6*beat, .1*beat, .5, 4*beat) => envelope.set;
(6*beat, .1*beat, .5, 4*beat) => envelope2.set;

.01 => g.gain;
.01 => g2.gain;

.1 => kick.rate;
.2 => kick2.rate;

1 => rev.mix;
1 => revplus.mix;
1 => rev2.mix;
1 => rev2plus.mix;


//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/kick_01.wav" => kick2.read;

// wind to end of file
kick.samples()=>kick.pos;
kick2.samples()=>kick2.pos;

    for ( 1 => int i; true; i++)
    {
        // kick test
       if (i % 2 == 1 )
        {
            00=>kick.pos;  
			1 => envelope.keyOn;          
        } 
		if (i % 2 == 0)  
        {
			00=>kick2.pos;  
			1 => envelope2.keyOn;          
		} 
 
    5*Std.rand2f(.1,.2) => kick.rate;
	5*Std.rand2f(.2,.3) => kick2.rate;

    6*beat=>now;  
	1 => envelope.keyOff;
	1 => envelope2.keyOff;
	4*beat=>now;
    }
