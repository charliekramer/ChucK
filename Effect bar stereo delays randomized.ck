ModalBar bar => Echo echoL => dac.right;
echoL => Echo echoR => dac.left;

59 => float midiBase;

Std.mtof(midiBase) => bar.freq;

.75::second => dur beat;

beat - (now % beat) => now;

.5 => echoL.gain;
.5 => echoL.mix;
echoL => echoL;

30*beat => echoL.max;
1.5*beat*Math.pow(1.5,1) => echoL.delay; //0,1,3,.5


.5 => echoR.gain;
.5 => echoR.mix;

30*beat => echoR.max;
1.5*beat*Math.pow(1.5,3) => echoR.delay;

0 => int j;

now + 20::second => time future;

while (now < future) {
	1=>bar.noteOn;
	beat => now;
	1 => bar.noteOff;
	beat => now;
	
	if (j % 8 == 0) {
		
		1.5*beat*Math.pow(1.5,Std.rand2(0,6))*.25 => echoR.delay;
		1.5*beat*Math.pow(1.5,Std.rand2(0,6))*.25 => echoL.delay;
		<<< "beat reset" >>>;
		
	}
	j++;
	
	
}