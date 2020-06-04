
SndBuf buf => NRev rev => Envelope env1 => Envelope env2 => dac;
.1 => rev.mix;

"/Users/charleskramer/Desktop/chuck/audio/nixon_humiliate.wav" => buf.read;

1 => buf.loop;
1 => float up;

while (true) {
    Std.rand2(0,1) => env1.keyOn;
    Std.rand2(0,1) => env2.keyOn;
    Std.rand2f(1,up)::ms => now;
    buf.rate() - .00003 => buf.rate;
    up + .001 => up;
}
    