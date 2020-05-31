
//"/Users/charleskramer/Desktop/chuck/misc/JG_Hexagrid_newl.txt" => string filename;

"/Users/charleskramer/Desktop/chuck/misc/JG_Hexagrid.txt" => string filename;

// look at command line
if( me.args() > 0 ) me.arg(0) => filename;

// instantiate
FileIO fio;

// open a file
fio.open( filename, FileIO.READ );

// ensure it's ok
if( !fio.good() )
{
    cherr <= "can't open file: " <= filename <= " for reading..."
          <= IO.newline();
    me.exit();
}

// variable to read into
string val;

0 => int count;

// loop until end
while( fio => val )
{
    //<<< "erading" >>>;
    //cherr <= val <= IO.newline();
    val <= IO.newline();  
    count++;
}
<<< "count1" , count>>>;

int x[count];
int y[count];

0 => count;
// close and reoopen

fio.close;
fio.open( filename, FileIO.READ );

// loop until end

0 => int max;
10000000 => int min;


while( fio => val )
{
    //cherr <= val <= IO.newline();
    val <= IO.newline();
    
    Std.atoi(val) => int intval;
   // <<< "val", val, "intval", intval >>>;
    intval => x[count];
    bin2dec(intval) => y[count];
    
    if (y[count] > max) y[count] => max;
    if (y[count] < min) y[count] => min;
   
    count++;
}
<<< "Max, min", max, min, "count2" , count>>>;

BandedWG osc1 => Gain gain1 => NRev rev => Pan2 pan => dac;
gain1 => Echo echo => NRev revEcho => Pan2 panEcho => dac;
revEcho => Echo echo2 => Pan2 pan2 => dac;
SinOsc osc2 => dac;

40 => osc1.gain;
.1 => osc2.gain;

80+36 => float midiMax; // use for
10+36 => float midiMin; // JL hexagrid_newl.txt
80 => midiMax; // use for 
10 => midiMin; //JL hexagrid.txt

360::ms*3 => dur beat;

4*beat => echo.max;
1.5*beat => echo.delay;
.7 => echo.gain;
1 => echo.mix;
echo => echo;

6*beat => echo2.max;
6*beat => echo2.delay;
.5 => echo2.gain;
.5 => echo2.mix;
echo2 => echo2;

-.6 => pan.pan;
.6 => panEcho.pan;
-.9=> pan2.pan;

.2 => rev.mix => revEcho.mix;

float freqLag[6];

for (0 => int i; i < freqLag.cap(); i++) {
    //Std.mtof(map(min, min, max, midiMin, midiMax))  => freqLag[i];
    Std.mtof(min-24) => freqLag[i];
}

.99 => float rho;

[1., 5., 4., 2., 3, 3] @=> float beatCount[];

for (0 => int i; i < count; i++) {
    Std.mtof(map(y[i], min, max, midiMin, midiMax)) => osc1.freq;
    1 => osc1.noteOn;
    osc2freq();
    beatCount[i%6]*beat => now;
}


fun int bin2dec(int in) {
    0 => int out; 
    1 => int base;
    in => int temp;
    
    while (temp) {
        temp % 10 => int last_digit;
        temp/10 => temp;
        
        last_digit*base +=> out;
        
        base*2 => base;
    }
    
    return out;
}

fun float map (float xin, float xmin, float xmax, float ymin, float ymax) {
    float a, b;
    (ymax - ymin)/(xmax - xmin) => b;
    ymax - b*xmax => a;
    return a + b*xin;
}

fun void osc2freq() {
    0 => float outFreq;
    for (0 => int i; i < freqLag.cap()-1; i++) {
        freqLag[i] => freqLag[i+1];
    }
    osc1.freq() => freqLag[0];
    
    for (0 => int i; i < freqLag.cap(); i++) {
        outFreq + freqLag[i]*Math.pow(rho,i+1) => outFreq;
    }
    outFreq*.125 => osc2.freq;
}
    