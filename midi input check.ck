
MidiIn min;
MidiMsg msg; 

2 => int device;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;


while(true)
{
	// wait on the event 'min'
	min => now;
	
	// get the message(s)
	while( min.recv(msg) )
	{
		// print out midi message
		//if (msg.data1 == 177) {
		<<< msg.data1, msg.data2, msg.data3 >>>;
		10::ms => now;
	//}

	}

}