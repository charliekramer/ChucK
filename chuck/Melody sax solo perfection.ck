//random sax solo
//Tanpura in C#/G# + prayer bowls in B/A/G/F/E/D/C = perfection
//sound chain
Saxofony sax => NRev rev => Echo e => Gain g => Pan2 p => dac;
0.7 => rev.mix;
10::second => e.max;
1.75::second => e.delay;
0.01 => g.gain;

// pick from this scale
//[60,63,64,65,66,67,70,72] @=> int scale[];
//[60,61,64,65,67,70,71,72] @=> int scale[];
[71,69,67,65,64,62,60,83,71,71,71] @=> int scale[];


//sax parameters
0.35 =>  sax.stiffness;
0.4 =>  sax.aperture;
0.5 =>  sax.pressure;
0.5 =>  sax.noiseGain;
0.4 =>  sax.blowPosition;
1 =>  sax.rate;

now + 1::minute => time future;
while (now < future) {
    // subtract 12 to experiment with octave
   Std.mtof( scale[ Math.random2(0,scale.cap()-1)])/2 => sax.freq; 
     
//   Math.random2f(0.0,0.015) => sax.startBlowing;
   
   1=> sax.noteOn;
   Math.random2f(.15,2.7)::second => now;
   1=>sax.noteOff;
   Math.random2f(.015,.017)::second => now;
}