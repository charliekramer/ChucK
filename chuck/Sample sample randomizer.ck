// sample randomizer; based on disquiet 0338

0.25::second => dur chunk;

chunk - (now % chunk) => now;

//sound buffers for all four samples; sound chains with pan
SndBuf lk => Gain lkgain => Pan2 lkpan => dac;
SndBuf ao => Gain aogain => Pan2 aopan => dac;
SndBuf ss => Gain ssgain => Pan2 sspan => dac;
SndBuf sv => Gain svgain => Pan2 svpan => dac;

//read audio files
me.dir()+"audio/Ikjoyce.wav" => lk.read;
me.dir()+"audio/AudioObscura.wav" => ao.read;
me.dir()+"audio/Subsepal.wav" => ss.read;
me.dir()+"audio/sevenism.wav" => sv.read;

//gain and pan settings;

0.5 => lkgain.gain;
0.5 => aogain.gain;
0.5 => ssgain.gain;
0.25 => svgain.gain;

-.75 => lkpan.pan;
-.25 => aopan.pan;
.25 => aopan.pan;
.75 => aopan.pan;

//set pointers to end

lk.samples() => lk.pos;
ao.samples() => ao.pos;
ss.samples() => ss.pos;
sv.samples() => sv.pos;

//set positions to 0 to play from start

0 => lk.pos;
//0 => ao.pos;
//0 => ss.pos;
//0 => sv.pos;

//set rate

1 => lk.rate;
//1 => ao.rate;
//1 => ss.rate;
//1 => sv.rate;

while (true)
{
//randomize position

Std.ftoi(Std.rand2f(0,1)*lk.samples())=>lk.pos; 
//Std.ftoi(Std.rand2f(0,1)*ao.samples())=>ao.pos; 
//Std.ftoi(Std.rand2f(0,1)*ss.samples())=>ss.pos; 
//Std.ftoi(Std.rand2f(0,1)*sv.samples())=>sv.pos; 

//randomize rate

Std.rand2f(0,1) => lk.rate;
//Std.rand2f(0,1) => ao.rate;
//Std.rand2f(0,1) => ss.rate;
//Std.rand2f(0,1) => sv.rate;



//play 
1::second => now;
}

