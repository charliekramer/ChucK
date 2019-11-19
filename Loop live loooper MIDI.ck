//simplest looper ck
// now with midi control
// playbackfraction doesnt' work--starting new version
// multi loops

2 => int device;

MidiIn min;
MidiMsg msg;

if( !min.open( device ) ) me.exit();

<<< "MIDI device:", min.num(), " -> ", min.name() >>>;

.5 => float gainSet;

4 => int nLoops;

5000::ms => dur loopDur;

LiSa loopme[nLoops];
LPF lpf;
NRev rev;
Echo echo;
Dyno dyn;
Gain gain;

for (0 => int i; i < nLoops; i++) {
    <<< "i", i>>>;
    adc => loopme[i] => lpf => rev => echo => dyn => gain => dac;
    
    loopme[i].maxVoices(4);
    // alloc memory
    loopDur => loopme[i].duration;
    loopme[i].recRamp( 2::ms );
        
    // set playback rate
    loopme[i].rate(1);
    loopme[i].play(1);
    loopme[i].loop(1);
    loopme[i].bi(0);
}

gainSet => gain.gain;

.5 => float revMix;
.0 => rev.mix;

loopDur*5 => echo.max;
loopDur*.25 => echo.delay;
.5 => echo.gain; 
.5 => float echoMix;
.0 =>echo.mix;
echo =>echo;

1000 => lpf.freq;
1 => lpf.Q;
/*
for (0 => int i; i < nLoops; i++) {
     
     // start recording input
     loopme[i].record( 1 );
     
     // record and then start playing what was just recorded
     loopDur => now;
     loopme[i].record(0);
 }
 */


time future;

// go
while( true ){ 
    
    <<< " top" >>>;
    
    now + loopDur => future;
    
    while (now < future) {
        
        1::samp => now; 
        
        while(min.recv(msg))
            
            {
                if (msg.data1 == 144 && msg.data2 > 39) {
                    <<< " new loop, loop #" , msg.data2-40 >>> ;
                    loopme[msg.data2-40].record(1);
                    loopDur => now;
                    loopme[msg.data2-40].record(0);
                    break;  
                  }
                  if (msg.data1 == 144 && msg.data2 < 40) {
                      if (msg.data2 == 36) {
                          0. => rev.mix => echo.mix;
                          <<< "echo off, reverb off " >>>;
                      }
                      if (msg.data2 == 37) {
                          revMix => rev.mix;
                          0 => echo.mix;
                          <<< "echo off, reverb on " >>>;
                      }
                      if (msg.data2 == 38) {
                          0. => rev.mix;
                          echoMix => echo.mix;
                          <<< "echo on, reverb off " >>>;
                      }
                      if (msg.data2 == 39) {
                          revMix => rev.mix;
                          echoMix => echo.mix;
                          <<< "echo on, reverb on " >>>;
                      }
                      break;  
                  }
                  
                  if( msg.data1 == 176 && msg.data2 == 1 ) //gain0 
                  {
                      msg.data3*1./127. => loopme[0].gain;
                      <<<"gain0", loopme[0].gain() >>>;
                  } 
                  if( msg.data1 == 176 && msg.data2 == 2 ) //gain1 
                  {
                      msg.data3*1./127. => loopme[1].gain;
                      <<<"gain1", loopme[1].gain() >>>;
                  }
                  if( msg.data1 == 176 && msg.data2 == 3 ) //gain2 
                  {
                      msg.data3*1./127. => loopme[2].gain;
                      <<<"gain2", loopme[2].gain() >>>;
                  }
                  if( msg.data1 == 176 && msg.data2 == 4 ) //gain3 
                  {
                      msg.data3*1./127. => loopme[3].gain;
                      <<<"gain3", loopme[3].gain() >>>;
                  }
                  if( msg.data1 == 176 && msg.data2 == 5 ) //rate0
                  {
                      (msg.data3-127.*.5)*4./127. => loopme[0].rate;
                      <<<"rate0", loopme[0].rate() >>>;
                  }
                  if( msg.data1 == 176 && msg.data2 == 6 ) //rate1
                  {
                      (msg.data3-127.*.5)*4./127. => loopme[1].rate;
                      <<<"rate1", loopme[1].rate() >>>;
                  }
                  if( msg.data1 == 176 && msg.data2 == 7 ) //rate0
                  {
                      (msg.data3-127.*.5)*4./127. => loopme[2].rate;
                      <<<"rate2", loopme[2].rate() >>>;
                  }
                  if( msg.data1 == 176 && msg.data2 == 8 ) //rate0
                  {
                      (msg.data3-127.*.5)*4./127. => loopme[3].rate;
                      <<<"rate2", loopme[3].rate() >>>;
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

