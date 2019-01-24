// control volca beats
MidiOut mout;
mout.open(1);

MidiMsg kick;
MidiMsg hat;
MidiMsg hatOpen;
MidiMsg snare;
MidiMsg tom;
	
fun void goKick () {  
	
	0x90 => kick.data1;
	36 => kick.data2;
	127 => kick.data3;
	mout.send(kick);
}

fun void goHat() {
	
	0x90 => hat.data1;
	42 => hat.data2;
	127 => hat.data3;
	mout.send(hat);
	
}

fun void goHatOpen() {
	
	0x90 => hatOpen.data1;
	42 => hatOpen.data2;
	127 => hatOpen.data3;
	mout.send(hatOpen);
	
}

fun void goSnare () {
	
	
	0x90 => snare.data1;
	38 => snare.data2;
	127 => snare.data3;
	mout.send(snare);
}

fun void goSnare () {
	
	
	0x90 => snare.data1;
	38 => snare.data2;
	127 => snare.data3;
	mout.send(snare);
}

60./120. => float beatsec;
beatsec::second*.5 => dur beat;

while(true)
{

spork~goHat();
spork~goKick();
beat => now;
spork~goHat();
spork~goKick();
beat => now;
spork~goHat();
spork~goSnare();
beat =>now;
spork~goHat();
beat/2 => now;
spork~goHatOpen();
beat/2 => now;

}
/*
KORG volca beats MIDI Implementation          Revision 0.01 (2013.06.23)





1.TRANSMITTED DATA



  No message is transmitted.

  (The volca beats is not equipped with a MIDI Out jack.)





2.RECOGNIZED RECEIVE DATA



2-1 CHANNEL MESSAGES        [H]:Hex,  [D]:Decimal

+--------+---------+-------------+-----------------------------------------+

| Status | Second  |   Third     |           Description                   |

| [Hex]  | [H] [D] | [H]   [D]   |                                         |

+--------+---------+-------------+-----------------------------------------+

|   8n   | kk (kk) | vv    (vv)  | Note Off  vv=0~127                    *1|

|   9n   | kk (kk) | 00    (00)  | Note Off                              *1|

|   9n   | kk (kk) | vv    (vv)  | Note On  vv=1~127                     *1|

|   Bn   | 28 (40) | vv    (vv)  | PART LEVEL (KICK)                     *1|

|   Bn   | 29 (41) | vv    (vv)  | PART LEVEL (SNARE)                    *1|

|   Bn   | 2A (42) | vv    (vv)  | PART LEVEL (LO TOM)                   *1|

|   Bn   | 2B (43) | vv    (vv)  | PART LEVEL (HI TOM)                   *1|

|   Bn   | 2C (44) | vv    (vv)  | PART LEVEL (CL HAT)                   *1|

|   Bn   | 2D (45) | vv    (vv)  | PART LEVEL (OP HAT)                   *1|

|   Bn   | 2E (46) | vv    (vv)  | PART LEVEL (CLAP)                     *1|

|   Bn   | 2F (47) | vv    (vv)  | PART LEVEL (CLAVES)                   *1|

|   Bn   | 30 (48) | vv    (vv)  | PART LEVEL (AGOGO)                    *1|

|   Bn   | 31 (49) | vv    (vv)  | PART LEVEL (CRASH)                    *1|

|   Bn   | 32 (50) | vv    (vv)  | PCM SPEED (CLAP)                      *1|

|   Bn   | 33 (51) | vv    (vv)  | PCM SPEED (CLAVES)                    *1|

|   Bn   | 34 (52) | vv    (vv)  | PCM SPEED (AGOGO)                     *1|

|   Bn   | 35 (53) | vv    (vv)  | PCM SPEED (CRASH)                     *1|

|   Bn   | 36 (54) | vv    (vv)  | STUTTER TIME                          *1|

|   Bn   | 37 (55) | vv    (vv)  | STUTTER DEPTH                         *1|

|   Bn   | 38 (56) | vv    (vv)  | DECAY (TOM)                           *1|

|   Bn   | 39 (57) | vv    (vv)  | DECAY (CLOSED HAT)                    *1|

|   Bn   | 3A (58) | vv    (vv)  | DECAY (OPEN HAT)                      *1|

|   Bn   | 3B (59) | vv    (vv)  | HAT GRAIN                             *1|

+--------+---------+-------------+-----------------------------------------+



 n  : MIDI Channel = 0 ~ F

 vv : Value

 kk : Note Number

      [H] [D]

      24 (36) : KICK

      26 (38) : SNARE

      2B (43) : LO TOM

      32 (50) : HI TOM

      2A (42) : CL HAT

      2E (46) : OP HAT

      27 (39) : CLAP

      4B (75) : CLAVES

      43 (67) : AGOGO

      31 (49) : CRASH



 *1 : This message is recognized when the "MIDI RX Short Message" is set to "On".





2-2.SYSTEM COMMON MESSAGES

+-----------+-----------+-----------+------------------------------+

| Status[H] | Second[B] | Third[B]  | Description                  |

|-----------+-----------+-----------+------------------------------+

|    F2     | 0xxx xxxx | 0xxx pppp | Song Position Pointer        |

+-----------+-----------+-----------+------------------------------+



 pppp : 0~15 = STEP 1 ~ STEP 16

    x : ignored





2-3 SYSTEM REALTIME MESSAGES

+-----------+----------------------------------------------+

| Status[H] | Description                                  |

+-----------+----------------------------------------------+

|    F8     | Timing Clock                               *2|

|    FA     | Start                                      *2|

|    FB     | Contiune                                   *2|

|    FC     | Stop                                       *2|

|    FE     | Active Sensing                               |

+-----------+----------------------------------------------+



 *2 : This message is recognized when the "MIDI Clock Src" is set to "Auto".








KORG volca beats MIDI Implementation          Revision 0.01 (2013.06.23)





1.TRANSMITTED DATA



  No message is transmitted.

  (The volca beats is not equipped with a MIDI Out jack.)





2.RECOGNIZED RECEIVE DATA



2-1 CHANNEL MESSAGES        [H]:Hex,  [D]:Decimal

+--------+---------+-------------+-----------------------------------------+

| Status | Second  |   Third     |           Description                   |

| [Hex]  | [H] [D] | [H]   [D]   |                                         |

+--------+---------+-------------+-----------------------------------------+

|   8n   | kk (kk) | vv    (vv)  | Note Off  vv=0~127                    *1|

|   9n   | kk (kk) | 00    (00)  | Note Off                              *1|

|   9n   | kk (kk) | vv    (vv)  | Note On  vv=1~127                     *1|

|   Bn   | 28 (40) | vv    (vv)  | PART LEVEL (KICK)                     *1|

|   Bn   | 29 (41) | vv    (vv)  | PART LEVEL (SNARE)                    *1|

|   Bn   | 2A (42) | vv    (vv)  | PART LEVEL (LO TOM)                   *1|

|   Bn   | 2B (43) | vv    (vv)  | PART LEVEL (HI TOM)                   *1|

|   Bn   | 2C (44) | vv    (vv)  | PART LEVEL (CL HAT)                   *1|

|   Bn   | 2D (45) | vv    (vv)  | PART LEVEL (OP HAT)                   *1|

|   Bn   | 2E (46) | vv    (vv)  | PART LEVEL (CLAP)                     *1|

|   Bn   | 2F (47) | vv    (vv)  | PART LEVEL (CLAVES)                   *1|

|   Bn   | 30 (48) | vv    (vv)  | PART LEVEL (AGOGO)                    *1|

|   Bn   | 31 (49) | vv    (vv)  | PART LEVEL (CRASH)                    *1|

|   Bn   | 32 (50) | vv    (vv)  | PCM SPEED (CLAP)                      *1|

|   Bn   | 33 (51) | vv    (vv)  | PCM SPEED (CLAVES)                    *1|

|   Bn   | 34 (52) | vv    (vv)  | PCM SPEED (AGOGO)                     *1|

|   Bn   | 35 (53) | vv    (vv)  | PCM SPEED (CRASH)                     *1|

|   Bn   | 36 (54) | vv    (vv)  | STUTTER TIME                          *1|

|   Bn   | 37 (55) | vv    (vv)  | STUTTER DEPTH                         *1|

|   Bn   | 38 (56) | vv    (vv)  | DECAY (TOM)                           *1|

|   Bn   | 39 (57) | vv    (vv)  | DECAY (CLOSED HAT)                    *1|

|   Bn   | 3A (58) | vv    (vv)  | DECAY (OPEN HAT)                      *1|

|   Bn   | 3B (59) | vv    (vv)  | HAT GRAIN                             *1|

+--------+---------+-------------+-----------------------------------------+



 n  : MIDI Channel = 0 ~ F

 vv : Value

 kk : Note Number

      [H] [D]

      24 (36) : KICK

      26 (38) : SNARE

      2B (43) : LO TOM

      32 (50) : HI TOM

      2A (42) : CL HAT

      2E (46) : OP HAT

      27 (39) : CLAP

      4B (75) : CLAVES

      43 (67) : AGOGO

      31 (49) : CRASH



 *1 : This message is recognized when the "MIDI RX Short Message" is set to "On".





2-2.SYSTEM COMMON MESSAGES

+-----------+-----------+-----------+------------------------------+

| Status[H] | Second[B] | Third[B]  | Description                  |

|-----------+-----------+-----------+------------------------------+

|    F2     | 0xxx xxxx | 0xxx pppp | Song Position Pointer        |

+-----------+-----------+-----------+------------------------------+



 pppp : 0~15 = STEP 1 ~ STEP 16

    x : ignored





2-3 SYSTEM REALTIME MESSAGES

+-----------+----------------------------------------------+

| Status[H] | Description                                  |

+-----------+----------------------------------------------+

|    F8     | Timing Clock                               *2|

|    FA     | Start                                      *2|

|    FB     | Contiune                                   *2|

|    FC     | Stop                                       *2|

|    FE     | Active Sensing                               |

+-----------+----------------------------------------------+



 *2 : This message is recognized when the "MIDI Clock Src" is set to "Auto".









*/
