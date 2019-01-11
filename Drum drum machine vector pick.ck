//drums drum machine vector pick
// pick drum sounds at random
// play for random length but with the constraint that beats add up to a measure
// slightly randomize gain and pitch

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

60./120*.5 => float beatsec; // .5 multiplier seems to work well
beatsec::second => dur beat;

beat - (now % beat) => now;

   0 => int totalBeats;
   0 => int beatsNow;
   4 => int maxBeats; // 4 seems to work well

for (0 => int i; i < sv.cap(); i++) {
	sv[i] => echo[i] => rev[i] => gain[i]=> dac;
	.9 => gain[i].gain;
	.1 => rev[i].mix;
	.3 => echo[i].mix;
	.4 => echo[i].gain;
	10::second => echo[i].max;
	1.5*beat => echo[i].delay;
	echo[i] => echo[i];
	sv[i].samples() => sv[i].pos;
}


while (true) {
	Std.rand2(0,nDrum) => int j;
	0 => sv[j].pos;
	Std.rand2f(.5,2) => sv[j].rate;
    Std.rand2f(.8,1.2) => sv[j].gain;
	Std.rand2(1,maxBeats-totalBeats) => beatsNow;
	beatsNow*beat => now;
	beatsNow+totalBeats => totalBeats;
	<<< "beatsNow, totalBeats", beatsNow, totalBeats >>>;
	if (totalBeats == maxBeats) 0 => totalBeats;
}

/*
while (true) {
	0 => sv[Std.rand2(0,3)].pos;
	beat => now;
}
*/