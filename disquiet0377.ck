Rhodey rhodes    => NRev rev => Pan2 pan1 => dac;
BeeThree rhodes2 =>      rev => Pan2 pan2 => dac;
ModalBar rhodes3 =>      rev => Pan2 pan3 => dac;

.2 => rev.mix;

1 => rhodes3.preset;
2 => rhodes3.gain;
0 => rhodes3.damp;

-0.75 => pan1.pan;
 0.75 => pan2.pan;
 0.0 => pan3.pan;

0 => int notesOff; //1 = turn off notes after play; may want separate function
0 => int synch; // send synch code after bursts

44 => int midiBase;

[0,2,4,5,7,9,11,12] @=> int notes[];

60./120. => float beatSec;
beatSec::second => dur beat;

[.25*beat, .25*beat, .5*beat, .5*beat, beat, 2*beat, 2*beat, 4*beat] @=> dur beats[]; 

//play(notes,beats);

int notesCopy[notes.size()];
dur beatsCopy[beats.size()];

int notesNew[4];
int notesSave[4];
dur beatsNew[4];

0 => int j;


while (j< 4) {
	
	<<< " playing ", j++ >>>;

int notesCopy[notes.size()];
dur beatsCopy[beats.size()];

xCopy(notes, notesCopy);
dCopy(beats,beatsCopy);

fisherYatesPop (notesCopy, notesNew);
fisherYatesPopDur (beatsCopy, beatsNew);

xCopy(notesNew,notesSave);

<<< "new notes">>>; 
play(notesNew,beatsNew);

<<< "duo notes">>>; 
spork~play(notesNew,beatsNew);
spork~play2(notesCopy,beatsNew);
4*beat => now;
if (synch == 1) beat - (now % beat) => now;

<<< "duo notes2">>>;
noteRep(notesNew,notesCopy,1);
spork~play(notesNew,beatsNew);
spork~play2(notesCopy,beatsNew);
4*beat => now;
if (synch == 1) beat - (now % beat) => now;


<<< "duo notes3">>>;
noteRep(notesNew,notesCopy,3);
spork~play(notesNew,beatsNew);
spork~play2(notesCopy,beatsNew);
4*beat => now;
if (synch == 1) beat - (now % beat) => now;

<<< "duo notes4">>>;
noteRep(notesNew,notesCopy,0);
spork~play(notesNew,beatsNew);
spork~play2(notesCopy,beatsNew);
4*beat => now;
if (synch == 1) beat - (now % beat) => now;

<<< " original melody" >>>;
play(notesSave,beatsNew);
if (synch == 1) beat - (now % beat) => now;

<<< "trio notes">>>;
spork~play(notesNew,beatsNew);
spork~play2(notesCopy,beatsNew);
spork~play3(notesSave,beatsNew);
4*beat => now;
if (synch == 1) beat - (now % beat) => now;

}

4::second => now;
1 => rhodes.noteOff;
1 => rhodes2.noteOff;
1 => rhodes3.noteOff;
4::second => now;

fun void noteRep(int x[], int y[], int which) {
	y[Std.rand2(0,y.cap()-1)] => x[which];
}


fun void play (int x[], dur d[]) { // play notes x for durations d
	
//	<<< "playing ", x.cap() >>>;

	for (0 => int i; i < x.cap(); i++) {
		Std.mtof(midiBase+x[i]) => rhodes.freq;
		1 => rhodes.noteOn;
//		<<< " note and dur", x[i], d[i] >>>;
		d[i] => now;
		if(notesOff ==1) 1 => rhodes.noteOff;
	}
}

fun void play2 (int x[], dur d[]) { // play notes x for durations d
	
//	<<< "playing2 ", x.cap() >>>;
	
	for (0 => int i; i < x.cap(); i++) {
		Std.mtof(midiBase+x[i]) => rhodes2.freq;
		1 => rhodes2.noteOn;
//		<<< " note and dur", x[i], d[i] >>>;
		d[i] => now;
    	if(notesOff ==1) 1 => rhodes2.noteOff;
	}
}

fun void play3 (int x[], dur d[]) { // play notes x for durations d
	
//	<<< "playing2 ", x.cap() >>>;
	
	for (0 => int i; i < x.cap(); i++) {
		Std.mtof(midiBase+x[i]) => rhodes3.freq;
		1 => rhodes3.noteOn;
//		<<< " note and dur", x[i], d[i] >>>;
		d[i] => now;
		if(notesOff ==1) 1 => rhodes3.noteOff;
	}
}
		

fun void xCopy( int x[], int xCopy[]) { // copy x into xCopy
	
	for (0 => int i; i < x.cap(); i++) {
		x[i] => xCopy[i];
	}
}

fun void dCopy( dur d[], dur dCopy[]) { // copy d into dCopy
	
	for (0 => int i; i < d.cap(); i++) {
		d[i] => dCopy[i];
	}
}

fun void xPrint( int x[]) { // print x
	
	for (0 => int i; i < x.cap(); i++) {
		<<< "i  x[i] ",i,  x[i]>>>;
	}
}		

fun void fisherYatesPop (int x[], int y[]) {
	// shuffle in place via Fisher Yates algorithm
	// copy top k samples into y
	// pop top k samples off x (used)
	
	y.cap() => int k;
	
	int holder,j;
	
	for (0 => int i; i < x.size(); i++) { // scramble x in place
		Std.rand2(i,x.size()-1) => j;
		x[i] => holder;
		x[j] => x[i];
		holder => x[j];
	}
	
	for (k => int i; i < x.size(); i++) { // copy last k of x into 
//		<<< "i, i-k+1", i, i-k+1 >>>;
		x[i] => y[i-k];
	}
	for (0 => int i; i < k; i++) { // delete last k of x; 
		x.popBack();
	}
	
	
}

fun void fisherYatesPopDur (dur x[], dur y[]) {
	// shuffle in place via Fisher Yates algorithm
	// copy top k samples into y
	// pop top k samples off x (used)
	
	y.cap() => int k;
	
	dur holder;
	int j;
	
	for (0 => int i; i < x.size(); i++) { // scramble x in place
		Std.rand2(i,x.size()-1) => j;
		x[i] => holder;
		x[j] => x[i];
		holder => x[j];
	}
	
	for (k => int i; i < x.size(); i++) { // copy last k of x into 
//		<<< "i, i-k+1", i, i-k+1 >>>;
		x[i] => y[i-k];
	}
	for (0 => int i; i < k; i++) { // delete last k of x; 
		x.popBack();
	}
	
	
}

