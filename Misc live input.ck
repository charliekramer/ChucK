adc => Gain ingain => Chorus chorus => Echo echo1 => Echo echo2 => NRev rev => dac;

SinOsc EchoLFO => blackhole;

.5 => chorus.mix;
.25 => chorus.modFreq;
.2 => chorus.modDepth;

10::second => echo1.max;
1.5::second => echo1.delay;
.5 => echo1.mix;
.5 => echo1.gain;
echo1 => echo1;

10::second => echo2.max;
.7::second => echo2.delay;
.5 => echo2.mix;
.5 => echo2.gain;
echo2 => echo2;

.7 => rev.mix;

2 => ingain.gain;

spork~LFOEcho(1.5,.25, .1, .1,1.5::second);

1000::second => now;

fun void LFOEcho (float a, float b, float freq_, float gain_, dur baseDur) {
	freq_ => EchoLFO.freq;
	gain_ => EchoLFO.gain;
	while (true) {
		(a+b*EchoLFO.last())*baseDur => echo1.delay;
		1::samp => now;
	}
}