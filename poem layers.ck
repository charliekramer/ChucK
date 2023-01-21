12 => int n; //up to 16
10*2*.7/(1.*n) => float gainSet;

SndBuf2 poem[n];
PitShift pitch[n];
NRev rev[n];
HPF filt[n];
Pan2 pan[n];

.995 => float rateM; //.995

1 => int pitchShift; // use pitchshift coeff to shift pitch

1/rateM => float pitchShiftCoeff;

for (0 => int i; i < n; i++) {
    
    gainSet => poem[i].gain;
    poem[i] => pitch[i] => filt[i] => rev[i] => pan[i] =>  dac;
    if (i%2 == 0) "/Users/charleskramer/Desktop/chuck/audio/secrest_poem_1.wav" => poem[i].read;
    else "/Users/charleskramer/Desktop/chuck/audio/secrest_poem_2.wav" => poem[i].read;
    //"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano_edit.wav"=> poem[i].read; 
   
    //"/Users/charleskramer/Desktop/chuck/audio/steve_MoFo.wav"=> poem[i].read; 
   //"/Users/charleskramer/Desktop/chuck/audio/2hearts_v3_heavy.wav" => poem[i].read;
   //"/Users/charleskramer/Desktop/chuck/audio/01_Red_Dress_vocal_splitted_by_lalalai.wav" => poem[i].read;
    Math.pow(rateM,i) => poem[i].rate;
    if (pitchShift == 1) {
        Math.pow(pitchShiftCoeff,i) => pitch[i].shift;
    }
    1 => pitch[i].mix;
    0 => poem[i].pos;
    1 => poem[i].loop;
    
    if (n > 1) -1. +  (i % n)*(.1*n+1.)/(1.*n) => pan[i].pan;
  
    
    .2 => rev[i].mix;
    
    Std.mtof(20) => filt[i].freq; //90?
    
    }
    
3.5::minute => now;