// 24 hour version
//re-resample from original housesounds
// now spork runs three versions of the outro audio and samples from them


SndBuf2 buf[5];
Envelope env0[5];
Pan2 pan[5];

for (0 => int i; i < 5; i++) {
    
     buf[i] =>  env0[i] =>  pan[i] => dac;
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
        Std.rand2(0,1) => env0[i].keyOn;   
    }
    
    beat => now;   
    
    
    for (0 => int i; i < 5; i++) {
        Std.rand2(0,1) => env0[i].keyOff;   
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

5 => int nBuf;


SndBuf2 buf2[nBuf];
LPF filt[nBuf];
PoleZero f[nBuf];
NRev rev[nBuf]; 
Gain gain[nBuf];
Envelope env[nBuf];
Pan2 panL[nBuf];
Echo echo[nBuf]; 
NRev rev2[nBuf];
Envelope env2[nBuf];
Pan2 panR[nBuf];

for (0 => int i; i < nBuf; i++) {
    .25 => buf2[i].gain;
    "/Users/charleskramer/Desktop/chuck/audio/house_sounds_cut2.wav" => buf2[i].read;
    echo[i] => echo[i];
    buf2[i] => filt[i] => f[i] => rev[i] => gain[i] => env[i] => panL[i] => dac;
    gain[i] => echo[i] => rev2[i] => env2[i] => panR[i] => dac;
}


int k;

while (now < future) {
    
    Std.rand2(1,3) => n;
    
    for (0 => int i; i < n; i++) {
        Std.rand2(44000*(3*60+20), buf[0].samples()-44000*5*2) => j;
        Std.rand2(0,nBuf-1) => k;
        spork~sampleHouse(k,j);
    }
    1.5*beat =>now;
    
    }

2*beat => now;

fun void sampleHouse(int bufNum, int pos) {
 
  
  .9*(future-now)/outro+.2 => float maxRate;
  .2*(future-now)/outro+.1 => float minRate;

  Std.rand2f(minRate,maxRate) => buf2[bufNum].rate;
  
  <<< "buf, minRate,maxRate, rate ", bufNum, minRate, maxRate, buf2[bufNum].rate() >>>; 

 Std.rand2f(50,440) => filt[bufNum].freq;
 2 => filt[bufNum].Q;
 
 Std.rand2f(10,750)::ms => echo[bufNum].max;
 echo[bufNum].max() => echo[bufNum].delay;
 .5 => echo[bufNum].mix => echo[bufNum].gain;
 
 Std.rand2f(-1,1) => panL[bufNum].pan;
 -panL[bufNum].pan() => panR[bufNum].pan;
 
 .2 => rev[bufNum].mix => rev2[bufNum].mix;
 
 .2* beat => env[bufNum].duration ;
 .2* beat => env2[bufNum].duration;
 
  pos => buf2[bufNum].pos;
  
  1 => env[bufNum].keyOn => env2[bufNum].keyOn;
  beat => now;
  1 => env[bufNum].keyOff => env2[bufNum].keyOff;
  beat => now;
    
}