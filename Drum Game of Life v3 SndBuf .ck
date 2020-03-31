// game of life
// v2 add convergence check
// v3 sndbuf 
// drum machine


4 => int n; // dimension of matrix
0 => int delta; // convergence check; adds up changes to matrix

int x[n][n];
int y[n][n];

Gain master;
.005/(n*n)*6 => float masterGain => master.gain;

NRev rev;

SndBuf buf0[n];
SndBuf buf1[n];
SndBuf buf2[n];
SndBuf buf3[n];


"/Users/charleskramer/Desktop/chuck/audio/drum" => string name; // 1/25th version

.2 => rev.mix; 
0 => int loop; // choose whether to loop buf
1 => float rate; // change rate of playback
1 => int randRate; // randomize playback rate
1 => int noteDown; // turn off notes after cycle; more spare sounding
1 => int switchMat; // switch order of i and j to mix it up

60./94.*.25 => float beatSec; // pretty cool to layer *1 and *.5 or *.25
beatSec::second => dur beat;

0 => master.gain;

beat - (now % beat) => now;

masterGain => master.gain;

string filename;

for (0 => int j; j< n; j++) { // set up notes 
	
	for (0 => int i; i < n; i++) {
		
		if (switchMat == 1) {
			name + j + i => filename; 
		}
		else {
			name + i + j =>  filename; 
		}
		if (i == 0) filename+".wav" => buf0[j].read;
		if (i == 1) filename+".wav" => buf1[j].read;
		if (i == 2) filename+".wav" => buf2[j].read;
		if (i == 3) filename+".wav" => buf3[j].read;
	}

    if (loop ==1 ) {
		1 => buf0[j].loop;
		1 => buf1[j].loop;
		1 => buf2[j].loop;
		1 => buf3[j].loop;
	}
	
	
	buf0[j] => rev => master => dac;
	buf1[j] => rev => master => dac;
	buf2[j] => rev => master => dac;
    buf3[j] => rev => master => dac;
	
	rate => buf0[j].rate;
	rate => buf1[j].rate;
	rate => buf2[j].rate;
	rate => buf3[j].rate;
	
	if (randRate == 1) {
		Std.rand2f(.75,1.5) => buf0[j].rate;
		Std.rand2f(.75,1.5) => buf1[j].rate;
		Std.rand2f(.75,1.5) => buf2[j].rate;
		Std.rand2f(.75,1.5) => buf3[j].rate;
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
fun void prnt_4 (int x[][]) { // only works on 4x4
	for (0 => int i; i < 4; i++) {
		<<< x[i][0],x[i][1],x[i][2],x[i][3]>>>;
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

fun void sound() { // set buffer position for all samples
	
	for (0 => int j; j < x.cap(); j++) {
		
			if (x[0][j] == 1) 0 => buf0[j].pos; 
			else buf0[j].samples() => buf0[j].pos;
			beat => now;
			
			if (x[1][j] == 1) 0 => buf1[j].pos; 
			else buf1[j].samples() => buf1[j].pos;
			beat => now;
			
			if (x[2][j] == 1) 0 => buf2[j].pos; 
			else buf2[j].samples() => buf2[j].pos;
			beat => now;
			
			if (x[3][j] == 1) 0 => buf3[j].pos; 
			else buf3[j].samples() => buf3[j].pos;
			beat => now;
			
	}
	
}

fun void notesoff() { // turn all notes off
	
	for (0 => int j; j < x.cap(); j++) {
		    
			buf0[j].samples() => buf0[j].pos;
			
			buf1[j].samples() => buf1[j].pos;
			
			buf2[j].samples() => buf2[j].pos;
			
			buf3[j].samples() => buf3[j].pos;
			
	}
}

fun int sum_x () { // add up all entries to check for all = 0
	
	0 => int x_sum;
	
	for (0 => int i; i < x.cap(); i++) {
		for (0 => int j; j < x.cap(); j++) {
			x_sum+x[i][j] => x_sum;
		}
	}
	<<< "x_sum", x_sum >>>;
	return x_sum;
}

//random_x(y);
//x_set();
random_x(x);
//x_set();
prnt_4(x);
notesoff();
while (true) {
	
	0 => delta;
	
	calc_x(); // check evolution criteria
	
	recalc_x(); // use to create next generation
	
	<<< "************* X ******************">>>;
	if (delta == 0) <<< "****CONVERGENCE ******************" >>>;
	
	prnt_4(x);// print the matrix
	
	sound(); // turn on the corresponding notes
	
    if (noteDown ==1) notesoff(); 
	
	if (sum_x() == 0) {
		<<< "regen on zeroes">>>;
		random_x(x);
	}
	
}

		