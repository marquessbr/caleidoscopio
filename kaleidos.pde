/**************************************************************** 
  draw a random coloured kaleidoscope on the screen
  use de mouse to redraw the image
  use the S or s key to save the image
  use the B or b key to play and stop the music 
  the sound fitures is implemented with the minim libraries
  use C or c to change the background color randomly
  the figure drawn is saved in the root folder of the sketch
  
****************************************************************/  

// implement the call to the sound libraries
import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;  
AudioPlayer jingle;
FFT fftLin;
FFT fftLog;

// global variables
final int NB_MAX = 16;
int NB = (int)random(2, NB_MAX);
final int RADIUS = 220;
PVector prevPoint1 = new PVector(0, 0);
PVector prevPoint2 = new PVector(0, 0);
float R;
float G;
float B;
float Rspeed;
float Gspeed;
float Bspeed;
float count = 0;
int bcolor = 0;
 
 // the code implementation 
void setup(){
  size(500, 600, P3D);
  background(bcolor);
  strokeWeight(2);
  minim = new Minim(this); // create the sound prototype
  jingle = minim.loadFile("fair1939.wav", 1024); // load the file
  generateColors(); // gnerate the colours schematic
}
 
void draw(){
  armmenu(); // mount the menu to the user
  caleidos();  // draw the kaleidoscope onto screen
}

void armmenu(){
  noFill();
  noStroke();
  fill(255);
  rect(0, height-60, width, 60);
  fill(0);
  text("press 'b' or 'B' to play the music using minim libraries", 20, height-50);
  text("press 'c' or 'C' to change the background color", 20, height-35);
  text("press 's' or 'S' to save the drawn image", 20, height-20);
  text("click the mouse button to redraw the image", 20, height-5);  
}

void caleidos(){
  smooth();
  fill(120, 10);
  
  translate(500/2, 500/2);
  float thetaD = map(mouseX, 0, width, -.05, .05);
  float theta = random(TWO_PI / NB);
 
  Rspeed = ((R += Rspeed) > 255 || (R < 0)) ? -Rspeed : Rspeed;
  Gspeed = ((G += Gspeed) > 255 || (G < 0)) ? -Gspeed : Gspeed;
  Bspeed = ((B += Bspeed) > 255 || (B < 0)) ? -Bspeed : Bspeed;
  color myColor = color(R, G, B);
  fill(myColor, 70);
  stroke(myColor, 70);
  float angle = random(TWO_PI);
 
  float radius = random(8);
 
  float tmpX = prevPoint1.x + radius * cos(angle);
  float tmpY = prevPoint1.y + radius * sin(angle);
   
  //adding the mouse rotation
  float x = tmpX * cos(thetaD) - tmpY * sin(thetaD);
  float y = tmpY * cos(thetaD) + tmpX * sin(thetaD);   
   
  if (x * x + y * y > RADIUS * RADIUS)
  {
    x = RADIUS * cos(atan2(prevPoint1.y, prevPoint1.x));
    y = RADIUS * sin(atan2(prevPoint1.y, prevPoint1.x));
  }
 
  for (int i = 0; i < NB; i++)
  {   
    // draw the image using lines and the color schematic
    rotate(TWO_PI / NB);
    line(prevPoint1.x, prevPoint1.y, x, y);
    line(prevPoint2.x, prevPoint2.y, x, -y);    
  }
  prevPoint1 = new PVector(x, y);
  prevPoint2 = new PVector(x, -y);
}

void generateColors()
{
  R = random(255);
  G = random(255);
  B = random(255);
  Rspeed = (random(1) > .5 ? 1 : -1) * random(.8, 1.5);
  Gspeed = (random(1) > .5 ? 1 : -1) * random(.8, 1.5);
  Bspeed = (random(1) > .5 ? 1 : -1) * random(.8, 1.5);
}

void playsound(boolean p){
  // play or stop the sound when the usr press the b key
  if (!p){
    jingle.loop();
    fftLin = new FFT( jingle.bufferSize(), 100*Rspeed );
    fftLog = new FFT( jingle.bufferSize(), 100*Bspeed );    
  } else {
    jingle.rewind();
    jingle.pause();
  }   
}
 
void mousePressed()
{
  // redraw the image when the user click the mouse button or press c
  background(bcolor);
  NB = (int)map(mouseX, 0, width, 2, NB_MAX);
  prevPoint1 = new PVector(0, 0);
  prevPoint2 = new PVector(0, 0);
  generateColors();
}

void keyPressed(){
  // implements the User interaction with keyboard 
  if (key == 's' || key == 'S'){
    // save the portion of the screen minus the menu area
    PImage img = get(0, 0, 500, 480);
    img.save("caleidoscopio.png");
  }
  if (key == 'b' || key == 'B') {
    // play and stop the sound
    playsound(jingle.isPlaying());    
  }
  if (key == 'c' || key == 'C'){
    // change the background color
    bcolor = round(60);
    background(bcolor);
    generateColors();
  }
}
