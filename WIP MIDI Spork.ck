//WIP Midi Spork

2 => int device;

MidiIn midiIn;
MidiMsg msg;

if( !midiIn.open( device ) ) me.exit();

<<< "MIDI device:", midiIn.num(), " -> ", midiIn.name() >>>;

float x;

spork~midiCatch(2,0.,1.);

100::second => now;

fun void midiCatch(int knob, float min, float max) {
	while (true) {
		
		midiIn => now;
		if (msg.data2 == knob) {
			<<< "catch,", knob, msg.data1, msg.data2,msg.data3>>>;
			min + msg.data3/127.0*(max-min) => x;
		}
		1::ms => now;
	}
}
