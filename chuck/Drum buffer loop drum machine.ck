// buffer looping drum machine with reverb and echo on snare

//0.4 => float beatsec; //sets both beat and loopFrequency
60./94. => float beatsec; //sets both beat and loopFrequency


//when changing beat change 1/beat below to the same number
beatsec::second => dur beat;
beat - (now % beat) => now;

// set to 1/beat above--for looping
1./beatsec => float loopFreq;

//needed to synch
//beat/4 => now;

SndBuf kick => Gain g => HPF h => dac;
SndBuf snare => Echo e => NRev rev => g => h => dac;
SndBuf hat => g => h => dac;

//hpf
h.freq(20);
h.Q(1);


0.1 => g.gain;

//snare effect parameters
10::second => e.max;
beat/4 => e.delay;
0.4 => e.mix;
0.2 => rev.mix;

//read files
me.dir(-1)+"chuck/audio/kick_01.wav" => kick.read;
me.dir(-1)+"chuck/audio/snare_02.wav" => snare.read;
me.dir(-1)+"chuck/audio/hihat_01.wav" => hat.read;

0.3=> hat.gain;
1=> kick.gain;
1=> snare.gain;


//loop kick, 2x/second
1 => kick.loop;
loopFreq => kick.freq;

//loop snare, 1x/second
1 => snare.loop;
.5*loopFreq => snare.freq;

//loop hat, 4x/second
1 => hat.loop;
4*loopFreq => hat.freq;
1=> hat.phase;

10000::second => now;