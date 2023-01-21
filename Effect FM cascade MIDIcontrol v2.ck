
// try controlling xtime parameters with midi controller
// add mapping of pitches to pushbuttons
class Fuzz extends Chugen
{
	1.0/2.0 => float p;
	
	2 => intensity;
	
	fun float tick(float in)
	{
		Math.sgn(in) => float sgn;
		return Math.pow(Math.fabs(in), p) * sgn;
	}
	
	fun void intensity(float i)
	{
		if(i > 1)
			1.0/i => p;
	}
}

20*.1 => float gainSet;

1 => int device;

62 => float midiBase;

SinOsc osc1 =>  blackhole;
SinOsc osc2 =>  blackhole;
SinOsc osc3 =>  blackhole;
SinOsc osc4 =>  blackhole;
SinOsc osc5 => blackhole;
osc1 => osc2 => osc3 =>  osc4 => osc5 => dac;
//SinOsc osc4 => dac;

gainSet => osc5.gain;


MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

while (true) {
	
	while(min.recv(msg))
	{
		if( msg.data1 == 176 && msg.data2 == 1 ) //osc1 Freq
		{
			msg.data3*10.+ 5 => osc1.freq;
			<<<" osc1freq, ", osc1.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 2 ) //osc1 gain
		{
			msg.data3*10 => osc1.gain;
			<<<"osc1gain, ", osc1.gain()>>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 3 ) //osc2 Freq
		{
			msg.data3*10. + 5. => osc2.freq;
			<<< " osc2 freq, ", osc2.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 4 ) //osc2 gain
		{
			msg.data3*10 => osc2.gain;
			<<<"osc2gain, ",osc2.gain()>>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 5 ) //osc3 Freq
		{
			msg.data3*10. + 5.  => osc3.freq;
			<<< " osc3freq, ", osc3.freq() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 6 ) //osc3 gain
		{
			msg.data3*10. => osc3.gain;
			<<<"osc3gain, ",osc3.gain()>>>;
		}
		if( msg.data1 == 176 && msg.data2 == 7 ) //osc4 gain
		{
			msg.data3*2200./127. + .05 => osc4.gain;
			<<< " osc4gain, ", osc4.gain() >>>;
		}
		
		if( msg.data1 == 176 && msg.data2 == 8 ) //osc5 gain
		{
			msg.data3/(127.)*gainSet => osc5.gain;
			<<<"osc5gain, ",osc5.gain()>>>;
		}
	//	if (msg.data1 == 144) {
			//save for later
	//	}
		
	}
	
	//osc1.last()+osc2.last()+osc3.last() => osc4.freq;
    
	1::ms => now;
	
}
	
	