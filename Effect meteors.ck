
SawOsc saw => Envelope env => LPF filt => Echo echo => Pan2 pan => dac;
TriOsc tri => env => filt => echo => pan => dac;
PulseOsc sqr => env => filt => echo => pan => dac;

.00005*6 => float gainSet;
30 => float length; // length in seconds

gainSet => saw.gain;
gainSet => tri.gain;
gainSet => sqr.gain;

.2 => sqr.width;

SinOsc FiltLFO => blackhole; 
SinOsc PanLFO => blackhole;  
SinOsc PitchLFO => blackhole; 

1 => FiltLFO.gain;
1 => PanLFO.gain;
1 => PitchLFO.gain; // max 1

59-12 => float midiBase;
Std.mtof(midiBase) => saw.freq;
Std.mtof(midiBase) => tri.freq;
Std.mtof(midiBase) => sqr.freq;
.5 => float spread; // spread of tri and sqr around saw; PitchLFO gain = 1 and this .5 = weird chords
Std.mtof(midiBase) => filt.freq;
5 => filt.Q;



60./80.*4 => float beatSec; //*4; *16 = triippy; multiply by 2 successively
beatSec::second => dur beat;
//beat - (now % beat) => now; // comment out for long pads

1 => int randBeats; // choose to randomize first (on) beat (total of totalBeats between on and off)
32 => int totalBeats; //32
4 => int beat1; // "noteon" beat ; 4
4 => int beat2; // "noteoff" beat ;4 

5*beat => echo.max;
.75*beat => echo.delay;
.7 => echo.gain;
.3 => echo.mix;
echo => echo;

.3/beatSec => FiltLFO.freq;
.1/beatSec => PanLFO.freq;
.05/beatSec => PitchLFO.freq;

spork~pitcher();
spork~panner();
spork~filterer();

int startBeat;

now + length::second => time future;

while (now < future) {
	
	if (randBeats == 1) {
		
		Std.rand2(1,totalBeats-1) => startBeat;
		<<<"randBeats on: startbeat =", startBeat>>>;
		1 => env.keyOn;
		startBeat*beat => now;
		1 => env.keyOff;
		(totalBeats-startBeat)*beat => now;
	}
	else {
		
		1 => env.keyOn;
		beat1*beat => now;
		1 => env.keyOff;
		beat2*beat => now;
	}
	
}

	
	fun void pitcher() {
		while (true) {
			
			Std.mtof(midiBase)*(1+PitchLFO.last()*.5) => saw.freq;
			Std.mtof(midiBase)*(1+PitchLFO.last()*(.5+spread)) => tri.freq;
			Std.mtof(midiBase)*(1+PitchLFO.last()*(.5-spread)) => sqr.freq;
			1::samp => now;
		}
		
	}
	
	fun void panner() {
		
		while (true) {
			
			PanLFO.last() => pan.pan;
			1::samp => now;
		}
		
	}
	
	fun void filterer() {
		
		while (true) {
			
			Std.mtof(midiBase)*(3.5+FiltLFO.last()*3.5) => filt.freq;
			1::samp => now;
		}
		
	}
