Shakers shak => NRev r => dac;

0.2=>r.mix;
2.=> shak.energy;
2=> shak.gain;
0.5=>shak.decay;
4=>shak.preset;
7000=> shak.freq;
 
3 => shak.gain;

while (true) {
    1=>shak.noteOn;
    .1::second => now;
    1=>shak.noteOff;
   .01::second => now;   
}
    
