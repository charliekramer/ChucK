// receives OSC signals from PixelateOscForHexagridVideo
SndBuf osc0 => Gain gain0 => PitShift pitch0 => Echo echo0 => NRev rev0 => Pan2 pan0 => dac;
SndBuf osc1 => Gain gain1 => PitShift pitch1 => Echo echo1 => NRev rev1 => Pan2 pan1 => dac;
SndBuf osc2 => Gain gain2 => PitShift pitch2 => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;
SndBuf osc3 => Gain gain3 => PitShift pitch3 => Echo echo3 => NRev rev3 => Pan2 pan3 => dac;

1 => float gainSet;

"/Users/charleskramer/Desktop/chuck/audio/AlienPrayer-JeremyGluckandBelindaGolding.wav" => osc0.read;
//"/Users/charleskramer/Desktop/chuck/audio/TheBenefactor-BelindaGolding.wav" => osc1.read;
//"/Users/charleskramer/Desktop/chuck/audio/TheBenefactor-JeremyGluck.wav" => osc2.read;
//"/Users/charleskramer/Desktop/chuck/audio/TheBenefactor-JeremyGluckandBelindaGolding.wav" => osc3.read;
"/Users/charleskramer/Desktop/chuck/audio/BenefactorBSynch.wav" => osc1.read;
"/Users/charleskramer/Desktop/chuck/audio/BenefactorJSynch.wav" => osc2.read;
"/Users/charleskramer/Desktop/chuck/audio/BenefactorJ&BSynch.wav" => osc3.read;


0 => osc0.loop => osc1.loop => osc2.loop => osc3.loop;

gainSet => gain0.gain; //NW
gainSet => gain1.gain; //NE
gainSet => gain2.gain; //SW
gainSet => gain3.gain; //SE

20=> float oscSpeed;
1./20 => float oscPitch;

oscPitch => pitch0.shift => pitch1.shift => pitch2.shift => pitch3.shift ;
oscSpeed => osc0.rate => osc1.rate => osc2.rate => osc3.rate; 
1 => pitch0.mix => pitch1.mix => pitch2.mix => pitch3.mix;

// the patch

0 => rev0.mix => rev1.mix => rev2.mix => rev3.mix;

-1*0 => pan0.pan;
1*0 => pan1.pan;
-1*0 => pan2.pan;
1*0 => pan3.pan;

.3 => float echoGain;
.1*0 => float echoMix;

1.55::second => echo0.max => echo0.delay;
echoMix => echo0.mix; 
echoGain => echo0.gain;
echo0 => echo0;
1.5::second => echo1.max => echo1.delay;
echoMix => echo1.mix; 
echoGain => echo1.gain;
echo1 => echo1;
1.45::second => echo2.max => echo2.delay;
echoMix => echo2.mix; 
echoGain => echo2.gain;
echo2 => echo2;
1.65::second => echo3.max => echo3.delay;
echoMix => echo3.mix; 
echoGain => echo3.gain;
echo3 => echo3;
// load the file
// don't play yet

0 => osc0.pos;

osc1.samples() => osc1.pos;
osc2.samples() => osc2.pos;
osc3.samples() => osc3.pos;


20::second => dur length;

now + length => time future;


while (now < future) {
    1::samp => now;
}

<<< "osc0 done">>>;

now + length => future;
0 => osc1.pos;

while (now < future) {
    1::samp => now;
}

<<< "osc1 done">>>;


0 => osc2.pos;
now + length => future;

while (now < future) {
    1::samp => now;
}

<<< "osc2 done">>>;



0 => osc3.pos;

now + length => future;
while (now < future) {
    1::samp => now;
}

<<< "osc3 done">>>;