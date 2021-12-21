
10 => int n;

for (0 => int j; j < n; j++) {
    spork~bufRun(1::ms, j*44000/100, .7/(.5*Math.pow(j,.5)+1.));
}

2::second => dur beat;

200::second => now;



fun void bufRun(dur echoLen, int bufStart, float rate) {
    SndBuf2 nixon => Echo echo => NRev rev =>  dac;
    "/Users/charleskramer/Desktop/chuck/audio/nixon_compilation.wav" => nixon.read;
    //"/Users/charleskramer/Desktop/chuck/audio/01_Red_Dress_vocal_splitted_by_lalalai.wav" => nixon.read;
    "/Users/charleskramer/Desktop/chuck/audio/50 Best Free Drum Loops/Shroom LANDR Break08_94bpm.wav" => nixon.read;

    echoLen => echo.max => echo.delay;
    1 => echo.mix;
    .7 => echo.gain;
    .2 => rev.mix;
    echo => echo;
    bufStart => nixon.pos;
    rate => nixon.rate;
    <<< "start, rate", nixon.pos(),nixon.rate() >>>;
    while (true) {
        beat => now;
    }
}

