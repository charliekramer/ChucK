// game of life
// v2 add convergence check


5 => int n; // dimension of matrix
0 => int delta; // convergence check; adds up changes to matrix

int x[n][n];
int y[n][n];

Gain master;
.1/(n*n) => master.gain;

NRev rev;
.1 => rev.mix;

Rhodey rhodes0[n]; //each row is a different instrument
ModalBar rhodes1[n];
PercFlut rhodes2[n];
Saxofony rhodes3[n];
Flute rhodes4[n];

55 => int midiBase; // base note

[0,4,5,7,9] @=> int notes[]; // each column is a different note

60./120.*2./4. => float beatSec; // 2/4 and 2/3 are interesting
beatSec::second => dur beat;

beat - (now % beat) => now;

for (0 => int i; i< n; i++) { // set up notes and soundchains

	Std.mtof(midiBase+notes[i]) => rhodes0[i].freq;
	Std.mtof(midiBase+notes[i]) => rhodes1[i].freq;
	Std.mtof(midiBase+notes[i]) => rhodes2[i].freq;
	Std.mtof(midiBase+notes[i]) => rhodes3[i].freq;
	Std.mtof(midiBase+notes[i]) => rhodes4[i].freq;
	rhodes0[i] => rev => master => dac;
	rhodes1[i] => rev => master => dac;
	rhodes2[i] => rev => master => dac;
    rhodes3[i] => rev => master => dac;
	rhodes4[i] => rev => master => dac;

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
		x[0][i] => rhodes0[i].noteOn;
		x[1][i] => rhodes1[i].noteOn;
		x[2][i] => rhodes2[i].noteOn;
		x[3][i] => rhodes3[i].noteOn;
		x[4][i] => rhodes4[i].noteOn;
	}
	
}

fun void notesoff() { // turn all notes off
	
	for (0 => int i; i < x.cap(); i++) {
		1 => rhodes0[i].noteOff;
		1 => rhodes1[i].noteOff;
		1 => rhodes2[i].noteOff;
		1 => rhodes3[i].noteOff;
		1 => rhodes4[i].noteOff;
	}
}

//random_x(y);
//x_set();
random_x(x);
//x_set();
prnt_5(x);
while (true) {
	
	0 => delta;
	
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

		