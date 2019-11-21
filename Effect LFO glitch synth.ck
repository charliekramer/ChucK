SinOsc sin => blackhole;
Impulse imp => Echo echo1 => Pan2 pan1 => dac;
echo1 => Echo echo2 => Pan2 pan2 => dac;

1. => pan1.pan;
-1*pan1.pan() => pan2.pan;

1.*(1.) => float multiplier;

.5 => imp.gain;
30::second => dur duration;

.7*1::second*multiplier => dur beat;

5*beat => echo1.max;
1.5*beat => echo1.delay;
.7 => echo1.gain;
.7 => echo1.mix;
echo1 => echo1;

5*beat => echo2.max;
2.2*beat => echo2.delay;
.7 => echo2.gain;
.7 => echo2.mix;
echo2 => echo2;

55*multiplier => sin.freq;

SinOsc cut1 => TriOsc cutoff => blackhole;

SinOsc LFO => blackhole;

.2*3/Math.sqrt(multiplier) => LFO.freq;
1*.5/Math.sqrt(multiplier) => cut1.freq;
.2*.3/Math.sqrt(multiplier) => cutoff.freq;

now + duration => time future;

while (now < future) {
    1::samp => now;
    if (sin.last() > cutoff.last() || sin.last() < -cutoff.last()) {
        1 => imp.next;
    }
    3+2.9*LFO.last() => cut1.freq;
}
<<< " effect LFO glitch ending " >>>;
10::second => now;