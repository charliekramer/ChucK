StifKarp bass => LPF filt => PRCRev rev => Gain g => dac;
PercFlut tube =>  g => dac;

.01 => g.gain;

1 => tube.gain;
.8 => bass.gain;

59-12 => int midiBase;
Std.mtof(midiBase-12) => tube.freq;
Std.mtof(midiBase)*15 => filt.freq;
3 => filt.Q;

0.5 => bass.pickupPosition;
.8 => bass.sustain;
.8 => bass.stretch;


60./80.*.5 => float beatsec;
beatsec::second => dur beat; 

beat - (now % beat) => now;

fun void playNote (int midiNote,int nBeats) {
	Std.mtof(midiNote) => bass.freq;
//	Std.mtof(midiNote) => tube.freq;
	1 => bass.noteOn;
//	1 => tube.noteOn;
	nBeats*beat => now;
}

1 => int i;

while (i < 1000) {
	
	if (i % 128 == 1) {
		 spork~playNote(midiBase,8);
	 }
	 if (i % 128 == 4) {
	 	spork~playNote(midiBase+3,8);
	 		
 			 }
 	 if (i % 128 == 33) {
 		spork~playNote(midiBase+4,8);
 		 	}
     if (i % 128 == 36) {
		 spork~playNote(midiBase-1,8);		
	 		}
	 		
	 if (i % 128 == 65) {
	 	spork~playNote(midiBase,8);
 			}
 	if (i % 128 == 68) {
		spork~playNote(midiBase+3,8); 				}
	if (i % 128 == 97) {
		spork~playNote(midiBase+4,8);
		}
	if (i % 128 == 100) {
		spork~playNote(midiBase-1,8);		
		}
 	1 => tube.noteOn;
 	.5*beat => now;
	i++;
	
	}
	

	
	