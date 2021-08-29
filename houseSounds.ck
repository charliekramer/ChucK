
5::minute => dur length;
.2*10 => float gainSet;
4 => int n; // number of buffers
4 => int k; // number of repeats of n buffers
4 => int maxK;
8 => int minK; //draw from uniform distribution
2 => int minBeatDiv; // divide beat by rand (min, max)*.5
4 => int maxBeatDiv;
.1 => float minSpeed;
5 => float maxSpeed;
.1 => float minPitch;
4 => float maxPitch;

.25::second => dur beat => dur minBeat;

10::second => dur maxBeat;


beat - (now % beat) => now;

int bufPos[n];
SndBuf2 bufs[n];
PitShift pitch[n];
float rates[n];

NRev rev;
0 => rev.mix;

for (0 => int i; i < n; i++) {
    bufs[i] =>  rev => Dyno dyn => dac;
    0 => bufs[i].loop;
    1 => pitch[i].mix;
    gainSet => bufs[i].gain;
}


for (0 => int i; i < n; i++) {
    "/Users/charleskramer/Desktop/houseSounds/"+Std.rand2(1,24)+".wav" => bufs[i].read;
     Std.rand2(0,bufs[i].samples()-1) => bufPos[i];
}
spork~speed();
now + length => time future;
while (now < future) {
    Std.rand2(minK,maxK) => k;
    for (0 => int t; t < n; t++) {
        Std.rand2f(minPitch,maxPitch) => pitch[t].shift;  
        "/Users/charleskramer/Desktop/houseSounds/"+Std.rand2(1,24)+".wav" => bufs[t].read;
        Std.rand2f(minSpeed,maxSpeed) => rates[t] => bufs[t].rate;
        Std.rand2(0,bufs[t].samples()-1) => bufPos[t];
        }
    for (0 => int s; s < k; s++) {     
        for (0 => int i; i < n; i++) {
           for (0 => int j; j < n; j++) {
                bufs[j].samples()=>bufs[j].pos;
                bufPos[i] => bufs[i].pos;
            }
            //<<< "playing buffer #" , i>>>;
            beat/(Std.rand2(minBeatDiv,maxBeatDiv)) => now;
                
            }
    }
       <<< "maxSpeed", maxSpeed, "maxPitch," , maxPitch, "revmix", rev.mix(), "beatSec", beat/1::second >>>;
 
}

fun void speed() {
    
    (maxSpeed-minSpeed)/(length/1::samp) => float speedDelta;
    (maxBeat - minBeat)/(length) => float timeDelta;
    (maxPitch - minPitch)/(length/1::samp) => float pitchDelta;
    1/(length/1::samp) => float revDelta;
    
    now + length => time future;
    
    while (now < future) {
        maxSpeed-speedDelta => maxSpeed;
        maxPitch-pitchDelta => maxPitch;
        1::samp => now;
       // <<< "maxSpeed", maxSpeed >>>;
        beat + timeDelta::samp => beat;
        rev.mix() + revDelta => rev.mix;
    }
    
}
