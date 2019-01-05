// fm chipster
//synch rising whop whop sound
60./120 => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

SinOsc s => Gain g => dac;
SinOsc m => blackhole;

0.2 => g.gain;

Std.mtof(60) => s.freq;

120 => int nSamps; // number of samples for upswing

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
        nSamps::samp => now;

    }
    baseMGain => m.gain;
    (beat-nSamps::samp)/16 => now;
} 