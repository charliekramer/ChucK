// try other instruments/envelopes, sporking for overlap?
// reverb, echo
// v3; envelope; panning creates blips anyway
//drumbeat; 60/600*6

1 => int n; // number of notes in chord

.1/(n*n)*1.0 => float gainSet;

.5::second => dur beat;

beat - (now % beat) => now;

1 => int choose; // 1 mtof(num); 2 mtof(log(num)); 3 mtof(sqrt(num))

1 => int panner; // 1 pan by size

SinOsc rhodes[n];
ADSR env[n];
Pan2 pan[n];
NRev rev;
Echo echo;

.5 => rev.mix;

beat*2 => echo.max;
beat*1.5 => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

Gain gain;

for (0 => int j; j < n; j++) {
    
    (.5*beat,.1*beat,.9,.5*beat) => env[j].set;
    rhodes[j] => env[j] => gain  => pan[j] => dac;
    gain => echo => rev => dac;
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
        
        
           1 => env[j].keyOn;
          
    }  
        
 
    .5*beat => now;
    
    for (0 => int j; j < n; j++) {
        
        
        1 => env[j].keyOff;
        
    }
    
    5*beat => now;
    
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
