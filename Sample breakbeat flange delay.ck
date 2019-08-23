.5 => float gainSet;
SndBuf2 buf => Echo delay => Echo delay2 => dac;

//"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => buf.read;
//138 => float BPM0;
"/Users/charleskramer/Desktop/chuck/audio/looperman-l-1319133-0161182-african-percu.wav" => buf.read;
110 => float BPM0;

80 => float BPM;

(60./BPM) => float beatSec;
(1/beatSec*60.)/BPM0 => buf.rate;

buf.samples() => buf.pos;

beatSec::second => dur beat;

beat - (now % beat) => now;

beat*5 => delay2.max;
beat*1.5 => delay2.delay;
.3 => delay2.mix;
.5 => delay2.gain;
delay2 => delay2;

0 => buf.loop;



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

time future;

0 => buf.pos;

while (true) {
	
	now + 8*beat => future;
	
	while (now < future) {
		
		.5*(2+LFO.last()/2)::ms => delay.delay;
		1::samp => now;
		baseFreq*(2+LFO_Master.last()/2) => LFO.freq;
		
	}
	<<< "loop reset" >>>;
	0 => buf.pos;
}