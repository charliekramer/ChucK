
SndBuf2 bufA => Envelope envA => dac;
"/Users/charleskramer/Documents/art/01_Red_Dress.wav" => bufA.read;
1 => bufA.loop;

SndBuf2 bufB => Envelope envB => dac;
"/Users/charleskramer/Documents/art/01_Red_Dress.wav" => bufB.read;
1 => bufB.loop;

50::ms => dur sampleLength;
sampleLength*1 => envA.duration;
sampleLength*1 => envB.duration;

100 => int dbP; //average change in bufPos per round
 
while (true) {
    spork~grainA();
    sampleLength*.5 => now;
    spork~grainB();
    sampleLength*.5 => now;
    }

fun void grainA() {
    
    bufA.pos() + dbP + Std.rand2(-1000,1000) => bufA.pos;
       
    1 => envA.keyOn;   
   
    sampleLength => now;
    
    1 => envA.keyOff;
    
    sampleLength => now;
    
    }
    
fun void grainB() {
        
        bufB.pos() + dbP+Std.rand2(-1000,1000) => bufB.pos;
        
        1 => envB.keyOn;   
        
        sampleLength => now;
        
        1 => envB.keyOff;
        
        sampleLength => now;
        
    }
    
