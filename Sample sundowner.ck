/// could be cool to have multiple buffers of the same thing and speed up/slow down

1.5 => float gainSet;

SndBuf2 buf0 => Gain gain => dac;
SndBuf2 buf1 => PitShift pitch1 => NRev rev1 => Pan2 pan1 => dac;
SndBuf2 buf2  => PitShift pitch2 => NRev rev2 => Pan2 pan2 => dac;
SndBuf2 buf3 => BPF filt => NRev rev3 => Pan2 pan3 => dac;

SinOsc LFO0;
SinOsc LFO1; 
SinOsc LFO2; 
SinOsc LFO3; 

.1 => LFO0.freq;
.1 => LFO1.freq;
.1 => LFO2.freq;
.1 => LFO3.freq;

.1 => buf0.rate => buf1.rate => buf2.rate => buf3.rate;
1 => buf0.loop => buf1.loop => buf2.loop => buf3.loop;
1 => pitch1.mix => pitch2.mix;
1.01 => pitch1.shift;
0.99 => pitch2.shift;
gainSet => buf0.gain => buf1.gain => buf2.gain => buf3.gain;

.4 => pitch1.gain => pitch2.gain;

.7 => rev1.mix => rev2.mix => rev3.mix;
.9 => rev3.mix;
.5 => pan1.pan;
-pan1.pan() => pan2.pan;
0 => pan3.pan;

440 => filt.freq;
10 => filt.Q;


"/Users/charleskramer/Desktop/chuck/audio/sundown_unprocessed.wav" => buf0.read;
"/Users/charleskramer/Desktop/chuck/audio/sundown_unprocessed.wav" => buf1.read;
"/Users/charleskramer/Desktop/chuck/audio/sundown_unprocessed.wav" => buf2.read;
"/Users/charleskramer/Desktop/chuck/audio/sundown_unprocessed.wav" => buf3.read;


10*41000*0 => buf0.pos => buf1.pos => buf2.pos => buf3.pos;

now+120::second => time future;

while (now < future) {
	buf0.rate() + LFO1.last()*.1 => buf1.rate;
	buf0.rate() - LFO2.last()*.1 => buf2.rate;
	buf0.rate() + LFO3.last()*.1 => buf1.rate;
	LFO3.last() => pan2.pan;

	1::samp => now; 
}
