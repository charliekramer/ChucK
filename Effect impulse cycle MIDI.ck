
// try controlling xtime parameters with midi controller
// add mapping of pitches to pushbuttons
class Fuzz extends Chugen
{
	1.0/2.0 => float p;
	
	2 => intensity;
	
	fun float tick(float in)
	{
		Math.sgn(in) => float sgn;
		return Math.pow(Math.fabs(in), p) * sgn;
	}
	
	fun void intensity(float i)
	{
		if(i > 1)
			1.0/i => p;
	}
}
Impulse imp => LPF filt => Fuzz fuzz => PitShift pitch => Echo echo => NRev rev =>  Gain gain => dac;

.1 => float gainSet;
5 => fuzz.intensity;
55+12+7 => float midiBase;

1 => pitch.mix;
.5 => pitch.shift;

[1.0, .4, .6, .8, 1.2, 1.5, 1.75, 2.0] @=> float pitches[]; // vector to map button pushes into pitch shift

10::second => echo.max;
3::second => echo.delay;
.5 => echo.gain;
.3 => echo.mix;
echo => echo;

.1 => rev.mix;

gainSet => gain.gain;

2 => int chooser;
//1 additive
//2 multiplicative

1 => float xmin; // min ms

SinOsc SinLFO =>  blackhole;
SawOsc SawLFO =>  blackhole;
SqrOsc SqrLFO =>  blackhole;
PulseOsc PulseLFO => blackhole;

// all 1s is pretty cool
// since these are effectively midi controlled prob good to just leave them

1 => float SinA;
1 => float SinB;
1 => float SawA;
1 => float SawB;
1 => float SqrA;
1 => float SqrB;
1 => float PulseA;
1 => float PulseB;

.01 => SinLFO.freq; //.2
.01 => SawLFO.freq; //.1
.01 => SqrLFO.freq; //.3
.01 => PulseLFO.freq; //.5

0.1 => SinLFO.gain => SawLFO.gain => SqrLFO.gain => PulseLFO.gain;

.2 => PulseLFO.width; //.2

float xtime;

Std.mtof(midiBase) => filt.freq;
10 => filt.Q;

2 => int device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while (true) {
	
	while(min.recv(msg))
	{
		if( msg.data1 == 176 && msg.data2 == 1 ) //Sin Freq
		{
			msg.data3*20./127. => SinLFO.freq;
			<<<"SinFreq, ", SinLFO.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 2 ) //Sin gain
		{
			msg.data3/(127.) => SinLFO.gain;
			<<<"SinGain, ",SinLFO.gain()>>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 3 ) //Saw Freq
		{
			msg.data3*20./127. => SawLFO.freq;
			<<< " SawFreq, ", SawLFO.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 4 ) //Saw gain
		{
			msg.data3/(127.) => SawLFO.gain;
			<<<"SawGain, ",SawLFO.gain()>>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 5 ) //Sqr Freq
		{
			msg.data3*20./127. => SqrLFO.freq;
			<<< " SqrFreq, ", SqrLFO.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 6 ) //Sqr gain
		{
			msg.data3/(127.) => SqrLFO.gain;
			<<<"SqrGain, ",SqrLFO.gain()>>>;
		}
		if( msg.data1 == 176 && msg.data2 == 7 ) //Pulse Freq
		{
			msg.data3*20./127. => PulseLFO.freq;
			<<< " PulseFreq, ", PulseLFO.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 8 ) //Pulse gain
		{
			msg.data3/(127.) => PulseLFO.gain;
			<<<"PulseGain, ",PulseLFO.gain()>>>;
		}
		if (msg.data1 == 144) {
			pitches[(msg.data2-36)] =>  pitch.shift;
		}
		
	}
	
	if (chooser == 1) {
		Math.fabs((SinA+SinB*SinLFO.last()) + (SawA+SawB*SawLFO.last()) + (SqrA+SqrB*SqrLFO.last()) + (PulseA+PulseB*PulseLFO.last())) +xmin => xtime;
	}
	else if (chooser ==2) {
		Math.fabs((SinA+SinB*SinLFO.last()) * (SawA+SawB*SawLFO.last()) * (SqrA+SqrB*SqrLFO.last()) * (PulseA+PulseB*PulseLFO.last())) + xmin => xtime;
	}
	1 => imp.next;
	xtime::ms => now;
	
}
	
	