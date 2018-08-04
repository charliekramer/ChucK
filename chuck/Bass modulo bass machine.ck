60./154. => float beatsec;
beatsec::second=>dur beat;
beat - (now % beat) => now;

Gain g => dac;
SinOsc s  => Envelope e => g => dac;
Blit b =>   e => g => dac;
SinOsc t  =>   e => g => dac;



1=>b.harmonics;

.01=> float ratio;

(55)*(1+ratio) => s.freq;
(55)*(1-ratio) => t.freq;

0.025 => g.gain;


for ( 0 => int i; true; i++)
{
    // bass test
 //   if (i % 8 == 1 || i % 8 == 5)
 if (i % 8 == 1 || i % 8 == 5)
    {
        1 => e.keyOn;
    }   
 //extra note on the 5
/* if ( i % 8 == 5)
    {
        1 => e.keyOn;
        220*80 => t.freq;
    }  
*/  
//play with divisor for fun 
    beat/16=>now;  
    1 => e.keyOff;
//    220=>t.freq;
}
