
SndBuf2 buf => Envelope env => dac;
"/Users/charleskramer/Documents/art/01_Red_Dress.wav" => buf.read;
1 => buf.loop;
100::ms => dur sampleLength;
sampleLength*1 => env.duration; 

0 => buf.pos;  

0 => int bP; //bufpos for sporks--allow to advance
1000 => int dbP;

while (true) {
    //spork~grain();
    spork~grain1();
    sampleLength*.5 => now;
    //spork~grain();
    spork~grain1();
    sampleLength*.5 => now;
    //<<< "buf pos, ",buf.pos() >>>;
    bP + dbP => bP;
    }

fun void grain() {
    
    buf.pos() + Std.rand2(-1000,1000) => buf.pos;
       
    1 => env.keyOn;   
   
    sampleLength => now;
    
    1 => env.keyOff;
    
    sampleLength => now;
    
    }
    
    
fun void grain1() {
    
    SndBuf2 buf => Envelope env => dac;
    "/Users/charleskramer/Documents/art/01_Red_Dress.wav" => buf.read;
    1 => buf.loop;
        
     bP + Std.rand2(-1000,1000) => buf.pos;
        
        1 => env.keyOn;   
        
        sampleLength => now;
        
        1 => env.keyOff;
        
        sampleLength => now;
        
    }