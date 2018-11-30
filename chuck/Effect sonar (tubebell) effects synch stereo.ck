// based on Effect sonar effects synch stereo
60./120.*4. => float beatsec;

beatsec::second => dur beat;

beat - (now % beat) => now;

PercFlut bottleL =>  NRev rL => Pan2 panL => Gain gain => dac;
PercFlut bottleR =>  NRev rR => Pan2 panR => gain => dac;

.2 => bottleL.lfoSpeed => bottleR.lfoSpeed;
.1 => bottleL.lfoDepth => bottleR.lfoDepth;

// 0.05 and .8 a good combo too

.1 => gain.gain;
.2 => rL.mix;
.2 => rR.mix;

62-12 => int midiBase;
1.5 => float multiplier; // multiplies first note to get second note

Std.mtof(midiBase) => bottleL.freq;
Std.mtof(midiBase)*multiplier => bottleR.freq;

while (true){
	
	Std.rand2(1,2)*Std.mtof(midiBase) => bottleL.freq;
	Std.rand2(1,2)*Std.mtof(midiBase)*multiplier => bottleR.freq;
	
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

