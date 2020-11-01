.1 => float gainSet;

.1::second => dur length;

10 => int n;

SinOsc SinLFOs[n];
TriOsc TriLFOs[n];
SqrOsc SqrLFOs[n];
SinOsc mixLFO[3];

.05*.5 => mixLFO[0].freq; // fast to creat grinding noise;
.07*.5 => mixLFO[1].freq;
.1*.5 => mixLFO[2].freq;

mixLFO[0] => blackhole;
mixLFO[1] => blackhole;
mixLFO[2] => blackhole;

0 => float freq;

Impulse osc => NRev rev => Pan2 pan => dac;
.05 => rev.mix;

Std.rand2f(-.5,.5) => pan.pan;

gainSet => osc.gain;

for (0 => int i; i < n; i++) {
    SinLFOs[i] => blackhole;
    TriLFOs[i] => blackhole;
    SqrLFOs[i] => blackhole;
    Std.rand2f(0,1.0*n)*200 => SinLFOs[i].freq;
    Std.rand2f(0,1.0*n)*200 => TriLFOs[i].freq;
    Std.rand2f(0,1.0*n)*200 => SqrLFOs[i].freq;
}

now + length => time future;

while (now < future) {
    
    for (0 => int i; i < n; i++) {
        (SinLFOs[i].last()*(1+mixLFO[0].last()) + TriLFOs[i].last()*(1+mixLFO[1].last()) + SqrLFOs[i].last()*(1+mixLFO[2].last()))/3. + freq => freq;
    }
    freq => osc.next;
    1::samp => now;
    0 => freq;
}

now + 5::second => future;

<<< "outro">>>;
while (now < future) {
    rev.mix() +.01*(1-rev.mix()) => rev.mix;
    1::ms => now;
    
}



    
    