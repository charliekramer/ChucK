// sample runs slower with bigger chunks granulated via dual envelopes

SndBuf buf => NRev rev => Envelope env1 => Envelope env2 => dac;
10 => buf.gain;
.5 => rev.mix;

"/Users/charleskramer/Desktop/chuck/audio/nixon_humiliate.wav" => buf.read;
//"/Users/charleskramer/Desktop/chuck/audio/hexagonJG.wav" => buf.read;
//"/Users/charleskramer/Desktop/chuck/audio/voicemail-31.wav" => buf.read;
"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => buf.read;


1 => buf.loop;
5 => float up;
.00003 => float rateDelta;

while (true) {
    Std.rand2(0,1) => env1.keyOn;
    Std.rand2(0,1) => env2.keyOn;
    Std.rand2f(1,up)::ms => now;
    buf.rate() - rateDelta => buf.rate;
    up + .001 => up;
}
    