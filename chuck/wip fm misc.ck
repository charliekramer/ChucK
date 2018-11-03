// FM misc bits
// from http://electro-music.com/forum/topic-13145.html

/*
SinOsc s1 => SinOsc s2 => s1 => dac; 
TriOsc s3 => s2; 
s1.freq(100); s2.freq(100); s3.freq(150); 
s1.sync(2); s2.sync(2); 
20 :: second => dur d; 
second / samp => float samplerate; 
1 => int i; 
while(i++) { 
	( i * 10 / samplerate => s2.gain ) * .1 => s3.gain; 
	samp => now; 
}
*/
/*
sinosc s1 => dac; 
0.5 => dac.gain; 
sinosc s2 => blackhole; 
.055 => s2.freq; 
triosc s3 => blackhole; 
while(true) { 
	s1.last() * 11000 + 550 => s3.freq; 
	s2.last() * .5 + .5 => s1.gain => s3.gain; 
	s3.last() * 550 + 550 => s1.freq; 
	1 :: samp => now; }
*/	
	sinosc s1 => dac; 
	0.5 => dac.gain; 
	sinosc s2 => blackhole; 
	.055 => s2.freq; 
	triosc s3 => blackhole; 
	while(true) { 
		s1.last() * 440 + 440 => s3.freq; 
		s2.last() * .5 + .5 => s1.gain => s3.gain; 
		s3.last() * 1100 + 550 => s1.freq; 
		1 :: samp => now; }