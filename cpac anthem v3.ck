// this time with individual buffers (reduce clicking?)
// n independent channels, loop each continuously and open and close 
// individual envelopes
// plus a bit of panning

80 => int n0; // start; can't load all 93 at once; max is around 15
n0+13 => int n; // 93 slices of CPAC

if (n > 93) <<< "N EXCEEDS NUMBER OF FILES" >>>;

n - n0 => int nBuf;

SndBuf2 bufPAC[nBuf];
Echo echo[nBuf];
NRev rev[nBuf];
Envelope env[nBuf];
Pan2 pan[nBuf];


1 => float rateSet;

0 => int index;

for (0 => int i; i < nBuf; i++) {
    
    bufPAC[i] => env[i]  => echo[i] => rev[i] => pan[i] => dac;
    n0+i => index;
    "/Users/charleskramer/Desktop/chuck/audio/CPAC"+index+".wav" => bufPAC[i].read;
    1 => bufPAC[i].loop; 
    0 => bufPAC[i].pos;  
     -1. +  (i % nBuf)*(nBuf+1)/nBuf => pan[i].pan;
     rateSet => bufPAC[i].rate;
     4::second => echo[i].max;
     .75::second*Std.rand2f(.75,1.5) => echo[i].delay;
     .5 => echo[i].mix;
     .5 => echo[i].gain;
     .2 => rev[i].mix;
     echo[i] => echo[i];
  
}

   
5 => int maxPick; // maximum number of picks
int nPick;
dur maxLength;


while (true) {
   
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
 

fun void pickNote(int i) {
  
  1 => env[i].keyOn;
  bufPAC[i].length() => now;
  1 => env[i].keyOff;
  
}
  
  