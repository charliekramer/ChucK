// granular from mandolin
// http://electro-music.com/forum/viewtopic.php?t=14196
Mandolin s1 => DelayL d1 => SinOsc s2 => dac; 
d1 => Gain g1 => LPF f1 => d1; 
s1.gain(0.1); 
s1.freq(440); 
s1.stringDamping(1); 
s1.pluckPos(.5); 
d1.max(2::second); 
d1.delay(0.5::second); 
s2.sync(1); 

g1.gain(0.3); 
f1.freq(4000.0); 
f1.Q(0.4); 

fun void KeepPlaying() { 
    while(true)   { 
        s1.noteOn(1); 
         4000::ms => now; 
//        10::second => now; 
  
        s1.freq(Std.rand2(4, 16) * 110); 
    } 
} 

spork ~ KeepPlaying(); 

while(Std.rand2f(100,500)::ms => now) { 
   d1.delay(Std.rand2f(1, 1000)::ms);}
