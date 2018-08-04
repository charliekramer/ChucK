// fm chipster
//synch
60./154 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

SinOsc s => Gain g => dac;
SinOsc m => blackhole;

0.2 => g.gain;

220 => s.freq;

110=> float mf;
mf => m.freq;
1=>float baseMGain=>m.gain;
100 => float index;
// vary maxgain for max intensity
400 => int maxgain;

while (true) {
      for (0 => int i; i < maxgain; i++) {
         m.gain()+i*.0001=>m.gain;
//vary the coefficient on i for fun        
         mf + (index*m.last()) => s.freq;        
        100::samp => now;
 //       beat/100 =>now;
 //       .125::second => now;
    }
    baseMGain => m.gain;
    beat/16 => now;
} 