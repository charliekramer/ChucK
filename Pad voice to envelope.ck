3 => int nVoice;
5 => int nChords;
VoicForm voice[nVoice];
ADSR env[nVoice];
NRev rev;
Pan2 pan[nVoice];

.01 => float masterGain;

.6 => rev.mix;

55-12 => float midiBase; // add 7 and overlay

[[0.,4.,7.],
 [4.,7.,11.],
 [7.,11.,14.],
 [12.,16.,19.],
 [7.,9.,14],
 [5.,7.,9.],
 [4.,7.,9.],
 [2.,4.,5],
 [0.,4.,12.]
  ] @=> float notes[][];
 
 <<< "notes size", notes.size()>>>;

60./94.*4 => float beatSec;
beatSec::second => dur beat;

for (0 => int i; i<voice.cap(); i++) {
	voice[i] => env[i] => rev => pan[i] => dac;
	-1 => pan[0].pan;
	-0 => pan[1].pan;
	 1 => pan[2].pan;
	env[i].set(beat*.2,0.25*beat,1,1.75*beat);
	voice[i].phonemeNum(i);
	1*(1+i*.1) => voice[i].vibratoFreq;
	.02 => voice[i].vibratoGain;
	//0 => voice[i].voiceMix;
	masterGain*(1) => voice[i].gain;
}

for (0 => int j; j < notes.size(); j++) {
	
	<<< "J ", j >>>;
	
	for (0 => int i; i < voice.cap(); i++) {			
		Std.mtof(midiBase+notes[j][i]) => voice[i].freq;
		<<< j, i, notes[j][i] >>>;
	}
	
	
	for (0 => int i; i< voice.cap(); i++) {
		1 => voice[i].noteOn;
		1 => env[i].keyOn;
	}
	2*beat => now;
	for (0 => int i; i< voice.cap(); i++) {
		//1 => voice[i].noteOff;
		1 => env[i].keyOff;
	}
	2*beat => now;
}
<<<"end voice to envelope">>>;
2*beat => now;



