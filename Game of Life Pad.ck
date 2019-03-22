// game of life
// v2 add convergence check
// add echo;
// add sweeping filters except for sinOsc
// add different notes per row
// add panning


5 => int n; // dimension of matrix
0 => int delta; // convergence check; adds up changes to matrix

int x[n][n];
int y[n][n];

Gain master;
.00001/(n*n) => master.gain;

NRev rev;
.2 => rev.mix;

SinOsc rhodes0[n]; //each row is a different instrument
SqrOsc rhodes1[n];
TriOsc rhodes2[n];
PulseOsc rhodes3[n];
SawOsc rhodes4[n];
ADSR env0[n];
ADSR env1[n];
ADSR env2[n];
ADSR env3[n];
ADSR env4[n];
ResonZ filt;
Pan2 pan[n];

55 => int midiBase; // base note

Std.mtof(midiBase)*3 => filt.freq;
3 => filt.Q;
spork~filt_freq(Std.mtof(midiBase)*3.5, .1);

int notes[n][n];
[[0-24,4-24,5-24,7-24,9-24],
[4,5,7,9,12],  
[12,14,16,17,19], 
[-3,-5,-7,-8,-12], 
[0,2,5,7,12]] @=> notes;  


60./120.*16 => float beatSec; // 2/4 and 2/3 are interesting
beatSec::second => dur beat;

beat - (now % beat) => now;

Echo echo;
10*beat => echo.max;
1.5*beat => echo.delay;
.3 => echo.mix;
.5 => echo.gain;
echo => echo;

-1.0 => pan[2].pan;
-0.5 => pan[1].pan;
 0.0 => pan[0].pan;
 0.5 => pan[3].pan;
 1.0 => pan[4].pan;


for (0 => int i; i< n; i++) { // set up notes and soundchains
	
	

	Std.mtof(midiBase+notes[0][i]) => rhodes0[i].freq;
	Std.mtof(midiBase+notes[1][i]) => rhodes1[i].freq;
	Std.mtof(midiBase+notes[2][i]) => rhodes2[i].freq;
	Std.mtof(midiBase+notes[3][i]) => rhodes3[i].freq;
	Std.mtof(midiBase+notes[4][i]) => rhodes4[i].freq;
	rhodes0[i] => env0[i] => echo => rev => master => pan[2] => dac;
	rhodes1[i] => env1[i] => filt => echo => rev => master => pan[1] =>dac;
	rhodes2[i] => env2[i] => filt => echo => rev => master => pan[0] =>dac;
    rhodes3[i] => env3[i] => filt => echo => rev => master => pan[3] =>dac;
	rhodes4[i] => env4[i] => filt => echo => rev => master => pan[4] =>dac;

}

fun void filt_freq (float center_freq, float LFO_freq) { //modulate filter frequency
	
	SinOsc LFO => blackhole;
	
	LFO_freq => LFO.freq;
	
	while (true) {
		(LFO.last()+3.1)*.5*(center_freq) => filt.freq;
		1::ms => now;
	}
	
}

fun void env_set () { // set up envelopes
	
	for (0 => int i; i < x.cap(); i++) {	
        (.5*beat, .1*beat,.9, .5*beat) => env0[i].set;	
        (.5*beat, .1*beat,.9, .5*beat) => env1[i].set;	
        (.5*beat, .1*beat,.9, .5*beat) => env2[i].set;	
        (.5*beat, .1*beat,.9, .5*beat) => env3[i].set;	
        (.5*beat, .1*beat,.9, .5*beat) => env4[i].set;			

	}
}
	
fun void x_set() { // apply rules for evolution to next matrix
	for (0 => int i; i < x.cap(); i++) {
		for (0 => int j; j < x.cap(); j++) {
			if (i == 2 && j == 1) 1 => x[i][j];	
			if (i == 2 && j == 2) 1 => x[i][j];	
			if (i == 2 && j == 3) 1 => x[i][j];
		}
	}
}

fun void random_x (int x[][]) { // generate random initial matrix
	
	for (0 => int i; i < x.cap(); i++) {
		for (0 => int j; j < x.cap(); j++) {
	//		<<< "i,j", i, j>>>;
			Std.rand2(0,1) => x[i][j];
		}
	}
}

fun void prnt_x (int x[][]) { // print element by element
	for (0 => int i; i < x.cap(); i++) {
		for (0 => int j; j < x.cap(); j++) {
			<<< "i,j, x", i, j, x[i][j] >>>;
		}
	}
}
fun void prnt_5 (int x[][]) { // only works on 5x5
	for (0 => int i; i < 5; i++) {
		<<< x[i][0],x[i][1],x[i][2],x[i][3],x[i][4]>>>;
	}
}


fun int sum(int i, int j) { // add up 1s in surrounding cells; use wrap rule
	int count,ti,tj;
	0 => count;
	for (-1 => int id; id <= 1; id++) {
		for (-1 => int jd; jd <= 1; jd++) {
			circ(i+id) => ti;
			circ(j+jd) => tj;
			count+x[ti][tj] => count;
//			<<< "(", ti, "," , tj,")", "x",x[ti][tj], "count", count>>>;
		}	
	}
	count-x[i][j] => count; //take out the target cell
	return count;
}

fun int circ (int i) { // wraparound rule
	if (i < 0) x.cap()-1 => i;
	if (i > x.cap()-1) 0 => i;
	return i;
}
			
fun void calc_x () { // y holds sum of surrounding cells from x
	
	for (0 => int i; i < x.cap(); i++) {
		for (0 => int j; j < x.cap(); j++) {
			sum(i,j) => y[i][j];
		}
	}
}
fun void recalc_x () { //apply rules for evolution and check whether changed (vs converged)
	
	for (0 => int i; i < x.cap(); i++) {
		for (0 => int j; j < x.cap(); j++) {
			if(y[i][j] == 0 || y[i][j] == 1) {
				0 => x[i][j];
				delta++;
			}
			if(y[i][j] == 3 && x[i][j] == 0) {
				1 => x[i][j];
				delta++;
			}
			if(y[i][j] == 4 && x[i][j] == 1) {
				0 => x[i][j];
				delta++;
			}	
		}
	}
}

fun void sound() { // turn on notes for 'living' cells
	
	for (0 => int i; i < x.cap(); i++) {
		x[0][i] => env0[i].keyOn;
		x[1][i] => env1[i].keyOn;
		x[2][i] => env2[i].keyOn;
	    x[3][i] => env3[i].keyOn;
		x[4][i] => env4[i].keyOn;
		
	}
	
}

fun void notesoff() { // turn all notes off
	
	for (0 => int i; i < x.cap(); i++) {
		
			x[0][i] => env0[i].keyOff;
			x[1][i] => env1[i].keyOff;
			x[2][i] => env2[i].keyOff;
			x[3][i] => env3[i].keyOff;
			x[4][i] => env4[i].keyOff;
			
		}
		
}

env_set();

random_x(x);

prnt_5(x);

	
	 
while (true) {
	
	0 => delta; // measures convergence
	
	calc_x(); // check evolution criteria
	
	recalc_x(); // use to create next generation
	
	<<< "************* X ******************">>>;
	
	if (delta == 0) <<< "****CONVERGENCE ******************" >>>;
	
	prnt_5(x);// print the matrix (only works for 5x5

	sound(); // turn on the corresponding notes

	beat => now;
	
	notesoff(); // turn all notes off
	
	beat => now;
}

		