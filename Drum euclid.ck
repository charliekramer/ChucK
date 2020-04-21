// https://medium.com/code-music-noise/euclidean-rhythms-391d879494df

.5 => float masterGain;

5 => int pulses;
3 => int onsets;


SndBuf2 sv[10]; // sound vector
NRev rev[10];
Echo echo [10];
Gain gain[10];

"/Users/charleskramer/Desktop/chuck/audio/kick_01.wav" => sv[0].read;
"/Users/charleskramer/Desktop/chuck/audio/snare_01.wav" => sv[1].read;
"/Users/charleskramer/Desktop/chuck/audio/hihat_01.wav" => sv[2].read;
"/Users/charleskramer/Desktop/chuck/audio/kick_02.wav" => sv[3].read;
"/Users/charleskramer/Desktop/chuck/audio/kick_03.wav" => sv[4].read;
"/Users/charleskramer/Desktop/chuck/audio/kick_04.wav" => sv[5].read;
"/Users/charleskramer/Desktop/chuck/audio/snare_02.wav" => sv[6].read;
"/Users/charleskramer/Desktop/chuck/audio/snare_03.wav" => sv[7].read;
"/Users/charleskramer/Desktop/chuck/audio/hihat_02.wav" => sv[8].read;
"/Users/charleskramer/Desktop/chuck/audio/hihat_04.wav" => sv[9].read;

sv.cap()-1 => int nDrum; // how big a drum set to use; this is the whole set
//4 => nDrum; // this is a more basic set, use for a more standard beat

60./94*.5 => float beatsec; // .5 multiplier seems to work well
beatsec::second => dur beat;

beat - (now % beat) => now;

for (0 => int i; i < sv.cap(); i++) {
    sv[i] => echo[i] => rev[i] => gain[i]=> dac;
    masterGain => gain[i].gain;
    .1 => rev[i].mix;
    .3 => echo[i].mix;
    .4 => echo[i].gain;
    10::second => echo[i].max;
    1.5*beat => echo[i].delay;
    echo[i] => echo[i];
    sv[i].samples() => sv[i].pos;
}


int beats[pulses];

onsets*1./(pulses*1.) => float slope;

1 => int current => int previous;

<<< pulses, onsets, slope >>>;

for (0 => int i; i < pulses; i++) {
    Math.floor(i*1.*slope) $ int => current;
    if (current != previous) 1 => beats[i];
    else 0 => beats[i];
    current => previous;
}
    
0 => int j;

40 => int k1;
31 => int k2; // fire new bass if j % k1 > k2;


    
while (true) {
    for (0 => int i; i < pulses; i++) {
        if (beats[i] == 1) {
            Std.rand2f(.5,2) => sv[1].rate;
            Std.rand2f(.7,1.5) => sv[1].gain;
            0 => sv[1].pos;
        }
        else {
            Std.rand2f(.5,2) => sv[0].rate;
            Std.rand2f(.7,1.5) => sv[0].gain;
            0 => sv[0].pos;  
        }
        
        Std.rand2f(.5,2) => sv[8].rate;
        Std.rand2f(.3,.5) => sv[8].gain;
        0 => sv[8].pos;
        
        if (j % k1 > k2) {
            Std.rand2f(2,4) => sv[3].rate;
            0 => sv[3].pos;
            <<< "roll" >>>;
        }
        
        beat => now;
        
        j++;
   }
}

//1001010100101010