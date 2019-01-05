// uses "vinyl 11" samples from musicradar free samples
//https://www.musicradar.com/news/drums/sampleradar-1000-free-drum-samples-229460
// based on Drum modulo drum machine shuffle
// added "shuffle" (variable gain depending on where we are in the measure)
//synch
// added glitch mode with variable rate 

60./120. => float beattime;
beattime::second => dur beat;
beat - (now % beat) => now;

//soundchain
Gain g => dac;
SndBuf kick  => Gain kickG => g => HPF h => dac;
SndBuf snare  =>  Gain snareG => NRev snareRev => g => h => dac;
SndBuf hat => Gain hatG => g => h => dac;
SndBuf hatOpen => hatG => g => h => dac;
SndBuf crash => Gain crashG => g => h => dac;
SndBuf tom1 => Gain tomG => g => h => dac;
SndBuf tom2 => tomG => g => h => dac;
SndBuf tom3 => tomG => g => h => dac;
Shakers shak => Gain shakG => g => h => dac;

h.freq(20);
h.Q(10);

//default gain setting (for reset use in shuffle code
0.9 => float snaregain;
snaregain => snare.gain;

// gain settings
0.002 => g.gain; //0.5
1.0 => kickG.gain; //1.0
0.2 => hatG.gain; //0.2
0.9 => crashG.gain; //0.2
0.1 => shakG.gain; //0.1
1.5 => snareG.gain;//1.5
.5 => tomG.gain;//0.5

.7 => float dank; // slow down all kit
dank => kick.rate => hat.rate => hatOpen.rate => crash.rate => snare.rate;

//or use glitchmode (random)

1 => int glitchMode;
.2 => float lowGlitch;
2. => float hiGlitch;


0.05 => snareRev.mix;

// use this to drop out all but kick or snare
//0. => hatG.gain => crashG.gain => shakG.gain => snareG.gain; //kick only
//0. => hatG.gain => crashG.gain => shakG.gain => kickG.gain; //snare only
    
    
//read files
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-Kick01.wav" => kick.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-Snr03.wav" => snare.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-ClHat04.wav" => hat.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-OpHat02.wav" => hatOpen.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-Crash01.wav" => crash.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-Tom01.wav" => tom1.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-Tom02.wav" => tom2.read;
"/Users/charleskramer/Desktop/musicradar-drum-samples/Drum Kits/Kit 11 - Vinyl/CYCdh_VinylK4-Tom03.wav" => tom3.read;

// wind to end of file
kick.samples()=>kick.pos;
snare.samples()=>snare.pos;
hat.samples()=>hat.pos;
crash.samples()=>crash.pos;
hatOpen.samples()=>hatOpen.pos;
tom1.samples()=>tom1.pos;
tom2.samples()=>tom2.pos;
tom3.samples()=>tom3.pos;

//funk option; set to 1 for funky action 
// shuffle option

0 => int funkoption; 
0 => int shuffle;

    for ( 1 => int i; true; i++)		
    {
        // kick test
        if (i % 8 == 1 || i % 16 == 3 || i % 16 == 15 || i % 32 > 29 || i % 128 > 120)
        {
            00=>kick.pos;
        }   
		
		if (i % 64 == 1) 0 => crash.pos;
		
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
        snaregain => snare.gain;
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
            if (i % 16 == 6 )
            {
                00=>snare.pos;
            }
        }
            // hat test
        if (i % 8 == 1 || i % 8 == 3 || i % 8 == 5 || i % 8 == 7)
        {
            00=>hat.pos;
        } 
		if ( i % 32 == 31)
		{
			00=>hatOpen.pos;
		} 
        // hat--funk option
        if (funkoption == 1 )
        {
            if (i % 8 == 2 || i % 8 == 4 || i % 8 == 6 || i % 16 == 8 || i % 32 > 1)
            {
                00=>hat.pos;
            } 
        }
		//toms 
		if ( i % 64 == 61)
		{
			00=>tom1.pos;
		} 
		if ( i % 64 == 62)
		{
			00=>tom2.pos;
		} 
		if ( i % 64 == 63)
		{
			00=>tom3.pos;
		} 
        // some random shaker action
        if (Std.rand2f(0.,1.) > 0.7) 
        {
            Std.rand2f(0.,1.) => shak.noteOn;
            Std.rand2(1,22) => shak.preset;
        }
        

 // fills here
//  0=> snare.pos;
//  0=> kick.pos;

// whoa glitch tastic
    if (glitchMode ==1) Std.rand2f(lowGlitch,hiGlitch) => kick.rate => hat.rate => hatOpen.rate => crash.rate => snare.rate;



    beat/4=>now;  
    }
