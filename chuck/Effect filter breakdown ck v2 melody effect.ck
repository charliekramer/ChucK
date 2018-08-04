// https://www.youtube.com/watch?v=IkbjktiF52k&start_radio=1&list=RDD_JSDNoc4Gs
//synch

60./154. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;

Blit s => LPF f => NRev rev => dac;
f.set(500,50);
0.5 => rev.mix;
.8 => f.gain;

//440 => s.freq;
55*4 => s.freq;
1=>s.gain;


int x;
while (beat/2 => now)
{
 

//(1+Math.sin(x % 25))*200+440 => f.freq;

//(1+Math.sin(x % 8))*(1+Math.sin(x%16))*200+440 => f.freq;
//(1+Math.sin(x % 8))*(1+Math.sin(x%16))*200+s.freq() => f.freq;
(1+Math.sin(x % 2))*(1+Math.sin(x%4))*400+s.freq() => f.freq;

    x++;
    
} 