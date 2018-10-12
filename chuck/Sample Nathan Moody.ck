// samples from Nathan Moody via disquiet: (disquiet0354)
//https://disquiet.com/2018/10/11/disquiet-junto-project-0354-rituals-canticles/
//http://www.noisejockey.net/main/

SndBuf BDB_1long => Gain g => Echo e =>PRCRev rev => Pan2 pan1 => dac; 
.1 => pan1.pan;
SndBuf DB_atonal => g =>  e => rev => Pan2 pan2 =>  dac; 
.25 => pan2.pan;
SndBuf DB_rapid => g =>  e => rev =>  Pan2 pan3 => dac; 
.75 => pan3.pan;
SndBuf spring_8cm => g =>  e => rev => Pan2 pan4 => dac;
 -.25 => pan4.pan;
SndBuf spring_13cm => g =>  e => rev  => Pan2 pan5 => dac;
 -.5 => pan5.pan;
SndBuf spring_18cm => g =>  e => rev => Pan2 pan6 => dac; 
-.75 => pan6.pan;
SndBuf spring_25cm => g =>  e => rev => Pan2 pan7 => dac; 
-.9 => pan7.pan;
SndBuf gong => g =>  e => rev =>  Pan2 pan8 => dac; 
.9 => pan8.pan;
SndBuf pipeHorn => g =>  e => rev => Pan2 pan9 => dac; 
.5 => pan9.pan;
SndBuf springBow=> g =>  e => rev => Pan2 pan10 => dac; 
-.1 => pan10.pan;

.01 => g.gain;

.2 => rev.mix;
10::second => e.max;
.75::second => e.delay;
.2 => e.mix;
.3 => e.gain;
e=>e;

"/Users/charleskramer/Desktop/chuck/audio/bassDiddleyBow_singleBowLong_B.wav" => BDB_1long.read;
"/Users/charleskramer/Desktop/chuck/audio/diddleyBow_atonalBowScrapes_vibrato_short_x6.wav" => DB_atonal.read;
"/Users/charleskramer/Desktop/chuck/audio/diddleyBow_rapidBowing_D_x5.wav" => DB_rapid.read;
"/Users/charleskramer/Desktop/chuck/audio/hit_spring_8cm_bundleStickHits_x9.wav" => spring_8cm.read;
"/Users/charleskramer/Desktop/chuck/audio/hit_spring_13cm_bundleStickHits_x7.wav" => spring_13cm.read;
"/Users/charleskramer/Desktop/chuck/audio/hit_spring_18cm_bundleStickHits_x4.wav" => spring_18cm.read;
"/Users/charleskramer/Desktop/chuck/audio/hit_spring_25cm_bundleStickHits_x6.wav" => spring_25cm.read;
"/Users/charleskramer/Desktop/chuck/audio/hit_steelPerfGong_stickHits_ECU_x6.wav" => gong.read;
"/Users/charleskramer/Desktop/chuck/audio/PVCPipeHorn_02.wav" => pipeHorn.read;
"/Users/charleskramer/Desktop/chuck/audio/spring_18cm_bowed_constantCircularStrokes.wav" => springBow.read;

BDB_1long.samples()=>BDB_1long.pos;
DB_atonal.samples()=>DB_atonal.pos;
DB_rapid.samples()=>DB_rapid.pos;
spring_8cm.samples()=>spring_8cm.pos;
spring_13cm.samples()=>spring_13cm.pos;
spring_18cm.samples()=>spring_18cm.pos;
spring_25cm.samples()=>spring_25cm.pos;
gong.samples()=>gong.pos;
pipeHorn.samples()=>pipeHorn.pos;
springBow.samples()=>springBow.pos;



fun void playBDB_1long (float rate, dur length) {
	0 => BDB_1long.pos;
	rate => BDB_1long.rate;
	length => now;
	BDB_1long.samples()=>BDB_1long.pos;

	
}
fun void playDB_atonal (float rate, dur length) {
	0 => DB_atonal.pos;
	rate => DB_atonal.rate;
	length => now;
	DB_atonal.samples()=>DB_atonal.pos;

}
fun void playDB_rapid (float rate, dur length) {
	0 => DB_rapid.pos;
	rate => DB_rapid.rate;
	length => now;
	DB_rapid.samples()=>DB_rapid.pos;

}
fun void playspring_8cm (float rate, dur length) {
	0 => spring_8cm.pos;
	rate => spring_8cm.rate;
	length => now;
	spring_8cm.samples()=>spring_8cm.pos;

}
fun void playspring_13cm (float rate, dur length) {
	0 => spring_13cm.pos;
	rate => spring_13cm.rate;
	length => now;
	spring_13cm.samples()=>spring_13cm.pos;

}
fun void playspring_18cm (float rate, dur length) {
	0 => spring_18cm.pos;
	rate => spring_18cm.rate;
	length => now;
	spring_18cm.samples()=>spring_18cm.pos;

}
fun void playspring_25cm (float rate, dur length) {
	0 => spring_25cm.pos;
	rate => spring_25cm.rate;
	length => now;
	spring_25cm.samples()=>spring_25cm.pos;

}
fun void playgong (float rate, dur length) {
	0 => gong.pos;
	rate => gong.rate;
	length => now;
	gong.samples()=>gong.pos;

}
fun void playpipeHorn (float rate, dur length) {
	0 => pipeHorn.pos;
	rate => pipeHorn.rate;
	length => now;
	pipeHorn.samples()=>pipeHorn.pos;

}
fun void playspringBow (float rate, dur length) {
	0 => springBow.pos;
	rate => springBow.rate;
	length => now;
	springBow.samples()=>springBow.pos;

}


1 => float rate;
4::second => dur length;

/*
playBDB_1long ( rate, length);

1::second => now;

playDB_rapid ( rate,  length);

1::second => now;

playspring_8cm ( rate,  length);

1::second => now;

playspring_13cm ( rate,  length);
 
1::second => now; 
 
playspring_18cm ( rate,  length);

1::second => now;

playspring_25cm ( rate,  length);

1::second => now;

playgong ( rate,  length);

1::second => now;

playpipeHorn ( rate,  length);

1::second => now;

playspringBow ( rate,  length);

1::second => now;
*/



for (1 => int i; i< 3; i++) {
	
	
	for (1 => int i; i<5; i++) {
		.25::second => length;
		playBDB_1long ( rate, length);
		playspring_8cm (rate,length);
		playspring_13cm (rate,length);
		playspring_25cm (rate,length);
	}
	
	for (1 => int i; i<5; i++) {
		.125::second => length;
		playgong (rate,length);
		.625::second => length;
		playpipeHorn (rate,length);
		1.25::second => length;
		playspringBow (rate,length);
	}
	
}

1.5 => rate;

for (1 => int i; i< 3; i++) {
	
	
	for (1 => int i; i<5; i++) {
		.25::second/2 => length;
		playBDB_1long ( rate, length);
		playspring_8cm (rate,length);
		playspring_13cm (rate,length);
		playspring_25cm (rate,length);
	}
	
	for (1 => int i; i<5; i++) {
		.125::second/2 => length;
		playgong (rate,length);
		.625::second/2 => length;
		playpipeHorn (rate,length);
		1.25::second/2 => length;
		playspringBow (rate,length);
	}
	
}

.5 => rate;

for (1 => int i; i< 2; i++) {
	
	
	for (1 => int i; i<5; i++) {
		.25::second*2 => length;
		playBDB_1long ( rate, length);
		playspring_8cm (rate,length);
		playspring_13cm (rate,length);
		playspring_25cm (rate,length);
	}
	
	for (1 => int i; i<5; i++) {
		.125::second*2 => length;
		playgong (rate,length);
		.625::second*2 => length;
		playpipeHorn (rate,length);
		1.25::second*2 => length;
		playspringBow (rate,length);
	}
	
}

1 => rate;


for (1 => int i; i< 3; i++) {
	
	spork~playBDB_1long(1,30::second);
    spork~playspringBow(1,30::second);
	
	for (1 => int i; i<5; i++) {
		.25::second => length;
		playBDB_1long ( rate, length);
		playspring_8cm (rate,length);
		playspring_13cm (rate,length);
		playspring_25cm (rate,length);
	}
	
	for (1 => int i; i<5; i++) {
		.125::second => length;
		playgong (rate,length);
		.625::second => length;
		playpipeHorn (rate,length);
		1.25::second => length;
		playspringBow (rate,length);
	}
	
}

5::second => now;
	
