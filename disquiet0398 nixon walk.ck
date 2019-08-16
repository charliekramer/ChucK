SndBuf2 buf_walk => dac;
"/Users/charleskramer/Desktop/chuck/audio/nixonwalk.wav" => buf_walk.read;

0 => buf_walk.pos;

.4 => buf_walk.gain;

4::minute => now;