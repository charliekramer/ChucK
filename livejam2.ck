SndBuf kick => Echo echo => dac;
SndBuf hat => echo =>  dac;
SndBuf snare => echo => NRev snareRev => dac;

.9 => snareRev.mix;

"audio/kick_01.wav" => kick.read;
"audio/snare_01.wav" => snare.read;
"audio/hihat_01.wav" => hat.read;

0 => kick.pos;
.3 => hat.gain;

1::second => dur beat;

5*beat => echo.max;
1.5*beat => echo.delay;
.5 => echo.gain;
.5 => echo.mix;
echo => echo;

beat - (now % beat) => now;

0 => int j;


while (true) {
	
	Std.rand2f(.7,1.5) => hat.rate;
	
	Std.rand2f(.7,1.5) => kick.rate;
	
	Std.rand2f(.7,1.5) => snare.rate;
	0 => hat.pos;
	if (j %4 == 0 || j% 16 ==0 ) 0 => snare.pos;
	if (j% 8 == 0 || j%13 == 0) 0 => kick.pos;
	beat*.25 => now;
	j++;
	
}