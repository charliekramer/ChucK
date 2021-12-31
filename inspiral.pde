float theta = 2*PI;
float radius = 20;
float circSize = 5;


void setup() {
size(900,700,P3D);
background(0);
}

void draw() {
  
//fill(0,2);
//rect(0,0, width, height);

translate(width/2,height/2);

float xpos = radius*sin(theta);
float ypos = radius*cos(theta);

rotateX(PI*sin(frameCount/400));
rotateY(PI*sin(frameCount/500));
rotateZ(2*PI*cos(frameCount/600));

stroke(255*(1+sin(frameCount/250)), 255*(1+cos(frameCount/250)), 255*(1+tan(frameCount/250))); 
ellipse(xpos,ypos,circSize,circSize);

theta += .1*PI*sin(frameCount/100);
radius += sin(frameCount/200);
}
