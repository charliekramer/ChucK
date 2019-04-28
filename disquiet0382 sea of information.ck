
5 => int nBuf;
SndBuf buf[nBuf] => dac;

for (0 => int i; i < buf.cap(); i++) {
"/Users/charleskramer/Desktop/chuck/audio/eric-mcluhan-kmox-10-sea-of-information.wav" => buf[i].read;
0 => buf[i].loop;
buf[i].samples() => buf[i].pos;
}


//(75000, 1.15::second ) "think about information;
// (270000, 1.15::second) "sea of information"

75000 => int startBuf;
270000 => startBuf;

2000 => int bufDiff; // 2000
500 => int bufDiffDelta; //1000
20000 => int bufDiffMax; // 20000

1.15::second => dur beat;


beat - (now % beat) => now;


while (bufDiff < bufDiffMax) {
	
for (0 => int i; i < buf.cap(); i++) {
	spork~playBuf(buf[i], startBuf+i*bufDiff, Math.pow(1,i), beat);
	}
	beat => now;
	
	bufDiff+bufDiffDelta => bufDiff;
	<<< bufDiff>>>;
}

.9::second => now;

fun void playBuf(SndBuf buffer, int pos, float rate, dur duration) {
	pos => buffer.pos;
	rate => buffer.rate;
	duration => now;
}
	 