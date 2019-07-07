Rhodey rhodes => Envelope env => Echo echo => Pan2 pan => dac;
env => Echo echo2 => Gain echoGain => Dyno limiter => dac;

SinOsc EchoLFO => blackhole;

.1 => float gainSet;
20 => float length; //duration in seconds

gainSet => rhodes.gain;

1 => echoGain.gain;

[0,6] @=> int notes[];

59-24 => float midiBase;

60./80. => float beatSec;
beatSec::second => dur beat;
beat - (now % beat) => now;

5*beat => echo.max;
.75*beat => echo.delay;
.5 => echo.gain;
.3 => echo.mix;
echo => echo;

5*beat => echo2.max;
.75*beat*2 => echo2.delay;
echo2.delay() => dur delayBase;
.5 => echo2.gain;
echo2.gain() => float echoGainBase;
.3 => echo2.mix;
echo2 => echo2;

.1 => EchoLFO.freq;
.7 => EchoLFO.gain; // warning echo gets very loud if LFOing delay gain

1 => int echoSelect; // 1 to LFO delay time, 2 to LFO delay gain, 3 both
                     // set to 2 and crank EchoLFO.freq

spork~LFOEcho();

0 => int i;

now + length::second => time future;

while (now < future) {
	
	0 => i;
	play(Std.mtof(midiBase+notes[i]),beat);
	1 =>  i;
	play(Std.mtof(midiBase+notes[i]),beat*3);

}

10::second => now;

fun void play(float freq, dur duration) {
	
	freq => rhodes.freq;
	1 => rhodes.noteOn;
	1 => env.keyOn;
	duration => now;
	
}

fun void LFOEcho() {
	while (true) {
		if (echoSelect ==1 ) {
			(1+.5*EchoLFO.last())*delayBase => echo2.delay;
		}
		else if (echoSelect == 2) {
			
			(1+.5*EchoLFO.last())*echoGainBase => echo2.gain;
		}
		else if (echoSelect == 3) {
			(1+.5*EchoLFO.last())*delayBase => echo2.delay;
			(1+.5*EchoLFO.last())*echoGainBase => echo2.gain;
		}
		1::samp => now;
	}
}
	