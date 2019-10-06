//TriOsc sin => ADSR envelope => Echo echo => NRev rev => Pan2 pan => dac; //
SinOsc sin => LPF filter => ADSR envelope => Echo echo => NRev rev => Pan2 panSin => dac; //
SqrOsc sqr =>  filter => envelope =>  echo =>  rev => Pan2 panSqr => dac; //
TriOsc tri =>  filter => envelope =>  echo =>  rev =>  Pan2 panTri => dac; //

Wurley w1 =>  filter =>   echo =>  rev =>  panSin => dac; //
Wurley w2 =>  filter => echo =>  rev =>  panSqr => dac; //
Wurley w3 =>  filter => echo =>  rev =>   panTri => dac; //



//.1 => sin.width;

.005 => sin.gain => sqr.gain => tri.gain;
.005 => w1.gain => w2.gain => w3.gain;

57 => float midiBase;

[0,4,5,7,9,12] @=> int notes[];

Std.mtof(midiBase) => sin.freq; 
Std.mtof(midiBase)*2 => filter.freq;
Std.mtof(midiBase+4) => sqr.freq;
Std.mtof(midiBase+7) => tri.freq;

2 => filter.Q;

1::second => dur beat;

beat*5 => echo.max;
1.5*beat => echo.delay;
.5 => echo.mix;
.7 => echo.gain;
echo => echo;

 0 => panSin.pan;
 -.75 => panTri.pan;
 .75 => panSqr.pan;

(.5*beat,.01*beat, 1, .5*beat) => envelope.set;

while (true) {
	
	//1 => sin.noteOn;
	
	//Std.rand2f(.5,1.5)*Std.mtof(midiBase) => sin.freq; 
	
	Std.mtof(midiBase+notes[Std.rand2(0,notes.cap()-1)]) => sin.freq => w1.freq; 
	sin.freq()*8 => filter.freq;
	sin.freq()*1.5 => sqr.freq => w2.freq;
	sin.freq()*1.33 => tri.freq => w3.freq;
	
	1 => envelope.keyOn;
	1 => w1.noteOn;
	1 => w2.noteOn;
	1 => w3.noteOn;


	
	beat => now;
	
	//1 => sin.noteOff;
	
	1 => envelope.keyOff;
	
	1 => w1.noteOff; 
	1 => w2.noteOff;
	1 => w3.noteOff;
	
	8*beat => now;
	
}
