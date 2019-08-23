
SndBuf2 buf => Echo delay => Echo delay2 => dac;

60./80. => float beatSec => buf.rate;

beatSec::second => dur beat;

beat - (now % beat) => now;

beat*5 => delay2.max;
beat*1.5 => delay2.delay;
.3 => delay2.mix;
.5 => delay2.gain;
delay2 => delay2;

1 => buf.loop;

"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => buf.read;
.1 => float gainSet;

SinOsc LFO => blackhole;
SinOsc LFO_Master => blackhole;


.05 => float baseFreq;
baseFreq => LFO.freq;
.1 => LFO_Master.freq;

5::second => delay.max ;
1::ms => delay.delay;

.5 => delay.mix;
.9 => delay.gain;

delay => delay;

gainSet => buf.gain;

//1::second => now;

while (true) {
	.5*(2+LFO.last()/2)::ms => delay.delay;
	1::samp => now;
	baseFreq*(2+LFO_Master.last()/2) => LFO.freq;
}