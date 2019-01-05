//synch
1::second*60./120.=>dur beat; // formula = 1::second*60/BPM => dur beat; beat is then a quarter note
beat - (now % beat) => now;

//soundchain
Gain g => dac;
SndBuf kick  => NRev rev => g => dac;
SndBuf snare  => rev => Delay d => g => dac;
SndBuf hat => rev =>g => dac;
Shakers shak => rev => g => dac;

//set gains;
0.02 => g.gain;
0.2 => hat.gain;
0.1 => shak.gain;

//effects
0.1 => rev.mix;
beat*3./4. => d.delay;
0.0 => d.gain;

//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/snare_01.wav" => snare.read;
me.dir(-1)+"chuck/audio/hihat_01.wav" => hat.read;

// wind to end of file
kick.samples()=>kick.pos;
snare.samples()=>snare.pos;
hat.samples()=>hat.pos;

//funk option; set to 1 for funky action 

0 => int funkoption; 

    for ( 1 => int i; true; i++)
    {
        // kick test
        if (i % 4 == 1 ||  i % 16 > 14 || i % 32 > 29)
        {
            00=>kick.pos;
        }   
        // kick--funk option 
        if (funkoption == 1)
        {
            if (i % 16 == 3 || i % 16 == 4)
            {
                00=>kick.pos;
            }
        }
        // snare test (divide i by 3 or 4 for funk action)
        if (i % 8 == 5 || i % 17 == 8 || i % 64 > 59*4)
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
        if (i % 8 == 1 || i % 8 == 0 ||i % 8 == 3 || i % 8 == 5 || i % 8 == 7)
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
//    0=> snare.pos;
//   0=> kick.pos;

    beat/4=>now;  
    }
