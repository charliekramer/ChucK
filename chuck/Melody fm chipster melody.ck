// fm chipster
//synch rising whop whop sound
60./94 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

SinOsc s => Gain g => dac;
SinOsc m => blackhole;

0.2 => g.gain;

Std.mtof(58) => s.freq;

s.freq()/4.=> float mf;
mf => m.freq;
1=>float baseMGain=>m.gain;
75 => float index;
// vary maxgain for max intensity
400 => int maxgain;

while (true) {
      for (0 => int i; i < maxgain; i++) {
         m.gain()+i*.0001=>m.gain;
//vary the coefficient on i for fun .0002    
         mf + (index*m.last()) => s.freq;        
        100::samp => now;
 //       beat/100 =>now;
 //       .125::second => now;
    }
    baseMGain => m.gain;
    (beat-100::samp)/16 => now;
} 