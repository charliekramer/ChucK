Shakers shak => NRev r => dac;

0.2=>r.mix;
1.=> shak.energy;
.5=> shak.gain;
0.5=>shak.decay;
4=>shak.preset;
5000=> shak.freq;

while (true) {
    1=>shak.noteOn;
    .1::second => now;
    1=>shak.noteOff;
   .01::second => now;   
}
    
