// 
36 => int midiBase; //base note; 12 or 24 is intense with sax and bowed; 36+ more musical
[0,2,4,5,7, 9, 11, 12] @=> int degrees[]; // scale degrees
//[0,4,4,7,7, 12, 12, 12] @=> int degrees[]; // scale degrees
[57,59,61,62,64,66,68,69] @=> int scale[]; //placeholder for scale

.9 => float octaveProb; // probability of an octave added/subtracted

for (0 => int i; i < scale.cap(); i++) {
	midiBase+degrees[i] => scale[i];
	<<< " i, scale", i, scale[i] >>>;
}

60./120.*2 => float beatsec;

beatsec::second => dur beat;

[beat/16, beat/8,beat/4, beat/6, beat/2, beat*2/3, beat*3/4, beat*1.5] @=> dur durations[];
[0, 1, -1, 2, -2] @=> int deltas[]; // delta to index number for scale/time vector
[.5,.65,.8,.9,1] @=> float probs[]; // associated cumulative probs

Saxofony sax => Echo echo => PRCRev rev => Dyno dyn => Gain master => Pan2 pan1 => dac;
Bowed bar1 => echo => rev => dyn => master => Pan2 pan2 => dac;

.3 => bar1.gain;
.025 => sax.gain;
.9 => master.gain;

.3 => pan1.pan;
-.3 => pan2.pan;

10*beat => echo.max;
1.5*beat => echo.delay;
.3 => echo.gain;
.2 => echo.mix;
echo => echo;

.5 => rev.mix;

fun void player1 (int notes[], int times[]) {
		
	for (0 => int i; i < notes.cap(); i++) {
		Std.mtof(scale[notes[i]]) => bar1.freq;
		if (Std.rand2f(0,1) > 1-octaveProb) Std.mtof(scale[notes[i]]+Std.rand2(-1,1)*12) => bar1.freq;
		1 => bar1.noteOn;
		durations[times[i]] => now;
		1 => bar1.noteOff;
		
	}
}

fun void player2 (int notes[], int times[]) {	
	
	for (0 => int i; i < notes.cap(); i++) {
		Std.mtof(scale[notes[i]]) => sax.freq;
		if (Std.rand2f(0,1) > 1-octaveProb) Std.mtof(scale[notes[i]]+Std.rand2(-1,1)*12) => sax.freq;
		1 => sax.noteOn;
		durations[times[i]] => now;
		1 => sax.noteOff;
	}
}

fun int pdraw (float probs[], int x[]) {
	// given cumulative probabilities return random draw from x
	// probabilities arranged lowest to highest
	Std.rand2f(0,1) => float z;
	if (z < probs[0] ) return 0;
	for (1=> int i; i < x.cap(); i++) {
		if (z < probs[i]) return i;
	}
} 

fun void shuffle (int notes[], int times[]) {
	for (0 => int i; i<notes.cap(); i++){
		
		notes[i]+pdraw(probs,deltas)=>notes[i];
		if (notes[i] > scale.cap()-1 || notes[i] < 0) Std.rand2(0,scale.cap()-1) => notes[i];
	    times[i]+pdraw(probs,deltas)=>times[i];
		if (times[i] > durations.cap()-1 || times[i] < 0) Std.rand2(0,durations.cap()-1) => times[i];
	  
	}
}
	
	

[0,2,5,3,6,7] @=> int notes[];

for (0 => int i; i < notes.cap(); i++) {
	if (notes[i]>scale.cap()-1) {
		<<< " notes initial out of range" >>>;
		me.exit();
	}
}
[0,1,6,2,3,4] @=> int times[];

for (0 => int i; i < times.cap(); i++) {
	if (times[i]>durations.cap()-1) {
		<<< " times initial out of range" >>>;
		me.exit();
	}
}



player1(notes,times);
player2(notes,times);

while (true) {
	
shuffle(notes,times);
player1(notes,times);

shuffle(notes,times);
player2(notes,times);

}


1000::second => now;