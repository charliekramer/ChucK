// added "shuffle" (variable gain depending on where we are in the measure)
//synch
//0.4::second=>dur beat;
60./94. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

0.02 => float gainSet;

//soundchain
Gain g => dac;
SndBuf kick  => Gain kickG => g => HPF h => dac;
SndBuf snare  =>  Gain snareG => NRev snareRev => g => h => dac;
SndBuf hat => Gain hatG => g => h => dac;
Shakers shak => Gain shakG => g => h => dac;

h.freq(44); // 44 gives big sound
h.Q(10);

0 => int funkoption; 
0 => int shuffle;
0 => int snareRoll;
0 => int kickRoll;
0 => int kickSolo;
0 => int snareSolo;


//default gain setting (for reset use in shuffle code
0.9 => float snareGain;
snareGain => snare.gain;
1.0 => float kickGain;
kickGain => kick.gain;

// gain settings
gainSet => g.gain; //0.5
1.0 => kickG.gain; //1.0
0.05 => hatG.gain; //0.2
0.1 => shakG.gain; //0.1
1.5 => snareG.gain;//1.0

0.1 => snareRev.mix;


// use this to drop out all but kick or snare
if (kickSolo ==1) 0. => hatG.gain => shakG.gain => snareG.gain; //kick only
if (snareSolo ==1) 0. => hatG.gain => shakG.gain => kickG.gain; //snare only
    
    
//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/snare_01.wav" => snare.read;
me.dir(-1)+"chuck/audio/hihat_01.wav" => hat.read;

// wind to end of file
kick.samples()=>kick.pos;
snare.samples()=>snare.pos;
hat.samples()=>hat.pos;

//funk option; set to 1 for funky action 
// shuffle option


    for ( 1 => int i; true; i++)
    {
        // kick test
        if (i % 8 == 1 || i % 8 == 5 || i % 32 > 29 || i % 128 > 120)
        {
            00=>kick.pos;
        }   
        // kick--funk option 
        if (funkoption == 1)
        {
            if (i % 16 == 3 || i % 16 == 4 || i % 3 == 2 )
            {
                00=>kick.pos;
            }
        }
        // snare test (divide i by 3 or 4 for funk action)
        // reset snare gain
        snareGain => snare.gain;
        if (i % 8 == 5 || i % 8 == 5 || i % 64 > 59)
        {
            00=>snare.pos;
        } 
        //snare - shuffle code
        if (shuffle == 1) {
            if (i % 11 == 1 || i % 9 == 1)
            {
                Std.rand2f(0.1,.4) => snare.gain; 
                00=>snare.pos;
            } 
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
        if (i % 4 == 0 || i % 4 == 1 || i % 4 == 1 || i % 4 == 3 || i % 8 == 5 || i % 8 == 7 || i % 5 == 1)
        {
            00=>hat.pos;
        } 
        // hat--funk option
        if (funkoption == 1 )
        {
            if (i % 8 == 2 || i % 8 == 4 || i % 8 == 6 || i % 16 == 8 || i % 32 > 1)
            {
                00=>hat.pos;
            } 
        }
        // some random shaker action
        if (Std.rand2f(0.,1.) > 0.7) 
        {
            Std.rand2f(0.,1.) => shak.noteOn;
            Std.rand2(1,22) => shak.preset;
        }
        

 // fills here
        if(snareRoll == 1) {
 	        Std.rand2f(.2,.7)*snareGain => snare.gain;
 	        0=> snare.pos;
         }
		 
		 if(kickRoll ==1) {
		 	 Std.rand2f(0.2,.7)*kickGain => kick.gain;
		 	 0=> kick.pos;
	 	 }

    beat/4=>now; 
	
	snareGain => snare.gain;
    kickGain => kick.gain;
	 
    }
