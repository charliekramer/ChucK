// midi controlled "sequencer"
// rewrite to use pads to control speed, echo

ModalBar bar[8];
LPF filt[8];
Echo echo[8];
NRev rev[8];

[0.,3.,4.,7.,9.,11., 12., 14.] @=> float notes[];

6. => float mult; // cutoff => midi/127*mult*noteFreq;


.3 => float gainSet;

59 => float midiBase;

60./80. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

1 => float beatDiv;


for (0 => int i; i < bar.size(); i++) {
	gainSet => bar[i].gain;
	Std.mtof(midiBase+notes[i]) => bar[i].freq;
	Std.mtof(midiBase)*.1 => filt[i].freq;
	5 => filt[i].Q;
	5*beat => echo[i].max;
	1.5*beat=> echo[i].delay; //*.375 pretty cool
	.3 => echo[i].gain;
	.3 => echo[i].mix;
	echo[i] => echo[i];
	.1 => rev[i].mix;
	bar[i] => filt[i] => echo[i] => rev[i] => dac;
	}
	
0 => int j; // counter

2 => int device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while (true) {
	
	while(min.recv(msg)) {
		
		if( msg.data1 == 176 && msg.data2 == 1 ) //
		{
			msg.data3*bar[0].freq()*mult/127. => filt[0].freq;
			<<<"Filt0, ", filt[0].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 2 ) //
		{
			msg.data3*bar[1].freq()*mult/127. => filt[1].freq;
			<<<"Filt1, ", filt[1].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 3 ) //
		{
			msg.data3*bar[2].freq()*mult/127. => filt[2].freq;
			<<<"Filt2, ", filt[2].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 4 ) //
		{
			msg.data3*bar[3].freq()*mult/127. => filt[3].freq;
			<<<"Filt3, ", filt[3].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 5 ) //
		{
			msg.data3*bar[4].freq()*mult/127. => filt[4].freq;
			<<<"Filt4, ", filt[4].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 6 ) //
		{
			msg.data3*bar[5].freq()*mult/127. => filt[5].freq;
			<<<"Filt5, ", filt[5].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 7 ) //
		{
			msg.data3*bar[6].freq()*mult/127. => filt[6].freq;
			<<<"Filt6, ", filt[6].freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 8 ) //
		{
			msg.data3*bar[7].freq()*mult/127. => filt[7].freq;
			<<<"Filt7, ", filt[7].freq() >>>;
		}
		if( msg.data1 == 144 && msg.data2 == 36) // beat division
		{
			.5 => beatDiv;
		}
		if( msg.data1 == 144 && msg.data2 == 37) // beat division
		{
			1 => beatDiv;
	    }
		if( msg.data1 == 144 && msg.data2 == 38) // beat division
		{
			2 => beatDiv;
		}
		if( msg.data1 == 144 && msg.data2 == 39) // beat division
		{
			4 => beatDiv;
	    }
		if( msg.data1 == 144 && msg.data2 == 40) // echo.beats
		{
			echoBeats(.25);
		}
		if( msg.data1 == 144 && msg.data2 == 41) // echo.beats
		{
			echoBeats(.5);
		}
		if( msg.data1 == 144 && msg.data2 == 42) // echo.beats
		{
			echoBeats(.75);
		}
		if( msg.data1 == 144 && msg.data2 == 43) // echo.beats
		{
			echoBeats(1);
		}
	}
	
	
	<<<" j", j>>>;
	1 => bar[j].noteOn;
	beat*.25*beatDiv => now;
	
	j++;
	if (j == 8) 0 => j;
	
}

fun void echoBeats (float echoBeats) {
	<<< "echo beats, ", echoBeats>>>;
	for (0 => int i; i < echo.size(); i++) {
		1.5*beat*echoBeats=> echo[i].delay; //*.375 pretty cool

	}
}


	