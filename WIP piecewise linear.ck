.2 => float gainSet;
60 => float midiBase;
5::second => dur beat;

now + 30::second => time future;

while (now < future) {
    
 spork~linear(2);
 beat => now;
 
}

5*beat => now;

fun void linear (int n) {
    
    SawOsc saw[n];
    float freqs[n];
    Pan2 pan[n];
    Echo echo[n];
    
    for (0 => int i; i < saw.cap(); i++) {
        5*beat => echo[i].max;
        Std.rand2f(.25,.75) * beat => echo[i].delay;
        .5 => echo[i].mix;
        .5 => echo[i].gain;
        
        gainSet => saw[i].gain;
    
        Std.rand2f(-1,1) => pan[i].pan;
        saw[i] => echo[i] => pan[i] => dac;
        Std.mtof(midiBase + Std.rand2f(-2,4)) => freqs[i];
        
    }
    
   Std.rand2f(.5,2) => float a;
   Std.rand2f(-1,1) => float b;
   
   0 => float note;
   80 => float max;
   20 => float min;
   
   0 => float j;
   
   now + Std.rand2f(.5,1.5)*beat => time future;
   .01 => float increment;
   
   while (now < future) {
       for (0 => int i; i < saw.cap(); i++) {  
           freqs[i]*(a+b*j) => saw[i].freq;
       }
       beat*increment => now;
       increment +=> j;
       
   }
  
   beat => now;
  } 