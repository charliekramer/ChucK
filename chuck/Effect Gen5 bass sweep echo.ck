// based on gen5 example: exponential line segment table generator
// 
Phasor p => Gen5 g5 => LPF f => LPF f2 => Echo echo => Chorus c => NRev rev => Dyno dyn => Gain g=> dac;;

60./94. => float beattime;
beattime::second => dur beat;

beat - (now % beat) => now;

.25 => g.gain;

.0 => rev.mix;

10::second => echo.max;
beat*1.5 => echo.delay;
.7 => echo.gain;
.5 => echo.mix;
echo=>echo;

1 => c.modFreq;
.5 => c.modDepth;
.0 => c.mix;

Std.mtof(58-12) => p.freq;
p.freq() => float baseFreq;
p.freq()*1.5=> f.freq => f2.freq;

f.freq() => float minFreq;
2400. => float maxFreq;

20 => f.Q => f2.Q;



// set up the values [0,1] and distances in the table
// first arg is initial value 
// followed by pairs indicating distance (total distance = 1)
// and destination value for exponential segments
// NOTE: real minimum value is 0.000001

// the following will create a triangle, with a peak at 1 halfway
// through the table
[1., 0.5, 1., 0.5, 0.] => g5.coefs;

// create an envelope to scan through the table values
// creates a continuous input from 0 -> 1 over 10 seconds
Envelope e => blackhole;
e.duration( 10000::ms );
0. => e.value;
e.keyOn();

1 => int diff;

now + 128*beat => time future;

// loop
while (now < future)
{
   f.freq()+10*diff => f.freq => f2.freq;
   Std.rand2(1,6)*baseFreq => p.freq;// top value of 6, 7, 8, 9 sound cool
    // advance time
    beat*.125 => now; //also 10::ms
	if (f.freq() > maxFreq || f.freq() < minFreq) -1*diff => diff;
}
