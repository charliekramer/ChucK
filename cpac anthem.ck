93 => int n; // 93 slices of CPAC

5 => int maxPick; // maximum number of picks
int nPick;

while (true) {
   
   Std.rand2(1,maxPick) => nPick;
   
   for (0 => int i; i < nPick; i++) {
    
    spork~pickNote(Std.rand2(1,n)*0 + 86); //86 = free 53 = red glare
    }
       2::second => now;
 
       
 }
 

fun void pickNote(int i) {
    SndBuf2 bufPAC => Envelope env => dac;
  "/Users/charleskramer/Desktop/chuck/audio/CPAC"+i+".wav" => bufPAC.read;
  
  1 => env.keyOn;
  bufPAC.length() => now;
  1 => env.keyOff;
    }