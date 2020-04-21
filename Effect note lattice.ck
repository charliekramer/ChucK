.1*20 => float gainSet;
5 => int n; // dimension of lattice
float A[n][n]; // status matrix
float B[2][2]; // sensitivity matrix
Clarinet sound[n][n]; // mandolin cool too, clarinet
Pan2 pan[n];

MidiOut mout;
mout.open(0);
MidiMsg msg;

1::minute => dur length;

60-36 => float midiBase;
[0.,4.,7.,9.,11,12.] @=> float notes[];
//[0.,4.,5.,9.,6.] @=> notes;

for (0 => int i; i< A.cap(); i++) {
    for (0 => int j; j < A.cap(); j++) {
        0.0 => A[i][j];
        sound[i][j] => pan[j] => dac;
        -1 + 2.*j/(n*1.-1.) => pan[j].pan;
        <<< "i ", i, " pan[i] ", pan[i].pan() >>>;
        gainSet => sound[i][j].gain;
        Std.mtof(midiBase+12*i + notes[j]) => sound[i][j].freq;
    }
} 

for (0 => int i; i< B.cap(); i++) {
    for (0 => int j; j < B.cap(); j++) {
        .1 => B[i][j];
    }
} 

// just use simple b for now

.1 => float b;
.5::second => dur beat;

int nCount;

now + length => time future;

while (now < future) {
    <<< "ncount,", nCount>>>;
    <<< "reset" >>>;
    if (false) { // set true to reset A[][] every time
        
        for (0 => int i; i< A.cap(); i++) {
            for (0 => int j; j < A.cap(); j++) {
                0.0 => A[i][j];
            }
        } 
    }
    
    0 => nCount;
    
    Std.rand2(0,n-1) => int row;
    Std.rand2(0,n-1) => int col;
    <<< "row col", row, col>>>;
    
    .025 => A[row][col];//shock random element
    A[row][col]/(A.cap()*A.cap()) => float aMin;
    1.*A[row][col] => float aMax;
    float avg;
    
    A[row][col] => sound[row][col].noteOn;
    beat*.5 => now;
    
    for (0 => int i; i< A.cap(); i++) {
        for (0 => int j; j < A.cap(); j++) {
           // <<< "row - i" , row - i, "col -j", col -j>>>;
            //if (Std.abs(row - i) == 1 || Std.abs(col - j) == 1)
            if (((row == i) && Std.abs(col-j) == 1) || ((col == j) && Std.abs(row-i) == 1))
            {
                A[row][col]*b +=> A[i][j];
                clamp(A[i][j],1,0) => sound[i][j].noteOn;
                <<< "row, col, i, j ", row, col, i, j>>>;
                nCount++;
                .5*beat => now;
                1 => sound[i][j].noteOff;
                
                
                 i+144 => msg.data1;
                 j+60 => msg.data2; 
                 12700*A[i][j] $ int => msg.data3;
                 mout.send(msg);
                                
            }        
        }
    } 
    average() => avg;
    if (avg > aMax || avg < aMin) {
        <<< "switch b ">>>;
       -1*b => b;
    }
}




10::second => now;

fun float clamp (float x, float xMax, float xMin) {
    if (x > xMax ) {
        <<< "clamp max">>>;
        xMax => x;
    }
    if (x < xMin) {
        <<< "clamp min">>>;
        xMin => x;
    }
    return x;
}

fun float average() {
    0 => float avg;
    for (0 => int i; i < A.cap(); i++) {
        for (0 => int j; j < A.cap(); j++) {
            A[i][j]/(A.cap()*A.cap()) +=> avg;
        }
    }
    <<< "-----------avg", avg, "----------" >>>;
   return avg;
}
            


fun void midiWrite() {
    for (0 => int i; i < A.cap(); i++) {
        for (0 => int j; j < A.cap(); j++) {
            
            i => msg.data1;
            j => msg.data2; 
            127*A[i][j] $ int => msg.data3;
            mout.send(msg);
        }
    }
}