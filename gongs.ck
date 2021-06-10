.5 => float gainSet;
5::minute => dur length;

["121098__thirsk__gong.wav",
"121800__boss-music__gong.wav",
"177872__jorickhoofd__heavy-gong.wav",
"185824__lloydevans09__paiste-gong.wav",
"207167__veiler__spooky-gong.wav",
"235454__jcdecha__ambient-gong-long.wav",
"347382__gevaroy__gong-2.wav",
"389783__martian__gong-horror-emperial-majesty.wav",
"434214__tmpz-1__deep-gong.wav",
"436482__rabban625__gong-011.wav",
"64554__nicstage__d-gong.wav",
"71507__pfeifferc__gong1.wav",
"7417__room__perc-emperor-gong.wav",
"Metal Gong-SoundBible.com-1270479122.wav",
"Metal_Gong-Dianakc-109711828.wav"] @=> string files[];

SndBuf getLen;

0::second => dur maxLen;

for (0 => int i; i < files.cap(); i++) {
    
      "/Users/charleskramer/Desktop/chuck/audio/gongs/"+files[i] => getLen.read;
     if (getLen.length() > maxLen) getLen.length() => maxLen;
    
    }

files.cap() => int n;

/*
for (0 => int i; i < n; i++) {
    "/Users/charleskramer/Desktop/chuck/audio/gongs/"+files[i] => gongs[i].read;
    gongs[i] => dac;
    0 => gongs[i].pos;
    }
    
*/

int nGong;

now + length => time future;

while (now < future) {
    Std.rand2(1,5) => nGong;
    for (0 => int i; i < nGong; i++) {
        spork~gong();
        Std.rand2f(.25,2)::second => now;
        }
     
     Std.rand2f(.5,1)*10::second => now;
    
    }

2*maxLen => now;

fun void gong() {
    Std.rand2(0,files.cap()-1) => int i;
    SndBuf gong => Pan2 pan1 => dac;
    gong => Echo echo => NRev rev => Pan2 pan2 => dac;
     "/Users/charleskramer/Desktop/chuck/audio/gongs/"+files[i] => gong.read;
     0 => gong.pos;
     gainSet => gong.gain;
     Std.rand2f(-1,1) => pan1.pan;
     -1.*pan1.pan() => pan2.pan;
     Std.rand2f(.125,.75)*gong.length() => echo.max => echo.delay;
     1 => echo.mix;
     .7 => echo.gain;
      
     2.*gong.length() => now;
    
    }