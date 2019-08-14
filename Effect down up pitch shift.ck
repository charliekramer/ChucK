SawOsc saw => PitShift pitch => NRev rev => Echo echo => Gain master => dac;
0.05 => float gainSet;

((59+12) -36)*1.1 => float midiBase; // *1.1 for cool overlaps

60./80. => float beatSec;
beatSec::second => dur beat;
0 => master.gain; // avoid initial beep
beat - (now % beat) => now;

.05 => master.gain;


Std.mtof(midiBase) => saw.freq;

.2 => rev.mix;

.5 => echo.mix;
.5 => echo.gain;
10*beat => echo.max;
1.5*beat => echo.delay;
echo => echo;

1 => pitch.mix;

.99 => float pitchDeltaDown; // .99
1./.99 => float pitchDeltaUp; // 1./.99

4. => float downBeats; // 4.
4. => float upBeats; // 4.

1::ms*400. => dur downGrain; //100::ms length of pitch grain
1::ms*400. => dur upGrain; //100::ms length of pitch grain

4. => float pitchRatio; //  4 ratio of up pitch to down
1 => float baseDelta; //  1 change of base note per each loop

now + downBeats*beat => time future;

now + 30::second => time end;

while (now < end) {
		
	midiBase*baseDelta => midiBase;
	
	// down note
	
	Std.mtof(midiBase) => saw.freq;
	1 => pitch.shift;
	
	now + downBeats*beat => future;
	
	while (now < future) {
		pitch.shift()*pitchDeltaDown => pitch.shift;
		downGrain => now;
	}
	
	Std.mtof(midiBase)*pitchRatio => saw.freq;
	
	1 => pitch.shift;
	
	now + upBeats*beat => future;
	
	while (now < future) {
		pitch.shift()*pitchDeltaUp => pitch.shift;
		upGrain => now;
	}
	
}

45::second => now;
		