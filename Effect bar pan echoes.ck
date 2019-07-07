ModalBar bar => NRev rev1 => Pan2 panBar =>  dac;

bar => Echo echo =>  NRev rev2 => Pan2 panEcho =>  dac;

1 => int panSwitch; // (pan echo/original between sides)

.5 => bar.gain;

44 => bar.freq;

.2 => rev1.mix;
.2 => rev2.mix;

-1 => panBar.pan;

1 => panEcho.pan;

1 => echo.mix; // 1
.5 => echo.gain; //.5
echo => echo;


60./94.*.5 => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

10::second => echo.max;

beat*1.5 => echo.delay;

while (true) {
	
	1 => bar.noteOn;
	beat => now;
	1 => bar.noteOff;
	4*beat => now;
	if (panSwitch ==1 ) {
		-1*panBar.pan()=>panBar.pan;
		-1*panEcho.pan()=>panEcho.pan;
	}
}
	
	