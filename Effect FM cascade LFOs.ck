

SinOsc s1 => SinOsc s2 => SinOsc s3 => SinOsc s4 => SinOsc s5 => Dyno dyn => NRev rev => dac;

.5 => rev.mix;

60 => s1.freq;
70 => s2.freq;
80 => s3.freq;
90 => s4.freq;


.03 => s5.gain;

SinOsc LFO1 => blackhole;
SinOsc LFO2 => blackhole;
SinOsc LFO3 => blackhole;
SinOsc LFO4 => blackhole;

.01 => LFO1.freq;
.02 => LFO2.freq;
.03 => LFO3.freq;
.04 => LFO4.freq;

SinOsc coeff1 => blackhole;
SinOsc coeff2 => blackhole;
SinOsc coeff3 => blackhole;
SinOsc coeff4 => blackhole;

.015*10 => coeff1.freq;
.025*10 => coeff2.freq;
.035*10 => coeff2.freq;
.005*10 => coeff2.freq;

1 => int LFOCoeffs;
float C1, C2, C3, C4;
2700*.1 => float masterCoeff;

now + 5::minute => time future;

while (now < future) {
    
    
    if (LFOCoeffs == 1) {
        (1+coeff1.last())*masterCoeff => C1;
        (1+coeff2.last())*masterCoeff => C2;
        (1+coeff3.last())*masterCoeff => C3;
        (1+coeff4.last())*masterCoeff => C4;
    }
    else {
        masterCoeff => C1;
        masterCoeff => C2;
        masterCoeff => C3;
        masterCoeff => C4;
    }
    
    (1+LFO1.last())*C1 => s1.gain;
    (1+LFO2.last())*C2 => s2.gain;
    (1+LFO3.last())*C3 => s3.gain;
    (1+LFO4.last())*C4 => s4.gain;
    1::samp => now;
}

30::second => dur fadeTime;

now + fadeTime =>  future;

<<< "fadeout" >>>;

while (now < future) {
    
    fadeTime/100. => now;
    s5.gain()*.9 => s5.gain;
    rev.mix()+.01=> rev.mix;
    (1+LFO1.last())*C1 => s1.gain;
    (1+LFO2.last())*C2 => s2.gain;
    (1+LFO3.last())*C3 => s3.gain;
    (1+LFO4.last())*C4 => s4.gain;
    
    
}
    