//sounds of saturn
// see https://www.techtimes.com/articles/232078/20180711/saturn-sings-an-eerie-cosmic-tune-to-enceladus-here-s-how-to-listen-to-it.htm
// credit: Tom Dowling

SndBuf saturn => NRev rev => LPF l => Chorus c => Gain g => Pan2 p => dac;
SndBuf saturn2 => rev => l => Chorus c2 => Gain g2 => Pan2 p2 => dac;

2200 => l.freq;
10 => l.Q;

.5 => rev.mix;

0.01 => g.gain;
0.01 => g2.gain;

me.dir(-1)+"chuck/audio/SoundsofSaturn.wav" => saturn.read;
me.dir(-1)+"chuck/audio/SoundsofSaturn.wav" => saturn2.read;

while (true) {
    
Std.ftoi(Std.rand2f(0,1)*saturn.samples()) => saturn.pos;
Std.ftoi(Std.rand2f(0,1)*saturn.samples()) => saturn2.pos;

Std.rand2f(-1.,0.) => p.pan;
Std.rand2f(-0.,1.) => p2.pan;

Std.rand2f(.1,10) => saturn.rate;
Std.rand2f(.1,10) => saturn2.rate;

Std.rand2f(.3,20) => c.modFreq;
Std.rand2f(0.1,1) => c.modDepth;
Std.rand2f(.3,1) => c2.modFreq;
Std.rand2f(0.1,1) => c2.modDepth;


Std.rand2f(.5,6.)::second => dur saturnTime;

saturnTime => now;

}