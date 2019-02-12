// concrete ambience v2 pitch shifter
SndBuf2 concrete[5];
HPF hpf[5];
Pan2 pan[5];
NRev rev;
Gain master;

0.01 => float gainLimit; //need this to keep it from getting too loud
.05 => master.gain; 


for (0 => int i; i< concrete.cap(); i++) {
	concrete[i] => hpf[i] => master => rev => pan[i] => dac;
	if (i % 2 == 0) {
		1 => pan[i].pan;
	}
	else {
		-1 => pan[i].pan;
	}
		
	0=> concrete[i].loop;
	.2 => rev.mix;
	440*i => hpf[i].freq;
	5 => hpf[i].Q;
}

"/Users/charleskramer/Desktop/chuck/audio/concrete_1.wav" => concrete[0].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_2.wav" => concrete[1].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_3.wav" => concrete[2].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_4.wav" => concrete[3].read;
"/Users/charleskramer/Desktop/chuck/audio/concrete_5.wav" => concrete[4].read;

60./120. => float beatSec;
beatSec::second => dur beat;

beat - (now % beat) => now;

float dG,d0,d1,d2,d3,d4,dRev;

0.6 => dG;
0.9 => d0;
0.7 => d1;
1.05 => d2;
0.5 => d3;
1.2 => d4;
1.5 => dRev;

8 => int nBeat;

now + nBeat*beat => time future;
	
	while (true) {	
		<<< "end" >>>;
		0 => concrete[0].pos => concrete[1].pos => concrete[2].pos => concrete[3].pos => concrete[4].pos;  
		master.gain()*dG => master.gain;
		concrete[0].rate()*d0 => concrete[0].rate;
		concrete[1].rate()*d1 => concrete[1].rate;
		concrete[2].rate()*d2 => concrete[2].rate;
		concrete[3].rate()*d3 => concrete[3].rate;
		concrete[4].rate()*d4 => concrete[4].rate;
		rev.mix()*dRev => rev.mix;
		if (master.gain() > gainLimit) {
			<<< "hit gainlimit" >>>;
			gainLimit => master.gain;
		}
		beat => now;
		if (now > future) {
			<<< "future" >>>;
			1./dG => dG;
			1./d0 => d0;
			1./d1 => d1;
			1./d2 => d2;
			1./d3 => d3;
			1./d4 => d4;
			1./dRev => dRev;
			now + nBeat*beat => future;
		}
	}
