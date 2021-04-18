16 => int n; //up to 16
.7/(1.*n) => float gainSet;

SndBuf2 poem[n];
PitShift pitch[n];
NRev rev[n];
HPF filt[n];
Pan2 pan[n];

.995 => float rateM;

for (0 => int i; i < n; i++) {
    
    gainSet => poem[i].gain;
    poem[i] => pitch[i] => filt[i] => rev[i] => pan[i] =>  dac;
    //if (i%2 == 0) "/Users/charleskramer/Desktop/chuck/audio/secrest_poem_1.wav" => poem[i].read;
    //else "/Users/charleskramer/Desktop/chuck/audio/secrest_poem_2.wav" => poem[i].read;
    //"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav"=> poem[i].read; 
   "/Users/charleskramer/Desktop/chuck/audio/2hearts_v3_heavy.wav" => poem[i].read;
    Math.pow(rateM,i) => poem[i].rate;
    0 => poem[i].pos;
    0 => poem[i].loop;
    
    if (n > 1) -1. +  (i % n)*(.1*n+1.)/(1.*n) => pan[i].pan;
  
    
    .2 => rev[i].mix;
    
    Std.mtof(90) => filt[i].freq; //90?
    
    }
    
7::minute => now;