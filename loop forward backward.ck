//-----------------------------------------------------------------------------
// name: LiSa
// desc: Live sampling utilities for ChucK
//
// author: Dan Trueman, 2007
//
// to run (in command line chuck):
//     %> chuck readme-LiSa2.ck
//
// to run (in miniAudicle):
//     (just run it!)
//-----------------------------------------------------------------------------

/*
 LiSa allows for multiple voice playback from a live-sampled buffer. Useful
 for granular sampling (a la [munger~] from PeRColate) and looping (a la 
 LoopLoop, Jamman, Echoplex, etc....). The methods are overloaded, taking a
 "voice" number as a first arg. if no voice number is specified, LiSa 
 assumes 0=>voice.

  Below is a simple example to show how to crossfade two voices. See also 
  the LiSa_munger directory for other approaches.

  Below the example find a (lengthy) command summary.
*/

//-----------------------------------------------------------------------------


//signal chain; record a sine wave, play it back
SndBuf buf =>  Envelope env => LiSa loopme => dac.left;
env => Echo echo => dac.right;

"/Users/charleskramer/Desktop/chuck/audio/nixon_humiliate.wav" => buf.read;


1 => buf.loop;
0 => buf.pos;

//alloc memory
2::second => loopme.duration;
250::ms => dur mylooplen;
mylooplen => echo.max => echo.delay;
1 => echo.mix;
echo => Gain echobuf => echo;
.2 => echobuf.gain;
.2 => loopme.feedback;

10::ms => env.duration;
loopme.rate(-1);

loopme.bi(1);

while (true) {
    loopme.record(1);
    1 => env.keyOn;
    mylooplen => now;
    loopme.record(0);
    env.keyOff;
    
    loopme.play(1);
    mylooplen => now;
    
    if (mylooplen > 10::ms) mylooplen*.995 => mylooplen;
    mylooplen => echo.delay;

}


//-----------------------------------------------------------------------------

//LiSa Command Summary:
//
//	mylisa.duration(dur); required -- sets max length of buffer
//	mylisa.duration(); returns max length of buffer
//	mylisa.record(1/0); turn on/off recording into buffer
//	mylisa.getVoice() => voice (int); returns first free voice number
//	mylisa.maxVoices(int); sets maximum # of allowable voices
//	mylisa.play(voice, 1/0); turn on/off play for particular voice
//	mylisa.rampUp(voice, dur); turn on play for voice with ramp
//	mylisa.rampDown(voice, dur); ramp down voice and then turn off play
//	mylisa.rate(voice, float); sets play rate for "voice"
//	mylisa.playPos(voice, dur); sets playback position for "voice" within buffer
//	mylisa.playPos(voice); returns playback position for "voice"
//	mylisa.recordPos(dur); sets record position
//	mylisa.recordPos(); gets record position
//	mylisa.recRamp(dur); sets ramping for the edges of the record buffer
//	mylisa.loopStart(dur, voice); sets loopstart point for "voice"
//	mylisa.loopStart(voice); get loopstart
//	mylisa.loopEnd(voice, dur); sets loopend point for "voice"
//	mylisa.loopEnd(voice); gets loopend
//	mylisa.loop(voice, 1/0); turn on/off looping for "voice"
// 	mylisa.loop(voice); get looping state
//	mylisa.bi(voice, 1/0); turn on/off bidirectional looping for "voice"
//	mylisa.bi(voice); get bi state
//	mylisa.voiceGain(voice, float); sets gain "voice"
//	mylisa.voiceGain(voice); gets gain for "voice"
//	mylisa.loopEndRec(dur); set looping end point for recording
//	mylisa.loopEndRec(); get ...
//	mylisa.feedback(float); set feedback amount [0,1] for recording
//	mylisa.feedback(); get...
//	mylisa.clear(); clear recording buffer
//  mylisa.pan(); returns pan value of voice 0
//  mylisa.pan(float where); pans voice 0 where can be [0., 7.], to place voice across LiSa's 8 outputs
//  mylisa.pan(int voice); returns pan value of voice
//  mylisa.pan(int voice, float where); pans specified voice where can be [0., 7.], to place voice across LiSa's 8 outputs
//  note that LiSa's 8 outputs can be sent to a multichannel dac, or simply to other ugens, if it is desirable to process the
//       channels in different ways. these 8 channels are available regardless of whether the dac is running > 2 chans
//
//All of these commands should work without the "voice" arg; 0=>voice will be assumed

//see online documentation for most up-do-date listing...

//-----------------------------------------------------------------------------


