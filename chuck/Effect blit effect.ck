// https://www.youtube.com/watch?v=IkbjktiF52k&start_radio=1&list=RDD_JSDNoc4Gs


1::second - (now % 1::second) => now;

Blit s => LPF f => NRev rev => dac;
f.set(500,50);
0.05 => rev.mix;
0.5 => f.gain;

100 => s.freq;

int x;
while (250::ms => now)
{
    ( ( (x*5+3) % 17) + 2) * 500 => f.freq;
    x++;
    
} 

