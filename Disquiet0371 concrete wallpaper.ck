// disquiet0371 concrete ambience
SndBuf concrete[5];
HPF hpf[5];
Pan2 pan[5];
NRev rev;
Gain master;

.1 => master.gain;

for (0 => int i; i< concrete.cap(); i++) {
	concrete[i] => hpf[i] => master => rev => pan[i] => dac;
	Math.pow(-1,i) => pan[i].pan;
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

for (0 => int i; i< concrete.cap(); i++) {
	concrete[i].samples() => concrete[i].pos;
	<<< " pan i", i, pan[i].pan() >>>;
	<<< "pos", concrete[i].pos() >>>;
}


60./120.*4 => float beatSec;
beatSec::second => dur beat;

now + 48*beat => time future;
now => time start;

while (now < future) {
	
	if (now < start+2*beat) {
	    0 => concrete[4].pos;
		beat => now;
		<<< "4" >>>;
		concrete[4].samples() => concrete[4].pos;
	}

	if (now >= start+2*beat && now <start+6*beat) {
		0 => concrete[3].pos;
		beat => now;
		concrete[3].samples() => concrete[3].pos;
		<<< "3" >>>;
	}
	
	if (now >= start+6*beat && now < start+12*beat) {
		0 => concrete[2].pos;
		0 => concrete[4].pos;
		beat => now;
		concrete[2].samples() => concrete[2].pos;
		concrete[4].samples() => concrete[4].pos;
		<<< "2" >>>;
	}
	
	if (now >= start+12*beat && now < start+18*beat) {
		0 => concrete[1].pos;
		0 => concrete[3].pos;
		beat => now;
		<<< "1" >>>;
		concrete[1].samples() => concrete[1].pos;
		concrete[3].samples() => concrete[3].pos;
	}
	
	if (now >= start+18*beat && now < start+24*beat) {
		0 => concrete[0].pos;
		0 => concrete[2].pos;
		beat => now;
		<<< "0" >>>;
		concrete[0].samples() => concrete[0].pos;
		concrete[2].samples() => concrete[2].pos;
	}
	
	if (now >= start+24*beat) {
		<<< "end" >>>;
		0 => concrete[0].pos => concrete[1].pos => concrete[2].pos => concrete[3].pos => concrete[4].pos;  
		master.gain()*.6 => master.gain;
		concrete[0].rate()*.9 => concrete[0].rate;
		concrete[1].rate()*.7 => concrete[1].rate;
		concrete[2].rate()*1.05 => concrete[2].rate;
		concrete[3].rate()*.5 => concrete[3].rate;
		concrete[4].rate()*1.2 => concrete[4].rate;
		rev.mix()*1.5 => rev.mix;
		beat => now;
	}
}

5::second => now;
	
	