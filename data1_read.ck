// todo: set up to detect length of file then initialize arrays etc
// try other instruments/envelopes, sporking for overlap?
// reverb, echo
// default file

1 => int n; // number of notes in chord

1 => float gainSet;

.15::second*1 => dur beat;

beat - (now % beat) => now;

1 => int choose; // 1 mtof(num); 2 mtof(log(num)); 3 mtof(sqrt(num))

1 => int panner; // 1 pan by size

Rhodey rhodes[n];
Pan2 pan[n];
for (0 => int j; j < n; j++) {
  
    rhodes[j] => pan[j] => dac;
    gainSet => rhodes[j].gain;   
}

//"/Users/charleskramer/Desktop/chuck/misc/01code.txt" => string filename;
"/Users/charleskramer/Desktop/chuck/misc/01-code-II.txt" => string filename;

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
int val;

0 => int count;

// loop until end
while( fio => val )
{
    //<<< "erading" >>>;
    cherr <= val <= IO.newline();
        
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
while( fio => val )
{
    cherr <= val <= IO.newline();
    val => x[count];
    bin2dec(val) => y[count];
    
    count++;
}
<<< "count2" , count>>>;


0 => int max;
10000000 => int min;

for (0 => int i; i < x.size()-(n-1); i++) {
    
    //<<< x[i], y[i] >>>;
    
    if (y[i] > max) y[i] => max;
    if (y[i] < min) y[i] => min;
    
    for (0 => int j; j < n; j++) {
        
        if (choose == 1) {
            Std.mtof(y[i+j]) => rhodes[j].freq;
        }
        else if (choose == 2) {
            Std.mtof(Math.log(y[i+j])) => rhodes[j].freq;
        }
        else {
            
            Std.mtof(Math.pow(y[i+j],.5)) => rhodes[j].freq;
        }
        
        if (panner == 1) {
            -1. + 2.*(1.*y[i+j]-1.*min)/(1.*max-1.*min) => pan[j].pan;
        }
    }
      
    for (0 => int j; j < n; j++) {
        
        
           1 => rhodes[j].noteOn;
          
    }  
        
 
    beat => now;
    
}

<<< "max, min", max, min >>>;

<<< "x0,", x[0], "decimal", bin2dec(x[0]) >>>;


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
