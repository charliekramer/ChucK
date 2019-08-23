1 => float gainSet;
SndBuf s => blackhole;
"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => s.read;

Step imp => dac;

gainSet => imp.gain;

.9 => float alpha; // MA coefficient

float loop[40];

init();

while (true) {
	
	movingAverage(loop) => imp.next;
	1::samp => now;
	update(s.last());
	1::ms => now;
	init();
}


fun void init () {
	for (0 => int i; i < loop.size() -1; i++) {
		s.last() => loop[i];
		1::samp => now;
	}
}

fun float movingAverage (float x[]) {
	
	0 => float ma; // average
	
	for (0 => int i; i < x.size(); i++) {
		ma + x[i]*Math.pow(alpha,x.size()-i)/(1-alpha) => ma;
	}
	
	return ma;
}

fun void update(float newData) {
	
	
	for (0 => int i; i < loop.size()-1; i++) {
		loop[i+1]*alpha => loop[i];
	}
	newData => loop[loop.size()-1];
}
	
	