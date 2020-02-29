Impulse imp => BPF filt => Echo echo1 => Gain gain1 => Dyno dyn1 => Pan2 pan2 =>dac;
gain1 => Echo echo2 => Dyno dyn2 => dac;
gain1 => Echo echo3 => Dyno dyn3 => Pan2 pan3 => dac;
echo2 => Gain fback32 => echo3;
echo2 => Gain fback21 => echo1;
echo3 => Gain fback31 => echo1;

1 => fback32.gain;
1 => fback21.gain;
.01 => fback31.gain;

5 => dyn1.gain => dyn2.gain => dyn3.gain;

1 => gain1.gain;

-1 => pan2.pan;
1 => pan3.pan;

.5::second => dur beat;// freaks out for very small e.g. .1 second when there is feedback

10*beat => echo1.max;
1.5*beat => echo1.delay;
.9 => echo1.gain;
.5 => echo1.mix;


10*beat => echo2.max;
.3*beat => echo2.delay;
.9 => echo2.gain;
.5 => echo2.mix;


10*beat => echo2.max;
2.25*beat => echo2.delay;
.9 => echo2.gain;
.5 => echo2.mix;

50 => imp.gain;
440 => filt.freq;
200 => filt.Q;

now + 1::minute => time future;

while (now < future) {
    Std.rand2f(22,440) => filt.freq;
    1 => imp.next;
    Std.rand2f(.1,9)*beat => echo1.delay;
    Std.rand2f(.1,9)*beat => echo2.delay;
    Std.rand2f(.1,9)*beat => echo3.delay;
    10*beat => now;
}

10*beat => now;
