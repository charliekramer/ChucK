.2 => float gainSet;

120 => float BPM;

5::minute => dur length;

(60./BPM)::second => dur beat;

SndBuf2 buf => PitShift pitch => Dyno dyn => Gain gain;

gainSet => buf.gain;

1 => buf.loop;

1 => pitch.mix;
1. => pitch.shift; // .1 good for FB solo, .33 good for EF

.1 => float delayLrate;
.11 => float delayRrate;
.12 => float mixLrate;
.13 => float mixRrate;

.4 => float LFOgains;

beat*1.5 => dur baseDelay;
.5 => float baseGain;
.3 => float baseMix;

gain => Echo echoL => dac.left;
gain => Echo echoR => dac.right;

2*baseDelay => echoL.max => echoR.max;
baseDelay => echoL.delay => echoR.delay;
baseGain => echoL.gain => echoR.gain;
baseMix => echoL.mix => echoR.mix;
echoL => echoL;
echoR => echoR;


"/Users/charleskramer/Desktop/chuck/audio/50 Best Free Drum Loops/" => string path;

[
"Aggresor Hats_150bpm.wav",
"BanginSlowStorm Drum loop_124bpm.wav",
"Breakbeat-8Bar_134bpm.wav",
"Broken Ankle-4Bar_87bpm.wav",
"COY_Satoshi_drums_hihats_105bpm.wav",
"COY_Satoshi_drums_toploop_105bpm.wav",
"Die Slow drums_80bpm.wav",
"Dive Break_88bpm.wav",
"Drum Break Loop_144bpm.wav",
"Drum_170bpm.wav",
"Drum_71bpm.wav",
"Drums Soca No Hat_97bpm.wav",
"Dub Drums_97bpm.wav",
"Ed HiHat1 Loop_130 BPM.wav",
"Feel_me_more_100bpm.wav",
"Feel_me_with_a_twist_100bpm.wav",
"GHOST TOP OPEN_110bpm.wav",
"HH FUNKY LITE_102bpm.wav",
"HH TOP_156bpm.wav",
"Haviitz_Get_Out_DrumRimShotStraight_4bar_84bpm.wav",
"Haviitz_SixFeet_Drum_4bar_16th note_87bpm.wav",
"Haviitz_SixFeet_Drum_6bar_8th note_87bpm.wav",
"Industry Hats_85bpm.wav",
"KickLoop_150bpm.wav",
"Kick_85bpm.wav",
"Loop LD Caroline Groove_123bpm.wav",
"MoonRising_Drums02_84bpm.wav",
"Pulse drums_86bpm.wav",
"Run Down drums_94bpm.wav",
"Shroom LANDR Break02_75bpm.wav",
"Shroom LANDR Break03_70bpm.wav",
"Shroom LANDR Break05_82bpm.wav",
"Shroom LANDR Break08_94bpm.wav",
"Shroom LANDR Break09_100bpm.wav",
"Shroom LANDR Break13_100bpm.wav",
"Shroom LANDR Break18_105bpm.wav",
"SnareClap.wav",
"Stay On Point drums_87bpm.wav",
"The Moments Drums_112bpm.wav",
"TopLoop 2-4Bar_125bpm.wav",
"Wild Hats_155bpm.wav",
"drumbeat2_90bpm.wav",
"drumbeat_100bpm.wav",
"drumbeat_70bpm.wav",
"drumbeat_80bpm.wav",
"drumbeat_90bpm.wav",
"drumloop_124bpm.wav",
"drums nosie_109bpm.wav",
"drums toms wet_109bpm.wav",
"drums_109bpm.wav"
] @=> string files[];
[
150,
124,
134,
87,
105,
105,
80,
88,
144,
170,
71,
97,
97,
130,
100,
100,
110,
102,
156,
84,
87,
87,
85,
150,
85,
123,
84,
86,
94,
75,
70,
82,
94,
100,
100,
105,
137,
87,
112,
125,
155,
90,
100,
70,
80,
90,
124,
109,
109,
109
] @=> int fileBPM[];

<<< fileBPM.cap(),files.cap() >>>;

spork~echoLFOs(delayLrate,delayRrate,mixLrate,mixRrate);

now + length => time future;

while (now < future) {
    
    Std.rand2(0,files.cap()-1) => int i;
    
    path+files[i] => buf.read;
    
    BPM/fileBPM[i] => buf.rate;
    
    <<< "file i", i>>>;
    
    Std.rand2(0,1) => int x;
    
    (x*Std.rand2(1,8)+(1.-x)/Std.rand2(1,2))*beat => now;   
    
}



fun void echoLFOs (float delayLrate,float delayRrate, float mixLRate, float mixRRate) {
    
    SinOsc LFOdelayL => blackhole;
    SinOsc LFOdelayR => blackhole;   
    SinOsc LFOmixL => blackhole;
    SinOsc LFOmixR => blackhole;
    
    LFOgains => LFOdelayL.gain => LFOdelayR.gain => LFOmixL.gain => LFOmixR.gain;
    delayLrate => LFOdelayL.freq;
    delayRrate => LFOdelayR.freq;
    mixLRate => LFOmixL.freq;
    mixRRate => LFOmixR.freq;
    
    while (true) {
        
        (1+LFOdelayL.last())*baseDelay => echoL.delay;    
        (1+LFOdelayR.last())*baseDelay => echoR.delay;
        (1+LFOmixL.last())*baseMix => echoL.mix;
        (1+LFOmixR.last())*baseMix => echoR.mix;
        
        1::samp => now;   
    }
    
    
    
    }