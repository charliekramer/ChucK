.01*2 => float gainSet;
10 => int n;

SqrOsc s[n];
22 => float baseFreq;
225 => float maxFreq;

10 => float a;
20 => float b;

0 => float t;
.00001 => float dt;
10::ms => dur timeIncrement;

240::second => dur length;


for (0 => int i; i < s.cap(); i++) {
    s[i] => dac;
    baseFreq => s[i].freq;
    gainSet => s[i].gain;
}

now + length => time future;

while (now < future) {
      
    for (0 => int i; i < s.cap(); i++) {
        baseFreq + Math.log(b*(i+a)*t+1)+ 1*b*(i+a)*t => s[i].freq;
    }
    timeIncrement => now;
    dt+=> t;
    if (s[n-1].freq() > maxFreq) {
        for (0 => int i; i < s.cap(); i++) {
            baseFreq => s[i].freq;
            0 => t;
        }
    }
}

now + 15::second => future;

while (now < future) {
    for (0 => int i; i < s.cap(); i++) {
        s[i].gain()*.99 => s[i].gain;
    }
    20::ms => now;
}
        

