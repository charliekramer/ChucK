60./94. => float beatsec;
beatsec::second=>dur beat;
beat - (now % beat) => now;

Gain g => dac;
SinOsc s  => Envelope e => g => dac;
Blit b =>   e => g => dac;
SinOsc t  =>   e => g => dac;



1=>b.harmonics; // change 

.01=> float ratio;

Std.mtof(58-12)*(1+ratio) => s.freq;
Std.mtof(58-12)*(1-ratio) => t.freq;
Std.mtof(58-24) => b.freq;

500::samp => e.duration;

0.025 => g.gain;

for ( 0 => int i; true; i++)
{
    // bass test
 //   if (i % 8 == 1 || i % 8 == 5)
 if (i % 8 == 1 || i % 8 == 5)
    {
        1 => e.keyOn;
    }   

//play with divisor for fun 
    beat/16=>now;  
    1 => e.keyOff;
}
