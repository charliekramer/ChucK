// lorenz system
// https://en.wikipedia.org/wiki/Lorenz_system
// dx / dt = sigma (y-x);
// dy / dt = x(rho - z) - y;
// dz /dt  = xy -beta z;

// choose soundchain; blit, blitsaw etc
// for some reason if-statement setup bombs; "g undefined" etc

/*
Blit x => Gain g => Dyno d => Pan2 pan =>  dac;
Blit y =>  g  =>  d => pan => dac;
Blit z => g  =>  d => pan => dac;
6 => x.harmonics;
6 => y.harmonics;
6 => z.harmonics;
*/
/*
BlitSaw x => Gain g => Dyno d => Pan2 pan =>  dac;
BlitSaw y =>  g  =>  d => pan => dac;
BlitSaw z => g  =>  d => pan => dac;
6 => x.harmonics;
6 => y.harmonics;
6 => z.harmonics;
*/
BlitSquare x => Gain g => Dyno d => Pan2 pan =>  dac;
BlitSquare y =>  g  =>  d => pan => dac;
BlitSquare z => g  =>  d => pan => dac;
6 => x.harmonics;
6 => y.harmonics;
6 => z.harmonics;

g => Echo e => NRev rev => dac; // feedback loop for echo

0.2 => rev.mix;

//echo parameters
10::second => e.max;
1.3::second => e.delay;
0.5 => e.mix; 
e => e;
.9 => e.gain; //controls amount of echo feedback

0.002 => float baseGain => g.gain; // base gain for on/off gain

// lorenz parameters

10 => float sigma;
(8./3.) => float beta;
(28.) => float rho;

//define coordinates (can't apply lorenz equations directly to frequencies because #s too large)

1 => float xcoord;
1 => float ycoord;
1 => float zcoord;

0.01 => float t;

220.=> float baseFreq;
1. => float freqMult; //multiplier for frequencies

.0 => float panDelta; //how much to change pan on each iteration
0 => pan.pan; // initial state

now + 8000::hour => time end;

while (now < end)
{
    // apply lorenz equations to coordinates
    xcoord + t*(sigma*(ycoord - xcoord)) => xcoord;
    ycoord + t*(xcoord*(rho - zcoord) - ycoord) => ycoord;
    zcoord + t*(xcoord*ycoord - beta*zcoord) => zcoord;
    <<< xcoord, ycoord, zcoord >>>;
    // then add coordinates*freqMult to base frequency 
    baseFreq+freqMult*xcoord => x.freq;
    baseFreq+freqMult*ycoord => y.freq;
    baseFreq+freqMult*zcoord => z.freq;
    baseGain => g.gain;
  // on/off switching
  // try varying length of sound vs silence
    1::samp => now;

     baseGain/1.5 => g.gain; 
     
     if (pan.pan() >= 1. || pan.pan() <= -1.) -1*=>panDelta; // panning
     pan.pan() + panDelta => pan.pan;
     
     //random harmonics
     Std.rand2(1,6) => x.harmonics;
     Std.rand2(1,6) => y.harmonics;
     Std.rand2(1,6) => z.harmonics;
     
     // put this in terms of samples (say 50, 100, 1000 samples) for industrial sounds
    .1::second => now;
    
}
    
    
