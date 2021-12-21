.1*1 => float gainSet;
7 => int n;
.1*1 => float rateMin;
.5*1 => float rateMax;
.9 => float revMix;
.9 => float echoGain;
.9 => float echoMix;
120./4*2 => float BPM;
(60./BPM)::second*.25 => dur beat;
20::second => dur length;
1.5 => float beatDiv; // for echo

beat - (now % beat) => now;

SndBuf snare[n];
Pan2 pan[n];
NRev rev[n];
Echo echo[n];

"/Users/charleskramer/Desktop/chuck/audio/ElectricSnareDrum.wav" => snare[0].read;
"/Users/charleskramer/Desktop/chuck/audio/snare3.wav" => snare[1].read;
"/Users/charleskramer/Desktop/chuck/audio/snlong.wav" => snare[2].read;
"/Users/charleskramer/Desktop/chuck/audio/SD5075.WAV" => snare[3].read;
"/Users/charleskramer/Desktop/chuck/audio/SD1075.WAV" => snare[4].read;
"/Users/charleskramer/Desktop/chuck/audio/rim2cntr.wav" => snare[5].read;
"/Users/charleskramer/Desktop/chuck/audio/SCI_SNARE.wav" => snare[6].read;


for (0 => int i; i < n; i++) {
    snare[i] => echo[i] => pan[i] =>  dac;
    Std.rand2f(-1,1) => pan[i].pan;
    0 => snare[i].loop;
    snare[i].samples() => snare[i].pos;
    gainSet => snare[i].gain;
    4*beat => echo[i].max;
    beatDiv*beat => echo[i].delay;
    echoGain => echo[i].gain;
    echoMix => echo[i].mix;
    echo[i] => echo[i];
    revMix => rev[i].mix;
}

now + length => time future;

while (now < future) {
    
    Std.rand2(1,n) => int nSnare;
    for (0 => int i; i < nSnare; i++) {
        Std.rand2(0,n-1) => int k;
        Std.rand2f(rateMin, rateMax) => snare[k].rate;
        0 => snare[k].pos;
    }
    beat => now;
}

10::second => now;
