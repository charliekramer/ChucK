// https://www.youtube.com/watch?v=IkbjktiF52k&start_radio=1&list=RDD_JSDNoc4Gs

60./94. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

Blit s => LPF f => NRev rev => dac;

Std.mtof(58-12) => s.freq;

f.set(s.freq()*5,50);
0.05 => rev.mix;
0.2 => s.gain;
0.5 => f.gain;

int x;
while (beat/4 => now)
{
    ( ( (x*5+3) % 17) + 2) * 500 => f.freq;
    x++;
    
} 

