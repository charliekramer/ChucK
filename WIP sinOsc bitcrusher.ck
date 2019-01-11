SinOsc s => dac;

44 => s.freq;

0 => int i;

while (true) {
	i++;
	if (i%130 == 0 || i%201 ==0 || i% 737 == 0) 0 =>s.gain;
//	1::samp => now;
   .01::ms => now;
	1 => s.gain;

}