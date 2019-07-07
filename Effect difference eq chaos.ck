// chaos from difference eqs
//https://www.math.psu.edu/treluga/textbook/chaos.html
//http://www.stsci.edu/~lbradley/seminar/logdiffeqn.html

/*
x(t+1) = r x(t) ( 1 - x(t) )

x in 0, 1 - 1/r

x(t+1) = f(x_t)

-1 < f'(x) <  1

x = 0 is stable for r < 1

x = 1 - 1/r is stable for 1 < r < 3
*/

.05 => float gainSet;

3.58 => float r; 
.01 => float deltaR;
3.0 => float rMin;
4.0-deltaR => float rMax;


Std.rand2f(0, 1.0 - 1.0/r) => float x;

PulseOsc sinX => Echo echo => dac.left;
sinX => dac.right;

gainSet => sinX.gain;

2::second => echo.max;
1.75::second => echo.delay;
.3 => echo.mix;
.5 => echo.gain;
echo => echo;

0.01 => float minWidth;
0.5 => float maxWidth;
0.01 => float widthDelta;

minWidth => sinX.width;

now + 120::second => time future;

while (now < future) {
	
	sinX.width()+widthDelta => sinX.width;
	if (sinX.width() >= maxWidth || sinX.width() <= minWidth) -1.*widthDelta => widthDelta;

	if (r <= rMin || r >= rMax) deltaR*-1 => deltaR;
	r + deltaR => r;
	r*x*(1-x) => x;
//	<<< "x ", x, "r", r>>>;
	(220.*x) => sinX.freq;
//	.1::second => now; // really cool with 1,.1, 0.01 second; or change below
    Std.rand2f(.09,.11)::second => now;
	
}

0 => sinX.gain;

10::second => now;