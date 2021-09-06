
//resample from original housesounds


SndBuf2 buf => dac;

"/Users/charleskramer/Desktop/chuck/audio/house_sounds_cut2.wav" => buf.read;

0 => buf.pos;

.5 => buf.gain;

buf.length() => dur length;

5::second => dur beat;

now + length => time future;

while (now < future) {
 
 beat => now;   
 
 if (Std.rand2f(0,1) > .3) spork~sampleHouse(buf.pos());
    
}

2*beat => now;

fun void sampleHouse(int pos) {
 
 SndBuf2 buf2 => LPF filt => NRev rev => Gain gain => Envelope env => Pan2 panL => dac;
 gain => Echo echo => NRev rev2 => Envelope env2 => Pan2 panR => dac;
 "/Users/charleskramer/Desktop/chuck/audio/house_sounds_cut2.wav" => buf2.read;

 .25*buf.gain() => buf2.gain;

 Std.mtof(110) => filt.freq;
 2 => filt.Q;
 
 Std.rand2(10,250)::ms => echo.max => echo.delay;
 .7 => echo.mix => echo.gain;
 echo => echo;
 
 Std.rand2f(.25,.75) => panL.pan;
 -panL.pan() => panR.pan;
 
 .2 => rev.mix => rev2.mix;
 
 .2* beat => env.duration => env2.duration;
 
  pos + Std.rand2(-40000*5,40000*5) => int bufPos;
  if (bufPos > buf2.samples()) pos => bufPos;
  if (bufPos < 0) 0 => bufPos;
  
  bufPos => buf2.pos;
  
  1 => env.keyOn => env2.keyOn;
  beat => now;
  1 => env.keyOff => env2.keyOff;
  beat => now;
    
}