
10 => float gainSet;

100::second => dur length;


Impulse imp1 => Gain gain1 => Gain masterL => dac.left;
Impulse imp2 => Gain gain2 => masterL => dac.left;
Impulse imp3 => Gain gain3 => masterL => dac.left;

gain1 => BPF filt1 => Echo echoR => dac.right;
gain2 => BPF filt2 =>  echoR => dac.right;
gain3 => BPF filt3 => echoR => dac.right;

SinOsc rateLFO => blackhole;
.01 => rateLFO.freq;

gainSet => gain1.gain => gain2.gain => gain3.gain;

220*1/2*1.5*1.5*1.5 => filt1.freq;
filt1.freq()*1.33 => filt2.freq;
filt1.freq()*1.5 => filt3.freq;
100 => filt1.Q => filt2.Q => filt3.Q => float QTarget;

.25::second*.125 => dur beat;

40*beat => echoR.max;
17.5*beat => echoR.delay;
.75 => echoR.gain;
1 => echoR.mix;

now + length => time future;

now/1::second => float n0w;
future/1::second => float th3n;

QTarget => float a;
(1-QTarget)/(th3n - n0w) => float b;


while (now < future) {
    a + b*(th3n - now/1::second) => filt1.Q => filt2.Q => filt3.Q;
    for (0 => int i; i < Std.rand2(0,5); i++) { 
        Std.rand2f(0,10) => imp1.next;
        Std.rand2f(0,10) => imp2.next;
        Std.rand2f(0,10) => imp3.next;
        1*Std.rand2f((1+rateLFO.last()+.1)*20/2,(1+rateLFO.last()+.1)*20)*beat => now;
    }
    1*Std.rand2(0,6)*beat => now;
}

0 => masterL.gain;

echoR => echoR;
echoR => Echo echoL => dac.left;
40*beat => echoL.max;
17.5*beat/2 => echoL.delay;
.75 => echoL.gain;
1 => echoL.mix;

now + length => future;

while (now < future) {
    for (0 => int i; i < 3; i++) { 
        Std.rand2f(0,1) => float choose;
        .3 => float cutoff;
        if (choose < cutoff) Std.rand2f(0,10) => imp1.next;
        else if (choose < 2*cutoff) Std.rand2f(0,10) => imp2.next;
        else Std.rand2f(0,10) => imp3.next;
        8*beat => now;
    }
    1*beat => now;
}

10::second => now;
  
   