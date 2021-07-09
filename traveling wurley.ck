
.2 => float gainSet;
15 => int n;
Wurley osc[n];
Pan2 pan[n];
1 => float frac; //change in pitch from hard left to hard right;

43  => float midiBase;

for (0 => int i; i < n; i++) {
    osc[i] => pan[i] => dac;
    Std.mtof(midiBase+frac*i/(1.*n)) => osc[i].freq;
    -1 + 2.*i/(n-1) => pan[i].pan;
    <<< "I, pani", i,pan[i].pan() >>>;
}

.1::second => dur beat;

<<< ".1 second beat" >>>;

for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    beat => now;
    
    }
    
for (n-1 => int i; i >= 0; i--) {
        1 => osc[i].noteOn;
        beat => now;
        
    }
    
for (0 => int i; i < n/2; i++) {
        1 => osc[i].noteOn;
        2*beat => now;
        1 => osc[n-1-i].noteOn;
        2*beat => now;
    }

now + 20::second => time future;

while (now < future) {
    1 => osc[Std.rand2(0,n-1)].noteOn;
    beat => now;
}


for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
    1 => osc[n-1-i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
}


for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    (2.+2.*i/(1.*n))*beat => now;
    
}


for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    (4.+4.*i/(1.*n))*beat => now;
    
}

2::second => now;


<<< ".25 second beat" >>>;

.22::second =>  beat;

for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    beat => now;
    
}

for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    beat => now;
    
}

for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    2*beat => now;
    1 => osc[n-1-i].noteOn;
    2*beat => now;
}

now + 20::second =>  future;

while (now < future) {
    1 => osc[Std.rand2(0,n-1)].noteOn;
    beat => now;
}


for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
    1 => osc[n-1-i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
}


for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    (2.+2.*i/(1.*n))*beat => now;
    
}


for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    (4.+4.*i/(1.*n))*beat => now;
    
}

2::second => now;


<<< ".01 second beat" >>>;

.01::second =>  beat;

for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    beat => now;
    
}

for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    beat => now;
    
}

for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    2*beat => now;
    1 => osc[n-1-i].noteOn;
    2*beat => now;
}

now + 20::second =>  future;

while (now < future) {
    1 => osc[Std.rand2(0,n-1)].noteOn;
    beat => now;
}


for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
    1 => osc[n-1-i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
}


for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    (2.+2.*i/(1.*n))*beat => now;
    
}


for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    (4.+4.*i/(1.*n))*beat => now;
    
}

2::second => now;

<<< "decreasing beat" >>>;

.01::second => beat;

for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    beat => now;
    
}

.05::second => beat;

for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    beat => now;
    
}

.1::second => beat;

for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    2*beat => now;
    1 => osc[n-1-i].noteOn;
    2*beat => now;
}

now + 20::second =>  future;

.15::second => beat;

while (now < future) {
    1 => osc[Std.rand2(0,n-1)].noteOn;
    beat => now;
}

.2::second => beat;

for (0 => int i; i < n/2; i++) {
    1 => osc[i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
    1 => osc[n-1-i].noteOn;
    (2+2.*i/(1.*n))*beat => now;
}

.25::second => beat;

for (n-1 => int i; i >= 0; i--) {
    1 => osc[i].noteOn;
    (2.+2.*i/(1.*n))*beat => now;
    
}

.3::second => beat;

for (0 => int i; i < n; i++) {
    1 => osc[i].noteOn;
    (4.+4.*i/(1.*n))*beat => now;
    
}

2::second => now;
