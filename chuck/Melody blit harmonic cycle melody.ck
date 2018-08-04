// https://www.youtube.com/watch?v=IkbjktiF52k&start_radio=1&list=RDD_JSDNoc4Gs

//synch
60./154. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;;

Blit s => NRev rev => dac;

0.3 => rev.mix;

440 => s.freq;
//220 => s.freq;
//55 => s.freq;
.2=>s.gain;

int x;
while (beat/2 => now)
{
    Std.ftoi((1+Math.sin(x % 32))*32) => s.harmonics;
    x++;  
} 