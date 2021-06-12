.01*.01*2 => float gainSet;
// 23 forindividual drums
// 10 for full mixes
SndBuf2 dnb[10];
PitShift pitch;
1. => pitch.mix;
1. => pitch.shift;
Gain gain;
Echo echo;
NRev rev;

.2 => rev.mix;

90. => float loopSpeed;
90.*1 => float BPM;
60./BPM => float beatSec;
beatSec::second => dur beat;

2*beat => echo.max;
1.5*beat*2 => echo.delay;
.5 => echo.mix;
.5 => echo.gain;
echo => echo;

/*
//individual drums
[
"TA_DrumA-90-01.wav",
"TA_DrumA-90-02.wav",
"TA_DrumA-90-03.wav",
"TA_DrumA-90-04.wav",
"TA_DrumA-90-05.wav",
"TA_DrumA-90-06.wav",
"TA_DrumA-90-07.wav",
"TA_DrumA-90-08.wav",
"TA_DrumA-90-09.wav",
"TA_DrumA-90-10.wav"
] @=> string files[];

"/Users/charleskramer/Desktop/musicradar-tribal-adventures-samples/90bpm/Individual Drums/" => string name;
string filename;

*/

// full mixes

[
"TA_DrumMix-90-01.wav",
"TA_DrumMix-90-02.wav",
"TA_DrumMix-90-03.wav",
"TA_DrumMix-90-04.wav",
"TA_DrumMix-90-05.wav",
"TA_DrumMix-90-06.wav",
"TA_DrumMix-90-07.wav",
"TA_DrumMix-90-08.wav",
"TA_DrumMix-90-09.wav",
"TA_DrumMix-90-010.wav"
] @=> string files[];
"/Users/charleskramer/Desktop/musicradar-tribal-adventures-samples/90bpm/Drum Mixes Full/" => string name;


gainSet => gain.gain;



beat - (now % beat) => now;

BPM/loopSpeed => float bufRate; 




for (0 => int i; i < dnb.cap(); i++) {
    name + files[i] => dnb[i].read;
    bufRate => dnb[i].rate;
    dnb[i] => pitch => echo => rev => gain => dac;
    dnb[i].samples() => dnb[i].pos;
    0 => dnb[i].loop;
    
}
/*
for (0 => int i; i < dnb.cap(); i++) {
    0 => dnb[i].pos;
    <<< "sample ",i>>>;
    16*beat => now;  
}
*/

int nBeats,nBreaks;

while (true) {
    
    1*Std.rand2(1,8) => nBeats;
    Std.rand2(1,4) => nBreaks;
    <<< "nBeats, nBreaks", nBeats, nBreaks>>>;
    spork~drumBreak(nBeats,nBreaks);
    nBeats*beat => now;
}

fun void drumBreak(int beats, int breaks){
    
    for (0 => int i; i < breaks; i++) {
        0 => dnb[Std.rand2(0,dnb.cap()-1)].pos;
    }
    
    beats*beat => now;
}


