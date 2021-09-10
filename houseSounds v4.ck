// 24 hour version
//re-resample from original housesounds

SndBuf2 buf[5];
Envelope env[5];
Pan2 pan[5];

for (0 => int i; i < 5; i++) {
    
     buf[i] =>  env[i] =>  pan[i] => dac;
     -1.0 + 2.0*i/4.0 => pan[i].pan;     
     i+1 => int j;
     "/Users/charleskramer/Desktop/chuck/audio/houseRemix"+j+".wav" => buf[i].read;
     1 => buf[i].loop;
     0 => buf[i].pos;
     .5/5. => buf[i].gain;


 }

buf[0].length() => dur length;

24::hour - length => dur outro;

5::second => dur beat;

now + length => time future;

while (now < future) {
 
    for (0 => int i; i < 5; i++) {
        Std.rand2(0,1) => env[i].keyOn;   
    }
    
    beat => now;   
    
    
    for (0 => int i; i < 5; i++) {
        Std.rand2(0,1) => env[i].keyOff;   
    }
    
    beat => now;
    
    //if (Std.rand2f(0,1) > .3) spork~sampleHouse(buf.pos());
    
}

for (0 => int i; i < 5; i++) {
    buf[i].samples() => buf[i].pos; 
    0 => buf[i].gain;   
}

now => time start;

now + outro =>  future;

int j;
int n;

while (now < future) {
    
    Std.rand2(1,3) => n;
    
    for (0 => int i; i < n; i++) {
        Std.rand2(44000*(3*60+20), buf[0].samples()-44000*5*2) => j;
        spork~sampleHouse(j);
    }
    beat =>now;
    
    }

2*beat => now;

fun void sampleHouse(int pos) {
 
 SndBuf2 buf2 => LPF filt => PoleZero f => NRev rev => Gain gain => Envelope env => Pan2 panL => dac;
 gain => Echo echo => NRev rev2 => Envelope env2 => Pan2 panR => dac;
 "/Users/charleskramer/Desktop/chuck/audio/house_sounds_cut2.wav" => buf2.read;

  .99 => f.blockZero;
  
  .9*(future-now)/outro+.2 => float maxRate;
  .2*(future-now)/outro+.1 => float minRate;

  Std.rand2f(minRate,maxRate) => buf2.rate;
  
  <<< "minRate,maxRate, rate ", minRate, maxRate, buf2.rate() >>>; 

 .25 => buf2.gain;

 Std.rand2f(50,440) => filt.freq;
 2 => filt.Q;
 
 Std.rand2f(10,750)::ms => echo.max;
 echo.max() => echo.delay;
 .5 => echo.mix => echo.gain;
 echo => echo;
 
 Std.rand2f(-1,1) => panL.pan;
 -panL.pan() => panR.pan;
 
 .2 => rev.mix => rev2.mix;
 
 .2* beat => env.duration ;
 .2* beat => env2.duration;
 
  pos => buf2.pos;
  
  1 => env.keyOn => env2.keyOn;
  beat => now;
  1 => env.keyOff => env2.keyOff;
  beat => now;
    
}