// 07042020 zeroed out reverb and echo
// receives OSC signals from PixelateOscForHexagridVideo
SndBuf osc0 => Gain gain0 => PitShift pitch0 => Echo echo0 => NRev rev0 => Pan2 pan0 => dac;
SndBuf osc1 => Gain gain1 => PitShift pitch1 => Echo echo1 => NRev rev1 => Pan2 pan1 => dac;
SndBuf osc2 => Gain gain2 => PitShift pitch2 => Echo echo2 => NRev rev2 => Pan2 pan2 => dac;
SndBuf osc3 => Gain gain3 => PitShift pitch3 => Echo echo3 => NRev rev3 => Pan2 pan3 => dac;

5 => float gainSet;
0 => osc0.gain => osc1.gain => osc2.gain => osc3.gain;// initialize to zero so audio doesn't start before video

"/Users/charleskramer/Desktop/chuck/audio/AlienPrayer-JeremyGluckandBelindaGolding.wav" => osc0.read;
"/Users/charleskramer/Desktop/chuck/audio/BenefactorBSynch_JSG_1.wav" => osc1.read;
"/Users/charleskramer/Desktop/chuck/audio/BenefactorJSynch_JSG_1.wav" => osc2.read;
"/Users/charleskramer/Desktop/chuck/audio/BenefactorJ&BSynch_JSG_1.wav" => osc3.read;


//"/Users/charleskramer/Desktop/chuck/audio/BenefactorBSynch_Amalgama.wav" => osc1.read;
//"/Users/charleskramer/Desktop/chuck/audio/BenefactorJSynch_Amalgama.wav" => osc2.read;
//"/Users/charleskramer/Desktop/chuck/audio/BenefactorJ&BSynch_Amalgama.wav" => osc3.read;


//"/Users/charleskramer/Desktop/chuck/audio/AlienPrayer-JeremyGluckandBelindaGolding.wav" => osc0.read;
//"/Users/charleskramer/Desktop/chuck/audio/BenefactorBSynch.wav" => osc1.read;
//"/Users/charleskramer/Desktop/chuck/audio/BenefactorJSynch.wav" => osc2.read;
//"/Users/charleskramer/Desktop/chuck/audio/BenefactorJ&BSynch.wav" => osc3.read;
//"/Users/charleskramer/Desktop/chuck/audio/TheBenefactor-BelindaGolding.wav" => osc1.read;
//"/Users/charleskramer/Desktop/chuck/audio/TheBenefactor-JeremyGluck.wav" => osc2.read;
//"/Users/charleskramer/Desktop/chuck/audio/TheBenefactor-JeremyGluckandBelindaGolding.wav" => osc3.read;

1 => osc0.loop => osc1.loop => osc2.loop => osc3.loop;

gainSet => gain0.gain; //NW
gainSet => gain1.gain; //NE
gainSet => gain2.gain; //SW
gainSet => gain3.gain; //SE

1 => float oscSpeed; //.2
1 => float oscPitch; //.5

oscPitch => pitch0.shift => pitch1.shift => pitch2.shift => pitch3.shift ;
oscSpeed => osc0.rate => osc1.rate => osc2.rate => osc3.rate; 
1 => pitch0.mix => pitch1.mix => pitch2.mix => pitch3.mix;

//spork~rateLFO(1./150., .5, .2);

// the patch

-1 => pan0.pan;
1 => pan1.pan;
-1 => pan2.pan;
1 => pan3.pan;

.5 => float echoGain;
.05*0 => float echoMix;
.1*0 => rev0.mix => rev1.mix => rev2.mix => rev3.mix;

1.55::second => echo0.max => echo0.delay;
echoMix => echo0.mix; 
echoGain => echo0.gain;
echo0 => echo0;
1.5::second => echo1.max => echo1.delay;
echoMix => echo1.mix; 
echoGain => echo1.gain;
echo1 => echo1;
1.45::second => echo2.max => echo2.delay;
echoMix => echo2.mix; 
echoGain => echo2.gain;
echo2 => echo2;
1.65::second => echo3.max => echo3.delay;
echoMix => echo3.mix; 
echoGain => echo3.gain;
echo3 => echo3;
// load the file
// don't play yet

// create our OSC receiver
OscIn oin;
// create our OSC message
OscMsg msg;
// use port 6449
6448 => oin.port;
// create an address in the receiver
oin.addAddress( "/hexagrid/avBright" );

// infinite event loop
while ( true )
{
    // wait for event to arrive
    oin => now;

    // grab the next message from the queue. 
    while ( oin.recv(msg) != 0 )
    { 
        // getFloat fetches the expected float (as indicated by "f")
            msg.getFloat(0)/125. => osc0.gain;
            msg.getFloat(1)/125. => osc1.gain;
            msg.getFloat(2)/125. => osc2.gain;
            msg.getFloat(3)/125. => osc3.gain;
        // print
        //<<< "got (via OSC):", msg.getFloat(0), msg.getFloat(1), msg.getFloat(2), msg.getFloat(3) >>>;
        // set play pointer to beginning
       }
}

fun void rateLFO(float freq, float gain, float baseRate) {
    SinOsc LFO => blackhole;
    freq => LFO.freq;
    gain => LFO.gain;
    while (true) {
        1./((1+LFO.last())*baseRate) => pitch0.shift => pitch1.shift => pitch2.shift => pitch3.shift;
        (1+LFO.last())*baseRate => osc0.rate => osc1.rate=> osc2.rate=> osc3.rate;
        1::samp => now;
    }
}
    
