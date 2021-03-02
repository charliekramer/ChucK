// this time with individual buffers (reduce clicking?)
// n independent channels, loop each continuously and open and close 
// individual envelopes
// plus a bit of panning

1 => float gainSet;
20::second => dur length;

88 => int n0; // start; can't load all 93 at once; max is around 15
n0+5 => int n; // end; total of 93 slices of CPAC

.125 => float rateSet;

if (n > 93) <<< "N EXCEEDS NUMBER OF FILES" >>>;

n - n0 + 1 => int nBuf;

SndBuf2 bufPAC[nBuf];
Echo echo[nBuf];
NRev rev[nBuf];
Envelope env[nBuf];
Pan2 pan[nBuf];

0 => int index;

for (0 => int i; i < nBuf; i++) {
    gainSet => bufPAC[i].gain;
    bufPAC[i] => env[i]  => echo[i] => rev[i] => pan[i] => dac;
    n0+i => index;
    "/Users/charleskramer/Desktop/chuck/audio/CPAC"+index+".wav" => bufPAC[i].read;
    1 => bufPAC[i].loop; 
    0 => bufPAC[i].pos;  
     if (nBuf > 1) -1. +  (i % nBuf)*(.1*nBuf+1.)/(1.*nBuf) => pan[i].pan;
     <<< "Pan i", pan[i].pan() >>>;
     rateSet => bufPAC[i].rate;
     4::second => echo[i].max;
     .75::second*Std.rand2f(.75,1.5) => echo[i].delay;
     .5 => echo[i].mix;
     .5 => echo[i].gain;
     .2 => rev[i].mix;
     echo[i] => echo[i];
     25::ms => env[i].duration;
  
}

   
5 => int maxPick; // maximum number of picks
int nPick;
dur maxLength;

now + length => time future;

while (now < future) {
   
   0::second =>  maxLength;
   
   Std.rand2(1,maxPick) => nPick;
   
   for (0 => int i; i < nPick; i++) {
       Std.rand2(0,nBuf-1) => int j;
       if (bufPAC[j].length() > maxLength) bufPAC[j].length() => maxLength;
       <<< "j ", j>>>;
       spork~pickNote(j);
    }
      
    maxLength => now;    
 }
 
10::second => now;
 

fun void pickNote(int i) {
  
  1 => env[i].keyOn;
  bufPAC[i].length() => now;
  1 => env[i].keyOff;
  
}
  
  