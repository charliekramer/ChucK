// based on Effect sonar effects synch stereo
60./120.*4. => float beatsec;

beatsec::second => dur beat;

beat - (now % beat) => now;

ModalBar bottleL =>  NRev rL => Pan2 panL => Gain gain => dac;
ModalBar bottleR =>  NRev rR => Pan2 panR => gain => dac;

.5 => bottleL.stickHardness => bottleR.stickHardness;
.5 => bottleL.strikePosition => bottleR.strikePosition;
0. => bottleL.vibratoFreq => bottleR.vibratoFreq;
0. => bottleL.vibratoGain => bottleR.vibratoGain;
 1 => bottleL.preset => bottleR.preset;
 1 => int randPreset; // choose random preset
 
.1 => gain.gain;
.2 => rL.mix;
.2 => rR.mix;

62-12 => int midiBase;

Std.mtof(midiBase) => bottleL.freq;
Std.mtof(midiBase)*1.5 => bottleR.freq;

while (true){
	
	if (randPreset == 1) {	
		Std.rand2(1,8) => bottleL.preset;
		Std.rand2(1,8) => bottleR.preset;
	}
		
	Std.rand2(1,2)*Std.mtof(midiBase) => bottleL.freq;
	Std.rand2(1,2)*Std.mtof(midiBase)*1.5 => bottleR.freq;
	
	1 =>bottleL.noteOn;
	Std.rand2f(-1,0)=>panL.pan;
	
	beat => now;
	
	1 => bottleL.noteOff;
	1 => bottleR.noteOn;
	Std.rand2f(0,1)=>panR.pan;
	beat => now;
	
	1 => bottleR.noteOff;
	2*beat => now;
	
}

