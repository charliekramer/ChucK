
SndBuf2 buf => PitShift pitch => NRev rev => Echo echo => dac;

"/Users/charleskramer/Desktop/chuck/audio/kitchen_1.wav" => buf.read;

4 => float k;


0 => buf.pos;
1 => buf.loop;

1/Math.pow(k,1) => pitch.shift;
k => buf.rate;

while (true) {
    1::samp => now;
    
}