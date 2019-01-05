60./120.*4. => float beatsec;

beatsec::second => dur beat;

beat - (now % beat) => now;

BlowBotl bottleL =>  NRev rL => Pan2 panL => Gain gain => dac;
BlowBotl bottleR =>  NRev rR => Pan2 panR => gain => dac;

.3 => bottleL.noiseGain => bottleR.noiseGain;

.1 => gain.gain;
.2 => rL.mix;
.2 => rR.mix;

60 => int midiBase;

Std.mtof(midiBase) => bottleL.freq;
Std.mtof(midiBase)*1.5 => bottleR.freq;

while (true){
	
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

