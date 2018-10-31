// experimenting with odd functions for pitch alteration
// includes "sound cloud" random noise around base pitch (see comment in function)
SinOsc s1 => BPF f => dac; // base tone
SinOsc s2 => f => Echo e => NRev rev => dac; // complex function 
SinOsc s3 => f => e => rev => dac; // complex function
SqrOsc s4 => f => e => rev => dac; // Poisson process

(58+12) => int freqNum; // midi code for base frequency

Std.mtof(freqNum)*1.5 => f.freq;
20 => f.Q;

0.1 => s1.gain;
s1.gain()*.7 => s2.gain => s3.gain;
0.0 => s4.gain;
Std.mtof(freqNum) => s1.freq;


10::second => e.max;
1.75::second => e.delay;
0.1 => e.mix;
e => e;
0.5 => e.gain;

0.1 => rev.mix;

0.05 => float smoothSinCos; // coefficient on sin-cos function
.99 => float offBase; // 'intercept' on freq transformation

fun void pitFun (dur timing) {
    
    1000 => int maxI;
    0 => int i;
    while (true) {
        if (i > maxI) 0 => i;
 //      (1+Math.sin(i/3)/3)*(1+Math.cos(i/7)/7)*Std.mtof(57+12) => s2.freq;
  //        (offBase+.smoothSinCos*(1+(Math.sin(Math.sqrt(i*.55))))*(1+(Math.cos(Math.sqrt(i*1.5)))))*Std.mtof(freqNum) => s2.freq;  
  //         (offBase+.smoothSinCos*(1+(Math.sin(Math.sqrt(i*100*Std.rand()))))*(1+(Math.cos(Math.sqrt(i*100*Std.rand())))))*Std.mtof(freqNum) => s2.freq;  
 //           (offBase+.smoothSinCos*(1+(Math.sin(Math.sqrt(i*1.0*(1+Std.rand())))))*(1+(Math.cos(Math.sqrt(i*1*(1+Std.rand()))))))*Std.mtof(freqNum) => s2.freq;  
              (offBase+smoothSinCos*(1+(Math.sin(i*1*(1+Std.rand()))))*(1+(Math.cos(i*1*(1+Std.rand())))))*Std.mtof(freqNum) => s2.freq; 
              (offBase+.1*smoothSinCos*(1+(Math.sin(Math.sqrt(i*.55)))))* (1+.1*(Math.cos(Math.sqrt(i*1.5))))*Std.mtof(freqNum) => s3.freq; 
              if (Std.rand2f(0.0, 1.0) > .95) {
                  Std.rand2f(-2.5, 2.5)*Std.mtof(freqNum) => s4.freq;
                  s3.gain() => s4.gain;
                  Std.rand2f(0.0, 1.0) => s4.width;
              }
 //    0.0 => s1.gain => s2.gain => s3.gain; // set to poission only; also fix gain in if statement above
        timing => now;
        0.0 =>s4.gain;
        i++;
    }
}

spork~pitFun (.1::second);

1000::second => now; 
     