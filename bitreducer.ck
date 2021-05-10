
SndBuf2 buf => blackhole;

Impulse imp => PitShift pitch => Dyno dyn => dac;

"/Users/charleskramer/Documents/FB_solo.wav" => buf.read;
//"/Users/charleskramer/Documents/twotef.wav" => buf.read;

1 => buf.loop;

.9*4 => buf.rate; ///.9.,2*.9 good for FB solo, .7 for EF

1 => pitch.mix;
.1 => pitch.shift; // .1 good for FB solo, .33 good for EF

2*2 => int nsamp; // higher more crunch

2 => int crush; //4 or 5 good crunch; lower more crunch


<<< bitReducer(.12345,1,1) >>>;

while (true) {
    
    bitReducer(buf.last(),crush,crush) => imp.next;
    
    //buf.last() => imp.next;
    nsamp::samp => now;
    
    
}










fun float bitReducer(float in, int times, int div) {
    
    1.0*Std.ftoi(in*Math.pow(2,times))/Math.pow(2,div) => in;
    
    return in;  
    
    }