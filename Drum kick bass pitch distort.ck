// based on goth drum machine
//synch

.2 => float gainSet;

60./94.*1 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

SndBuf kick  =>  NRev rev => Echo echo => Gain gain => Gain master => dac;

gainSet => master.gain;

beat*2 => echo.max;
beat*1.5 => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

.0 => rev.mix;

SawOsc sin => master => dac;
gainSet*.8 => sin.gain;

57-24 =>float midiBase;

//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;

kick.samples()=>kick.pos;

    for ( 1 => int i; true; i++)
    {
        // kick test
        if (i % 8 == 1 )
        {
            00=>kick.pos;
            Std.rand2f(.7,1.3) => kick.rate;
           
        }   
    now + beat / 4 => time future;
    
    while (now < future) {    
        Std.mtof(midiBase)*.5*(1+1/((i%120)*Std.fabs(gain.last())+1)) => sin.freq;
        1::samp => now; 
    }
       
    }
