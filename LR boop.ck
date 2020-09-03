
1 => float gainSet;

Impulse imp => BPF filt => Gain gain => Dyno dyn => dac;
gain => Echo echoL => Dyno dynL => dac.left;
echoL => Echo echoR => Dyno dynR => dac.right;

gainSet => gain.gain;

220*1.5/3*1.5*1.5 => filt.freq;
100 => filt.Q;

.25::second => dur beat;

4*beat => echoL.max => echoR.max;
1.5*beat => echoL.delay;
1.75*beat => echoR.delay;
.75 => echoL.gain => echoR.gain;
1 => echoL.mix => echoR.mix;

while (true) {
    10 => imp.next;
    Std.rand2(1,6)*beat => now;
}
    