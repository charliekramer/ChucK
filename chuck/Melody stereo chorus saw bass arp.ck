// stereo chorus Saw Bass w/ arp

60./94. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

SqrOsc s => Chorus cL => dac.left;
s => Echo e => Chorus cR => dac.right;

.05 => s.gain;

Std.mtof(58+12) => float baseFreq => s.freq; //layer on this *1.5

.5  => float freqDiv;

4 => int numIt;

.1 => cL.modFreq => cR.modFreq;

0.2 => cR.modDepth => cL.modDepth;

1::second => e.max;

50::ms => e.delay;

1 => e.mix;

while (true) {
	
   baseFreq => s.freq;
   
   beat/numIt => now;
   
   for (1 => int i; i < numIt; i++) {
   	
     s.freq()*freqDiv => s.freq;
     beat/numIt => now; 
	 
   }

 
}