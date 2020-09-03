//timed (see below) 

Impulse imp  => PitShift pitch => dac;
SndBuf s => blackhole;

"/Users/charleskramer/Desktop/chuck/audio/disquiet_piano.wav" => s.read;
"/Users/charleskramer/Desktop/chuck/audio/secrest_poem_1.wav" => s.read;


//"/Users/charleskramer/Desktop/chuck/audio/apache_break_editor.wav" => s.read;

138 => float loopSpeed; // native speed of loop

//"/Users/charleskramer/Desktop/chuck/audio/loopermanferryterry101bpmjazzsambadrum.wav" => s.read;
///101 => loopSpeed;

//"/Users/charleskramer/Desktop/chuck/audio/looperman-83bpm-l-0850517-0116649-miazyo-sazzyjazzydrumlings.wav" => s.read;
//83 => loopSpeed;

//"/Users/charleskramer/Desktop/chuck/audio/looperman-1564425-0149579-brisk-bossa-nova-drumgroove.wav" => s.read;
//87 => loopSpeed;




0 => s.pos;
1 => s.loop;

float hold;

1000 => float beatMs;

beatMs::ms => dur beat;

1 => int minSkip;
1 => int maxSkip;

2./(minSkip+maxSkip) => pitch.shift;
1 => pitch.mix;

-1 => s.rate;

int holder;

now + 20::second => time future;

while (now < future) {
	
	//s.pos() + Std.rand2(minSkip, maxSkip) => s.pos;
    s.pos() => holder;
    s.last() => hold;
    
    Std.rand2(1,4) => int nBeats;
    Std.rand2(1,8) => int beatDiv;
    for (0 => int i; i < nBeats*beatDiv; i++) {
        now + beat/beatDiv => time nextBeat;
        while (now < nextBeat) {
            //hold => imp.next;
            s.last() => imp.next;
            1::samp => now;
        }  
        holder + Std.rand2(minSkip, maxSkip)  => s.pos;
 
    }
    holder + Std.ftoi(beatMs)/1000*41000 => s.pos;
}
    
5::second => now;
