adc => Gain inGain => Dyno dyn => HPF l =>  Echo echo => NRev rev => Gain outGain => dac;
adc =>  inGain =>  dyn =>  l =>  echo => LiSa loop =>  rev =>   Gain loopGain => Pan2 loopPan =>dac;

25 => l.freq;

0.02 => inGain.gain; 
0.5 => outGain.gain;
0.2 => loopGain.gain;

10::second => echo.max;

1.25::second => echo.delay;

.7 => echo.gain;
.3 => echo.mix;
echo => echo;

.2 => rev.mix;

float randLength;
int numLoops;

now + 360::second => time future;

while (now < future) {
	
	Std.rand2f(.1,4.0) => randLength;
	
	randLength::second =>loop.duration;
	
	loop.record(1);
	
	randLength::second => now;
	
	loop.record(0);
	
	loop.rampUp(10::ms);
	
	Std.rand2(-4,4)*.5 => loop.rate;
	
	Std.rand2(1,4) => numLoops;
	
	Std.rand2f(-1,1) => loopPan.pan;
	
	1 => loop.gain;
	
	<<< "length" , randLength, "rate", loop.rate(), "numLoops", numLoops, "pan", loopPan.pan() >>> ;

	
	for (1 => int i; i < numLoops; i++) {
		
		randLength::second => now;
		loop.gain()*.75 => loop.gain;
	}	
	
	if (false) { // last
		
		for (1 => int i; i < 10; i++) {
			<<< "loop" , i, "gain", loop.gain() >>>;
			randLength::second => now;
			loop.gain()*.5 => loop.gain;
		}	
		
		break;
	}
		
	
}
	
/*
4::second => loop.duration;

loop.record(1);

4::second => now;

loop.record(0);

loop.rampUp(10::ms);
*/

100::second => now;