// lorenz system
// https://en.wikipedia.org/wiki/Lorenz_system
// dx / dt = sigma (y-x);
// dy / dt = x(rho - z) - y;
// dz /dt  = xy -beta z;

//soundchains

SinOsc x => Gain g => dac;
SinOsc y =>  g => dac;
SinOsc z =>  g => dac;

g => Echo e => NRev rev => dac;

3::second => e.delay;

0.5 => g.gain;

// parameters


10 => float sigma;
(8./3.) => float beta;
(28.) => float rho;



//define coordinates (can't apply lorenz equations to frequencies because #s too large)

1 => float xcoord;
1 => float ycoord;
1 => float zcoord;

0.01 => float t;

220 => float baseFreq;
1 => float freqMult; 

while (true)
{
    xcoord + t*(sigma*(ycoord - xcoord)) => xcoord;
    ycoord + t*(xcoord*(rho - zcoord) - ycoord) => ycoord;
    zcoord + t*(xcoord*ycoord - beta*zcoord) => zcoord;
    <<< xcoord, ycoord, zcoord >>>;
    baseFreq+freqMult*xcoord => x.freq;
    baseFreq+freqMult*ycoord => y.freq;
    baseFreq+freqMult*zcoord => z.freq;
    001::second => now;
}
    
    
