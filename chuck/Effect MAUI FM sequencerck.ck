// FM synth with MAUI interface and sequencer that adds random pitch shocks

// buttons for the sequencer
MAUI_Button button_1, button_2, button_3, button_4;
button_1.size(75,75);
button_1.position(0,0);
button_1.toggleType();
button_1.name ("1");

button_2.size(75,75);
button_2.position(75,0);
button_2.toggleType();
button_2.name ("2");

button_3.size(75,75);
button_3.position(150,0);
button_3.toggleType();
button_3.name ("3");

button_4.size(75,75);
button_4.position(225,0);
button_4.toggleType();
button_4.name ("4");

// LED lights for the sequencer
MAUI_LED led_1, led_2, led_3, led_4;
led_1.size(75,75);
led_2.size(75,75);
led_3.size(75,75);
led_4.size(75,75);
led_1.position(00,75);
led_2.position(75,75);
led_3.position(150,75);
led_4.position(225,75);
led_1.color(MAUI_LED.red);
led_2.color(MAUI_LED.red);
led_3.color(MAUI_LED.red);
led_4.color(MAUI_LED.red);

//assembling the sequencer
MAUI_View viewpanel;

viewpanel.name("rando sequencer");
viewpanel.size(300,150);
viewpanel.addElement(button_1);
viewpanel.addElement(button_2);
viewpanel.addElement(button_3);
viewpanel.addElement(button_4);
viewpanel.addElement(led_1);
viewpanel.addElement(led_2);
viewpanel.addElement(led_3);
viewpanel.addElement(led_4);
viewpanel.display();

// control panel for the FM synth parameters
MAUI_View control_view;

control_view.size( 200, 400 );
control_view.name( "FM Synth" );
control_view.position(0,0);

//sliders for the FM synth paramters
MAUI_Slider slider1;
"Carrier Frequency" => slider1.name;
//slider1.display();
slider1.range( 1, 127 );
slider1.size(200,100);
slider1.position(0,0);
1 => slider1.value;

MAUI_Slider slider2;
"Modulator Frequency" => slider2.name;
//slider2.display();
slider2.range( 0.001, 127 );
slider2.size(200,100);
slider2.position(0,100);
.001 => slider2.value;

MAUI_Slider slider3;
"Modulator Gain" => slider3.name;
//slider3.display();
slider3.range( 1, 1000 );
slider3.size(200,100);
slider3.position(0,200);
1 => slider3.value;

MAUI_Slider slider8;
"Step time" => slider8.name;
slider8.range( 10, 1000);
slider8.size(200,100);
slider8.position(0,300);
250 => slider8.value;

// put the panel together
control_view.addElement(slider1);
control_view.addElement(slider2);
control_view.addElement(slider3);
control_view.addElement(slider8);
control_view.display();

// panel for the effects parameters
MAUI_View control_effects;

control_effects.size( 200, 400 );
control_effects.name( "Effects" );
control_effects.position(300,0);

// effects sliders
MAUI_Slider slider4;
"Chorus Speed" => slider4.name;
//slider1.display();
slider4.range( 0.1, 20 );
slider4.size(200,100);
slider4.position(0,0);
.1 => slider4.value;

MAUI_Slider slider5;
"Chorus Depth " => slider5.name;
//slider2.display();
slider5.range( 0, 1 );
slider5.size(200,100);
slider5.position(0,100);
0 => slider5.value;

MAUI_Slider slider6;
"Delay Time (sec.)" => slider6.name;
//slider3.display();
slider6.range( .1, 5 );
slider6.size(200,100);
slider6.position(0,200);
.1 => slider6.value;

MAUI_Slider slider7;
"Echo Mix" => slider7.name;
//slider3.display();
slider7.range( 0, 1 );
slider7.size(200,100);
slider7.position(0,300);
0 => slider7.value;

// assemble the parameters
control_effects.addElement(slider4);
control_effects.addElement(slider5);
control_effects.addElement(slider6);
control_effects.addElement(slider7);
control_effects.display();



// FM synth chain
SinOsc m => SinOsc s => Chorus c => Echo e  => dac;
m => blackhole;

.5 => c.modFreq;
.1 => c.modDepth;
.5 => c.mix;

10::second => e.max;
.75::second => e.delay;
.7 => e.mix;
.5 => e.gain;
e => e;

2 => s.sync;

440=>s.freq => m.freq => float baseFreq;
1 => m.gain;

0 => int j;

250 => float stepTime;

now + 120::second => time future; 

while(now < future )
{
	// pull parameter values from sliders
	slider1.value() => Std.mtof => s.freq;
	slider2.value() => Std.mtof => m.freq;
	slider3.value() =>  m.gain;
	slider4.value() =>  c.modFreq;
	slider5.value() =>  c.modDepth;
	slider6.value()::second =>  e.delay;
	slider7.value() =>  e.mix;
	slider8.value() =>  stepTime;
	
	// loop through sequencer
	
	j++;
	
	if (j % 4 == 1) {
		led_1.light();
		led_4.unlight();
		if (button_1.state() != 0) baseFreq*Std.rand2f(1.5,3.5) => s.freq;
	}
	else if (j % 4 == 2) {
		led_2.light();
		led_1.unlight();
		if (button_2.state() != 0) baseFreq*Std.rand2f(1.5,3.5)  => s.freq;
	}
	else if (j % 4 == 3) {
		led_3.light();
		led_2.unlight();
		if (button_3.state() != 0) baseFreq*Std.rand2f(1.5,3.5)  => s.freq;
	}
	else if (j % 4 == 0) {
		led_4.light();
		led_3.unlight();
		if (button_4.state() != 0) baseFreq*Std.rand2f(1.5,3.5)  => s.freq;
	}
	
	stepTime::ms => now;
	
	baseFreq => s.freq;
}




