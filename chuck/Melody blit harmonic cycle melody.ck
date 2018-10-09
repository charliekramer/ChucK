// https://www.youtube.com/watch?v=IkbjktiF52k&start_radio=1&list=RDD_JSDNoc4Gs

//synch
60./94. => float beattime;
beattime::second=>dur beat;
beat - (now % beat) => now;;

Blit s => NRev rev => dac;

0.3 => rev.mix;

Std.mtof(58) => s.freq;
//220 => s.freq;
//55 => s.freq;
.2=>s.gain;

int x;
while (beat/4 => now)
{
    Std.ftoi((1+Math.sin(x % 7))*8) => s.harmonics;
    x++;  
} 