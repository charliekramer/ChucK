// korg midi in timing experiment

Rhodey rhodes => dac;

55 => rhodes.freq;

MidiIn min;

1 => int port;

if (!min.open(port) )
{
	<<< "port not found ", port >>>;
	me.exit();
}

MidiMsg msg;

0 => int i;

while (true)
{
	min => now;
	while ( min.recv(msg) ) {
		i++;
		<<< msg.data1, msg.data2, msg.data3 >>>;
		if (i % 16 == 0 && msg.data1 == 248) {
			1 => rhodes.noteOn;
		.1::second => now;
	}
	
	}
	.01::ms=> now;
}
1::second => now;
