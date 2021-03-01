// this time with individual buffers (reduce clicking?)

93 => int n; // 93 slices of CPAC

SndBuf2 bufPAC[n];

for (1 => int i; i < n; i++) {
    bufPAC[i] => dac;
    "/Users/charleskramer/Desktop/chuck/audio/CPAC"+i+".wav" => bufPAC[i].read;
    bufPAC[i].samples() => bufPAC[i].pos;   
}

    

5 => int maxPick; // maximum number of picks
int nPick;
dur maxLength;


while (true) {
   
   0::second =>  maxLength;
   
   Std.rand2(1,maxPick) => nPick;
   
   for (0 => int i; i < nPick; i++) {
       Std.rand2(1,n-1) => int j;
       if (bufPAC[j].length() > maxLength) bufPAC[j].length() => maxLength;
       spork~pickNote(j);
    }
      
    maxLength => now;    
 }
 

fun void pickNote(int i) {
  
  0 => bufPAC[i].pos;
  bufPAC[i].length() => now;
  
}
  
  