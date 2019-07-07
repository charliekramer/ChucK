// sndbuf FM
// use audio file to modulate sin, vice versa etc
// try continuous and short sounds, try modifying rate and pitch of
// modulator

SndBuf bufCarry=> Gain g => dac; 
SinOsc sinCarry => g => dac;
SndBuf bufMod => blackhole; 
SinOsc sinMod  => blackhole;
Noise noise => blackhole; 

.05 => g.gain;

120::second => dur lengthTime;

1 => bufCarry.rate;
1 => bufMod.rate;

1 => bufCarry.loop;
1 => bufMod.loop;

10 => float index;

1::samp => dur timeIncrement;


//"/Users/charleskramer/Desktop/chuck/audio/nixon_compilation.wav" => bufCarry.read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => bufCarry.read;
"/Users/charleskramer/Desktop/chuck/audio/nixon_farewell.wav" => bufMod.read;


220 => sinCarry.freq;
55 => sinMod.freq;

4 => int chooser;

// 1 2buf
// 2 buf2sin
// 3 sin2buf
// 4 noise2buf


if (chooser == 1) {
	0 => sinCarry.gain;
    spork~fm2buf(bufMod, bufCarry, 1, 12);
}	

else if (chooser == 2) {
	bufCarry.gain(0);
	spork~fmbuf2sin(bufMod, sinCarry, 10, 1800);
}

else if (chooser == 3) {
	
	0 => sinCarry.gain;
	spork~fmsin2buf(sinMod, bufCarry, .5, 3./2.); //.5, 3/2 cylons w/ nixon
}

else {
	
	0 => sinCarry.gain;
	spork~fmnoise2buf(noise,bufCarry, .9, 3);

}

lengthTime => now;

fun void fm2buf (SndBuf mod, SndBuf carry, float baseFreq, float index) { // carrier = buf
	while( true )
	{
		// modulate
		baseFreq+(index * mod.last()) => carry.rate;
		// advance time by 1 samp
		timeIncrement => now;
	}
	
}



fun void fmbuf2sin (SndBuf mod, SinOsc carry, float baseFreq, float index) { // carrier = sin
	while( true )
	{
		// modulate
		baseFreq+(index * mod.last()) => carry.freq;
		// advance time by 1 samp
		timeIncrement => now;
	}
	
}


fun void fmsin2buf (SinOsc mod, SndBuf carry, float baseFreq, float index) { // carrier = sin
	while( true )
	{
		// modulate
		baseFreq+(index * mod.last()) => carry.rate;
		// advance time by 1 samp
		timeIncrement => now;
	}
	
}

fun void fmnoise2buf (Noise mod, SndBuf carry, float baseFreq, float index) { // carrier = sin
	while( true )
	{
		// modulate
		baseFreq+(index * mod.last()) => carry.rate;
		// advance time by 1 samp
		timeIncrement => now;
	}
	
}