//based on drums drum machine vector pick

SndBuf2 sv[3]; // sound vector
NRev rev[3];
Echo echo [3];
Gain gain[3];

.3 => float gainSet;

"/Users/charleskramer/Desktop/chuck/audio/scream.wav" => sv[0].read;
"/Users/charleskramer/Desktop/chuck/audio/scream_bass.wav" => sv[1].read;
"/Users/charleskramer/Desktop/chuck/audio/scream_chatter.wav" => sv[2].read;


sv.cap()-1 => int nDrum; // how big a drum set to use; this is the whole set


60./94*.5 => float beatsec; // .5 multiplier seems to work well
beatsec::second => dur beat;

beat - (now % beat) => now;

   0 => int totalBeats;
   0 => int beatsNow;
   4 => int maxBeats; // 4 seems to work well

for (0 => int i; i < sv.cap(); i++) {
	sv[i] => echo[i] => rev[i] => gain[i]=> dac;
	1 => sv[i].loop;
	gainSet => gain[i].gain;
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
//	Std.rand2f(-1,1.2) => sv[j].rate; //glitchy
    Std.rand2(1,4)*.5 => sv[j].rate; // kind of musical
    Std.rand2f(.8,1.2) => sv[j].gain;
	Std.rand2(1,maxBeats-totalBeats) => beatsNow;
	beatsNow*beat => now;
	beatsNow+totalBeats => totalBeats;
	<<< "beatsNow, totalBeats", beatsNow, totalBeats >>>;
	if (totalBeats == maxBeats) 0 => totalBeats;
	sv[j].samples()=>sv[j].pos; // stops current sample before next starts
}

