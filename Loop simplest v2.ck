//simplest looper ck
// now with midi control
// playbackfraction doesnt' work--starting new version


2 => int device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

.5 => float gainSet;

adc => LiSa loopme => LPF lpf => NRev rev => Echo echo => Dyno dyn => Gain gain => dac;

gainSet => gain.gain;
5000::ms => dur loopDur => dur maxLoopDur;

.0 => rev.mix;

loopDur*5 => echo.max;
loopDur*.75 => echo.delay;
.5 => echo.gain; 
.0 =>echo.mix;
echo =>echo;

1000 => lpf.freq;
1 => lpf.Q;

// alloc memory
loopDur => loopme.duration;
loopme.recRamp( 2::ms );

// start recording input
loopme.record( 1 );

// record and then start playing what was just recorded
loopDur => now;
loopme.record(0);

// set playback rate
loopme.rate(1);
loopme.play(1);
loopme.loop(1);
loopme.bi(0);
time future;
1. => float playbackFraction;

// go
while( true ){ 
    <<< " top, fraction", playbackFraction >>>;
    0 =>loopme.playPos;
    now + loopDur*playbackFraction => future;
    while (now < future) {
        
        1::samp => now; 
        
        while(min.recv(msg))
            
            {
                if (msg.data1 == 144) {
                    <<< " new loop"  >>> ;
                    loopme.record(1);
                    loopDur => now;
                    loopme.record(0);  
                  }
                  
                  if( msg.data1 == 176 && msg.data2 == 1 ) //loop playback fraction 
                  {
                      msg.data3*.9/127.+.1 => playbackFraction;
                      <<<"playbackFrqction", playbackFraction >>>;
                  } 
                  
              }
          }
    }


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

