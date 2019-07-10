//random jumps in fifths (1.5^n)
// rhodes version
// rewrite to arbitrary n (chord size)
//Rhodey version

7 => int n;//try for large n (up to 16), long time

Rhodey rhodes[n];
NRev rev[n];
Echo echo[n];
Pan2 pan[n];

.1 => float gainSet;

for (0 => int i; i < rhodes.size(); i++) {
	<<< "i ", i>>>;
	if (i == 0) 
		{-1 => pan[i].pan;
	}
	else {
		pan[0].pan()-(2.*i)*pan[0].pan()/(n*1.0-1.) => pan[i].pan;
	}
	rhodes[i] => rev[i] => echo[i] => pan[i] => dac;
	.2 => rev[i].mix;
	gainSet => rhodes[i].gain;
	<<< "Pan ," , i, pan[i].pan() >>>;
}

60./80. => float beatSec;
beatSec::second => dur beat;

for (0 => int i; i < echo.size(); i++) {
	5*beat => echo[i].max;
	.5*beat*(i+1) => echo[i].delay;
	.5 => echo[i].gain;
	.3 => echo[i].mix;
	echo[i] => echo[i];
}

now + 120::second => time future;

beat - (now % beat) => now;

59-12 => float midiBase; // try +7, +5
resetFreqs();

rhodes[0].freq()*3 => float maxFreq;
rhodes[0].freq()/3 => float minFreq;

float beatFraction, beatPause;

while (now < future) {
	
	setFreqs();
	
	if (rhodes[0].freq() > maxFreq || rhodes[0].freq() < minFreq) {
		resetFreqs();
		
	}
	
	Std.rand2f(0,1.5)/(n-1) => beatFraction;	
	Std.rand2f(0,1.5)/(n-1) => beatPause;
	<<< "beatFraction, beatPause", beatFraction, beatPause>>>;
	for (0 => int i; i < rhodes.size(); i++) {
		1 => rhodes[i].noteOn;
		beat*beatFraction => now;
	}
	beat*(8 - beatPause - n*beatFraction) => now;
	for (0 => int i; i < rhodes.size(); i++) {
		1 => rhodes[i].noteOff;
	}
	<<< "Pause" >>>;
	beat*beatPause => now;
}
resetFreqs();
<<< " End" >>>;
5::second => now;
	
fun void resetFreqs() {
	
	for (0 => int i; i < rhodes.size(); i++) {
		if (i == 0) Std.mtof(midiBase) => rhodes[i].freq;
		else if (i == 1) Std.mtof(midiBase+7) => rhodes[i].freq;
		else Std.mtof(midiBase+7+(i-1)*2.) => rhodes[i].freq;
	}
}
		
fun void setFreqs() {
			
	for (0 => int i; i < rhodes.size(); i++) {
		if (i == 0) rhodes[0].freq()*Math.pow(1.5,Std.rand2(-1,1)) => rhodes[0].freq;
		else rhodes[i-1].freq()*Math.pow(1.5,Std.rand2(-1,1)) => rhodes[i].freq;
	
	}
}
	
