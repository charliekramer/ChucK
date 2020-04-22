// https://medium.com/code-music-noise/euclidean-rhythms-391d879494df

.5 => float masterGain;

11 => int pulses;
9 => int onsets;


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
    .2 => echo[i].mix;
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

spork~hat(2,.5, 1); // beatdiv, gain, random gain/rate
    
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
         
        //if (j % k1 > k2) {
        //    Std.rand2f(2,4) => sv[3].rate;
        //    0 => sv[3].pos;
        //    <<< "roll" >>>;
        //}
        
        if (Std.rand2f(0,1) > .9) spork~roll();
        
        beat => now;
        
        j++;
   }
}

fun void hat (float beatDiv, float gain, int random) {
    gain => sv[8].gain;
    [1., 1., 1., 1., 1., 1., 1., .5, 2., 3., 4.] @=> float divisors[];
    1 => float randDiv;
    while (true) {
        0 => sv[8].pos;
        if (random == 1) {
            Std.rand2f(.5,2) => sv[8].rate;
            Std.rand2f(gain*.7,gain/.7) => sv[8].gain;
            if(Std.rand2f(0,1) > .9) {
                divisors[Std.rand2(0, divisors.cap()-1)] => randDiv;
                <<< "hat" , randDiv>>>;
            }
        }
        1./(beatDiv*randDiv)*beat => now;
    }
}

fun void roll() {
    Std.rand2(1,8) => int beat1;
    Std.rand2(1,4) => int rate1;
    Std.rand2(1,8) => int beat2;
    Std.rand2(1,4) => int rate2;
    
    <<< "roll, beat 1" , beat1, "rate1", rate1, "beat2", beat2, "rate2", rate2 >>>;
   
    for (0 => int i; i< beat1; i++) {
        0 => sv[3].pos;
        Std.rand2f(.5,6) => sv[3].rate;
        beat/rate1 => now;
    }
    
    for (0 => int i; i< beat2; i++) {
        0 => sv[4].pos;
        Std.rand2f(.5,6) => sv[4].rate;
        beat/rate2 => now;
    }
}
        
        

//1001010100101010