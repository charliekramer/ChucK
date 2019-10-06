// stigmata remix

.05 => float gainSet;

80 => float BPM;

60./BPM => float beatsec; // original is 154 BPM

BPM/154. => float rate;

// is this right
beatsec::second => dur beat;
beat - (now % beat) => now;

Gain g;

gainSet => g.gain;

//set buffers for the chunks of song
SndBuf2 intro => g => dac;
SndBuf2 introNoise => g => dac;
SndBuf2 main => g => dac;
SndBuf2 breakScream => g => dac;
SndBuf2 breakDrum => g => dac; // break is a protected work
SndBuf2 v1 => g => dac;
SndBuf2 c => g => dac;
SndBuf2 v2 => g =>  dac;
SndBuf2 blast => g => dac;

// load samples
me.dir(-1)+"chuck/audio/stigmata_intro.wav"=> intro.read;
me.dir(-1)+"chuck/audio/stigmata_intro_noise.wav"=> introNoise.read;
me.dir(-1)+"chuck/audio/stigmata_main_riff.wav"=> main.read;
me.dir(-1)+"chuck/audio/stigmata_break_scream.wav"=> breakScream.read;
me.dir(-1)+"chuck/audio/stigmata_break.wav"=> breakDrum.read;
me.dir(-1)+"chuck/audio/stigmata_verse_1.wav"=> v1.read;
me.dir(-1)+"chuck/audio/stigmata_chorus.wav"=> c.read;
me.dir(-1)+"chuck/audio/stigmata_verse_2.wav"=> v2.read;
me.dir(-1)+"chuck/audio/stigmata_blast.wav"=> blast.read;

// wind all samples to end
intro.samples()=>intro.pos;
introNoise.samples()=>introNoise.pos;
main.samples()=>main.pos;
breakScream.samples()=>breakScream.pos;
breakDrum.samples()=>breakDrum.pos;
v1.samples()=>v1.pos;
v2.samples()=>v2.pos;
c.samples()=>c.pos;
blast.samples()=>blast.pos;

fun void goBuf(SndBuf buf, int loop, float rate){
    0 => buf.pos;
    loop => buf.loop;
    rate => buf.rate;
}

//spork~goBuf(intro,1,rate);
//spork~goBuf(introNoise,1,rate);
spork~goBuf(main,1,rate);
//spork~goBuf(breakScream,1,rate);
//spork~goBuf(breakDrum,1,rate);
//spork~goBuf(v1,1,rate);
//spork~goBuf(c,1,rate);
//spork~goBuf(v2,1,rate);
//spork~goBuf(blast,1,rate);

52::week => now;